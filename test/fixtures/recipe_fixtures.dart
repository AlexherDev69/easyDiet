import 'package:easydiet/data/local/database.dart';
import 'package:easydiet/data/local/models/recipe_with_details.dart';
import 'package:easydiet/data/local/models/day_plan_with_meals.dart';
import 'package:easydiet/data/local/models/meal_with_recipe.dart';
import 'package:easydiet/data/local/models/week_plan_with_days.dart';

// ── Recipe helpers ────────────────────────────────────────────────────────────

Recipe makeRecipe({
  int id = 1,
  String name = 'Test Recipe',
  String category = 'LUNCH',
  int caloriesPerServing = 400,
  double proteinGrams = 30,
  double carbsGrams = 40,
  double fatGrams = 10,
  int servings = 1,
  String dietType = 'OMNIVORE',
  List<String> allergens = const [],
  List<String> meatTypes = const [],
  bool isBatchFriendly = false,
}) {
  return Recipe(
    id: id,
    name: name,
    description: '',
    category: category,
    caloriesPerServing: caloriesPerServing,
    proteinGrams: proteinGrams,
    carbsGrams: carbsGrams,
    fatGrams: fatGrams,
    servings: servings,
    prepTimeMinutes: 10,
    cookTimeMinutes: 20,
    isBatchFriendly: isBatchFriendly,
    allergens: allergens,
    difficulty: 'EASY',
    dietType: dietType,
    meatTypes: meatTypes,
    imagePath: null,
  );
}

RecipeWithDetails makeRecipeWithDetails({
  required Recipe recipe,
  List<Ingredient> ingredients = const [],
}) {
  return RecipeWithDetails(
    recipe: recipe,
    steps: [],
    ingredients: ingredients,
  );
}

Ingredient makeIngredient({
  int id = 1,
  int recipeId = 1,
  required String name,
  required double quantity,
  required String unit,
  String supermarketSection = 'PRODUCE',
}) {
  return Ingredient(
    id: id,
    recipeId: recipeId,
    name: name,
    quantity: quantity,
    unit: unit,
    supermarketSection: supermarketSection,
  );
}

// ── Catalogue fixtures ────────────────────────────────────────────────────────

/// Omnivore breakfast with egg (protein) + gluten (allergen).
final recipeOmnivoreBreakfast = makeRecipe(
  id: 1,
  name: 'Omelette Jambon',
  category: 'BREAKFAST',
  caloriesPerServing: 350,
  proteinGrams: 28,
  carbsGrams: 5,
  fatGrams: 22,
  dietType: 'OMNIVORE',
  allergens: ['GLUTEN'],
  meatTypes: ['PORK'],
);

/// Omnivore lunch — chicken (poultry).
final recipeOmnivoreLunch = makeRecipe(
  id: 2,
  name: 'Poulet Riz',
  category: 'LUNCH',
  caloriesPerServing: 500,
  proteinGrams: 40,
  carbsGrams: 50,
  fatGrams: 8,
  dietType: 'OMNIVORE',
  allergens: [],
  meatTypes: ['POULTRY'],
);

/// Omnivore dinner — beef (red_meat).
final recipeOmnivoreDinner = makeRecipe(
  id: 3,
  name: 'Boeuf Patate Douce',
  category: 'DINNER',
  caloriesPerServing: 600,
  proteinGrams: 45,
  carbsGrams: 55,
  fatGrams: 12,
  dietType: 'OMNIVORE',
  allergens: [],
  meatTypes: ['BEEF'],
);

/// Vegetarian lunch (no meat, dairy allergen).
final recipeVegetarianLunch = makeRecipe(
  id: 4,
  name: 'Quiche Legumes',
  category: 'LUNCH',
  caloriesPerServing: 420,
  proteinGrams: 18,
  carbsGrams: 45,
  fatGrams: 16,
  dietType: 'VEGETARIAN',
  allergens: ['DAIRY', 'GLUTEN'],
  meatTypes: [],
);

/// Vegan dinner — legumes (legume protein group).
final recipeVeganDinner = makeRecipe(
  id: 5,
  name: 'Curry Lentilles',
  category: 'DINNER',
  caloriesPerServing: 380,
  proteinGrams: 22,
  carbsGrams: 60,
  fatGrams: 5,
  dietType: 'VEGAN',
  allergens: [],
  meatTypes: [],
);

/// Vegan snack.
final recipeVeganSnack = makeRecipe(
  id: 6,
  name: 'Fruits Secs Mix',
  category: 'SNACK',
  caloriesPerServing: 200,
  proteinGrams: 5,
  carbsGrams: 25,
  fatGrams: 10,
  dietType: 'VEGAN',
  allergens: [],
  meatTypes: [],
);

/// Omnivore snack.
final recipeOmnivoreSnack = makeRecipe(
  id: 7,
  name: 'Yaourt Proteine',
  category: 'SNACK',
  caloriesPerServing: 150,
  proteinGrams: 15,
  carbsGrams: 10,
  fatGrams: 3,
  dietType: 'OMNIVORE',
  allergens: ['DAIRY'],
  meatTypes: [],
);

/// High-fat omnivore lunch — used to test fat-penalty and blacklisting.
final recipeHighFatLunch = makeRecipe(
  id: 8,
  name: 'Burger Fromage',
  category: 'LUNCH',
  caloriesPerServing: 700,
  proteinGrams: 35,
  carbsGrams: 45,
  fatGrams: 45,
  dietType: 'OMNIVORE',
  allergens: ['DAIRY', 'GLUTEN'],
  meatTypes: ['BEEF'],
);

// ── Shopping list fixtures ────────────────────────────────────────────────────

/// A recipe with known ingredients to test aggregation and normalisation.
RecipeWithDetails makeShoppingTestRecipe({
  int id = 10,
  String name = 'Test Shopping Recipe',
  String category = 'LUNCH',
  int servings = 1,
  List<Ingredient> ingredients = const [],
}) {
  return makeRecipeWithDetails(
    recipe: makeRecipe(
      id: id,
      name: name,
      category: category,
      caloriesPerServing: 400,
      servings: servings,
    ),
    ingredients: ingredients,
  );
}

// ── Week plan fixture builder ─────────────────────────────────────────────────

WeekPlanWithDays makeWeekPlan({
  int weekPlanId = 1,
  required List<DayPlanWithMeals> days,
}) {
  return WeekPlanWithDays(
    weekPlan: WeekPlan(
      id: weekPlanId,
      weekStartDate: DateTime(2025, 1, 6).millisecondsSinceEpoch,
      createdAt: DateTime(2025, 1, 1).millisecondsSinceEpoch,
    ),
    days: days,
  );
}

DayPlanWithMeals makeDayPlan({
  int id = 1,
  int weekPlanId = 1,
  required DateTime date,
  bool isFreeDay = false,
  List<MealWithRecipe> meals = const [],
}) {
  return DayPlanWithMeals(
    dayPlan: DayPlan(
      id: id,
      weekPlanId: weekPlanId,
      date: date.millisecondsSinceEpoch,
      dayOfWeek: date.weekday,
      isFreeDay: isFreeDay,
      batchCookingSession: null,
    ),
    meals: meals,
  );
}

MealWithRecipe makeMealWithRecipe({
  int mealId = 1,
  int dayPlanId = 1,
  required Recipe recipe,
  String mealType = 'LUNCH',
  double servings = 1.0,
  bool isConsumed = false,
}) {
  return MealWithRecipe(
    meal: Meal(
      id: mealId,
      dayPlanId: dayPlanId,
      mealType: mealType,
      recipeId: recipe.id,
      servings: servings,
      isConsumed: isConsumed,
    ),
    recipe: recipe,
  );
}
