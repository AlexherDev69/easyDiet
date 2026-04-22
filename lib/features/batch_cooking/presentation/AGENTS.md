<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose
Presentation layer — Cubits, pages, and widgets for batch cooking UI.

## Key Files
| File | Description |
|------|-------------|
| `cubit/batch_cooking_cubit.dart` | Overview — loads recipes for a day plan |
| `cubit/batch_cooking_mode_cubit.dart` | Execution — step progression, timers, completion |
| `pages/batch_cooking_page.dart` | Overview list of recipes |
| `pages/batch_cooking_mode_page.dart` | Step-by-step cooking interface |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `cubit/` | State management (see `cubit/AGENTS.md`) |
| `pages/` | Full-screen pages (see `pages/AGENTS.md`) |
| `widgets/` | Reusable components (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Cubits: one per screen, manage state with copyWith()
- Pages: stateless, consume cubit via BlocBuilder/BlocListener
- Widgets: const constructors, no business logic
- UI text in French
- Handle loading, error, data states explicitly

### Common Patterns
- BlocBuilder for reactive UI updates
- BlocListener for side effects (nav, snackbars)
- Use GetIt to inject Cubits and Repositories
- Const widget constructors throughout

## Dependencies

### Internal
- `lib/core/theme/` — Colors, typography
- `lib/core/utils/` — Formatters, date utils
- `lib/data/local/` — Database, DAOs
- `lib/features/meal_plan/` — MealPlanRepository
- `lib/features/recipes/` — RecipeRepository
- `lib/shared/widgets/` — Reusable cards, buttons

### External
- `flutter_bloc` — Cubit, BlocBuilder, BlocListener
- `go_router` — Navigation

<!-- MANUAL: -->
