<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# batch_cooking

## Purpose
Batch cooking feature — phase-interleaved cooking mode and step optimizer for preparing multiple recipes simultaneously.

## Key Files
| File | Description |
|------|-------------|
| `presentation/cubit/batch_cooking_cubit.dart` | Manages batch overview — loads recipes for a day plan |
| `presentation/cubit/batch_cooking_mode_cubit.dart` | Manages step-by-step execution with timers and progress |
| `domain/usecases/batch_step_optimizer.dart` | Interleaves prep/cook/finish phases across recipes |
| `domain/models/batch_cooking_models.dart` | BatchCookingRecipeInfo, BatchPage, RecipeStepItem |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `domain/` | Models and use cases (see `domain/AGENTS.md`) |
| `domain/models/` | Batch cooking data models (see `domain/models/AGENTS.md`) |
| `domain/usecases/` | Step optimizer logic (see `domain/usecases/AGENTS.md`) |
| `presentation/` | Cubit, pages, widgets (see `presentation/AGENTS.md`) |
| `presentation/cubit/` | BatchCookingCubit, BatchCookingModeCubit states (see `presentation/cubit/AGENTS.md`) |
| `presentation/pages/` | Batch overview and mode pages (see `presentation/pages/AGENTS.md`) |
| `presentation/widgets/` | Reusable batch UI widgets (see `presentation/widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Use Cubit state management with `emit(state.copyWith(...))`
- Manage async loading states: emit initial state → loading → data/error
- Timers and step progression in `BatchCookingModeCubit`
- Prefer const widget constructors
- No business logic in widgets — keep logic in Cubits/UseCases
- All user-facing text in French (e.g., "Étapes", "Minuteur")

### Common Patterns
- Two-Cubit pattern: `BatchCookingCubit` (overview) + `BatchCookingModeCubit` (execution)
- Phase interleaving: optimize step order across recipes (prep → cook → finish)
- Step completion tracking: toggle `isComplete`, update progress
- Timer management: countdown with `Wakelock.enable()` to prevent sleep

## Dependencies

### Internal
- `lib/features/meal_plan/domain/repositories/` — MealPlanRepository
- `lib/features/recipes/domain/repositories/` — RecipeRepository
- `lib/core/utils/date_utils.dart` — Date formatting
- `lib/core/utils/ingredient_normalizer.dart` — Ingredient name normalization
- `lib/data/local/models/` — RecipeWithDetails, DayPlanWithMeals

### External
- `flutter_bloc` — Cubit state management
- `wakelock_plus` — Keep screen on during cooking

<!-- MANUAL: -->
