<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose
Presentation layer — meal plan Cubit, page, and interaction dialogs.

## Key Files
| File | Description |
|------|-------------|
| `cubit/meal_plan_cubit.dart` | Plan state, regenerate, swap, move, shift actions |
| `pages/meal_plan_page.dart` | Weekly grid view of meal cards |
| `widgets/meal_card.dart` | Single meal display with actions |
| `widgets/swap_meal_dialog.dart` | Dialog to select meal to swap |
| `widgets/move_meal_dialog.dart` | Dialog to move meal to another day |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `cubit/` | State management (see `cubit/AGENTS.md`) |
| `pages/` | Plan page (see `pages/AGENTS.md`) |
| `widgets/` | Meal cards, dialogs (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- One Cubit per page — MealPlanCubit
- StatelessWidget + BlocBuilder pattern
- Dialogs for meal swaps/moves
- No business logic in widgets
- All user text in French
- Const constructors

### Common Patterns
- BlocBuilder for reactive state
- showDialog() for user interaction
- Callbacks to Cubit methods
- GetIt for dependency injection

## Dependencies

### Internal
- `lib/core/theme/` — Colors, typography
- `lib/core/utils/` — Formatters, quantity display
- `lib/data/local/` — Models
- `lib/shared/widgets/` — Card base components
- `lib/features/recipes/` — Recipe display

### External
- `flutter_bloc` — Cubit, BlocBuilder
- `go_router` — Navigation
- `google_fonts` — Nunito

<!-- MANUAL: -->
