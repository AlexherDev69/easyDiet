import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../database.dart';

/// Seeds the database with recipes from assets/recipes.json.
class DatabaseSeeder {
  DatabaseSeeder(this._db);

  final AppDatabase _db;

  Future<void> seedRecipes() async {
    final recipeDao = _db.recipeDao;

    final existingNames = await recipeDao.getAllRecipeNames();

    final jsonString = await rootBundle.loadString('assets/recipes.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final allRecipes = data['recipes'] as List<dynamic>;

    final newRecipes =
        allRecipes.where((r) => !existingNames.contains(r['name'])).toList();
    if (newRecipes.isEmpty) return;

    debugPrint('DatabaseSeeder: inserting ${newRecipes.length} new recipes');

    await _db.transaction(() async {
      for (final raw in newRecipes) {
        try {
          final recipe = raw as Map<String, dynamic>;

          final allergens = json.encode(recipe['allergens'] ?? <String>[]);
          final meatTypes = json.encode(recipe['meatTypes'] ?? <String>[]);

          final recipeId = await recipeDao.insertRecipe(
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
          await recipeDao.insertSteps(stepCompanions);

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
          await recipeDao.insertIngredients(ingredientCompanions);
        } catch (e) {
          // Log and skip malformed recipe entries to avoid blocking seeding.
          debugPrint('DatabaseSeeder: skipping recipe due to error — $e');
        }
      }
    });
  }
}
