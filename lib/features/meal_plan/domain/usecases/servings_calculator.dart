import '../../../../core/constants/app_constants.dart';
import '../../../../data/local/database.dart';
import '../../../onboarding/domain/models/meal_type.dart';

/// Calculates the number of servings for a recipe in a given meal slot.
class ServingsCalculator {
  ServingsCalculator._();

  /// Returns the serving count rounded to the nearest 0.5,
  /// clamped to [0.5, maxServings].
  static double calculate(
    Recipe recipe,
    int dailyTarget,
    MealType mealType,
  ) {
    final maxServings = mealType == MealType.snack
        ? AppConstants.maxServingsSnack
        : AppConstants.maxServingsMeal;
    final targetCalories = dailyTarget * mealType.calorieShare;
    if (recipe.caloriesPerServing <= 0) return 1.0;
    final servings = targetCalories / recipe.caloriesPerServing;
    // Round to nearest 0.5 instead of floor to avoid chronic calorie
    // under-delivery for high-kcal recipes in small meal slots.
    return ((servings * 2).round() / 2.0).clamp(0.5, maxServings);
  }
}
