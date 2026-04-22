<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose
State management for batch cooking: overview and step-by-step execution.

## Key Files
| File | Description |
|------|-------------|
| `batch_cooking_cubit.dart` | Loads recipes and prepares batch session |
| `batch_cooking_cubit_state.dart` | BatchCookingState (isLoading, recipes, error) |
| `batch_cooking_mode_cubit.dart` | Manages step progression, timers, completion |
| `batch_cooking_mode_state.dart` | BatchCookingModeState (currentPage, steps, timers) |

## For AI Agents

### Working In This Directory
- Extend Cubit<State>, emit() to notify listeners
- Use copyWith() for immutable state updates
- Separate Cubits for different concerns (overview vs. execution)
- Handle async loading with try/catch, emit errors
- Call GetIt to inject repositories

### Common Patterns
- Load recipes in constructor or on first method call
- Toggle step completion: find step → update isComplete → emit
- Timer management: countdown in BatchCookingModeCubit
- Error states: emit with isLoading: false, error message

## Dependencies

### Internal
- `lib/features/meal_plan/domain/repositories/` — MealPlanRepository
- `lib/features/recipes/domain/repositories/` — RecipeRepository
- `lib/core/utils/` — Date utils, normalizers

### External
- `flutter_bloc` — Cubit base class
- `get_it` — Dependency injection

<!-- MANUAL: -->
