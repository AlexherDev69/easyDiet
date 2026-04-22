<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# dashboard

## Purpose
Home screen feature — displays daily meal plan, calories, hydration, weight trends, and quick actions.

## Key Files
| File | Description |
|------|-------------|
| `presentation/cubit/dashboard_cubit.dart` | Manages dashboard state — day selection, meal updates, shifts |
| `presentation/pages/dashboard_page.dart` | Main home screen layout |
| `domain/models/dashboard_models.dart` | DayScheduleItem, NextMealInfo, NextBatchCookingInfo |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `domain/` | Models (see `domain/AGENTS.md`) |
| `domain/models/` | Dashboard data structures (see `domain/models/AGENTS.md`) |
| `presentation/` | Cubit, pages, widgets (see `presentation/AGENTS.md`) |
| `presentation/cubit/` | DashboardCubit state (see `presentation/cubit/AGENTS.md`) |
| `presentation/pages/` | Main dashboard page (see `presentation/pages/AGENTS.md`) |
| `presentation/widgets/` | Dashboard widget library (see `presentation/widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Cubit initializes on creation with _loadDashboard()
- Watch streams for plan and weight logs (StreamSubscription)
- Cache computed values (e.g., _cachedWeekPlan)
- Emit state updates for day selection, meal toggles, plan shifts
- Prefer const widget constructors
- All user text in French

### Common Patterns
- Day selector: selectDay(int index) updates selectedDayIndex
- Meal toggle: toggleMealConsumed(mealId, bool) updates isConsumed
- Plan shift: shiftByOneDay() cascades meals, marks today as free
- Refresh on demand: _refreshSelectedDay()

## Dependencies

### Internal
- `lib/features/meal_plan/` — MealPlanRepository
- `lib/features/weight_log/` — WeightLogRepository, calculator
- `lib/features/settings/` — UserProfileRepository
- `lib/core/utils/` — Date utils, formatters
- `lib/data/local/` — Database, DAOs, models

### External
- `flutter_bloc` — Cubit, streams
- `intl` — Locale formatting
- `fl_chart` — Charts (weight, macros)

<!-- MANUAL: -->
