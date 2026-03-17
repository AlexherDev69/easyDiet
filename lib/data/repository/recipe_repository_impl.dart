import '../local/database.dart';
import '../local/daos/recipe_dao.dart';
import '../local/models/recipe_with_details.dart';
import '../../features/recipes/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._dao);

  final RecipeDao _dao;

  @override
  Stream<List<Recipe>> watchAllRecipes() => _dao.watchAllRecipes();

  @override
  Stream<RecipeWithDetails?> watchRecipeWithDetails(int recipeId) =>
      _dao.watchRecipeWithDetails(recipeId);

  @override
  Future<RecipeWithDetails?> getRecipeWithDetails(int recipeId) =>
      _dao.getRecipeWithDetails(recipeId);

  @override
  Future<List<RecipeWithDetails>> getAllRecipesWithDetails() =>
      _dao.getAllRecipesWithDetails();

  @override
  Future<List<Recipe>> getAllRecipes() => _dao.getAllRecipes();

  @override
  Future<List<Recipe>> getRecipesByCategory(String category) =>
      _dao.getRecipesByCategory(category);
}
