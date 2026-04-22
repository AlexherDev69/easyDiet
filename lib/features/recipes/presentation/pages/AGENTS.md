<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose

Pages for recipe browsing, detail view, and cooking mode.

## Key Files

| File | Description |
|------|-------------|
| `recipe_list_page.dart` | List page with tabs, category filters, recipe cards |
| `recipe_detail_page.dart` | Detail page with ingredients, steps, macros, serving adjuster |
| `cooking_mode_page.dart` | Full-screen cooking mode with step timer and completion tracking |

## For AI Agents

### Working In This Directory

- **RecipeListPage**: BlocBuilder observing `RecipeListCubit`. Show category chips, render recipe cards. Tap card to navigate to detail page.
- **RecipeDetailPage**: BlocBuilder observing `RecipeDetailCubit`. Show ingredients with scaled quantities, steps, macros. Serving spinner at top.
- **CookingModePage**: BlocBuilder observing recipe detail. Full-screen immersive layout. Wakelock enabled. One step per view, timer optional, completion checkmark.
- **French labels**: All UI text in French (e.g., "Ingrédients", "Préparation", "Mode Cuisson", "Suivant").
- **Material 3**: Cards, chips, buttons, spinners; Emerald primary color.

### Common Patterns

- **Category tab/chip**: Render horizontal chip row; selected state shows filled chip; call `selectCategory()` on tap.
- **Recipe card**: Show thumbnail, name, prep/cook time, macros. Tap navigates to `/recipes/:id?servings=1.0`.
- **Ingredient list**: Scale quantities based on `userServings / recipeServings`; round using `QuantityFormatter`.
- **Step display**: One step per card/section; show step number, instruction, optional timer button.
- **Cooking mode**: Lock screen orientation to portrait, enable wakelock, large font for visibility.

## Dependencies

### Internal

- `lib/features/recipes/presentation/cubit/` — `RecipeListCubit`, `RecipeDetailCubit`, states
- `lib/features/recipes/presentation/widgets/` — Shared widgets
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/core/utils/` — `QuantityFormatter`
- `lib/data/local/database.dart` — `Recipe`, `RecipeStep`, `Ingredient`

### External

- `flutter` — Material widgets
- `flutter_bloc` — `BlocBuilder`, `BlocListener`
- `go_router` — Navigation with deep links
- `wakelock_plus` — Keep screen on in cooking mode
