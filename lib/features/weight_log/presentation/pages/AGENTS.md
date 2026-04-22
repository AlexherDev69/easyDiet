<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose

Full-screen weight tracking page with chart, entry form, and projection info.

## Key Files

| File | Description |
|------|-------------|
| `weight_log_page.dart` | Page with chart widget, period selector, log entry form, projection display |

## For AI Agents

### Working In This Directory

- **BlocBuilder**: Observe `WeightLogCubit` state; rebuild on log changes, period selection, loading state.
- **Layout sections**: Chart area (top), period buttons, entry form (date + weight), projection info (target, estimated date, weekly loss), logs list.
- **French labels**: All UI text in French (e.g., "Poids", "Date", "Objectif").
- **Material 3**: Cards, buttons, date picker, text fields; Emerald primary color.
- **Loading state**: Show spinner overlay during entry save.
- **Error display**: Show `state.errorMessage` in snackbar.
- **Outlier warning**: Show `state.outlierWarning` in snackbar with icon.
- **Chart integration**: Use `WeightLineChart` widget to display weight trend.

### Common Patterns

- **Chart area**: Render `WeightLineChart` with `state.logs` filtered by period; show target line.
- **Period buttons**: "All time", "1 month", "3 months"; call `selectPeriod()` on tap.
- **Entry form**: Date picker (today by default) + weight text field (decimal) + "Save" button.
- **Projection box**: Card showing current weight, target, projected goal date, weekly loss.
- **Logs list**: Render recent entries below form; tap to delete (confirmation dialog).
- **Empty state**: Show message if no logs yet.

## Dependencies

### Internal

- `lib/features/weight_log/presentation/cubit/` — `WeightLogCubit`, `WeightLogState`
- `lib/features/weight_log/presentation/widgets/` — `WeightLineChart`
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/core/utils/` — `AppDateUtils`

### External

- `flutter` — Material widgets
- `flutter_bloc` — `BlocBuilder`, `BlocListener`
- `intl` — Date formatting
