<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose

Cubits and states for recipe list and detail screens. Manages recipe data, filtering, and serving adjustments.

## Key Files

| File | Description |
|------|-------------|
| `recipe_list_cubit.dart` | Cubit: `selectTab()`, `selectCategory()`, load/watch recipes, query with filters |
| `recipe_list_state.dart` | State: `selectedTab`, `selectedCategory`, `recipes`, `recipesWithDetails`, `isLoading`, `errorMessage` |
| `recipe_detail_cubit.dart` | Cubit: `loadRecipe()`, `increaseServings()`, `decreaseServings()` |
| `recipe_detail_state.dart` | State: `recipe`, `userServings`, `isLoading`, `errorMessage` |

## For AI Agents

### Working In This Directory

- **RecipeListCubit**: On init, subscribe to `watchAllRecipes()`. Filter by `selectedCategory` on emit. Unsubscribe in `close()`.
- **RecipeDetailCubit**: Load recipe on init via `getRecipeWithDetails()`. Adjust servings in 0.5 increments.
- **Serving calculation**: `newServings = currentServings ± 0.5` (0.5 min, no max). Recalc ingredients/macros on change.
- **Error handling**: Catch exceptions, emit `errorMessage`, log with `debugPrint()`.
- **State const**: Use `copyWith()` for immutable updates.

### Common Patterns

- **Category filtering**: `selectCategory(null)` shows all; `selectCategory('Pasta')` shows only that category.
- **Tab selection**: `selectTab(0)` for "All", `selectTab(1)` for "Favorites", etc.
- **Serving bounds**: Min 0.5, no max. Clamp with `max(0.5, newServings)`.
- **Quantity rounding**: Call `QuantityFormatter.roundForCooking()` on ingredient quantities.
- **Macro scaling**: Scale each macro by `userServings / recipeServings`.

## Dependencies

### Internal

- `lib/features/recipes/domain/repositories/` — `RecipeRepository`
- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository` (for context)
- `lib/core/utils/` — `QuantityFormatter`
- `lib/data/local/database.dart` — `Recipe`, `RecipeWithDetails`
- `lib/data/local/models/` — `WeekPlanWithDays`

### External

- `flutter_bloc` — `Cubit`
- `flutter/foundation.dart` — `debugPrint()`
