<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose
Meal plan page — weekly grid layout with meal cards and actions.

## Key Files
| File | Description |
|------|-------------|
| `meal_plan_page.dart` | StatelessWidget, BlocBuilder, week grid |

## For AI Agents

### Working In This Directory
- StatelessWidget only
- BlocBuilder<MealPlanCubit, MealPlanState> wraps content
- GridView or Column layout (7 days)
- Each day shows up to 4 meals (breakfast, lunch, dinner, snack)
- Long-press or button on meal card to swap/move
- Regenerate button at top
- Handle loading/error states

### Common Patterns
- Days arranged vertically or in grid
- Meal cards colored by meal type
- Swipe or tap to see options
- Navigation via context.go()

## Dependencies

### Internal
- `lib/core/theme/` — Colors, spacing
- `lib/core/utils/` — Formatters
- Cubit from parent directory
- Widgets from sibling `widgets/` directory

### External
- `flutter_bloc` — BlocBuilder
- `go_router` — Navigation
- `google_fonts` — Typography

<!-- MANUAL: -->
