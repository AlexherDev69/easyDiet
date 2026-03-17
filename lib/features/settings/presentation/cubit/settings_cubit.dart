import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/database.dart';
import '../../../meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../../onboarding/domain/models/models.dart';
import '../../../onboarding/domain/usecases/calorie_calculator.dart';
import '../../../weight_log/domain/repositories/weight_log_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'settings_state.dart';

/// Manages settings screen — port of SettingsViewModel.kt.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required UserProfileRepository userProfileRepository,
    required MealPlanRepository mealPlanRepository,
    required WeightLogRepository weightLogRepository,
    required CalorieCalculator calorieCalculator,
  })  : _userProfileRepository = userProfileRepository,
        _mealPlanRepository = mealPlanRepository,
        _weightLogRepository = weightLogRepository,
        _calorieCalculator = calorieCalculator,
        super(const SettingsState()) {
    _loadProfile();
  }

  final UserProfileRepository _userProfileRepository;
  final MealPlanRepository _mealPlanRepository;
  final WeightLogRepository _weightLogRepository;
  final CalorieCalculator _calorieCalculator;

  /// Original diet fields snapshot to detect changes.
  Object? _originalDietFields;

  Future<void> _loadProfile() async {
    final profile = await _userProfileRepository.getProfile();
    if (profile == null) return;

    final allergies = _parseStringList(profile.allergies)
        .map((n) => Allergy.values.where((a) => a.name == n).firstOrNull)
        .whereType<Allergy>()
        .toSet();

    final freeDaysList = _parseIntList(profile.freeDays).toSet();

    final excludedMeats = _parseStringList(profile.excludedMeats)
        .map(
            (n) => ExcludedMeat.values.where((m) => m.name == n).firstOrNull)
        .whereType<ExcludedMeat>()
        .toSet();

    final enabledMealTypes = _parseEnabledMealTypes(profile.enabledMealTypes);

    final dietStartDate = AppDateUtils.fromEpochMillis(profile.dietStartDate);

    emit(state.copyWith(
      name: profile.name,
      age: profile.age.toString(),
      sex: Sex.values.firstWhere(
        (s) => s.name == profile.sex,
        orElse: () => Sex.male,
      ),
      heightCm: profile.heightCm.toString(),
      weightKg: profile.weightKg.toString(),
      targetWeightKg: profile.targetWeightKg.toString(),
      lossPace: LossPace.values.firstWhere(
        (lp) => lp.name == profile.lossPace,
        orElse: () => LossPace.moderate,
      ),
      activityLevel: ActivityLevel.values.firstWhere(
        (al) => al.name == profile.activityLevel,
        orElse: () => ActivityLevel.sedentary,
      ),
      dietType: DietType.values.firstWhere(
        (d) => d.name == profile.dietType,
        orElse: () => DietType.omnivore,
      ),
      freeDays: freeDaysList,
      batchCookingSessions: profile.batchCookingSessionsPerWeek,
      shoppingTrips: profile.shoppingTripsPerWeek,
      distinctBreakfasts: profile.distinctBreakfasts,
      distinctLunches: profile.distinctLunches,
      distinctDinners: profile.distinctDinners,
      distinctSnacks: profile.distinctSnacks,
      enabledMealTypes: enabledMealTypes,
      dietStartDate: dietStartDate,
      batchCookingBeforeDiet: profile.batchCookingBeforeDiet,
      selectedAllergies: allergies,
      excludedMeats: excludedMeats,
      customAllergies: profile.customAllergies,
      economicMode: profile.economicMode,
      calculatedCalories: profile.dailyCalorieTarget,
      calculatedWaterMl: profile.dailyWaterMl,
      isLoading: false,
    ));
    _originalDietFields = extractDietFields(state);
  }

  // ── Field updaters ──────────────────────────────────────────────────

  void updateName(String v) =>
      emit(state.copyWith(name: v, isSaved: false));
  void updateAge(String v) =>
      emit(state.copyWith(age: v, isSaved: false));
  void updateSex(Sex v) =>
      emit(state.copyWith(sex: v, isSaved: false));
  void updateHeight(String v) =>
      emit(state.copyWith(heightCm: v, isSaved: false));
  void updateWeight(String v) =>
      emit(state.copyWith(weightKg: v, isSaved: false));
  void updateTargetWeight(String v) =>
      emit(state.copyWith(targetWeightKg: v, isSaved: false));
  void updateLossPace(LossPace v) =>
      emit(state.copyWith(lossPace: v, isSaved: false));
  void updateActivityLevel(ActivityLevel v) =>
      emit(state.copyWith(activityLevel: v, isSaved: false));
  void updateDietType(DietType v) =>
      emit(state.copyWith(dietType: v, isSaved: false));
  void updateDietStartDate(DateTime v) =>
      emit(state.copyWith(dietStartDate: v, isSaved: false));
  void updateCustomAllergies(String v) =>
      emit(state.copyWith(customAllergies: v, isSaved: false));
  void updateEconomicMode(bool v) =>
      emit(state.copyWith(economicMode: v, isSaved: false));
  void updateBatchCookingBeforeDiet(bool v) =>
      emit(state.copyWith(batchCookingBeforeDiet: v, isSaved: false));

  void toggleFreeDay(int dayIndex) {
    final updated = Set<int>.from(state.freeDays);
    if (updated.contains(dayIndex)) {
      updated.remove(dayIndex);
    } else if (updated.length < 3) {
      updated.add(dayIndex);
    }
    emit(state.copyWith(freeDays: updated, isSaved: false));
  }

  void updateBatchCooking(int v) =>
      emit(state.copyWith(
          batchCookingSessions: v.clamp(1, 2), isSaved: false));
  void updateShoppingTrips(int v) =>
      emit(state.copyWith(shoppingTrips: v.clamp(1, 2), isSaved: false));
  void updateDistinctBreakfasts(int v) =>
      emit(state.copyWith(
          distinctBreakfasts: v.clamp(1, 6), isSaved: false));
  void updateDistinctLunches(int v) =>
      emit(state.copyWith(
          distinctLunches: v.clamp(1, 7), isSaved: false));
  void updateDistinctDinners(int v) =>
      emit(state.copyWith(
          distinctDinners: v.clamp(1, 7), isSaved: false));
  void updateDistinctSnacks(int v) =>
      emit(state.copyWith(
          distinctSnacks: v.clamp(1, 5), isSaved: false));

  void toggleMealType(MealType mealType) {
    final updated = Set<MealType>.from(state.enabledMealTypes);
    if (updated.contains(mealType) && updated.length > 1) {
      updated.remove(mealType);
    } else {
      updated.add(mealType);
    }
    emit(state.copyWith(enabledMealTypes: updated, isSaved: false));
  }

  void toggleAllergy(Allergy allergy) {
    final updated = Set<Allergy>.from(state.selectedAllergies);
    if (updated.contains(allergy)) {
      updated.remove(allergy);
    } else {
      updated.add(allergy);
    }
    emit(state.copyWith(selectedAllergies: updated, isSaved: false));
  }

  void toggleExcludedMeat(ExcludedMeat meat) {
    final updated = Set<ExcludedMeat>.from(state.excludedMeats);
    if (updated.contains(meat)) {
      updated.remove(meat);
    } else {
      updated.add(meat);
    }
    emit(state.copyWith(excludedMeats: updated, isSaved: false));
  }

  // ── Save ────────────────────────────────────────────────────────────

  Future<void> saveProfile() async {
    final weight = double.tryParse(state.weightKg);
    final height = int.tryParse(state.heightCm);
    final age = int.tryParse(state.age);
    final targetWeight = double.tryParse(state.targetWeightKg);
    if (weight == null || height == null || age == null ||
        targetWeight == null) {
      return;
    }

    if (targetWeight >= weight) {
      emit(state.copyWith(
        targetWeightError:
            'Le poids cible doit etre inferieur au poids actuel',
      ));
      return;
    }
    emit(state.copyWith(clearTargetWeightError: true));

    final calories = _calorieCalculator.calculateDailyTarget(
      weightKg: weight,
      heightCm: height,
      age: age,
      sex: state.sex,
      activityLevel: state.activityLevel,
      lossPace: state.lossPace,
    );
    final waterMl = _calorieCalculator.calculateDailyWater(
      weightKg: weight,
      heightCm: height,
      age: age,
      sex: state.sex,
      activityLevel: state.activityLevel,
    );

    final startDate = state.dietStartDate ?? AppDateUtils.today();

    await _userProfileRepository.saveProfile(
      UserProfilesCompanion(
        id: const Value(1),
        name: Value(state.name),
        age: Value(age),
        sex: Value(state.sex.name),
        heightCm: Value(height),
        weightKg: Value(weight),
        targetWeightKg: Value(targetWeight),
        lossPace: Value(state.lossPace.name),
        activityLevel: Value(state.activityLevel.name),
        dietType: Value(state.dietType.name),
        dietDaysPerWeek: Value(state.dietDaysPerWeek),
        freeDays: Value(json.encode(state.freeDays.toList())),
        batchCookingSessionsPerWeek: Value(state.batchCookingSessions),
        shoppingTripsPerWeek: Value(state.shoppingTrips),
        distinctBreakfasts: Value(state.distinctBreakfasts),
        distinctLunches: Value(state.distinctLunches),
        distinctDinners: Value(state.distinctDinners),
        distinctSnacks: Value(state.distinctSnacks),
        enabledMealTypes: Value(
            json.encode(state.enabledMealTypes.map((m) => m.name).toList())),
        allergies: Value(
            json.encode(state.selectedAllergies.map((a) => a.name).toList())),
        customAllergies: Value(state.customAllergies),
        excludedMeats: Value(
            json.encode(state.excludedMeats.map((m) => m.name).toList())),
        dietStartDate: Value(AppDateUtils.toEpochMillis(startDate)),
        batchCookingBeforeDiet: Value(state.batchCookingBeforeDiet),
        economicMode: Value(state.economicMode),
        dailyCalorieTarget: Value(calories),
        dailyWaterMl: Value(waterMl),
        onboardingCompleted: const Value(true),
        createdAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );

    final currentDietFields = extractDietFields(state);
    final dietChanged =
        _originalDietFields != null && currentDietFields != _originalDietFields;

    emit(state.copyWith(
      calculatedCalories: calories,
      calculatedWaterMl: waterMl,
      isSaved: true,
      showRegenerateDialog: dietChanged,
    ));
  }

  // ── Reset ───────────────────────────────────────────────────────────

  void showResetDialog() =>
      emit(state.copyWith(showResetDialog: true));
  void hideResetDialog() =>
      emit(state.copyWith(showResetDialog: false));

  Future<void> resetApp() async {
    await _userProfileRepository.deleteAll();
    await _mealPlanRepository.deleteWeekPlans();
    await _weightLogRepository.deleteAll();
    hideResetDialog();
  }

  // ── Regenerate dialog ───────────────────────────────────────────────

  void dismissRegenerateDialog() =>
      emit(state.copyWith(showRegenerateDialog: false));

  void onRegenerateConfirmed() {
    _originalDietFields = extractDietFields(state);
    dismissRegenerateDialog();
  }

  // ── JSON parsing helpers ────────────────────────────────────────────

  List<String> _parseStringList(String jsonStr) {
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) return decoded.cast<String>();
    } catch (_) {}
    return [];
  }

  List<int> _parseIntList(String jsonStr) {
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) return decoded.cast<int>();
    } catch (_) {}
    return [];
  }

  Set<MealType> _parseEnabledMealTypes(String jsonStr) {
    try {
      final names = _parseStringList(jsonStr);
      return names
          .map((n) => MealType.values.where((m) => m.name == n).firstOrNull)
          .whereType<MealType>()
          .toSet();
    } catch (_) {
      return MealType.values.toSet();
    }
  }
}
