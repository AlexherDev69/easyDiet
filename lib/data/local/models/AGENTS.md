<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# models

## Purpose
Relation models for complex Drift queries (JOINs): RecipeWithDetails, MealWithRecipe, DayPlanWithMeals, WeekPlanWithDays.

## Key Files
| File | Description |
|------|-------------|
| `recipe_with_details.dart` | Recipe + RecipeSteps + Ingredients (full recipe for detail page) |
| `meal_with_recipe.dart` | Meal + Recipe (meal assignment with recipe info) |
| `day_plan_with_meals.dart` | DayPlan + List<MealWithRecipe> (full day schedule) |
| `week_plan_with_days.dart` | WeekPlan + List<DayPlanWithMeals> (full week plan) |

## For AI Agents

### Working In This Directory
- Each model combines 2+ tables for a domain-level view (e.g., "give me a full recipe with steps and ingredients").
- Define via Drift `@DataClassName` + `includes` parameter in DAO queries.
- Add new relation model if a feature needs a complex JOIN (e.g., "shopping items with recipe origins").
- Models are immutable (Freezed), use copyWith() for updates.

### Relation Pattern
```dart
@DataClassName('RecipeWithDetails')
class RecipesCompanion {
  // Includes linked tables via foreign keys
  final RecipeStepsTable recipeSteps;
  final IngredientsTable ingredients;
  // ... resolved to Recipe + List<RecipeStep> + List<Ingredient>
}
```

## Dependencies

### Internal
- `lib/data/local/tables/*.dart` — Table definitions
- `lib/data/local/database.dart` — AppDatabase

### External
- **drift** ^2.25.0 — DataClassName, includes
- **freezed_annotation** ^2.4.4 — Immutable models

<!-- MANUAL: -->
