<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose
State management for dashboard — day selection, meal updates, plan shifts.

## Key Files
| File | Description |
|------|-------------|
| `dashboard_cubit.dart` | Main Cubit — loads plan, manages streams |
| `dashboard_state.dart` | DashboardState (selectedDayIndex, dayPlan, mealsToday, etc.) |

## For AI Agents

### Working In This Directory
- Initialize with _loadDashboard() in constructor
- Listen to week plan and weight log streams
- Cache week plan to avoid excessive queries
- selectDay(index) updates selectedDayIndex and refreshes day data
- toggleMealConsumed() updates meal status in DB
- shiftByOneDay() advances plan by one day

### Common Patterns
- Stream subscriptions in init, cleanup in close()
- emit(state.copyWith(...)) for immutable updates
- _refreshSelectedDay() called after any change
- Try/catch for async operations, emit errors

## Dependencies

### Internal
- `lib/features/meal_plan/domain/repositories/` — MealPlanRepository
- `lib/features/weight_log/` — WeightLogRepository, calculator
- `lib/features/settings/` — UserProfileRepository
- `lib/core/utils/date_utils.dart` — Date helpers

### External
- `flutter_bloc` — Cubit
- `drift` — Database types
- `get_it` — DI

<!-- MANUAL: -->
