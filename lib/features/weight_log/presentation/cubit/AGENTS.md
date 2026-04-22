<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose

Cubit and state for weight tracking page. Manages log entries, projections, chart filtering, and outlier detection.

## Key Files

| File | Description |
|------|-------------|
| `weight_log_cubit.dart` | Cubit: `_loadData()`, `addWeightLog()`, `deleteLog()`, `selectPeriod()`, outlier detection, projection calculation |
| `weight_log_state.dart` | State: `logs`, `targetWeight`, `currentWeight`, `projectedGoalDate`, `averageWeeklyLoss`, `selectedPeriod`, `isLoading`, `outlierWarning`, `errorMessage` |

## For AI Agents

### Working In This Directory

- **Init pattern**: On construction, call `_loadData()` to load profile, subscribe to weight logs, calculate projections.
- **Reactive updates**: Subscribe to `watchAllLogs()` stream; recalculate projections on each log update.
- **Outlier detection**: On new entry, check if ±5 kg from last entry; emit `outlierWarning` if true.
- **Projection calculation**: Call `WeightProjectionCalculator.calculate()` with logs and profile; emit results.
- **Period filtering**: `selectPeriod()` filters logs to time range; chart observes and re-renders.
- **Entry addition**: `addWeightLog()` inserts new log (upsert by date); triggers stream update.
- **Entry deletion**: `deleteLog()` removes log; triggers stream update.
- **Error handling**: Catch exceptions, emit `errorMessage`, log with `debugPrint()`.

### Common Patterns

- **Outlier threshold**: Constant `_outlierThresholdKg = 5.0`.
- **Period filtering**: Filter logs by date range; e.g., `logs.where((l) => l.date.isAfter(thirtyDaysAgo))`.
- **Projection format**: Store as string (e.g., "Estimated goal: June 15, 2026") for display.
- **Reactive streams**: Unsubscribe in `close()` to prevent memory leaks.
- **Async operations**: Show `isLoading: true` during add/delete; disable inputs.

## Dependencies

### Internal

- `lib/features/weight_log/domain/repositories/` — `WeightLogRepository`
- `lib/features/weight_log/domain/usecases/` — `WeightProjectionCalculator`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/features/onboarding/domain/models/` — `Sex`, `ActivityLevel`, `LossPace`
- `lib/features/onboarding/domain/usecases/` — `CalorieCalculator`
- `lib/core/utils/` — `AppDateUtils`
- `lib/data/local/database.dart` — `WeightLog`

### External

- `flutter_bloc` — `Cubit`
- `flutter/foundation.dart` — `debugPrint()`
