<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# meal_plan

## Purpose
Weekly meal plan management — generation, swapping, moving meals, plan persistence.

## Key Files
| File | Description |
|------|-------------|
| `domain/usecases/meal_plan_generator.dart` | Core ~940-line generator: filter, select, assign recipes |
| `domain/usecases/recipe_filter.dart` | Filter by allergens, diet type, excluded meats |
| `domain/usecases/servings_calculator.dart` | Calculate servings per meal type |
| `domain/repositories/meal_plan_repository.dart` | Interface for plan CRUD |
| `presentation/cubit/meal_plan_cubit.dart` | Plan state, swap/move/regenerate actions |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `data/` | Repository implementations (see `data/AGENTS.md`) |
| `data/repositories/` | MealPlanRepository impl (see `data/repositories/AGENTS.md`) |
| `domain/` | Core logic and interfaces (see `domain/AGENTS.md`) |
| `domain/repositories/` | Interfaces (see `domain/repositories/AGENTS.md`) |
| `domain/usecases/` | Generators and filters (see `domain/usecases/AGENTS.md`) |
| `presentation/` | Cubit, pages, widgets (see `presentation/AGENTS.md`) |
| `presentation/cubit/` | MealPlanCubit state (see `presentation/cubit/AGENTS.md`) |
| `presentation/pages/` | Plan page (see `presentation/pages/AGENTS.md`) |
| `presentation/widgets/` | Meal cards, dialogs (see `presentation/widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- MealPlanGenerator is the engine — read it first for logic
- Recipe filtering: diet type → available recipes → allergens → excluded meats
- Servings: meal share × daily target / recipe calories, 0.5 increments
- Plan generation: 7 days, no repeats in same week, ±10% daily calorie variance
- Economic mode: maximize ingredient overlap across recipes
- Cubit manages state, DB updates, error handling

### Common Patterns
- Generate full week: one call to generator.generateWeekPlan()
- Swap meals: find meals → swap → update DB → emit state
- Move meal: remove → reassign to another day → emit
- No repeats: track selected per week, exclude from pool

## Dependencies

### Internal
- `lib/features/recipes/` — RecipeRepository
- `lib/features/onboarding/domain/models/` — Diet, meal type enums
- `lib/features/settings/` — UserProfileRepository
- `lib/core/utils/` — Date utils, ingredient normalizer
- `lib/data/local/` — Database, DAOs, models

### External
- `flutter_bloc` — Cubit
- `drift` — Database access
- `get_it` — DI

<!-- MANUAL: -->
