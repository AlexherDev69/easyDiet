<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# onboarding

## Purpose
6-step onboarding wizard — collect user profile, calculate calories, generate first meal plan.

## Key Files
| File | Description |
|------|-------------|
| `domain/usecases/calorie_calculator.dart` | Mifflin-St Jeor BMR, TDEE, daily target |
| `presentation/cubit/onboarding_cubit.dart` | Manages all 6 steps, profile save, plan generation |
| `domain/models/*.dart` | 8 enums: Sex, DietType, ActivityLevel, LossPace, MealType, Allergy, ExcludedMeat, SupermarketSection |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `data/` | Repository implementations (see `data/AGENTS.md`) |
| `data/repositories/` | UserProfileRepository impl (see `data/repositories/AGENTS.md`) |
| `domain/` | Models and use cases (see `domain/AGENTS.md`) |
| `domain/models/` | 8 enums and model definitions (see `domain/models/AGENTS.md`) |
| `domain/repositories/` | Interfaces (see `domain/repositories/AGENTS.md`) |
| `domain/usecases/` | CalorieCalculator (see `domain/usecases/AGENTS.md`) |
| `presentation/` | Cubit, page, widgets (see `presentation/AGENTS.md`) |
| `presentation/cubit/` | OnboardingCubit state (see `presentation/cubit/AGENTS.md`) |
| `presentation/pages/` | Onboarding page (see `presentation/pages/AGENTS.md`) |
| `presentation/widgets/` | 6 step widgets (see `presentation/widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- 6-step flow: personal → body metrics → goal → lifestyle → allergies → plan preview
- CalorieCalculator is pure — no side effects
- OnboardingCubit accumulates user data, validates, generates plan
- Each step is a separate widget/Cubit method
- French UI text throughout
- No navigation — modal/full screen

### Common Patterns
- Step progression: validateStep() → next step
- Go back: previousStep()
- Profile accumulation: updateField() → copyWith()
- Final step: calculateCalories() → generatePlan() → save → emit success

## Dependencies

### Internal
- `lib/features/meal_plan/` — MealPlanGenerator
- `lib/features/settings/` — UserProfileRepository
- `lib/core/utils/` — Date utils, constants
- `lib/data/local/` — Database, DAOs

### External
- `flutter_bloc` — Cubit
- `get_it` — DI
- `intl` — Locale support

<!-- MANUAL: -->
