import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:easydiet/data/local/database.dart';
import 'package:easydiet/data/local/models/recipe_with_details.dart';
import 'package:easydiet/features/meal_plan/domain/usecases/meal_plan_generator.dart';
import 'package:easydiet/features/meal_plan/domain/repositories/meal_plan_repository.dart';
import 'package:easydiet/features/recipes/domain/repositories/recipe_repository.dart';

import '../../../../fixtures/recipe_fixtures.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockMealPlanRepository extends Mock implements MealPlanRepository {}

class MockRecipeRepository extends Mock implements RecipeRepository {}

// ── Fake for registerFallbackValue ───────────────────────────────────────────

class FakeWeekPlansCompanion extends Fake implements WeekPlansCompanion {}

class FakeDayPlansCompanion extends Fake implements DayPlansCompanion {}

// ── Helpers ───────────────────────────────────────────────────────────────────

UserProfile makeProfile({
  int id = 1,
  String name = 'Test',
  int age = 30,
  String sex = 'male',
  int heightCm = 175,
  double weightKg = 75,
  double targetWeightKg = 70,
  String lossPace = 'moderate',
  String activityLevel = 'sedentary',
  int dietDaysPerWeek = 5,
  int batchCookingSessionsPerWeek = 0,
  int shoppingTripsPerWeek = 1,
  String dietType = 'OMNIVORE',
  int distinctBreakfasts = 2,
  int distinctLunches = 2,
  int distinctDinners = 2,
  int distinctSnacks = 2,
  List<String> allergies = const [],
  String customAllergies = '',
  int dailyCalorieTarget = 2000,
  int dailyWaterMl = 2500,
  List<String> enabledMealTypes = const [
    'breakfast',
    'lunch',
    'dinner',
    'snack',
  ],
  int? dietStartDate,
  List<int> freeDays = const [],
  bool batchCookingBeforeDiet = true,
  List<String> excludedMeats = const [],
  bool economicMode = false,
  bool onboardingCompleted = true,
}) {
  return UserProfile(
    id: id,
    name: name,
    age: age,
    sex: sex,
    heightCm: heightCm,
    weightKg: weightKg,
    targetWeightKg: targetWeightKg,
    lossPace: lossPace,
    activityLevel: activityLevel,
    dietDaysPerWeek: dietDaysPerWeek,
    batchCookingSessionsPerWeek: batchCookingSessionsPerWeek,
    shoppingTripsPerWeek: shoppingTripsPerWeek,
    dietType: dietType,
    distinctBreakfasts: distinctBreakfasts,
    distinctLunches: distinctLunches,
    distinctDinners: distinctDinners,
    distinctSnacks: distinctSnacks,
    allergies: allergies,
    customAllergies: customAllergies,
    dailyCalorieTarget: dailyCalorieTarget,
    dailyWaterMl: dailyWaterMl,
    enabledMealTypes: enabledMealTypes,
    dietStartDate: dietStartDate ?? DateTime.now().millisecondsSinceEpoch,
    freeDays: freeDays,
    batchCookingBeforeDiet: batchCookingBeforeDiet,
    excludedMeats: excludedMeats,
    economicMode: economicMode,
    onboardingCompleted: onboardingCompleted,
    createdAt: DateTime.now().millisecondsSinceEpoch,
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    registerFallbackValue(FakeWeekPlansCompanion());
    registerFallbackValue(FakeDayPlansCompanion());
  });

  group('MealPlanGenerator', () {
    late MockMealPlanRepository mockMealPlanRepo;
    late MockRecipeRepository mockRecipeRepo;

    setUp(() {
      mockMealPlanRepo = MockMealPlanRepository();
      mockRecipeRepo = MockRecipeRepository();

      // Stub side-effectful persistence methods
      when(() => mockMealPlanRepo.createWeekPlan(any()))
          .thenAnswer((_) async => 1);
      when(() => mockMealPlanRepo.createDayPlan(any()))
          .thenAnswer((_) async => 1);
      when(() => mockMealPlanRepo.createMeals(any()))
          .thenAnswer((_) async {});
    });

    MealPlanGenerator buildGenerator() =>
        MealPlanGenerator(mockMealPlanRepo, mockRecipeRepo);

    // ── validateMacros (visibleForTesting) ───────────────────────────────

    group('validateMacros', () {
      test('should return isValid true when fat and protein are within limits',
          () {
        final generator = buildGenerator();
        // Balanced recipe: 400 kcal, 30g protein (30%), 10g fat (22.5%)
        final recipe = makeRecipe(
          id: 1,
          category: 'LUNCH',
          caloriesPerServing: 400,
          proteinGrams: 30,
          fatGrams: 10,
        );
        final ingredientSets = <int, Set<String>>{
          1: {'poulet', 'lentille', 'oeuf'},
        };

        final result = generator.validateMacros(
          {
            'LUNCH': [recipe],
          },
          2000,
          ingredientSets,
          35.0,
        );

        expect(result.isValid, isTrue);
      });

      test('should return isValid false and identify fattiest recipe when fat > limit',
          () {
        final generator = buildGenerator();
        // Very fatty recipe: 400 kcal, 5g protein, 40g fat (90% fat calories)
        final fattyRecipe = makeRecipe(
          id: 10,
          category: 'LUNCH',
          caloriesPerServing: 400,
          proteinGrams: 5,
          fatGrams: 40,
        );
        final ingredientSets = <int, Set<String>>{
          10: {'fromage'},
        };

        final result = generator.validateMacros(
          {
            'LUNCH': [fattyRecipe],
          },
          2000,
          ingredientSets,
          35.0,
        );

        expect(result.isValid, isFalse);
        expect(result.recipeToBlacklist, equals(10));
      });

      test('should return isValid false when protein percentage is below 20%',
          () {
        final generator = buildGenerator();
        // Carb-heavy recipe: 500 kcal, 5g protein (4% of calories), 5g fat
        final lowProteinRecipe = makeRecipe(
          id: 20,
          category: 'LUNCH',
          caloriesPerServing: 500,
          proteinGrams: 5,
          carbsGrams: 110,
          fatGrams: 5,
        );
        final ingredientSets = <int, Set<String>>{
          20: {'riz'},
        };

        final result = generator.validateMacros(
          {
            'LUNCH': [lowProteinRecipe],
          },
          2000,
          ingredientSets,
          35.0,
        );

        expect(result.isValid, isFalse);
      });

      test(
          'should return isValid false when fewer than 3 distinct protein groups are present',
          () {
        final generator = buildGenerator();
        // Two recipes both from the same protein group
        final recipe1 = makeRecipe(
          id: 30,
          category: 'LUNCH',
          caloriesPerServing: 400,
          proteinGrams: 35,
          fatGrams: 10,
        );
        final recipe2 = makeRecipe(
          id: 31,
          category: 'DINNER',
          caloriesPerServing: 400,
          proteinGrams: 35,
          fatGrams: 10,
        );
        // Only poulet (poultry group) — not enough diversity
        final ingredientSets = <int, Set<String>>{
          30: {'poulet'},
          31: {'poulet'},
        };

        final result = generator.validateMacros(
          {
            'LUNCH': [recipe1],
            'DINNER': [recipe2],
          },
          2000,
          ingredientSets,
          35.0,
        );

        expect(result.isValid, isFalse);
      });
    });

    // ── computeEffectiveFatLimit (visibleForTesting) ─────────────────────

    group('computeEffectiveFatLimit', () {
      test('should return default 35% when median fat is below relaxation threshold',
          () {
        final generator = buildGenerator();
        final recipes = [
          makeRecipe(id: 1, category: 'LUNCH', caloriesPerServing: 400, fatGrams: 10),
          makeRecipe(id: 2, category: 'DINNER', caloriesPerServing: 500, fatGrams: 12),
        ];
        final limit = generator.computeEffectiveFatLimit(recipes);
        expect(limit, equals(35.0));
      });

      test('should return relaxed 38% when median fat exceeds relaxation threshold',
          () {
        final generator = buildGenerator();
        // Build a pool of recipes whose median fat% > 35%
        final recipes = List.generate(
          5,
          (i) => makeRecipe(
            id: i + 1,
            category: i.isEven ? 'LUNCH' : 'DINNER',
            caloriesPerServing: 400,
            fatGrams: 20, // 45% fat → median will be > 35%
          ),
        );
        final limit = generator.computeEffectiveFatLimit(recipes);
        expect(limit, equals(38.0));
      });

      test('should return default 35% when there are no LUNCH or DINNER recipes',
          () {
        final generator = buildGenerator();
        final recipes = [
          makeRecipe(id: 1, category: 'BREAKFAST', caloriesPerServing: 300, fatGrams: 8),
        ];
        final limit = generator.computeEffectiveFatLimit(recipes);
        expect(limit, equals(35.0));
      });
    });

    // ── computeFatPenalty (visibleForTesting) ────────────────────────────

    group('computeFatPenalty', () {
      test('should return 0 when fat percent is below 30%', () {
        final generator = buildGenerator();
        // 10g fat * 9 / 400 * 100 = 22.5%
        expect(generator.computeFatPenalty(10, 400), equals(0));
      });

      test('should return 1 when fat percent is between 30% and 40%', () {
        final generator = buildGenerator();
        // 15g fat * 9 / 400 * 100 = 33.75%
        expect(generator.computeFatPenalty(15, 400), equals(1));
      });

      test('should return 3 when fat percent is between 40% and 50%', () {
        final generator = buildGenerator();
        // 20g fat * 9 / 400 * 100 = 45%
        expect(generator.computeFatPenalty(20, 400), equals(3));
      });

      test('should return 4 when fat percent exceeds 50%', () {
        final generator = buildGenerator();
        // 25g fat * 9 / 400 * 100 = 56.25%
        expect(generator.computeFatPenalty(25, 400), equals(4));
      });

      test('should return 0 when caloriesPerServing is zero', () {
        final generator = buildGenerator();
        expect(generator.computeFatPenalty(15, 0), equals(0));
      });
    });

    // ── isWithinGroupCaps (visibleForTesting) ────────────────────────────

    group('isWithinGroupCaps', () {
      test('should return true when no group has reached the cap of 2', () {
        final generator = buildGenerator();
        final groupUsage = {'poultry': 1};
        expect(
          generator.isWithinGroupCaps({'poulet'}, groupUsage),
          isTrue,
        );
      });

      test('should return false when a group has already reached cap (2)', () {
        final generator = buildGenerator();
        final groupUsage = {'poultry': 2};
        expect(
          generator.isWithinGroupCaps({'poulet'}, groupUsage),
          isFalse,
        );
      });

      test('should return true when ingredients are null', () {
        final generator = buildGenerator();
        expect(generator.isWithinGroupCaps(null, {}), isTrue);
      });

      test('should return true when ingredient has no group mapping', () {
        final generator = buildGenerator();
        expect(
          generator.isWithinGroupCaps({'herbes de provence'}, {'egg': 2}),
          isTrue,
        );
      });
    });

    // ── resolveGroup static ───────────────────────────────────────────────

    group('MealPlanGenerator.resolveGroup', () {
      test('should resolve oeuf to egg group', () {
        expect(MealPlanGenerator.resolveGroup('oeuf'), equals('egg'));
      });

      test('should resolve poulet to poultry group', () {
        expect(MealPlanGenerator.resolveGroup('poulet'), equals('poultry'));
      });

      test('should resolve saumon to salmon group', () {
        expect(MealPlanGenerator.resolveGroup('saumon'), equals('salmon'));
      });

      test('should resolve lentille to legume group', () {
        expect(MealPlanGenerator.resolveGroup('lentille'), equals('legume'));
      });

      test('should resolve tofu to plant_protein group', () {
        expect(MealPlanGenerator.resolveGroup('tofu'), equals('plant_protein'));
      });

      test('should return null for an unknown ingredient', () {
        expect(MealPlanGenerator.resolveGroup('courgette'), equals(null));
      });
    });

    // ── generateWeekPlan: full integration with mocks ────────────────────

    group('generateWeekPlan', () {
      /// Builds a minimal valid catalogue (2 per meal type) for a given diet type.
      List<Recipe> _buildCatalogue({String dietType = 'OMNIVORE'}) {
        final types = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
        var id = 100;
        return types
            .expand((cat) => [
                  makeRecipe(
                    id: id++,
                    category: cat,
                    dietType: dietType,
                    caloriesPerServing: 400,
                    proteinGrams: 30,
                    carbsGrams: 40,
                    fatGrams: 10,
                  ),
                  makeRecipe(
                    id: id++,
                    category: cat,
                    dietType: dietType,
                    caloriesPerServing: 380,
                    proteinGrams: 28,
                    carbsGrams: 38,
                    fatGrams: 9,
                  ),
                ])
            .toList();
      }

      List<RecipeWithDetails> _toWithDetails(List<Recipe> recipes) =>
          recipes.map((r) => makeRecipeWithDetails(recipe: r)).toList();

      test('should not create any meals on free days', () async {
        final catalogue = _buildCatalogue();
        when(() => mockRecipeRepo.getAllRecipes())
            .thenAnswer((_) async => catalogue);
        when(() => mockRecipeRepo.getAllRecipesWithDetails())
            .thenAnswer((_) async => _toWithDetails(catalogue));

        final createdMeals = <List<MealsCompanion>>[];
        when(() => mockMealPlanRepo.createMeals(any())).thenAnswer((inv) async {
          createdMeals.add(inv.positionalArguments[0] as List<MealsCompanion>);
        });

        // Monday (weekday=1) is declared a free day
        final profile = makeProfile(
          freeDays: [1],
          dietStartDate: DateTime(2025, 1, 6).millisecondsSinceEpoch,
        );

        // Capture how many times createDayPlan was called per day
        final dayCapture = <DayPlansCompanion>[];
        when(() => mockMealPlanRepo.createDayPlan(any())).thenAnswer((inv) async {
          dayCapture.add(inv.positionalArguments[0] as DayPlansCompanion);
          return dayCapture.length;
        });

        await buildGenerator().generateWeekPlan(profile);

        // Any day companion with isFreeDay = true should have had no meals created
        // after its dayPlanId was returned. We verify via the isFreeDay flag.
        final freeDayCompanions = dayCapture
            .where((d) => d.isFreeDay.value == true)
            .toList();
        expect(freeDayCompanions, isNotEmpty,
            reason: 'Expected at least one free day to be created');
        // createMeals should never have been called with the dayPlanId
        // corresponding to a free day (implementation skips isFreeDay days).
        // Since dayPlanId is incremental and we know free day is index 0 (id=1),
        // assert no MealsCompanion has dayPlanId 1 (the free day id).
        final allMeals = createdMeals.expand((m) => m).toList();
        for (final meal in allMeals) {
          expect(meal.dayPlanId.value, isNot(equals(1)));
        }
      });

      test('should not generate snack meals when snack is disabled', () async {
        final catalogue = _buildCatalogue();
        when(() => mockRecipeRepo.getAllRecipes())
            .thenAnswer((_) async => catalogue);
        when(() => mockRecipeRepo.getAllRecipesWithDetails())
            .thenAnswer((_) async => _toWithDetails(catalogue));

        final createdMeals = <List<MealsCompanion>>[];
        when(() => mockMealPlanRepo.createMeals(any())).thenAnswer((inv) async {
          createdMeals.add(inv.positionalArguments[0] as List<MealsCompanion>);
        });
        when(() => mockMealPlanRepo.createDayPlan(any()))
            .thenAnswer((inv) async => 1);

        final profile = makeProfile(
          enabledMealTypes: ['breakfast', 'lunch', 'dinner'], // snack disabled
          dietStartDate: DateTime(2025, 1, 6).millisecondsSinceEpoch,
        );

        await buildGenerator().generateWeekPlan(profile);

        final allMeals = createdMeals.expand((m) => m).toList();
        final snackMeals =
            allMeals.where((m) => m.mealType.value == 'SNACK').toList();
        expect(snackMeals, isEmpty,
            reason: 'No SNACK meals should be created when snack is disabled');
      });

      test('should not pick a recipe with an allergen declared by the user',
          () async {
        // Only recipe in LUNCH has NUTS allergen; user is allergic to NUTS
        final nutRecipe = makeRecipe(
          id: 200,
          category: 'LUNCH',
          dietType: 'OMNIVORE',
          allergens: ['NUTS'],
          caloriesPerServing: 400,
          proteinGrams: 25,
          fatGrams: 10,
        );
        final safeRecipe = makeRecipe(
          id: 201,
          category: 'LUNCH',
          dietType: 'OMNIVORE',
          allergens: [],
          caloriesPerServing: 420,
          proteinGrams: 28,
          fatGrams: 10,
        );
        final allRecipes = [
          // Breakfasts
          makeRecipe(id: 202, category: 'BREAKFAST', dietType: 'OMNIVORE', caloriesPerServing: 350, proteinGrams: 22, fatGrams: 8),
          makeRecipe(id: 203, category: 'BREAKFAST', dietType: 'OMNIVORE', caloriesPerServing: 320, proteinGrams: 20, fatGrams: 7),
          // Lunches (one with allergen, one without)
          nutRecipe,
          safeRecipe,
          // Dinners
          makeRecipe(id: 204, category: 'DINNER', dietType: 'OMNIVORE', caloriesPerServing: 500, proteinGrams: 35, fatGrams: 12),
          makeRecipe(id: 205, category: 'DINNER', dietType: 'OMNIVORE', caloriesPerServing: 480, proteinGrams: 33, fatGrams: 11),
          // Snacks
          makeRecipe(id: 206, category: 'SNACK', dietType: 'OMNIVORE', caloriesPerServing: 180, proteinGrams: 10, fatGrams: 5),
          makeRecipe(id: 207, category: 'SNACK', dietType: 'OMNIVORE', caloriesPerServing: 160, proteinGrams: 9, fatGrams: 4),
        ];

        when(() => mockRecipeRepo.getAllRecipes())
            .thenAnswer((_) async => allRecipes);
        when(() => mockRecipeRepo.getAllRecipesWithDetails()).thenAnswer(
            (_) async => allRecipes.map((r) => makeRecipeWithDetails(recipe: r)).toList());

        final createdMeals = <List<MealsCompanion>>[];
        when(() => mockMealPlanRepo.createMeals(any())).thenAnswer((inv) async {
          createdMeals.add(inv.positionalArguments[0] as List<MealsCompanion>);
        });
        when(() => mockMealPlanRepo.createDayPlan(any()))
            .thenAnswer((inv) async => 1);

        final profile = makeProfile(
          allergies: ['NUTS'],
          dietStartDate: DateTime(2025, 1, 6).millisecondsSinceEpoch,
        );

        await buildGenerator().generateWeekPlan(profile);

        final allGeneratedMeals = createdMeals.expand((m) => m).toList();
        final lunchMeals = allGeneratedMeals
            .where((m) => m.mealType.value == 'LUNCH')
            .toList();

        // None of the LUNCH meals should reference the nut recipe
        for (final meal in lunchMeals) {
          expect(meal.recipeId.value, isNot(equals(nutRecipe.id)),
              reason: 'Recipe with NUTS allergen must not be assigned');
        }
      });

      test('should only use VEGAN recipes when user dietType is VEGAN', () async {
        final veganRecipes = [
          makeRecipe(id: 300, category: 'BREAKFAST', dietType: 'VEGAN', caloriesPerServing: 350, proteinGrams: 20, fatGrams: 8),
          makeRecipe(id: 301, category: 'BREAKFAST', dietType: 'VEGAN', caloriesPerServing: 320, proteinGrams: 18, fatGrams: 7),
          makeRecipe(id: 302, category: 'LUNCH', dietType: 'VEGAN', caloriesPerServing: 420, proteinGrams: 25, fatGrams: 9),
          makeRecipe(id: 303, category: 'LUNCH', dietType: 'VEGAN', caloriesPerServing: 400, proteinGrams: 23, fatGrams: 8),
          makeRecipe(id: 304, category: 'DINNER', dietType: 'VEGAN', caloriesPerServing: 480, proteinGrams: 28, fatGrams: 11),
          makeRecipe(id: 305, category: 'DINNER', dietType: 'VEGAN', caloriesPerServing: 460, proteinGrams: 26, fatGrams: 10),
          makeRecipe(id: 306, category: 'SNACK', dietType: 'VEGAN', caloriesPerServing: 180, proteinGrams: 8, fatGrams: 4),
          makeRecipe(id: 307, category: 'SNACK', dietType: 'VEGAN', caloriesPerServing: 160, proteinGrams: 7, fatGrams: 3),
        ];
        final omniRecipes = [
          makeRecipe(id: 400, category: 'LUNCH', dietType: 'OMNIVORE', caloriesPerServing: 500, proteinGrams: 40, fatGrams: 15),
        ];
        final all = [...veganRecipes, ...omniRecipes];
        final veganIds = veganRecipes.map((r) => r.id).toSet();

        // Enrich vegan recipes with ingredient keys recognised by resolveGroup
        // so that the macro validation (minProteinGroups=3) can pass.
        // Without ingredients, every recipe would be blacklisted and the
        // fallback could collapse to an empty selection.
        RecipeWithDetails enrichVegan(Recipe r) {
          return makeRecipeWithDetails(
            recipe: r,
            ingredients: [
              makeIngredient(id: r.id * 10,     recipeId: r.id, name: 'tofu',       quantity: 100, unit: 'g'),
              makeIngredient(id: r.id * 10 + 1, recipeId: r.id, name: 'lentille',   quantity: 150, unit: 'g'),
              makeIngredient(id: r.id * 10 + 2, recipeId: r.id, name: 'pois chiche',quantity: 100, unit: 'g'),
            ],
          );
        }

        when(() => mockRecipeRepo.getAllRecipes())
            .thenAnswer((_) async => all);
        when(() => mockRecipeRepo.getAllRecipesWithDetails()).thenAnswer(
            (_) async => [
              ...veganRecipes.map(enrichVegan),
              ...omniRecipes.map((r) => makeRecipeWithDetails(recipe: r)),
            ]);

        final createdMeals = <List<MealsCompanion>>[];
        when(() => mockMealPlanRepo.createMeals(any())).thenAnswer((inv) async {
          createdMeals.add(inv.positionalArguments[0] as List<MealsCompanion>);
        });
        when(() => mockMealPlanRepo.createDayPlan(any()))
            .thenAnswer((inv) async => 1);

        // profile.dietType must match DietType enum name (lowercase) since
        // generateWeekPlan uses DietType.values.firstWhere((d) => d.name == ...).
        final profile = makeProfile(
          dietType: 'vegan',
          dietStartDate: DateTime(2025, 1, 6).millisecondsSinceEpoch,
        );

        await buildGenerator().generateWeekPlan(profile);

        final allGeneratedMeals = createdMeals.expand((m) => m).toList();
        for (final meal in allGeneratedMeals) {
          expect(veganIds.contains(meal.recipeId.value), isTrue,
              reason:
                  'Recipe id ${meal.recipeId.value} is not vegan');
        }
      });

      test('should not assign excluded meat recipes to any meal', () async {
        final porkRecipe = makeRecipe(
          id: 500,
          category: 'LUNCH',
          dietType: 'OMNIVORE',
          meatTypes: ['PORK'],
          caloriesPerServing: 400,
          proteinGrams: 28,
          fatGrams: 10,
        );
        final safeRecipe = makeRecipe(
          id: 501,
          category: 'LUNCH',
          dietType: 'OMNIVORE',
          meatTypes: ['POULTRY'],
          caloriesPerServing: 420,
          proteinGrams: 30,
          fatGrams: 9,
        );
        final all = [
          makeRecipe(id: 502, category: 'BREAKFAST', dietType: 'OMNIVORE', caloriesPerServing: 350, proteinGrams: 22, fatGrams: 8),
          makeRecipe(id: 503, category: 'BREAKFAST', dietType: 'OMNIVORE', caloriesPerServing: 320, proteinGrams: 20, fatGrams: 7),
          porkRecipe,
          safeRecipe,
          makeRecipe(id: 504, category: 'DINNER', dietType: 'OMNIVORE', caloriesPerServing: 500, proteinGrams: 35, fatGrams: 12),
          makeRecipe(id: 505, category: 'DINNER', dietType: 'OMNIVORE', caloriesPerServing: 480, proteinGrams: 33, fatGrams: 11),
          makeRecipe(id: 506, category: 'SNACK', dietType: 'OMNIVORE', caloriesPerServing: 180, proteinGrams: 10, fatGrams: 5),
          makeRecipe(id: 507, category: 'SNACK', dietType: 'OMNIVORE', caloriesPerServing: 160, proteinGrams: 9, fatGrams: 4),
        ];

        when(() => mockRecipeRepo.getAllRecipes()).thenAnswer((_) async => all);
        when(() => mockRecipeRepo.getAllRecipesWithDetails()).thenAnswer(
            (_) async => all.map((r) => makeRecipeWithDetails(recipe: r)).toList());

        final createdMeals = <List<MealsCompanion>>[];
        when(() => mockMealPlanRepo.createMeals(any())).thenAnswer((inv) async {
          createdMeals.add(inv.positionalArguments[0] as List<MealsCompanion>);
        });
        when(() => mockMealPlanRepo.createDayPlan(any()))
            .thenAnswer((inv) async => 1);

        final profile = makeProfile(
          excludedMeats: ['PORK'],
          dietStartDate: DateTime(2025, 1, 6).millisecondsSinceEpoch,
        );

        await buildGenerator().generateWeekPlan(profile);

        final allGeneratedMeals = createdMeals.expand((m) => m).toList();
        for (final meal in allGeneratedMeals) {
          expect(meal.recipeId.value, isNot(equals(porkRecipe.id)),
              reason: 'Pork recipe must not appear when PORK is excluded');
        }
      });

      test('should return immediately without creating a plan when recipe list is empty',
          () async {
        when(() => mockRecipeRepo.getAllRecipes()).thenAnswer((_) async => []);
        when(() => mockRecipeRepo.getAllRecipesWithDetails())
            .thenAnswer((_) async => []);

        final profile = makeProfile(
          dietStartDate: DateTime(2025, 1, 6).millisecondsSinceEpoch,
        );

        await buildGenerator().generateWeekPlan(profile);

        verifyNever(() => mockMealPlanRepo.createWeekPlan(any()));
      });
    });
  });
}
