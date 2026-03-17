import '../database.dart';

/// A meal entry joined with its recipe data.
class MealWithRecipe {
  const MealWithRecipe({
    required this.meal,
    required this.recipe,
  });

  final Meal meal;
  final Recipe recipe;
}
