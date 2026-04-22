<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# weight_log

## Purpose

Weight tracking and projection. Users log daily weight, view trend chart, and see projected goal date. Uses fl_chart for line graph. Port of `WeightLogViewModel.kt`.

## Key Files

| File | Description |
|------|-------------|
| `domain/repositories/weight_log_repository.dart` | Interface for weight log CRUD and stream queries |
| `domain/usecases/weight_projection_calculator.dart` | Calculates estimated goal date, average weekly loss, projected date at current pace |
| `presentation/cubit/weight_log_cubit.dart` | State; manages log entries, chart period selection, outlier detection |
| `presentation/cubit/weight_log_state.dart` | State model with logs, projections, selected period |
| `presentation/pages/weight_log_page.dart` | Full-screen page with chart and log form |
| `presentation/widgets/weight_line_chart.dart` | fl_chart line graph widget |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `data/` | Data layer (if present) |
| `data/repositories/` | (see `data/repositories/AGENTS.md` if exists) |
| `domain/` | (see `domain/AGENTS.md`) |
| `domain/repositories/` | (see `domain/repositories/AGENTS.md`) |
| `domain/usecases/` | (see `domain/usecases/AGENTS.md`) |
| `presentation/` | (see `presentation/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Cubit pattern**: `WeightLogCubit` subscribes to weight logs; auto-loads profile and latest entry.
- **Outlier detection**: Warn if new entry ±5 kg from last entry.
- **Projection logic**: Calculate estimated goal date using `WeightProjectionCalculator`.
- **Chart rendering**: Display weight over time using `fl_chart`.
- **Period selection**: Filter chart by period (all time, last month, last 3 months, etc.).
- **French UI strings**: All labels in French (e.g., "Poids", "Date", "Objectif").
- **Date picker**: Calendar picker to select weight entry date.

### Common Patterns

- **Reactive loading**: Subscribe to weight logs stream; auto-update chart on new entry.
- **Entry form**: Date picker + weight input + save button.
- **Projection display**: Show target weight, current weight, estimated date, average loss per week.
- **Warning**: Show warning snackbar if entry is outlier (±5 kg).
- **Deletion**: Tap log entry to delete (confirmation dialog).

## Dependencies

### Internal

- `lib/data/local/database.dart` — `WeightLog`
- `lib/features/onboarding/domain/models/` — `Sex`, `ActivityLevel`, `LossPace`
- `lib/features/onboarding/domain/usecases/` — `CalorieCalculator`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/core/utils/` — `AppDateUtils`
- `lib/core/theme/` — `AppColors`, `AppTheme`

### External

- `flutter_bloc` — `Cubit`
- `fl_chart` — Line chart widget
- `intl` — Date formatting
