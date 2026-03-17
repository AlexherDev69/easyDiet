import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../database.dart';
import '../daos/recipe_dao.dart';

/// Seeds the database with recipes from assets/recipes.json.
class DatabaseSeeder {
  DatabaseSeeder(this._recipeDao);

  final RecipeDao _recipeDao;

  Future<void> seedRecipes() async {
    final jsonString = await rootBundle.loadString('assets/recipes.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final recipes = data['recipes'] as List<dynamic>;

    for (final raw in recipes) {
      final recipe = raw as Map<String, dynamic>;

      final allergens = json.encode(recipe['allergens'] ?? <String>[]);
      final meatTypes = json.encode(recipe['meatTypes'] ?? <String>[]);

      final recipeId = await _recipeDao.insertRecipe(
        RecipesCompanion.insert(
          name: recipe['name'] as String,
          description: recipe['description'] as String,
          category: recipe['category'] as String,
          caloriesPerServing: recipe['caloriesPerServing'] as int,
          proteinGrams: (recipe['proteinGrams'] as num).toDouble(),
          carbsGrams: (recipe['carbsGrams'] as num).toDouble(),
          fatGrams: (recipe['fatGrams'] as num).toDouble(),
          servings: recipe['servings'] as int,
          prepTimeMinutes: recipe['prepTimeMinutes'] as int,
          cookTimeMinutes: recipe['cookTimeMinutes'] as int,
          isBatchFriendly: recipe['isBatchFriendly'] as bool,
          allergens: allergens,
          difficulty: Value(recipe['difficulty'] as String? ?? 'EASY'),
          dietType: Value(recipe['dietType'] as String? ?? 'OMNIVORE'),
          meatTypes: Value(meatTypes),
        ),
      );

      // Insert steps
      final steps = recipe['steps'] as List<dynamic>;
      final stepCompanions = steps.map((s) {
        final step = s as Map<String, dynamic>;
        return RecipeStepsCompanion.insert(
          recipeId: recipeId,
          stepNumber: step['stepNumber'] as int,
          instruction: step['instruction'] as String,
          timerSeconds: Value(step['timerSeconds'] as int?),
        );
      }).toList();
      await _recipeDao.insertSteps(stepCompanions);

      // Insert ingredients
      final ingredients = recipe['ingredients'] as List<dynamic>;
      final ingredientCompanions = ingredients.map((i) {
        final ing = i as Map<String, dynamic>;
        return IngredientsCompanion.insert(
          recipeId: recipeId,
          name: ing['name'] as String,
          quantity: (ing['quantity'] as num).toDouble(),
          unit: ing['unit'] as String,
          supermarketSection: ing['section'] as String,
        );
      }).toList();
      await _recipeDao.insertIngredients(ingredientCompanions);
    }
  }
}
