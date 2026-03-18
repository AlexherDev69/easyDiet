import 'package:equatable/equatable.dart';

import '../../../../data/local/database.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../domain/models/models.dart';

/// Onboarding UI state — mirrors OnboardingUiState from Kotlin.
class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentStep = 0,
    this.name = '',
    this.age = '',
    this.sex = Sex.male,
    this.heightCm = '',
    this.weightKg = '',
    this.targetWeightKg = '',
    this.lossPace = LossPace.moderate,
    this.activityLevel = ActivityLevel.sedentary,
    this.dietType = DietType.omnivore,
    this.freeDays = const {},
    this.batchCookingEnabled = false,
    this.showBatchCookingInfo = false,
    this.batchCookingSessions = 1,
    this.shoppingTrips = 1,
    this.distinctBreakfasts = 2,
    this.distinctLunches = 3,
    this.distinctDinners = 3,
    this.distinctSnacks = 2,
    this.enabledMealTypes = const {
      MealType.breakfast,
      MealType.lunch,
      MealType.dinner,
      MealType.snack,
    },
    this.dietStartDate,
    this.batchCookingBeforeDiet = true,
    this.selectedAllergies = const {},
    this.excludedMeats = const {},
    this.economicMode = false,
    this.calculatedCalories = 0,
    this.calculatedWaterMl = 0,
    this.isLoading = false,
    this.isOnboardingCompleted = false,
    this.totalSteps = 6,
    this.generatedWeekPlan,
    this.showMoveDialog = false,
    this.movingMeal,
    this.movingSourceDayPlanId = 0,
    this.moveTargetDays = const [],
    this.showReplaceDialog = false,
    this.replacingMeal,
    this.replacementCandidates = const [],
    this.otherOccurrencesCount = 0,
  });

  final int currentStep;
  final String name;
  final String age;
  final Sex sex;
  final String heightCm;
  final String weightKg;
  final String targetWeightKg;
  final LossPace lossPace;
  final ActivityLevel activityLevel;
  final DietType dietType;
  final Set<int> freeDays;
  final bool batchCookingEnabled;
  final bool showBatchCookingInfo;
  final int batchCookingSessions;
  final int shoppingTrips;
  final int distinctBreakfasts;
  final int distinctLunches;
  final int distinctDinners;
  final int distinctSnacks;
  final Set<MealType> enabledMealTypes;
  final DateTime? dietStartDate;
  final bool batchCookingBeforeDiet;
  final Set<Allergy> selectedAllergies;
  final Set<ExcludedMeat> excludedMeats;
  final bool economicMode;
  final int calculatedCalories;
  final int calculatedWaterMl;
  final bool isLoading;
  final bool isOnboardingCompleted;
  final int totalSteps;

  // Plan preview state (step 5)
  final WeekPlanWithDays? generatedWeekPlan;
  final bool showMoveDialog;
  final MealWithRecipe? movingMeal;
  final int movingSourceDayPlanId;
  final List<DayPlanWithMeals> moveTargetDays;
  final bool showReplaceDialog;
  final MealWithRecipe? replacingMeal;
  final List<Recipe> replacementCandidates;
  final int otherOccurrencesCount;

  @override
  List<Object?> get props => [
        currentStep,
        name,
        age,
        sex,
        heightCm,
        weightKg,
        targetWeightKg,
        lossPace,
        activityLevel,
        dietType,
        freeDays,
        batchCookingEnabled,
        showBatchCookingInfo,
        batchCookingSessions,
        shoppingTrips,
        distinctBreakfasts,
        distinctLunches,
        distinctDinners,
        distinctSnacks,
        enabledMealTypes,
        dietStartDate,
        batchCookingBeforeDiet,
        selectedAllergies,
        excludedMeats,
        economicMode,
        calculatedCalories,
        calculatedWaterMl,
        isLoading,
        isOnboardingCompleted,
        totalSteps,
        generatedWeekPlan,
        showMoveDialog,
        movingMeal,
        movingSourceDayPlanId,
        moveTargetDays,
        showReplaceDialog,
        replacingMeal,
        replacementCandidates,
        otherOccurrencesCount,
      ];

  int get dietDaysPerWeek => 7 - freeDays.length;

  bool get isCurrentStepValid {
    switch (currentStep) {
      case 0:
        final ageInt = int.tryParse(age);
        return name.trim().isNotEmpty &&
            ageInt != null &&
            ageInt >= 10 &&
            ageInt <= 120;
      case 1:
        final h = int.tryParse(heightCm);
        final w = double.tryParse(weightKg);
        return h != null &&
            h >= 100 &&
            h <= 250 &&
            w != null &&
            w >= 30 &&
            w <= 300;
      case 2:
        final target = double.tryParse(targetWeightKg);
        final current = double.tryParse(weightKg);
        return target != null &&
            target >= 30 &&
            target <= 300 &&
            (current == null || target < current);
      case 3:
        return freeDays.length <= 3; // at least 4 diet days
      case 4:
        return true;
      case 5:
        return generatedWeekPlan != null;
      default:
        return false;
    }
  }

  OnboardingState copyWith({
    int? currentStep,
    String? name,
    String? age,
    Sex? sex,
    String? heightCm,
    String? weightKg,
    String? targetWeightKg,
    LossPace? lossPace,
    ActivityLevel? activityLevel,
    DietType? dietType,
    Set<int>? freeDays,
    bool? batchCookingEnabled,
    bool? showBatchCookingInfo,
    int? batchCookingSessions,
    int? shoppingTrips,
    int? distinctBreakfasts,
    int? distinctLunches,
    int? distinctDinners,
    int? distinctSnacks,
    Set<MealType>? enabledMealTypes,
    DateTime? dietStartDate,
    bool? batchCookingBeforeDiet,
    Set<Allergy>? selectedAllergies,
    Set<ExcludedMeat>? excludedMeats,
    bool? economicMode,
    int? calculatedCalories,
    int? calculatedWaterMl,
    bool? isLoading,
    bool? isOnboardingCompleted,
    int? totalSteps,
    WeekPlanWithDays? generatedWeekPlan,
    bool? showMoveDialog,
    MealWithRecipe? movingMeal,
    int? movingSourceDayPlanId,
    List<DayPlanWithMeals>? moveTargetDays,
    bool? showReplaceDialog,
    MealWithRecipe? replacingMeal,
    List<Recipe>? replacementCandidates,
    int? otherOccurrencesCount,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      lossPace: lossPace ?? this.lossPace,
      activityLevel: activityLevel ?? this.activityLevel,
      dietType: dietType ?? this.dietType,
      freeDays: freeDays ?? this.freeDays,
      batchCookingEnabled: batchCookingEnabled ?? this.batchCookingEnabled,
      showBatchCookingInfo: showBatchCookingInfo ?? this.showBatchCookingInfo,
      batchCookingSessions: batchCookingSessions ?? this.batchCookingSessions,
      shoppingTrips: shoppingTrips ?? this.shoppingTrips,
      distinctBreakfasts: distinctBreakfasts ?? this.distinctBreakfasts,
      distinctLunches: distinctLunches ?? this.distinctLunches,
      distinctDinners: distinctDinners ?? this.distinctDinners,
      distinctSnacks: distinctSnacks ?? this.distinctSnacks,
      enabledMealTypes: enabledMealTypes ?? this.enabledMealTypes,
      dietStartDate: dietStartDate ?? this.dietStartDate,
      batchCookingBeforeDiet:
          batchCookingBeforeDiet ?? this.batchCookingBeforeDiet,
      selectedAllergies: selectedAllergies ?? this.selectedAllergies,
      excludedMeats: excludedMeats ?? this.excludedMeats,
      economicMode: economicMode ?? this.economicMode,
      calculatedCalories: calculatedCalories ?? this.calculatedCalories,
      calculatedWaterMl: calculatedWaterMl ?? this.calculatedWaterMl,
      isLoading: isLoading ?? this.isLoading,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      totalSteps: totalSteps ?? this.totalSteps,
      generatedWeekPlan: generatedWeekPlan ?? this.generatedWeekPlan,
      showMoveDialog: showMoveDialog ?? this.showMoveDialog,
      movingMeal: movingMeal ?? this.movingMeal,
      movingSourceDayPlanId:
          movingSourceDayPlanId ?? this.movingSourceDayPlanId,
      moveTargetDays: moveTargetDays ?? this.moveTargetDays,
      showReplaceDialog: showReplaceDialog ?? this.showReplaceDialog,
      replacingMeal: replacingMeal ?? this.replacingMeal,
      replacementCandidates:
          replacementCandidates ?? this.replacementCandidates,
      otherOccurrencesCount:
          otherOccurrencesCount ?? this.otherOccurrencesCount,
    );
  }
}
