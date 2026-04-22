
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/profile_json_parser.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../../meal_plan/domain/usecases/meal_plan_generator.dart';
import '../../../meal_plan/domain/usecases/plan_edit_use_case.dart';
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
    required PlanEditUseCase planEditUseCase,
  })  : _userProfileRepository = userProfileRepository,
        _weightLogRepository = weightLogRepository,
        _calorieCalculator = calorieCalculator,
        _mealPlanGenerator = mealPlanGenerator,
        _mealPlanRepository = mealPlanRepository,
        _shoppingListGenerator = shoppingListGenerator,
        _planEditUseCase = planEditUseCase,
        super(OnboardingState(dietStartDate: AppDateUtils.today(), isLoading: true)) {
    _checkOnboardingStatus();
  }

  final UserProfileRepository _userProfileRepository;
  final WeightLogRepository _weightLogRepository;
  final CalorieCalculator _calorieCalculator;
  final MealPlanGenerator _mealPlanGenerator;
  final MealPlanRepository _mealPlanRepository;
  final ShoppingListGenerator _shoppingListGenerator;
  final PlanEditUseCase _planEditUseCase;

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

    if (nextStep == 3) _calculateCalories();
    _savePartialProfile();
  }

  /// Called from the Allergies step button: generate plan + advance to preview.
  Future<void> generateAndShowPreview() async {
    await _generateAndShowPlan();
    if (state.generatedWeekPlan == null) return;
    emit(state.copyWith(currentStep: state.currentStep + 1));
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
    emit(state.copyWith(
      showMoveDialog: true,
      movingMeal: meal,
      movingSourceDayPlanId: sourceDayPlanId,
      moveTargetDays: _planEditUseCase.getMovableTargetDays(weekPlan, sourceDayPlanId),
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
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final meal = state.movingMeal;
      if (meal == null) return;
      final updatedPlan =
          await _planEditUseCase.moveMealToDay(meal.meal.id, targetDayPlanId);
      emit(state.copyWith(
        generatedWeekPlan: updatedPlan,
        showMoveDialog: false,
        movingMeal: null,
        moveTargetDays: const [],
      ));
    } catch (e) {
      debugPrint('Error in moveMealToDay: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // ── Plan preview: replace recipe ────────────────────────────────────

  Future<void> openReplaceDialog(MealWithRecipe meal) async {
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final weekPlan = state.generatedWeekPlan;
      if (weekPlan == null) return;
      final data = await _planEditUseCase.getReplaceDialogData(meal, weekPlan);
      emit(state.copyWith(
        showReplaceDialog: true,
        replacingMeal: meal,
        replacementCandidates: data.candidates,
        otherOccurrencesCount: data.otherOccurrencesCount,
      ));
    } catch (e) {
      debugPrint('Error in openReplaceDialog: $e');
      emit(state.copyWith(errorMessage: e.toString()));
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
    emit(state.copyWith(clearErrorMessage: true));
    try {
      final currentMeal = state.replacingMeal;
      final weekPlan = state.generatedWeekPlan;
      if (currentMeal == null || weekPlan == null) return;
      final updatedPlan = await _planEditUseCase.replaceRecipe(
        currentMeal,
        weekPlan,
        newRecipe,
        replaceAll: replaceAll,
      );
      emit(state.copyWith(
        generatedWeekPlan: updatedPlan,
        showReplaceDialog: false,
        replacingMeal: null,
        replacementCandidates: const [],
        otherOccurrencesCount: 0,
      ));
    } catch (e) {
      debugPrint('Error in replaceRecipe: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // ── Finish onboarding ──────────────────────────────────────────────

  Future<void> finishOnboarding() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    try {

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
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────

  Future<void> _checkOnboardingStatus() async {
    try {
      final profile = await _userProfileRepository.getProfile();
      if (profile == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      if (profile.onboardingCompleted) {
        emit(state.copyWith(isLoading: false, isOnboardingCompleted: true));
        return;
      }

      // Resume partial onboarding from saved profile
      final resumeStep = await _determineResumeStep(profile);
      emit(state.copyWith(
        isLoading: false,
        currentStep: resumeStep,
        name: profile.name,
        age: profile.age > 0 ? profile.age.toString() : '',
        sex: Sex.values.firstWhere(
          (s) => s.name == profile.sex,
          orElse: () => Sex.male,
        ),
        heightCm: profile.heightCm > 0 ? profile.heightCm.toString() : '',
        weightKg: profile.weightKg > 0 ? profile.weightKg.toString() : '',
        targetWeightKg: profile.targetWeightKg > 0
            ? profile.targetWeightKg.toString()
            : '',
        lossPace: LossPace.values.firstWhere(
          (l) => l.name == profile.lossPace,
          orElse: () => LossPace.moderate,
        ),
        activityLevel: ActivityLevel.values.firstWhere(
          (a) => a.name == profile.activityLevel,
          orElse: () => ActivityLevel.sedentary,
        ),
        dietType: DietType.values.firstWhere(
          (d) => d.name == profile.dietType,
          orElse: () => DietType.omnivore,
        ),
        freeDays: profile.freeDays.toSet(),
        batchCookingEnabled: profile.batchCookingSessionsPerWeek > 0,
        batchCookingSessions:
            profile.batchCookingSessionsPerWeek.clamp(1, 2),
        shoppingTrips: profile.shoppingTripsPerWeek.clamp(1, 2),
        distinctBreakfasts: profile.distinctBreakfasts.clamp(1, 6),
        distinctLunches: profile.distinctLunches.clamp(1, 7),
        distinctDinners: profile.distinctDinners.clamp(1, 7),
        distinctSnacks: profile.distinctSnacks.clamp(1, 5),
        enabledMealTypes: ProfileJsonParser.parseMealTypes(profile.enabledMealTypes),
        batchCookingBeforeDiet: profile.batchCookingBeforeDiet,
        economicMode: profile.economicMode,
        selectedAllergies: ProfileJsonParser.parseAllergies(profile.allergies),
        excludedMeats: ProfileJsonParser.parseExcludedMeats(profile.excludedMeats),
        calculatedCalories: profile.dailyCalorieTarget,
        calculatedWaterMl: profile.dailyWaterMl,
      ));

    } catch (e) {
      debugPrint('Error in _checkOnboardingStatus: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<int> _determineResumeStep(UserProfile profile) async {
    if (profile.name.isEmpty) return 1;
    if (profile.heightCm == 0 || profile.weightKg == 0) return 2;
    if (profile.dailyCalorieTarget == 0) return 3;
    final weekPlan = await _mealPlanRepository.getCurrentWeekPlan();
    if (weekPlan != null) return 6;
    return 5;
  }

  Future<void> _savePartialProfile() async {
    try {
      final weight = double.tryParse(state.weightKg) ?? 0;
      final height = int.tryParse(state.heightCm) ?? 0;
      final age = int.tryParse(state.age) ?? 0;
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
            state.enabledMealTypes.map((m) => m.name).toList()),
        allergies:
            state.selectedAllergies.map((a) => a.name).toList(),
        customAllergies: '',
        excludedMeats: Value(
            state.excludedMeats.map((m) => m.name).toList()),
        dietStartDate: AppDateUtils.toEpochMillis(startDate),
        freeDays: Value(state.freeDays.toList()),
        dailyCalorieTarget: state.calculatedCalories,
        dailyWaterMl: Value(state.calculatedWaterMl),
        batchCookingBeforeDiet: Value(state.batchCookingBeforeDiet),
        economicMode: Value(state.economicMode),
        onboardingCompleted: const Value(false),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _userProfileRepository.saveProfile(profile);
    } catch (e) {
      debugPrint('Error saving partial profile: $e');
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

  /// Minimum duration the generation loading animation is displayed, so
  /// that even when generation is near-instant the hero animation has time
  /// to play out. Matches the progress bar duration in GenerationLoadingView.
  static const _minGenerationAnimationDuration = Duration(milliseconds: 6500);

  Future<void> _generateAndShowPlan() async {
    emit(state.copyWith(isLoading: true, clearErrorMessage: true));
    final minDelay = Future<void>.delayed(_minGenerationAnimationDuration);
    try {
      final weight = double.tryParse(state.weightKg);
      final height = int.tryParse(state.heightCm);
      final age = int.tryParse(state.age);
      if (weight == null || height == null || age == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

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
            state.enabledMealTypes.map((m) => m.name).toList()),
        allergies:
            state.selectedAllergies.map((a) => a.name).toList(),
        customAllergies: '',
        excludedMeats: Value(
            state.excludedMeats.map((m) => m.name).toList()),
        dietStartDate: AppDateUtils.toEpochMillis(startDate),
        freeDays: Value(state.freeDays.toList()),
        dailyCalorieTarget: calories,
        dailyWaterMl: Value(waterMl),
        batchCookingBeforeDiet: Value(state.batchCookingBeforeDiet),
        economicMode: Value(state.economicMode),
        onboardingCompleted: const Value(false),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      await _userProfileRepository.saveProfile(profile);

      // Delete any existing plan (e.g. user went back and changed settings)
      await _mealPlanRepository.deleteWeekPlans();

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

      await minDelay;

      emit(state.copyWith(
        isLoading: false,
        generatedWeekPlan: weekPlan,
      ));
    } catch (e) {
      debugPrint('Error in _generateAndShowPlan: $e');
      await minDelay;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
