<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose
State management for 6-step onboarding wizard.

## Key Files
| File | Description |
|------|-------------|
| `onboarding_cubit.dart` | Main Cubit, all step updates and plan generation |
| `onboarding_state.dart` | OnboardingState (step, profile fields, loading, error) |

## For AI Agents

### Working In This Directory
- Cubit holds accumulated profile state (name, age, height, weight, etc.)
- Methods: nextStep(), previousStep(), updateField()
- calculateCalories(): calls CalorieCalculator
- generatePlan(): calls MealPlanGenerator + saves profile
- currentStep: 0-5 (personal, body, goal, lifestyle, allergies, preview)
- Validation on step transition

### Common Patterns
- Accumulate data: emit(state.copyWith(name: value))
- Validate before next: if invalid, emit error message
- Final step: generatePlan() → save() → emit success
- Navigation handled by page, not Cubit

## Dependencies

### Internal
- `lib/features/onboarding/domain/` — CalorieCalculator, models
- `lib/features/meal_plan/` — MealPlanGenerator
- `lib/features/settings/` — UserProfileRepository
- `lib/core/constants/app_constants.dart` — Min calorie values

### External
- `flutter_bloc` — Cubit
- `get_it` — DI

<!-- MANUAL: -->
