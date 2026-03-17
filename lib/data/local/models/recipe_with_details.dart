import '../database.dart';

/// Combines a recipe with its steps and ingredients.
class RecipeWithDetails {
  const RecipeWithDetails({
    required this.recipe,
    required this.steps,
    required this.ingredients,
  });

  final Recipe recipe;
  final List<RecipeStep> steps;
  final List<Ingredient> ingredients;
}
