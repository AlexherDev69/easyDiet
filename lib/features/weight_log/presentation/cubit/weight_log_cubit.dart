import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/local/database.dart';
import '../../../onboarding/domain/models/activity_level.dart';
import '../../../onboarding/domain/models/loss_pace.dart';
import '../../../onboarding/domain/models/sex.dart';
import '../../../onboarding/domain/usecases/calorie_calculator.dart';
import '../../../settings/domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/weight_log_repository.dart';
import '../../domain/usecases/weight_projection_calculator.dart';
import 'weight_log_state.dart';

/// Outlier threshold in kg for warning the user.
const _outlierThresholdKg = 5.0;

/// Manages weight log screen — port of WeightLogViewModel.kt.
class WeightLogCubit extends Cubit<WeightLogState> {
  WeightLogCubit({
    required WeightLogRepository weightLogRepository,
    required UserProfileRepository userProfileRepository,
    required WeightProjectionCalculator weightProjectionCalculator,
    required CalorieCalculator calorieCalculator,
  })  : _weightLogRepository = weightLogRepository,
        _userProfileRepository = userProfileRepository,
        _weightProjectionCalculator = weightProjectionCalculator,
        _calorieCalculator = calorieCalculator,
        super(WeightLogState()) {
    _loadData();
  }

  final WeightLogRepository _weightLogRepository;
  final UserProfileRepository _userProfileRepository;
  final WeightProjectionCalculator _weightProjectionCalculator;
  final CalorieCalculator _calorieCalculator;
  StreamSubscription<List<WeightLog>>? _logSubscription;

  Future<void> _loadData() async {
    try {
      final profile = await _userProfileRepository.getProfile();
      if (profile != null) {
        emit(state.copyWith(targetWeight: profile.targetWeightKg));

        final lossPace = LossPace.values.firstWhere(
          (lp) => lp.name == profile.lossPace,
          orElse: () => LossPace.moderate,
        );
        final latestLog = await _weightLogRepository.getLatestLog();
        final latestWeight = latestLog?.weightKg ?? profile.weightKg;

        final dietStartDate =
            DateTime.fromMillisecondsSinceEpoch(profile.dietStartDate);
        final initialDate =
            _weightProjectionCalculator.calculateEstimatedGoalDate(
          currentWeight: latestWeight,
          targetWeight: profile.targetWeightKg,
          lossPace: lossPace,
          dietDaysPerWeek: profile.dietDaysPerWeek,
          startDate: dietStartDate,
        );
        emit(state.copyWith(initialProjectedDate: initialDate));
      }

      _logSubscription = _weightLogRepository.watchAllLogs().listen((logs) {
        final sorted = List.of(logs)..sort((a, b) => a.date.compareTo(b.date));

        final totalLost = sorted.length >= 2
            ? sorted.first.weightKg - sorted.last.weightKg
            : 0.0;

        final avgLoss =
            _weightProjectionCalculator.calculateAverageWeeklyLoss(sorted);

        final currentWeight = sorted.lastOrNull?.weightKg ?? 0.0;
        final lastLogDate = sorted.lastOrNull?.date;
        final projectedDate =
            _weightProjectionCalculator.calculateProjectedDateAtCurrentPace(
          currentWeight: currentWeight,
          targetWeight: state.targetWeight,
          averageWeeklyLoss: avgLoss,
          referenceDate: lastLogDate != null
              ? DateTime.fromMillisecondsSinceEpoch(lastLogDate)
              : null,
        );

        emit(state.copyWith(
          allLogs: sorted,
          totalLost: totalLost,
          avgLossPerWeek: avgLoss,
          projectedGoalDate: projectedDate,
          clearProjectedGoalDate: projectedDate == null,
          isAggressiveLoss:
              _weightProjectionCalculator.isAggressiveLossRate(avgLoss),
          isLoading: false,
        ));
      });
    } catch (e) {
      debugPrint('Error in _loadData: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void selectPeriod(int period) {
    emit(state.copyWith(selectedPeriod: period));
  }

  void showAddDialog() {
    emit(state.copyWith(
      showAddDialog: true,
      weightInput: '',
      selectedDate: DateTime.now(),
    ));
  }

  void hideAddDialog() {
    emit(state.copyWith(showAddDialog: false));
  }

  void updateWeightInput(String value) {
    emit(state.copyWith(weightInput: value));
  }

  void updateSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<void> addWeightLog() async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final weight = double.tryParse(state.weightInput);
      if (weight == null) return;

      final date = state.selectedDate ?? DateTime.now();
      final selectedDate = DateTime(date.year, date.month, date.day);
      final dateMillis = selectedDate.millisecondsSinceEpoch;
      final existingLog = await _weightLogRepository.getLogByDate(dateMillis);

      if (existingLog != null) {
        emit(state.copyWith(showDuplicateDialog: true));
        return;
      }

      await _insertWeightLog(weight, dateMillis);
    } catch (e) {
      debugPrint('Error in addWeightLog: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> confirmReplaceDuplicate() async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final weight = double.tryParse(state.weightInput);
      if (weight == null) return;

      final date = state.selectedDate ?? DateTime.now();
      final selectedDate = DateTime(date.year, date.month, date.day);
      final dateMillis = selectedDate.millisecondsSinceEpoch;
      final existingLog = await _weightLogRepository.getLogByDate(dateMillis);
      if (existingLog != null) {
        await _weightLogRepository.deleteLog(existingLog);
      }

      await _insertWeightLog(weight, dateMillis);
      emit(state.copyWith(showDuplicateDialog: false));
    } catch (e) {
      debugPrint('Error in confirmReplaceDuplicate: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void dismissDuplicateDialog() {
    emit(state.copyWith(showDuplicateDialog: false));
  }

  void dismissOutlierWarning() {
    emit(state.copyWith(clearOutlierWarning: true));
  }

  Future<void> _insertWeightLog(double weight, int date) async {
    try {
      // Find the chronologically adjacent log for outlier detection.
      final adjacentWeight = _findAdjacentWeight(date);

      await _weightLogRepository.insertLog(
        WeightLogsCompanion.insert(
          date: date,
          weightKg: weight,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      hideAddDialog();

      // Sync profile weight and recalculate calories.
      await _syncProfileWeight(weight);

      if (adjacentWeight != null) {
        final diff = (weight - adjacentWeight).abs();
        if (diff > _outlierThresholdKg) {
          emit(state.copyWith(
            outlierWarning:
                'Ecart important detecte (${diff.toStringAsFixed(1)} kg). '
                'Verifiez la valeur.',
          ));
        }
      }
    } catch (e) {
      debugPrint('Error in _insertWeightLog: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _syncProfileWeight(double newWeight) async {
    try {
      final profile = await _userProfileRepository.getProfile();
      if (profile == null) return;

      final sex = Sex.values.firstWhere(
        (s) => s.name == profile.sex,
        orElse: () => Sex.male,
      );
      final activityLevel = ActivityLevel.values.firstWhere(
        (a) => a.name == profile.activityLevel,
        orElse: () => ActivityLevel.moderatelyActive,
      );
      final lossPace = LossPace.values.firstWhere(
        (lp) => lp.name == profile.lossPace,
        orElse: () => LossPace.moderate,
      );

      final newCalories = _calorieCalculator.calculateDailyTarget(
        weightKg: newWeight,
        heightCm: profile.heightCm,
        age: profile.age,
        sex: sex,
        activityLevel: activityLevel,
        lossPace: lossPace,
      );
      final newWater = _calorieCalculator.calculateDailyWater(
        weightKg: newWeight,
        heightCm: profile.heightCm,
        age: profile.age,
        sex: sex,
        activityLevel: activityLevel,
      );

      await _userProfileRepository.updateWeightAndCalories(
        weightKg: newWeight,
        calories: newCalories,
        waterMl: newWater,
      );
    } catch (e) {
      debugPrint('Error in _syncProfileWeight: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Finds the weight of the chronologically closest log to [date].
  double? _findAdjacentWeight(int date) {
    final logs = state.allLogs;
    if (logs.isEmpty) return null;
    double? closestWeight;
    int closestDiff = 0x7FFFFFFFFFFFFFFF;
    for (final log in logs) {
      final diff = (log.date - date).abs();
      if (diff > 0 && diff < closestDiff) {
        closestDiff = diff;
        closestWeight = log.weightKg;
      }
    }
    return closestWeight;
  }

  Future<void> deleteLog(WeightLog log) async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      await _weightLogRepository.deleteLog(log);
    } catch (e) {
      debugPrint('Error in deleteLog: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _logSubscription?.cancel();
    return super.close();
  }
}
