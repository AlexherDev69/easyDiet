import 'package:flutter_test/flutter_test.dart';
import 'package:easydiet/features/meal_plan/domain/usecases/servings_calculator.dart';
import 'package:easydiet/features/onboarding/domain/models/meal_type.dart';
import 'package:easydiet/core/constants/app_constants.dart';

import '../../../../fixtures/recipe_fixtures.dart';

void main() {
  group('ServingsCalculator', () {
    // ── Basic computation ─────────────────────────────────────────────────

    test('should calculate breakfast servings as 25% of daily target', () {
      // 2000 * 0.25 = 500 kcal / 500 kcal per serving = 1.0 serving
      final recipe = makeRecipe(caloriesPerServing: 500, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.breakfast);
      expect(result, equals(1.0));
    });

    test('should calculate lunch servings as 35% of daily target', () {
      // 2000 * 0.35 = 700 kcal / 500 kcal per serving = 1.4 → rounds to 1.5
      final recipe = makeRecipe(caloriesPerServing: 500, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.lunch);
      expect(result, equals(1.5));
    });

    test('should calculate dinner servings as 30% of daily target', () {
      // 2000 * 0.30 = 600 kcal / 600 kcal per serving = 1.0
      final recipe = makeRecipe(caloriesPerServing: 600, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.dinner);
      expect(result, equals(1.0));
    });

    test('should calculate snack servings as 10% of daily target', () {
      // 2000 * 0.10 = 200 kcal / 200 kcal per serving = 1.0
      final recipe = makeRecipe(caloriesPerServing: 200, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.snack);
      expect(result, equals(1.0));
    });

    // ── Rounding to nearest 0.5 ──────────────────────────────────────────

    test('should round result to nearest 0.5 increment', () {
      // 2000 * 0.25 = 500 / 350 ≈ 1.43 → rounds to 1.5
      final recipe = makeRecipe(caloriesPerServing: 350, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.breakfast);
      expect(result % 0.5, closeTo(0.0, 0.001));
    });

    test('should produce a result that is always a multiple of 0.5', () {
      final recipe = makeRecipe(caloriesPerServing: 333, servings: 1);
      for (final mealType in MealType.values) {
        final result =
            ServingsCalculator.calculate(recipe, 1800, mealType);
        expect((result * 2).round() / 2.0, equals(result),
            reason: '$mealType: result $result is not a multiple of 0.5');
      }
    });

    // ── Clamp to minimum 0.5 ─────────────────────────────────────────────

    test('should clamp to minimum 0.5 servings for very high-calorie recipe',
        () {
      // A 2000-kcal snack recipe with 200-kcal target → raw = 0.1 → clamp to 0.5
      final recipe = makeRecipe(caloriesPerServing: 2000, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.snack);
      expect(result, equals(0.5));
    });

    // ── Clamp to maximum ─────────────────────────────────────────────────

    test(
        'should clamp meal servings to maxServingsMeal (3.0) for very low-calorie recipe',
        () {
      // 2000 * 0.35 = 700 kcal / 50 kcal per serving = 14 → clamp to 3.0
      final recipe = makeRecipe(caloriesPerServing: 50, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.lunch);
      expect(result, equals(AppConstants.maxServingsMeal));
    });

    test(
        'should clamp snack servings to maxServingsSnack (2.0) for very low-calorie recipe',
        () {
      final recipe = makeRecipe(caloriesPerServing: 10, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.snack);
      expect(result, equals(AppConstants.maxServingsSnack));
    });

    // ── Edge case: zero calories ──────────────────────────────────────────

    test('should return 1.0 when recipe has zero caloriesPerServing', () {
      final recipe = makeRecipe(caloriesPerServing: 0, servings: 1);
      final result =
          ServingsCalculator.calculate(recipe, 2000, MealType.lunch);
      expect(result, equals(1.0));
    });
  });
}
