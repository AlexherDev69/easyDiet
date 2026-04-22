<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose

Cubit state management and UI for weight tracking. Displays chart, handles log entries, shows projections, and period filtering.

## Key Files

| File | Description |
|------|-------------|
| `cubit/weight_log_cubit.dart` | Cubit; manages logs, projections, outlier detection, chart period selection |
| `cubit/weight_log_state.dart` | State: logs, target weight, projections, selected period, form inputs, loading state |
| `pages/weight_log_page.dart` | Full-screen page with chart, log entry form, projection info |
| `widgets/weight_line_chart.dart` | fl_chart line graph showing weight over time |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `cubit/` | (see `cubit/AGENTS.md`) |
| `pages/` | (see `pages/AGENTS.md`) |
| `widgets/` | (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Single Cubit**: `WeightLogCubit` for all weight tracking state and operations.
- **Reactive loading**: Subscribe to weight logs stream; auto-update chart on new entry.
- **Material 3**: Card layout, date picker, chart widget; Emerald primary color.
- **French labels**: All UI text in French (e.g., "Poids", "Date", "Objectif").
- **Chart visualization**: Line chart with date axis and weight axis; optional target line.
- **Period filtering**: Switch between all-time, last month, last 3 months, etc.
- **Outlier warning**: Show snackbar if new entry ±5 kg from last entry.

### Common Patterns

- **Entry form**: Date picker + weight input + save button.
- **Projection display**: Current weight, target, estimated goal date, average loss/week.
- **Chart periods**: Buttons or dropdown to filter chart by time range.
- **Deletion**: Tap log to show options (view details, delete).
- **Async state**: Show spinner during entry save; disable inputs during loading.

## Dependencies

### Internal

- `lib/features/weight_log/domain/repositories/` — `WeightLogRepository`
- `lib/features/weight_log/domain/usecases/` — `WeightProjectionCalculator`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/features/onboarding/domain/models/` — `Sex`, `ActivityLevel`, `LossPace`
- `lib/features/onboarding/domain/usecases/` — `CalorieCalculator`
- `lib/features/weight_log/presentation/cubit/` — Cubits and states
- `lib/features/weight_log/presentation/widgets/` — Chart widget
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/core/utils/` — `AppDateUtils`
- `lib/data/local/database.dart` — `WeightLog`

### External

- `flutter_bloc` — `Cubit`, `BlocBuilder`
- `fl_chart` — Line chart widget
- `intl` — Date formatting
