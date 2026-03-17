import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../onboarding/domain/models/meal_type.dart';

/// Info about the next meal to eat.
class NextMealInfo {
  const NextMealInfo({
    required this.mealType,
    required this.recipeName,
    required this.caloriesPerServing,
    required this.servings,
    required this.prepTimeMinutes,
  });

  final MealType mealType;
  final String recipeName;
  final int caloriesPerServing;
  final double servings;
  final int prepTimeMinutes;
}

/// Info about the next batch cooking session.
class NextBatchCookingInfo {
  const NextBatchCookingInfo({
    required this.dayPlanId,
    required this.dayName,
    required this.date,
    required this.sessionNumber,
    required this.meals,
  });

  final int dayPlanId;
  final String dayName;
  final DateTime date;
  final int sessionNumber;
  final List<MealWithRecipe> meals;
}

/// A single day in the week schedule row.
class DayScheduleItem {
  const DayScheduleItem({
    required this.dayName,
    required this.date,
    required this.isFreeDay,
    required this.isToday,
    required this.isBatchCooking,
    required this.meals,
    this.hasPlan = true,
  });

  final String dayName;
  final DateTime date;
  final bool isFreeDay;
  final bool isToday;
  final bool isBatchCooking;
  final List<MealWithRecipe> meals;
  final bool hasPlan;
}
