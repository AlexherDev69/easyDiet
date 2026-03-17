import '../../../../data/local/database.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../data/local/models/week_plan_with_days.dart';

/// UI state for the weekly meal plan screen.
class MealPlanState {
  const MealPlanState({
    this.weekPlan,
    this.isLoading = true,
    this.isRegenerating = false,
    this.selectedDayIndex = 0,
    // Swap dialog
    this.swapDialogMeal,
    this.swapAlternatives = const [],
    this.swapOtherOccurrencesCount = 0,
    // Move dialog
    this.showMoveDialog = false,
    this.movingMeal,
    this.movingSourceDayPlanId = 0,
    this.moveTargetDays = const [],
  });

  final WeekPlanWithDays? weekPlan;
  final bool isLoading;
  final bool isRegenerating;
  final int selectedDayIndex;

  // Swap dialog state
  final Meal? swapDialogMeal;
  final List<Recipe> swapAlternatives;
  final int swapOtherOccurrencesCount;

  // Move dialog state
  final bool showMoveDialog;
  final MealWithRecipe? movingMeal;
  final int movingSourceDayPlanId;
  final List<DayPlanWithMeals> moveTargetDays;

  /// Sorted days from the plan.
  List<DayPlanWithMeals> get sortedDays {
    final days = weekPlan?.days ?? [];
    return List.of(days)..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));
  }

  MealPlanState copyWith({
    WeekPlanWithDays? weekPlan,
    bool? isLoading,
    bool? isRegenerating,
    int? selectedDayIndex,
    Meal? swapDialogMeal,
    List<Recipe>? swapAlternatives,
    int? swapOtherOccurrencesCount,
    bool? showMoveDialog,
    MealWithRecipe? movingMeal,
    int? movingSourceDayPlanId,
    List<DayPlanWithMeals>? moveTargetDays,
    bool clearSwapDialog = false,
    bool clearMoveDialog = false,
  }) {
    return MealPlanState(
      weekPlan: weekPlan ?? this.weekPlan,
      isLoading: isLoading ?? this.isLoading,
      isRegenerating: isRegenerating ?? this.isRegenerating,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      swapDialogMeal:
          clearSwapDialog ? null : (swapDialogMeal ?? this.swapDialogMeal),
      swapAlternatives: clearSwapDialog
          ? const []
          : (swapAlternatives ?? this.swapAlternatives),
      swapOtherOccurrencesCount: clearSwapDialog
          ? 0
          : (swapOtherOccurrencesCount ?? this.swapOtherOccurrencesCount),
      showMoveDialog:
          clearMoveDialog ? false : (showMoveDialog ?? this.showMoveDialog),
      movingMeal:
          clearMoveDialog ? null : (movingMeal ?? this.movingMeal),
      movingSourceDayPlanId: clearMoveDialog
          ? 0
          : (movingSourceDayPlanId ?? this.movingSourceDayPlanId),
      moveTargetDays: clearMoveDialog
          ? const []
          : (moveTargetDays ?? this.moveTargetDays),
    );
  }
}
