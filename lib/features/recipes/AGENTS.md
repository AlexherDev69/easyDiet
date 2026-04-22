<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# recipes

## Purpose

Recipe browsing (list by category), detail view, and cooking mode. Provides recipe filtering by category and display of ingredients/steps/macros. Integrates with meal plan for serving size scaling. Port of `RecipeListViewModel.kt`, `RecipeDetailViewModel.kt`, and cooking mode logic.

## Key Files

| File | Description |
|------|-------------|
| `domain/repositories/recipe_repository.dart` | Interface for recipe data access |
| `presentation/cubit/recipe_list_cubit.dart` | State for recipe list (category selection, search) |
| `presentation/cubit/recipe_detail_cubit.dart` | State for recipe detail (serving adjustments, selected recipe) |
| `presentation/pages/recipe_list_page.dart` | List UI with tabs and category filters |
| `presentation/pages/recipe_detail_page.dart` | Detail UI with ingredients, instructions, macros |
| `presentation/pages/cooking_mode_page.dart` | Full-screen cooking mode with timer and step tracking |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `domain/` | (see `domain/AGENTS.md`) |
| `presentation/` | (see `presentation/AGENTS.md`) |
| `data/` | Data layer (if present) |

## For AI Agents

### Working In This Directory

- **Two Cubits**: `RecipeListCubit` for list state (category, tab selection), `RecipeDetailCubit` for detail state (recipe, servings).
- **Category filtering**: Recipes grouped by category; display categories as chips or tabs.
- **Serving adjustment**: Increment/decrement by 0.5 servings; recalculate ingredient quantities and macros client-side.
- **Cooking mode**: Full-screen immersive view; show one step at a time, track completion, timer support.
- **French UI strings**: All labels in French (e.g., "Ingrédients", "Préparation", "Mode Cuisson").

### Common Patterns

- **StreamSubscription**: Subscribe to recipe list in cubit init; unsubscribe in close.
- **Category filtering**: Emit `selectedCategory` to show/hide recipes; null means all.
- **Serving calculation**: `quantity * (userServings / recipeServings)` rounded via `roundForCooking()`.
- **Macro scaling**: Scale macros proportionally with servings.
- **Cooking mode navigation**: Deep link `/recipes/:id/cooking?servings=X` with query params.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `Recipe`, `RecipeStep`, `Ingredient`, `RecipeWithDetails`
- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository` (for context)
- `lib/core/utils/` — `QuantityFormatter`
- `lib/core/theme/` — `AppColors`, `AppTheme`

### External

- `flutter_bloc` — `Cubit`, `BlocBuilder`
- `go_router` — Deep linking with query params
- `wakelock_plus` — Keep screen on during cooking mode
