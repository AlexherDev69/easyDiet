<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose

Reusable widgets for weight tracking page.

## Key Files

| File | Description |
|------|-------------|
| `weight_line_chart.dart` | fl_chart line graph widget showing weight over time with optional target line |

## For AI Agents

### Working In This Directory

- **Const constructor**: Widget uses `const` where possible.
- **Stateless**: No state; receives data and styling via parameters.
- **Chart customization**: Line color (Emerald), axes labels, target line, grid, tooltips.
- **Responsive**: Scale to available height; readable on small/large screens.

### Common Patterns

- **Data rendering**: Map `List<WeightLog>` to chart data points; X-axis = date, Y-axis = weight (kg).
- **Target line**: Horizontal line at target weight; optional styling (dashed, color).
- **Axes**: Date labels on X (monthly or weekly), weight labels on Y (kg).
- **Tooltip**: Show weight and date on tap.
- **Styling**: Use `AppColors.emerald` for line; theme-aware grid/axis colors.

## Dependencies

### Internal

- `lib/core/theme/` — `AppColors`
- `lib/core/utils/` — `AppDateUtils`
- `lib/data/local/database.dart` — `WeightLog`

### External

- `flutter` — Widget
- `fl_chart` — LineChart, line styling
- `intl` — Date formatting
