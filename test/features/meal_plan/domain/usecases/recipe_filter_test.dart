import 'package:flutter_test/flutter_test.dart';
import 'package:easydiet/features/meal_plan/domain/usecases/recipe_filter.dart';
import 'package:easydiet/features/onboarding/domain/models/diet_type.dart';

import '../../../../fixtures/recipe_fixtures.dart';

void main() {
  group('RecipeFilter', () {
    // ── Diet type filtering ───────────────────────────────────────────────

    group('filterByDietType', () {
      final allRecipes = [
        makeRecipe(id: 1, dietType: 'OMNIVORE'),
        makeRecipe(id: 2, dietType: 'VEGETARIAN'),
        makeRecipe(id: 3, dietType: 'VEGAN'),
      ];

      test('should accept all recipes when dietType is OMNIVORE', () {
        final result =
            RecipeFilter.filterByDietType(allRecipes, DietType.omnivore);
        expect(result.length, equals(3));
      });

      test(
          'should accept only VEGETARIAN and VEGAN recipes when dietType is VEGETARIAN',
          () {
        final result =
            RecipeFilter.filterByDietType(allRecipes, DietType.vegetarian);
        expect(result.length, equals(2));
        expect(result.every((r) => r.dietType != 'OMNIVORE'), isTrue);
      });

      test('should accept only VEGAN recipes when dietType is VEGAN', () {
        final result =
            RecipeFilter.filterByDietType(allRecipes, DietType.vegan);
        expect(result.length, equals(1));
        expect(result.first.dietType, equals('VEGAN'));
      });

      test('should exclude OMNIVORE recipes when user is VEGAN', () {
        final result =
            RecipeFilter.filterByDietType(allRecipes, DietType.vegan);
        expect(result.any((r) => r.dietType == 'OMNIVORE'), isFalse);
      });

      test('should exclude OMNIVORE recipes when user is VEGETARIAN', () {
        final result =
            RecipeFilter.filterByDietType(allRecipes, DietType.vegetarian);
        expect(result.any((r) => r.dietType == 'OMNIVORE'), isFalse);
      });
    });

    // ── Allergen filtering ────────────────────────────────────────────────

    group('filterByAllergies', () {
      test('should return all recipes when user has no allergies', () {
        final recipes = [
          makeRecipe(id: 1, allergens: ['GLUTEN', 'DAIRY']),
          makeRecipe(id: 2, allergens: ['NUTS']),
        ];
        final result = RecipeFilter.filterByAllergies(recipes, {});
        expect(result.length, equals(2));
      });

      test(
          'should exclude a recipe that contains one of the user declared allergens',
          () {
        final recipes = [
          makeRecipe(id: 1, allergens: ['GLUTEN']),
          makeRecipe(id: 2, allergens: ['DAIRY']),
          makeRecipe(id: 3, allergens: []),
        ];
        final result =
            RecipeFilter.filterByAllergies(recipes, {'GLUTEN'});
        expect(result.length, equals(2));
        expect(result.any((r) => r.allergens.contains('GLUTEN')), isFalse);
      });

      test('should exclude recipes containing any of multiple user allergens',
          () {
        final recipes = [
          makeRecipe(id: 1, allergens: ['GLUTEN']),
          makeRecipe(id: 2, allergens: ['DAIRY']),
          makeRecipe(id: 3, allergens: ['NUTS']),
          makeRecipe(id: 4, allergens: []),
        ];
        final result =
            RecipeFilter.filterByAllergies(recipes, {'GLUTEN', 'DAIRY'});
        expect(result.length, equals(2));
      });

      test(
          'should exclude recipe where SHELLFISH is only tagged in meatTypes not allergens',
          () {
        final recipe = makeRecipe(
          id: 1,
          allergens: [],
          meatTypes: ['SHELLFISH'],
        );
        final result =
            RecipeFilter.filterByAllergies([recipe], {'SHELLFISH'});
        expect(result, isEmpty);
      });
    });

    // ── Excluded meats filtering ──────────────────────────────────────────

    group('filterByExcludedMeats', () {
      test('should return all recipes when excludedMeats is empty', () {
        final recipes = [
          makeRecipe(id: 1, meatTypes: ['PORK']),
          makeRecipe(id: 2, meatTypes: ['BEEF']),
        ];
        final result = RecipeFilter.filterByExcludedMeats(recipes, {});
        expect(result.length, equals(2));
      });

      test('should exclude recipe containing an excluded meat type', () {
        final recipes = [
          makeRecipe(id: 1, meatTypes: ['PORK']),
          makeRecipe(id: 2, meatTypes: ['POULTRY']),
          makeRecipe(id: 3, meatTypes: []),
        ];
        final result =
            RecipeFilter.filterByExcludedMeats(recipes, {'PORK'});
        expect(result.length, equals(2));
        expect(result.any((r) => r.meatTypes.contains('PORK')), isFalse);
      });
    });

    // ── parseAllergies mapping ───────────────────────────────────────────

    group('parseAllergies', () {
      test('should map enum names to canonical JSON keys', () {
        final result = RecipeFilter.parseAllergies(
          ['gluten', 'lactose', 'treeNuts', 'birchPollen'],
          '',
        );
        expect(result, equals({'GLUTEN', 'LACTOSE', 'TREE_NUTS', 'BIRCH_POLLEN'}));
      });

      test('should append uppercased custom allergies', () {
        final result =
            RecipeFilter.parseAllergies(['gluten'], 'kiwi, peanuts');
        expect(result, containsAll(['GLUTEN', 'KIWI', 'PEANUTS']));
      });

      test('should pass through unknown entries uppercased (legacy data)', () {
        final result = RecipeFilter.parseAllergies(['DAIRY'], '');
        expect(result, equals({'DAIRY'}));
      });
    });

    // ── parseExcludedMeats expansion ─────────────────────────────────────

    group('parseExcludedMeats', () {
      // Inputs are enum `.name` (camelCase) as stored in profiles.
      // Legacy uppercase aliases (`ALL_MEAT`, `ALL_FISH`) remain accepted.
      test('should expand allMeat (enum name) to all meat categories', () {
        final expanded = RecipeFilter.parseExcludedMeats(['allMeat']);
        expect(expanded, containsAll(
            ['PORK', 'BEEF', 'POULTRY', 'VEAL', 'LAMB', 'FISH', 'SHELLFISH']));
      });

      test('should expand allFish (enum name) to FISH and SHELLFISH only', () {
        final expanded = RecipeFilter.parseExcludedMeats(['allFish']);
        expect(expanded, containsAll(['FISH', 'SHELLFISH']));
        expect(expanded.contains('BEEF'), isFalse);
      });

      test('should map enum name pork to canonical PORK', () {
        final expanded = RecipeFilter.parseExcludedMeats(['pork']);
        expect(expanded, equals({'PORK'}));
      });

      test('should map shellfishMeat to SHELLFISH', () {
        final expanded = RecipeFilter.parseExcludedMeats(['shellfishMeat']);
        expect(expanded, equals({'SHELLFISH'}));
      });

      test('should still accept legacy ALL_MEAT alias', () {
        final expanded = RecipeFilter.parseExcludedMeats(['ALL_MEAT']);
        expect(expanded, containsAll(
            ['PORK', 'BEEF', 'POULTRY', 'VEAL', 'LAMB', 'FISH', 'SHELLFISH']));
      });

      test('should pass through already-uppercase explicit meat type', () {
        final expanded = RecipeFilter.parseExcludedMeats(['PORK']);
        expect(expanded, equals({'PORK'}));
      });
    });

    // ── applyAll pipeline ─────────────────────────────────────────────────

    group('applyAll', () {
      test('should combine diet type, allergen, and meat filters in one call',
          () {
        final recipes = [
          makeRecipe(id: 1, dietType: 'OMNIVORE', allergens: [], meatTypes: ['PORK']),
          makeRecipe(id: 2, dietType: 'VEGETARIAN', allergens: ['DAIRY'], meatTypes: []),
          makeRecipe(id: 3, dietType: 'VEGAN', allergens: [], meatTypes: []),
        ];

        // Vegan user, dairy allergy, excludes pork
        final result = RecipeFilter.applyAll(
          recipes,
          allergies: {'DAIRY'},
          dietType: DietType.vegan,
          excludedMeats: {'PORK'},
        );

        expect(result.length, equals(1));
        expect(result.first.id, equals(3));
      });
    });
  });
}
