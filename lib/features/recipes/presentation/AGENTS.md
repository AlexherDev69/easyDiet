<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose

Cubits, pages, and widgets for recipe browsing, detail, and cooking mode. Reactive state management with Material 3 UI.

## Key Files

| File | Description |
|------|-------------|
| `cubit/recipe_list_cubit.dart` | List state (category, tab selection, recipes) |
| `cubit/recipe_list_state.dart` | List state model |
| `cubit/recipe_detail_cubit.dart` | Detail state (recipe, servings) |
| `cubit/recipe_detail_state.dart` | Detail state model |
| `pages/recipe_list_page.dart` | List page with tabs and category filters |
| `pages/recipe_detail_page.dart` | Detail page with ingredients, instructions, macros |
| `pages/cooking_mode_page.dart` | Full-screen cooking mode |
| `widgets/recipe_list_card.dart` | Individual recipe card (list view) |
| `widgets/category_filter_chips.dart` | Category chip selector |
| `widgets/category_header.dart` | Category section header |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `cubit/` | (see `cubit/AGENTS.md`) |
| `pages/` | (see `pages/AGENTS.md`) |
| `widgets/` | (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Two Cubits**: `RecipeListCubit` and `RecipeDetailCubit`, each managing their own screen state.
- **Material 3 design**: Cards, chips, buttons, spinners; Emerald (#10B981) as primary color.
- **French UI**: All labels, hints, buttons in French.
- **Stream subscription**: Cubits subscribe to watch streams on init, unsubscribe in `close()`.
- **Navigation**: Use `go_router` with named routes and query parameters.

### Common Patterns

- **BlocBuilder**: Rebuild widgets on state change; show loading/error overlays.
- **Category tabs**: Show as chip group or segmented buttons; filter recipes on tap.
- **Recipe cards**: Display recipe image, name, calories, macros in card layout.
- **Serving spinner**: Increment/decrement buttons or text field; update on change.
- **Cooking mode**: Full-screen immersive view with wakelock enabled.

## Dependencies

### Internal

- `lib/features/recipes/domain/repositories/` — `RecipeRepository`
- `lib/features/recipes/presentation/cubit/` — Cubits and states
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/core/utils/` — `QuantityFormatter`
- `lib/data/local/database.dart` — `Recipe`, `RecipeStep`, `Ingredient`

### External

- `flutter_bloc` — `Cubit`, `BlocBuilder`, `BlocListener`
- `go_router` — Navigation with deep links
- `wakelock_plus` — Keep screen on in cooking mode
