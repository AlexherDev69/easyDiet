import '../../../../data/local/database.dart';
import '../../../../data/local/models/recipe_with_details.dart';

/// Interface for recipe data access.
abstract class RecipeRepository {
  Stream<List<Recipe>> watchAllRecipes();
  Stream<RecipeWithDetails?> watchRecipeWithDetails(int recipeId);
  Future<RecipeWithDetails?> getRecipeWithDetails(int recipeId);
  Future<List<RecipeWithDetails>> getAllRecipesWithDetails();
  Future<List<Recipe>> getAllRecipes();
  Future<List<Recipe>> getRecipesByCategory(String category);
}
