import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:easydiet/data/local/database.dart';
import 'package:easydiet/data/local/models/recipe_with_details.dart';
import 'package:easydiet/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:easydiet/features/shopping/domain/repositories/shopping_repository.dart';
import 'package:easydiet/features/shopping/domain/usecases/shopping_list_generator.dart';

import '../../../../fixtures/recipe_fixtures.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockRecipeRepository extends Mock implements RecipeRepository {}

class MockShoppingRepository extends Mock implements ShoppingRepository {}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Captures all ShoppingItemsCompanion passed to insertItems across calls.
class CapturingShoppingRepository extends MockShoppingRepository {
  final List<ShoppingItemsCompanion> inserted = [];

  @override
  Future<List<ShoppingItem>> getGeneratedItemsForWeek(int weekPlanId) async =>
      [];

  @override
  Future<void> deleteItemsByIds(List<int> ids) async {}

  @override
  Future<void> updateItem(ShoppingItem item) async {}

  @override
  Future<void> insertItems(List<ShoppingItemsCompanion> items) async {
    inserted.addAll(items);
  }
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('ShoppingListGenerator', () {
    late MockRecipeRepository mockRecipeRepo;
    late CapturingShoppingRepository capturedShoppingRepo;

    setUp(() {
      mockRecipeRepo = MockRecipeRepository();
      capturedShoppingRepo = CapturingShoppingRepository();
    });

    ShoppingListGenerator buildGenerator() => ShoppingListGenerator(
          mockRecipeRepo,
          capturedShoppingRepo,
        );

    // ── Excluded ingredients ──────────────────────────────────────────────

    test('should not include eau in the shopping list', () async {
      final recipe = makeShoppingTestRecipe(
        id: 1,
        ingredients: [
          makeIngredient(id: 1, recipeId: 1, name: 'eau', quantity: 500, unit: 'ml'),
          makeIngredient(id: 2, recipeId: 1, name: 'riz', quantity: 200, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(
                  recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final names = capturedShoppingRepo.inserted.map((i) => i.name.value);
      expect(names.any((n) => n.toLowerCase().contains('eau')), isFalse);
    });

    test('should not include sel in the shopping list', () async {
      final recipe = makeShoppingTestRecipe(
        id: 1,
        ingredients: [
          makeIngredient(id: 1, recipeId: 1, name: 'sel', quantity: 1, unit: 'pincee'),
          makeIngredient(id: 2, recipeId: 1, name: 'poulet', quantity: 200, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(
                  recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final names = capturedShoppingRepo.inserted.map((i) => i.name.value);
      expect(names.any((n) => n.toLowerCase() == 'sel'), isFalse);
    });

    test('should not include poivre in the shopping list', () async {
      final recipe = makeShoppingTestRecipe(
        id: 1,
        ingredients: [
          makeIngredient(id: 1, recipeId: 1, name: 'poivre', quantity: 1, unit: 'pincee'),
          makeIngredient(id: 2, recipeId: 1, name: 'tomate', quantity: 120, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(
                  recipe: recipe.recipe, mealType: 'DINNER', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final names = capturedShoppingRepo.inserted.map((i) => i.name.value);
      expect(names.any((n) => n.toLowerCase() == 'poivre'), isFalse);
    });

    // ── g/kg unit normalisation ───────────────────────────────────────────

    test('should aggregate grams across two days and convert to kg when >= 1000g',
        () async {
      // Two days, each with 600g of farine → total 1200g → should be stored as 1.2 kg
      final recipe = makeShoppingTestRecipe(
        id: 1,
        ingredients: [
          makeIngredient(id: 1, recipeId: 1, name: 'farine', quantity: 600, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(
                  recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
          makeDayPlan(
            id: 2,
            date: DateTime(2025, 1, 7),
            meals: [
              makeMealWithRecipe(
                  mealId: 2,
                  recipe: recipe.recipe,
                  mealType: 'LUNCH',
                  servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final item = capturedShoppingRepo.inserted.firstWhere(
        (i) => i.name.value.toLowerCase().contains('farine'),
      );
      expect(item.unit.value, equals('kg'));
      expect(item.quantity.value, closeTo(1.2, 0.05));
    });

    test('should convert kg ingredient to grams then back to kg if still >= 1000g',
        () async {
      // 1.5 kg listed in recipe → 1500g aggregated over 1 day → 1.5 kg displayed
      final recipe = makeShoppingTestRecipe(
        id: 2,
        ingredients: [
          makeIngredient(id: 3, recipeId: 2, name: 'farine', quantity: 1.5, unit: 'kg'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final item = capturedShoppingRepo.inserted.firstWhere(
        (i) => i.name.value.toLowerCase().contains('farine'),
      );
      expect(item.unit.value, equals('kg'));
    });

    // ── Piece-count normalisation (poivron rouge → unite) ─────────────────

    test('should convert poivron rouge grams to piece count', () async {
      // 150g of poivron rouge → 1 unit (150g/piece)
      final recipe = makeShoppingTestRecipe(
        id: 3,
        ingredients: [
          makeIngredient(
              id: 4, recipeId: 3, name: 'poivron rouge', quantity: 150, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final item = capturedShoppingRepo.inserted.firstWhere(
        (i) => i.name.value.toLowerCase().contains('poivron'),
      );
      expect(item.unit.value, equals('unite'));
      expect(item.quantity.value, closeTo(1.0, 0.1));
    });

    test('should convert tomate grams to piece count (120g per piece)', () async {
      // 240g of tomate → 2 units
      final recipe = makeShoppingTestRecipe(
        id: 4,
        ingredients: [
          makeIngredient(id: 5, recipeId: 4, name: 'tomate', quantity: 240, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final item = capturedShoppingRepo.inserted.firstWhere(
        (i) => i.name.value.toLowerCase().contains('tomate'),
      );
      expect(item.unit.value, equals('unite'));
      expect(item.quantity.value, closeTo(2.0, 0.1));
    });

    // ── Sauce tomate ml → g override ──────────────────────────────────────

    test('should convert sauce tomate from ml to g via unit override', () async {
      final recipe = makeShoppingTestRecipe(
        id: 5,
        ingredients: [
          makeIngredient(
              id: 6, recipeId: 5, name: 'sauce tomate', quantity: 400, unit: 'ml'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(recipe: recipe.recipe, mealType: 'DINNER', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final item = capturedShoppingRepo.inserted.firstWhere(
        (i) => i.name.value.toLowerCase().contains('sauce tomate'),
      );
      expect(item.unit.value, equals('g'));
    });

    // ── Aggregation across multiple recipes ───────────────────────────────

    test('should sum the same ingredient from two different recipes on the same day',
        () async {
      final recipeA = makeShoppingTestRecipe(
        id: 10,
        name: 'Recette A',
        ingredients: [
          makeIngredient(id: 10, recipeId: 10, name: 'oignon', quantity: 150, unit: 'g'),
        ],
      );
      final recipeB = makeShoppingTestRecipe(
        id: 11,
        name: 'Recette B',
        category: 'DINNER',
        ingredients: [
          makeIngredient(id: 11, recipeId: 11, name: 'oignon', quantity: 150, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipeA, recipeB]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(
                  mealId: 1, recipe: recipeA.recipe, mealType: 'LUNCH', servings: 1),
              makeMealWithRecipe(
                  mealId: 2, recipe: recipeB.recipe, mealType: 'DINNER', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      // 300g → 2 oignons (150g/unit)
      final oignonItems = capturedShoppingRepo.inserted
          .where((i) => i.name.value.toLowerCase().contains('oignon'))
          .toList();
      expect(oignonItems.length, equals(1),
          reason: 'Should be aggregated into a single oignon entry');
      expect(oignonItems.first.quantity.value, closeTo(2.0, 0.1));
    });

    // ── Free days are excluded ────────────────────────────────────────────

    test('should not include ingredients from free days', () async {
      final recipe = makeShoppingTestRecipe(
        id: 20,
        ingredients: [
          makeIngredient(
              id: 20, recipeId: 20, name: 'quinoa', quantity: 150, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          // This day is a free day — meals on it should be ignored
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            isFreeDay: true,
            meals: [
              makeMealWithRecipe(recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final names = capturedShoppingRepo.inserted.map((i) => i.name.value);
      expect(names.any((n) => n.toLowerCase().contains('quinoa')), isFalse);
    });

    // ── sourceDetails JSON ────────────────────────────────────────────────

    test('should populate sourceDetails with recipeName, dayOfWeek, and mealType',
        () async {
      final recipe = makeShoppingTestRecipe(
        id: 30,
        name: 'Salade Nicoise',
        ingredients: [
          makeIngredient(
              id: 30, recipeId: 30, name: 'thon', quantity: 150, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6), // Monday → weekday = 1
            meals: [
              makeMealWithRecipe(
                  recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final item = capturedShoppingRepo.inserted.firstWhere(
        (i) => i.name.value.toLowerCase().contains('thon'),
      );
      final sources =
          json.decode(item.sourceDetails.value!) as List<dynamic>;
      expect(sources, isNotEmpty);

      final source = sources.first as Map<String, dynamic>;
      expect(source['recipeName'], equals('Salade Nicoise'));
      expect(source['dayOfWeek'], equals(1)); // Monday
      expect(source['mealType'], equals('LUNCH'));
    });

    // ── Trip split ────────────────────────────────────────────────────────

    test('should assign all days to trip 1 when shoppingTripsPerWeek is 1',
        () async {
      final recipe = makeShoppingTestRecipe(
        id: 40,
        ingredients: [
          makeIngredient(
              id: 40, recipeId: 40, name: 'brocoli', quantity: 500, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
          makeDayPlan(
            id: 2,
            date: DateTime(2025, 1, 7),
            meals: [
              makeMealWithRecipe(
                  mealId: 2, recipe: recipe.recipe, mealType: 'LUNCH', servings: 1),
            ],
          ),
        ],
      );

      await buildGenerator()
          .generateShoppingList(weekPlan, shoppingTripsPerWeek: 1);

      final items = capturedShoppingRepo.inserted;
      expect(items.every((i) => i.tripNumber.value == 1), isTrue);
    });

    test(
        'should split ingredients across 2 trips when shoppingTripsPerWeek is 2',
        () async {
      final recipe = makeShoppingTestRecipe(
        id: 50,
        ingredients: [
          makeIngredient(
              id: 50, recipeId: 50, name: 'avocat', quantity: 200, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      // 4 diet days across the week to guarantee both trip numbers appear
      final days = List.generate(4, (i) {
        return makeDayPlan(
          id: i + 1,
          date: DateTime(2025, 1, 6 + i),
          meals: [
            makeMealWithRecipe(
                mealId: i + 1,
                recipe: recipe.recipe,
                mealType: 'LUNCH',
                servings: 1),
          ],
        );
      });

      final weekPlan = makeWeekPlan(days: days);

      await buildGenerator()
          .generateShoppingList(weekPlan, shoppingTripsPerWeek: 2);

      final tripNumbers = capturedShoppingRepo.inserted
          .map((i) => i.tripNumber.value)
          .toSet();
      expect(tripNumbers, containsAll([1, 2]));
    });

    // ── Servings multiplier ───────────────────────────────────────────────

    test(
        'should scale ingredient quantity proportionally to servings multiplier',
        () async {
      // Recipe has 1 serving of 100g oignon. Meal uses 2.0 servings → 200g → 1.33 units ≈ 1.5
      final recipe = makeShoppingTestRecipe(
        id: 60,
        servings: 1,
        ingredients: [
          makeIngredient(
              id: 60, recipeId: 60, name: 'oignon', quantity: 100, unit: 'g'),
        ],
      );

      when(() => mockRecipeRepo.getAllRecipesWithDetails())
          .thenAnswer((_) async => [recipe]);

      final weekPlan = makeWeekPlan(
        days: [
          makeDayPlan(
            id: 1,
            date: DateTime(2025, 1, 6),
            meals: [
              makeMealWithRecipe(
                  recipe: recipe.recipe,
                  mealType: 'LUNCH',
                  servings: 2.0), // 2× servings
            ],
          ),
        ],
      );

      await buildGenerator().generateShoppingList(weekPlan);

      final item = capturedShoppingRepo.inserted.firstWhere(
        (i) => i.name.value.toLowerCase().contains('oignon'),
      );
      // 200g / 150g per unit ≈ 1.33 → rounded to nearest 0.5 → 1.5
      expect(item.quantity.value, greaterThan(1.0));
    });
  });
}
