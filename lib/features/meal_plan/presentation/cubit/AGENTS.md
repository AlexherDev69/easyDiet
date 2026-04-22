<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose
State management for meal plan — plan loading, swaps, moves, shifts, regeneration.

## Key Files
| File | Description |
|------|-------------|
| `meal_plan_cubit.dart` | Main Cubit with all meal plan actions |
| `meal_plan_state.dart` | MealPlanState (weekPlan, selectedDay, loading, error) |

## For AI Agents

### Working In This Directory
- Initialize by loading current week plan
- selectDay(index) updates selectedDayIndex
- regenerateWeekPlan() calls generator with current profile
- swapMealsBetweenDays() calls repository, updates state
- moveMealToDay() reassigns meal to another day
- shiftByOneDay() cascades meals forward
- Watch plan stream for reactive updates

### Common Patterns
- Emit loading state at start of async ops
- Try/catch with error messages
- Cache week plan to avoid redundant queries
- Invalidate cache after mutations

## Dependencies

### Internal
- `lib/features/meal_plan/domain/` — Repos, generators
- `lib/features/settings/` — UserProfileRepository
- `lib/core/utils/` — Date utils

### External
- `flutter_bloc` — Cubit
- `get_it` — DI

<!-- MANUAL: -->
