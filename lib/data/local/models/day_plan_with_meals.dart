import '../database.dart';
import 'meal_with_recipe.dart';

/// A day plan joined with all its meals (each including recipe).
class DayPlanWithMeals {
  const DayPlanWithMeals({
    required this.dayPlan,
    required this.meals,
  });

  final DayPlan dayPlan;
  final List<MealWithRecipe> meals;
}
