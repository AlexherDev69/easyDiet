<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose
Presentation layer — onboarding Cubit, page, and step widgets.

## Key Files
| File | Description |
|------|-------------|
| `cubit/onboarding_cubit.dart` | Manages all 6 steps, accumulates user data |
| `pages/onboarding_page.dart` | Full-screen wizard with step indicators |
| `widgets/*_step.dart` | 6 step widgets (personal, body, goal, lifestyle, allergies, preview) |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `cubit/` | State management (see `cubit/AGENTS.md`) |
| `pages/` | Onboarding page (see `pages/AGENTS.md`) |
| `widgets/` | 6 step widgets (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- One Cubit: OnboardingCubit
- One Page: full-screen, step indicator, step content
- Six separate step widgets
- Animations and gradient backgrounds
- No navigation — modal or full screen
- All text in French
- Const constructors

### Common Patterns
- Cubit accumulates data: updateName(), updateAge(), etc.
- Page shows step widgets based on currentStep
- Next/Previous buttons call Cubit methods
- Final step calls calculateCalories() + generatePlan()
- GetIt for dependency injection

## Dependencies

### Internal
- `lib/core/theme/` — Colors, typography, gradient
- `lib/core/utils/` — Constants, validators
- `lib/features/meal_plan/` — MealPlanGenerator
- `lib/features/settings/` — UserProfileRepository
- `lib/data/local/` — Database models

### External
- `flutter_bloc` — Cubit, BlocBuilder
- `intl` — Locale support
- `google_fonts` — Nunito
- `get_it` — DI

<!-- MANUAL: -->
