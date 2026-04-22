<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose
Reusable dashboard components — cards, charts, selectors, action buttons.

## Key Files
| File | Description |
|------|-------------|
| `calories_hero_card.dart` | Large calories burned/remaining display |
| `macro_radial_chart.dart` | Radial chart showing macro breakdown |
| `mini_weight_chart.dart` | Small weight trend chart (fl_chart) |
| `day_selector.dart` | Day picker with left/right nav |
| `day_meals_section.dart` | List of meals for selected day |
| `next_meal_card.dart` | Next upcoming meal info |
| `hydration_card.dart` | Water intake vs. target |
| `progress_card.dart` | Weight progress toward goal |
| `next_batch_cooking_card.dart` | Upcoming batch cooking session |
| `quick_action_card.dart` | Action buttons (add meal, shift plan) |
| `dashboard_header.dart` | Top header with greeting |

## For AI Agents

### Working In This Directory
- Const constructors always
- Accept data and callbacks via constructor params
- No state management — stateless widgets only
- Keep files focused: one main widget per file
- Extract complex widget trees to helper methods

### Common Patterns
- Card widgets inherit from lib/shared/widgets base
- Charts use fl_chart for visualization
- Buttons call callbacks passed from parent
- Material 3 design with Emerald accent

## Dependencies

### Internal
- `lib/core/theme/` — Colors, gradients, typography
- `lib/core/utils/` — Formatters (calories, weight, quantity)
- `lib/shared/widgets/` — GradientCard, SolidCard, FreeDaysSection

### External
- `flutter` — Material widgets
- `fl_chart` — Line/radial charts
- `google_fonts` — Nunito

<!-- MANUAL: -->
