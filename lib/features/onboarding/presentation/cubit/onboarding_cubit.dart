import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../../meal_plan/domain/usecases/meal_plan_generator.dart';
import '../../../settings/domain/repositories/user_profile_repository.dart';
import '../../../shopping/domain/usecases/shopping_list_generator.dart';
import '../../../weight_log/domain/repositories/weight_log_repository.dart';
import '../../domain/models/models.dart';
import '../../domain/usecases/calorie_calculator.dart';
import 'onboarding_state.dart';

/// Manages the onboarding flow — port of OnboardingViewModel.kt.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required UserProfileRepository userProfileRepository,
    required WeightLogRepository weightLogRepository,
    required CalorieCalculator calorieCalculator,
    required MealPlanGenerator mealPlanGenerator,
    required MealPlanRepository mealPlanRepository,
    required ShoppingListGenerator shoppingListGenerator,
  })  : _userProfileRepository = userProfileRepository,
        _weightLogRepository = weightLogRepository,
        _calorieCalculator = calorieCalculator,
        _mealPlanGenerator = mealPlanGenerator,
        _mealPlanRepository = mealPlanRepository,
        _shoppingListGenerator = shoppingListGenerator,
        super(OnboardingState(dietStartDate: AppDateUtils.today())) {
    _checkOnboardingStatus();
  }

  final UserProfileRepository _userProfileRepository;
  final WeightLogRepository _weightLogRepository;
  final CalorieCalculator _calorieCalculator;
  final MealPlanGenerator _mealPlanGenerator;
  final MealPlanRepository _mealPlanRepository;
  final ShoppingListGenerator _shoppingListGenerator;

  // ── Simple field updates ────────────────────────────────────────────

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateAge(String value) => emit(state.copyWith(age: value));
  void updateSex(Sex value) => emit(state.copyWith(sex: value));
  void updateHeight(String value) => emit(state.copyWith(heightCm: value));
  void updateWeight(String value) => emit(state.copyWith(weightKg: value));

  void updateTargetWeight(String value) =>
      emit(state.copyWith(targetWeightKg: value));

  void updateLossPace(LossPace value) {
    emit(state.copyWith(lossPace: value));
    _calculateCalories();
  }

  void updateActivityLevel(ActivityLevel value) {
    emit(state.copyWith(activityLevel: value));
    _calculateCalories();
  }

  void updateDietType(DietType value) =>
      emit(state.copyWith(dietType: value));

  void toggleFreeDay(int dayIndex) {
    final updated = Set<int>.from(state.freeDays);
    if (updated.contains(dayIndex)) {
      updated.remove(dayIndex);
    } else if (updated.length < 3) {
      updated.add(dayIndex);
    }
    emit(state.copyWith(freeDays: updated));
  }

  void updateBatchCookingEnabled(bool enabled) =>
      emit(state.copyWith(batchCookingEnabled: enabled));

  void showBatchCookingInfo() =>
      emit(state.copyWith(showBatchCookingInfo: true));

  void hideBatchCookingInfo() =>
      emit(state.copyWith(showBatchCookingInfo: false));

  void updateBatchCooking(int sessions) =>
      emit(state.copyWith(batchCookingSessions: sessions.clamp(1, 2)));

  void updateShoppingTrips(int trips) =>
      emit(state.copyWith(shoppingTrips: trips.clamp(1, 2)));

  void updateDistinctBreakfasts(int n) =>
      emit(state.copyWith(distinctBreakfasts: n.clamp(1, 6)));

  void updateDistinctLunches(int n) =>
      emit(state.copyWith(distinctLunches: n.clamp(1, 7)));

  void updateDistinctDinners(int n) =>
      emit(state.copyWith(distinctDinners: n.clamp(1, 7)));

  void updateDistinctSnacks(int n) =>
      emit(state.copyWith(distinctSnacks: n.clamp(1, 5)));

  void updateDietStartDate(DateTime date) =>
      emit(state.copyWith(dietStartDate: date));

  void updateBatchCookingBeforeDiet(bool before) =>
      emit(state.copyWith(batchCookingBeforeDiet: before));

  void updateEconomicMode(bool enabled) =>
      emit(state.copyWith(economicMode: enabled));

  void toggleMealType(MealType mealType) {
    final updated = Set<MealType>.from(state.enabledMealTypes);
    if (updated.contains(mealType) && updated.length > 1) {
      updated.remove(mealType);
    } else {
      updated.add(mealType);
    }
    emit(state.copyWith(enabledMealTypes: updated));
  }

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

  // ── Step navigation ─────────────────────────────────────────────────

  void nextStep() {
    if (state.currentStep >= state.totalSteps - 1) return;

    final nextStep = state.currentStep + 1;
    emit(state.copyWith(currentStep: nextStep));

    if (nextStep == 2) _calculateCalories();
    if (nextStep == 5) _generateAndShowPlan();
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  // ── Plan preview: move meal between days ────────────────────────────

  void openMoveMealDialog(MealWithRecipe meal, int sourceDayPlanId) {
    final weekPlan = state.generatedWeekPlan;
    if (weekPlan == null) return;

    final targetDays = weekPlan.days
        .where((d) => !d.dayPlan.isFreeDay && d.dayPlan.id != sourceDayPlanId)
        .toList()
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));

    emit(state.copyWith(
      showMoveDialog: true,
      movingMeal: meal,
      movingSourceDayPlanId: sourceDayPlanId,
      moveTargetDays: targetDays,
    ));
  }

  void dismissMoveDialog() {
    emit(state.copyWith(
      showMoveDialog: false,
      movingMeal: null,
      moveTargetDays: const [],
    ));
  }

  Future<void> moveMealToDay(int targetDayPlanId) async {
    try {
      final meal = state.movingMeal;
      if (meal == null) return;

      await _mealPlanRepository.swapMealsBetweenDays(
        meal.meal.id,
        targetDayPlanId,
      );

      final updatedPlan = await _mealPlanRepository.getCurrentWeekPlan();
      emit(state.copyWith(
        generatedWeekPlan: updatedPlan,
        showMoveDialog: false,
        movingMeal: null,
        moveTargetDays: const [],
      ));
    } catch (e) {
      debugPrint('Error in moveMealToDay: $e');
    }
  }

  // ── Plan preview: replace recipe ────────────────────────────────────

  Future<void> openReplaceDialog(MealWithRecipe meal) async {
    try {
      final profile = await _userProfileRepository.getProfile();
      final weekPlan = state.generatedWeekPlan;
      if (profile == null || weekPlan == null) return;

      final usedRecipeIds =
          weekPlan.days.expand((d) => d.meals).map((m) => m.recipe.id).toSet();

      final candidates = await _mealPlanGenerator.getCompatibleReplacements(
        meal.recipe.category,
        usedRecipeIds,
        profile,
      );

      final otherOccurrences = weekPlan.days
          .expand((d) => d.meals)
          .where((m) => m.meal.id != meal.meal.id && m.recipe.id == meal.recipe.id)
          .length;

      emit(state.copyWith(
        showReplaceDialog: true,
        replacingMeal: meal,
        replacementCandidates: candidates,
        otherOccurrencesCount: otherOccurrences,
      ));
    } catch (e) {
      debugPrint('Error in openReplaceDialog: $e');
    }
  }

  void dismissReplaceDialog() {
    emit(state.copyWith(
      showReplaceDialog: false,
      replacingMeal: null,
      replacementCandidates: const [],
      otherOccurrencesCount: 0,
    ));
  }

  Future<void> replaceRecipe(Recipe newRecipe, bool replaceAll) async {
    try {
      final currentMeal = state.replacingMeal;
      final weekPlan = state.generatedWeekPlan;
      if (currentMeal == null || weekPlan == null) return;

      final profile = await _userProfileRepository.getProfile();
      if (profile == null) return;

      final mealType = MealType.values.firstWhere(
        (m) => m.name.toUpperCase() == currentMeal.meal.mealType,
        orElse: () => MealType.lunch,
      );

      final mealsToUpdate = replaceAll
          ? weekPlan.days
              .expand((d) => d.meals)
              .where((m) => m.recipe.id == currentMeal.recipe.id)
              .map((m) => m.meal)
              .toList()
          : [currentMeal.meal];

      for (final meal in mealsToUpdate) {
        final type = MealType.values.firstWhere(
          (m) => m.name.toUpperCase() == meal.mealType,
          orElse: () => mealType,
        );
        final servings = _mealPlanGenerator.calculateServings(
          newRecipe,
          profile.dailyCalorieTarget,
          type,
        );
        await _mealPlanRepository.updateMeal(meal.copyWith(
          recipeId: newRecipe.id,
          servings: servings,
        ));
      }

      final updatedPlan = await _mealPlanRepository.getCurrentWeekPlan();
      emit(state.copyWith(
        generatedWeekPlan: updatedPlan,
        showReplaceDialog: false,
        replacingMeal: null,
        replacementCandidates: const [],
        otherOccurrencesCount: 0,
      ));
    } catch (e) {
      debugPrint('Error in replaceRecipe: $e');
    }
  }

  // ── Finish onboarding ──────────────────────────────────────────────

  Future<void> finishOnboarding() async {
    try {
      emit(state.copyWith(isLoading: true));

      // Mark profile as completed
      final profile = await _userProfileRepository.getProfile();
      if (profile != null) {
        await _userProfileRepository.saveProfile(
          UserProfilesCompanion(
            id: const Value(1),
            onboardingCompleted: const Value(true),
            // Preserve all existing fields
            name: Value(profile.name),
            age: Value(profile.age),
            sex: Value(profile.sex),
            heightCm: Value(profile.heightCm),
            weightKg: Value(profile.weightKg),
            targetWeightKg: Value(profile.targetWeightKg),
            lossPace: Value(profile.lossPace),
            activityLevel: Value(profile.activityLevel),
            dietType: Value(profile.dietType),
            dietDaysPerWeek: Value(profile.dietDaysPerWeek),
            batchCookingSessionsPerWeek:
                Value(profile.batchCookingSessionsPerWeek),
            shoppingTripsPerWeek: Value(profile.shoppingTripsPerWeek),
            distinctBreakfasts: Value(profile.distinctBreakfasts),
            distinctLunches: Value(profile.distinctLunches),
            distinctDinners: Value(profile.distinctDinners),
            distinctSnacks: Value(profile.distinctSnacks),
            enabledMealTypes: Value(profile.enabledMealTypes),
            allergies: Value(profile.allergies),
            excludedMeats: Value(profile.excludedMeats),
            dietStartDate: Value(profile.dietStartDate),
            freeDays: Value(profile.freeDays),
            batchCookingBeforeDiet: Value(profile.batchCookingBeforeDiet),
            economicMode: Value(profile.economicMode),
            dailyCalorieTarget: Value(profile.dailyCalorieTarget),
            dailyWaterMl: Value(profile.dailyWaterMl),
            customAllergies: Value(profile.customAllergies),
            createdAt: Value(profile.createdAt),
          ),
        );
      }

      // Generate shopping list
      final weekPlan = await _mealPlanRepository.getCurrentWeekPlan();
      final currentProfile = await _userProfileRepository.getProfile();
      if (weekPlan != null) {
        await _shoppingListGenerator.generateShoppingList(
          weekPlan,
          shoppingTripsPerWeek: currentProfile?.shoppingTripsPerWeek ?? 1,
        );
      }

      emit(state.copyWith(isLoading: false, isOnboardingCompleted: true));
    } catch (e) {
      debugPrint('Error in finishOnboarding: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────

  Future<void> _checkOnboardingStatus() async {
    try {
      final profile = await _userProfileRepository.getProfile();
      if (profile?.onboardingCompleted == true) {
        emit(state.copyWith(isOnboardingCompleted: true));
      }
    } catch (e) {
      debugPrint('Error in _checkOnboardingStatus: $e');
    }
  }

  void _calculateCalories() {
    final weight = double.tryParse(state.weightKg);
    final height = int.tryParse(state.heightCm);
    final age = int.tryParse(state.age);
    if (weight == null || height == null || age == null) return;

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
    emit(state.copyWith(
      calculatedCalories: calories,
      calculatedWaterMl: waterMl,
    ));
  }

  Future<void> _generateAndShowPlan() async {
    try {
      emit(state.copyWith(isLoading: true));

      final weight = double.tryParse(state.weightKg);
      final height = int.tryParse(state.heightCm);
      final age = int.tryParse(state.age);
      if (weight == null || height == null || age == null) return;

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

      final profile = UserProfilesCompanion.insert(
        name: state.name,
        age: age,
        sex: state.sex.name,
        heightCm: height,
        weightKg: weight,
        targetWeightKg: double.tryParse(state.targetWeightKg) ?? weight,
        lossPace: state.lossPace.name,
        activityLevel: state.activityLevel.name,
        dietType: Value(state.dietType.name),
        dietDaysPerWeek: state.dietDaysPerWeek,
        batchCookingSessionsPerWeek:
            state.batchCookingEnabled ? state.batchCookingSessions : 0,
        shoppingTripsPerWeek: state.shoppingTrips,
        distinctBreakfasts: Value(state.distinctBreakfasts),
        distinctLunches: Value(state.distinctLunches),
        distinctDinners: Value(state.distinctDinners),
        distinctSnacks: Value(state.distinctSnacks),
        enabledMealTypes: Value(
            json.encode(state.enabledMealTypes.map((m) => m.name).toList())),
        allergies:
            json.encode(state.selectedAllergies.map((a) => a.name).toList()),
        customAllergies: '',
        excludedMeats: Value(
            json.encode(state.excludedMeats.map((m) => m.name).toList())),
        dietStartDate: AppDateUtils.toEpochMillis(startDate),
        freeDays: Value(json.encode(state.freeDays.toList())),
        dailyCalorieTarget: calories,
        dailyWaterMl: Value(waterMl),
        batchCookingBeforeDiet: Value(state.batchCookingBeforeDiet),
        economicMode: Value(state.economicMode),
        onboardingCompleted: const Value(false),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _userProfileRepository.saveProfile(profile);

      // Log initial weight
      await _weightLogRepository.insertLog(WeightLogsCompanion.insert(
        date: AppDateUtils.todayMillis(),
        weightKg: weight,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));

      // Generate the week plan
      final savedProfile = await _userProfileRepository.getProfile();
      if (savedProfile != null) {
        await _mealPlanGenerator.generateWeekPlan(savedProfile);
      }

      final weekPlan = await _mealPlanRepository.getCurrentWeekPlan();

      emit(state.copyWith(
        isLoading: false,
        generatedWeekPlan: weekPlan,
      ));
    } catch (e) {
      debugPrint('Error in _generateAndShowPlan: $e');
      emit(state.copyWith(isLoading: false));
    }
  }
}
