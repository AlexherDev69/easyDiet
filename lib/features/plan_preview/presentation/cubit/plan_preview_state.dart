import 'package:equatable/equatable.dart';

import '../../../../data/local/database.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../data/local/models/week_plan_with_days.dart';

/// State for the standalone plan preview screen.
class PlanPreviewState extends Equatable {
  const PlanPreviewState({
    this.isLoading = false,
    this.weekPlan,
    this.showMoveDialog = false,
    this.movingMeal,
    this.movingSourceDayPlanId = 0,
    this.moveTargetDays = const [],
    this.showReplaceDialog = false,
    this.replacingMeal,
    this.replacementCandidates = const [],
    this.otherOccurrencesCount = 0,
  });

  final bool isLoading;
  final WeekPlanWithDays? weekPlan;
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
        isLoading,
        weekPlan,
        showMoveDialog,
        movingMeal,
        movingSourceDayPlanId,
        moveTargetDays,
        showReplaceDialog,
        replacingMeal,
        replacementCandidates,
        otherOccurrencesCount,
      ];

  PlanPreviewState copyWith({
    bool? isLoading,
    WeekPlanWithDays? weekPlan,
    bool? showMoveDialog,
    MealWithRecipe? movingMeal,
    int? movingSourceDayPlanId,
    List<DayPlanWithMeals>? moveTargetDays,
    bool? showReplaceDialog,
    MealWithRecipe? replacingMeal,
    List<Recipe>? replacementCandidates,
    int? otherOccurrencesCount,
  }) {
    return PlanPreviewState(
      isLoading: isLoading ?? this.isLoading,
      weekPlan: weekPlan ?? this.weekPlan,
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
