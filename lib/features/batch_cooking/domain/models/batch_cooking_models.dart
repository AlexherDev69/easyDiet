import '../../../../data/local/database.dart';

/// Recipe info for batch cooking overview.
class BatchCookingRecipeInfo {
  const BatchCookingRecipeInfo({
    required this.recipeId,
    required this.recipeName,
    required this.servings,
    required this.baseServings,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.totalTimeMinutes,
    required this.ingredients,
    required this.mealType,
  });

  final int recipeId;
  final String recipeName;
  final double servings;
  final int baseServings;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int totalTimeMinutes;
  final List<Ingredient> ingredients;
  final String mealType;

  double get servingsMultiplier =>
      baseServings > 0 ? servings / baseServings : 1.0;
}

/// Merged ingredient from multiple recipes.
class MergedIngredient {
  const MergedIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.section,
    required this.fromRecipes,
  });

  final String name;
  final double quantity;
  final String unit;
  final String section;
  final List<String> fromRecipes;
}
