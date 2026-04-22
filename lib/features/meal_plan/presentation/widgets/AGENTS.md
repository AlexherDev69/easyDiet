<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose
Reusable meal plan components — cards, dialogs, summary.

## Key Files
| File | Description |
|------|-------------|
| `meal_card.dart` | Single meal display with name, macros, actions |
| `swap_meal_dialog.dart` | Modal to select which meal to swap |
| `move_meal_dialog.dart` | Modal to pick destination day |
| `macro_summary_card.dart` | Displays daily macros for selected day |

## For AI Agents

### Working In This Directory
- Const constructors always
- MealCard: show meal name, meal type icon, macros, calorie count
- Swap dialog: list available meals of same type
- Move dialog: list days with dropdown for meal type
- Macro summary: bar chart or table (P/C/F)
- Accept data and callbacks only — no logic

### Common Patterns
- Dialog returns selection via Navigator.pop(value)
- Color by meal type (breakfast, lunch, dinner, snack)
- Display serving size and total calories
- Icons from Material Design

## Dependencies

### Internal
- `lib/core/theme/` — Colors, meal type colors
- `lib/core/utils/` — Formatters
- `lib/shared/widgets/` — Card base

### External
- `flutter` — Material widgets
- `fl_chart` — Bar/pie charts (if used)
- `google_fonts` — Typography

<!-- MANUAL: -->
