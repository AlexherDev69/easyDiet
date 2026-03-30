import 'package:drift/drift.dart';

import '../database.dart';
import '../models/recipe_with_details.dart';
import '../tables/ingredient_table.dart';
import '../tables/recipe_step_table.dart';
import '../tables/recipe_table.dart';

part 'recipe_dao.g.dart';

@DriftAccessor(tables: [Recipes, RecipeSteps, Ingredients])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(super.db);

  /// Watch a single recipe with its steps and ingredients.
  Stream<RecipeWithDetails?> watchRecipeWithDetails(int recipeId) {
    final recipeQuery = select(recipes)..where((t) => t.id.equals(recipeId));
    final stepsQuery = select(recipeSteps)
      ..where((t) => t.recipeId.equals(recipeId))
      ..orderBy([(t) => OrderingTerm.asc(t.stepNumber)]);
    final ingredientsQuery = select(ingredients)
      ..where((t) => t.recipeId.equals(recipeId));

    return recipeQuery.watchSingleOrNull().asyncMap((recipe) async {
      if (recipe == null) return null;
      final stepsList = await stepsQuery.get();
      final ingredientsList = await ingredientsQuery.get();
      return RecipeWithDetails(
        recipe: recipe,
        steps: stepsList,
        ingredients: ingredientsList,
      );
    });
  }

  /// Get a single recipe with details (one-shot).
  Future<RecipeWithDetails?> getRecipeWithDetails(int recipeId) async {
    final recipe = await (select(recipes)
          ..where((t) => t.id.equals(recipeId)))
        .getSingleOrNull();
    if (recipe == null) return null;

    final stepsList = await (select(recipeSteps)
          ..where((t) => t.recipeId.equals(recipeId))
          ..orderBy([(t) => OrderingTerm.asc(t.stepNumber)]))
        .get();
    final ingredientsList = await (select(ingredients)
          ..where((t) => t.recipeId.equals(recipeId)))
        .get();

    return RecipeWithDetails(
      recipe: recipe,
      steps: stepsList,
      ingredients: ingredientsList,
    );
  }

  /// Get all recipes with details (one-shot).
  /// Loads all steps and ingredients in 2 bulk queries, then groups in memory.
  Future<List<RecipeWithDetails>> getAllRecipesWithDetails() async {
    final allRecipes = await select(recipes).get();
    final allSteps = await (select(recipeSteps)
          ..orderBy([(t) => OrderingTerm.asc(t.stepNumber)]))
        .get();
    final allIngredients = await select(ingredients).get();

    final stepsMap = <int, List<RecipeStep>>{};
    for (final step in allSteps) {
      stepsMap.putIfAbsent(step.recipeId, () => []).add(step);
    }

    final ingredientsMap = <int, List<Ingredient>>{};
    for (final ing in allIngredients) {
      ingredientsMap.putIfAbsent(ing.recipeId, () => []).add(ing);
    }

    return allRecipes
        .map((recipe) => RecipeWithDetails(
              recipe: recipe,
              steps: stepsMap[recipe.id] ?? [],
              ingredients: ingredientsMap[recipe.id] ?? [],
            ))
        .toList();
  }

  /// Watch all recipes (without details).
  Stream<List<Recipe>> watchAllRecipes() => select(recipes).watch();

  /// Get all recipes (one-shot).
  Future<List<Recipe>> getAllRecipes() => select(recipes).get();

  /// Get all recipe names (for incremental seeding).
  Future<Set<String>> getAllRecipeNames() async {
    final nameCol = recipes.name;
    final query = selectOnly(recipes)..addColumns([nameCol]);
    final rows = await query.get();
    return rows.map((row) => row.read(nameCol)!).toSet();
  }

  /// Get recipe count.
  Future<int> getRecipeCount() async {
    final count = countAll();
    final query = selectOnly(recipes)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Get recipes by category.
  Future<List<Recipe>> getRecipesByCategory(String category) {
    return (select(recipes)..where((t) => t.category.equals(category))).get();
  }

  /// Get ingredients for a recipe.
  Future<List<Ingredient>> getIngredientsForRecipe(int recipeId) {
    return (select(ingredients)..where((t) => t.recipeId.equals(recipeId)))
        .get();
  }

  /// Insert a recipe and return its ID.
  Future<int> insertRecipe(RecipesCompanion recipe) {
    return into(recipes).insert(recipe);
  }

  /// Insert recipe steps.
  Future<void> insertSteps(List<RecipeStepsCompanion> steps) {
    return batch((b) => b.insertAll(recipeSteps, steps));
  }

  /// Insert ingredients.
  Future<void> insertIngredients(List<IngredientsCompanion> items) {
    return batch((b) => b.insertAll(ingredients, items));
  }

  /// Delete all recipes (cascade deletes steps + ingredients).
  Future<void> deleteAllRecipes() => delete(recipes).go();
}
