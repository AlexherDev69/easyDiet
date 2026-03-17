import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/database.dart';
import '../../../onboarding/domain/models/models.dart';
import '../../../settings/domain/repositories/user_profile_repository.dart';
import 'plan_config_state.dart';

/// Manages the plan configuration screen — port of PlanConfigViewModel.kt.
class PlanConfigCubit extends Cubit<PlanConfigState> {
  PlanConfigCubit({
    required UserProfileRepository userProfileRepository,
  })  : _userProfileRepository = userProfileRepository,
        super(const PlanConfigState()) {
    _loadProfile();
  }

  final UserProfileRepository _userProfileRepository;

  Future<void> _loadProfile() async {
    final profile = await _userProfileRepository.getProfile();
    if (profile == null) return;

    final freeDaysList = _parseIntList(profile.freeDays).toSet();
    final enabledMealTypes = _parseEnabledMealTypes(profile.enabledMealTypes);
    final dietType = DietType.values.firstWhere(
      (d) => d.name == profile.dietType,
      orElse: () => DietType.omnivore,
    );

    emit(state.copyWith(
      isLoading: false,
      dietType: dietType,
      freeDays: freeDaysList,
      dietStartDate: AppDateUtils.fromEpochMillis(profile.dietStartDate),
      enabledMealTypes: enabledMealTypes,
      distinctBreakfasts: profile.distinctBreakfasts,
      distinctLunches: profile.distinctLunches,
      distinctDinners: profile.distinctDinners,
      distinctSnacks: profile.distinctSnacks,
    ));
  }

  void updateDietType(DietType v) => emit(state.copyWith(dietType: v));

  void toggleFreeDay(int dayIndex) {
    final updated = Set<int>.from(state.freeDays);
    if (updated.contains(dayIndex)) {
      updated.remove(dayIndex);
    } else if (updated.length < 3) {
      updated.add(dayIndex);
    }
    emit(state.copyWith(freeDays: updated));
  }

  void updateDietStartDate(DateTime v) =>
      emit(state.copyWith(dietStartDate: v));

  void toggleMealType(MealType mealType) {
    final updated = Set<MealType>.from(state.enabledMealTypes);
    if (updated.contains(mealType) && updated.length > 1) {
      updated.remove(mealType);
    } else {
      updated.add(mealType);
    }
    emit(state.copyWith(enabledMealTypes: updated));
  }

  void updateDistinctBreakfasts(int v) =>
      emit(state.copyWith(distinctBreakfasts: v));
  void updateDistinctLunches(int v) =>
      emit(state.copyWith(distinctLunches: v));
  void updateDistinctDinners(int v) =>
      emit(state.copyWith(distinctDinners: v));
  void updateDistinctSnacks(int v) =>
      emit(state.copyWith(distinctSnacks: v));

  /// Saves config and proceeds to plan preview.
  Future<void> saveAndProceed() async {
    final profile = await _userProfileRepository.getProfile();
    if (profile == null) return;

    final startDate = state.dietStartDate ?? AppDateUtils.today();

    await _userProfileRepository.saveProfile(
      UserProfilesCompanion(
        id: const Value(1),
        name: Value(profile.name),
        age: Value(profile.age),
        sex: Value(profile.sex),
        heightCm: Value(profile.heightCm),
        weightKg: Value(profile.weightKg),
        targetWeightKg: Value(profile.targetWeightKg),
        lossPace: Value(profile.lossPace),
        activityLevel: Value(profile.activityLevel),
        dietType: Value(state.dietType.name),
        dietDaysPerWeek: Value(state.dietDaysPerWeek),
        freeDays: Value(json.encode(state.freeDays.toList())),
        batchCookingSessionsPerWeek:
            Value(profile.batchCookingSessionsPerWeek),
        shoppingTripsPerWeek: Value(profile.shoppingTripsPerWeek),
        distinctBreakfasts: Value(state.distinctBreakfasts),
        distinctLunches: Value(state.distinctLunches),
        distinctDinners: Value(state.distinctDinners),
        distinctSnacks: Value(state.distinctSnacks),
        enabledMealTypes: Value(
            json.encode(state.enabledMealTypes.map((m) => m.name).toList())),
        allergies: Value(profile.allergies),
        customAllergies: Value(profile.customAllergies),
        excludedMeats: Value(profile.excludedMeats),
        dietStartDate: Value(AppDateUtils.toEpochMillis(startDate)),
        batchCookingBeforeDiet: Value(profile.batchCookingBeforeDiet),
        economicMode: Value(profile.economicMode),
        dailyCalorieTarget: Value(profile.dailyCalorieTarget),
        dailyWaterMl: Value(profile.dailyWaterMl),
        onboardingCompleted: const Value(true),
        createdAt: Value(profile.createdAt),
      ),
    );
  }

  // ── JSON parsing ──────────────────────────────────────────────────

  List<int> _parseIntList(String jsonStr) {
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) return decoded.cast<int>();
    } catch (_) {}
    return [];
  }

  Set<MealType> _parseEnabledMealTypes(String jsonStr) {
    try {
      final decoded = json.decode(jsonStr);
      if (decoded is List) {
        return decoded
            .cast<String>()
            .map(
                (n) => MealType.values.where((m) => m.name == n).firstOrNull)
            .whereType<MealType>()
            .toSet();
      }
    } catch (_) {}
    return MealType.values.toSet();
  }
}
