import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/profile_json_parser.dart';
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
    try {
      final profile = await _userProfileRepository.getProfile();
      if (profile == null) return;

      final freeDaysList = ProfileJsonParser.parseIntSet(profile.freeDays);
      final enabledMealTypes = ProfileJsonParser.parseMealTypes(profile.enabledMealTypes);
      final dietType = DietType.values.firstWhere(
        (d) => d.name == profile.dietType,
        orElse: () => DietType.omnivore,
      );

      emit(state.copyWith(
        isLoading: false,
        dietType: dietType,
        selectedAllergies: ProfileJsonParser.parseAllergies(profile.allergies),
        excludedMeats: ProfileJsonParser.parseExcludedMeats(profile.excludedMeats),
        freeDays: freeDaysList,
        dietStartDate: AppDateUtils.fromEpochMillis(profile.dietStartDate),
        enabledMealTypes: enabledMealTypes,
        distinctBreakfasts: profile.distinctBreakfasts,
        distinctLunches: profile.distinctLunches,
        distinctDinners: profile.distinctDinners,
        distinctSnacks: profile.distinctSnacks,
        economicMode: profile.economicMode,
      ));
    } catch (e) {
      debugPrint('Error in _loadProfile: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void updateDietType(DietType v) => emit(state.copyWith(dietType: v));

  void toggleAllergy(Allergy allergy) {
    final updated = Set<Allergy>.from(state.selectedAllergies);
    if (updated.contains(allergy)) {
      updated.remove(allergy);
    } else {
      updated.add(allergy);
    }
    emit(state.copyWith(selectedAllergies: updated));
  }

  void toggleExcludedMeat(ExcludedMeat meat) {
    final updated = Set<ExcludedMeat>.from(state.excludedMeats);
    if (updated.contains(meat)) {
      updated.remove(meat);
    } else {
      updated.add(meat);
    }
    emit(state.copyWith(excludedMeats: updated));
  }

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

  void toggleEconomicMode(bool v) =>
      emit(state.copyWith(economicMode: v));

  /// Saves config and proceeds to plan preview.
  Future<void> saveAndProceed() async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
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
          allergies: Value(
              json.encode(state.selectedAllergies.map((a) => a.name).toList())),
          customAllergies: Value(profile.customAllergies),
          excludedMeats: Value(
              json.encode(state.excludedMeats.map((m) => m.name).toList())),
          dietStartDate: Value(AppDateUtils.toEpochMillis(startDate)),
          batchCookingBeforeDiet: Value(profile.batchCookingBeforeDiet),
          economicMode: Value(state.economicMode),
          dailyCalorieTarget: Value(profile.dailyCalorieTarget),
          dailyWaterMl: Value(profile.dailyWaterMl),
          onboardingCompleted: const Value(true),
          createdAt: Value(profile.createdAt),
        ),
      );
    } catch (e) {
      debugPrint('Error in saveAndProceed: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

}
