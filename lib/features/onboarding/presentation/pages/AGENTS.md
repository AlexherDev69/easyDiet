<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose
Onboarding page — 6-step wizard container with navigation.

## Key Files
| File | Description |
|------|-------------|
| `onboarding_page.dart` | StatelessWidget, BlocBuilder, step display |

## For AI Agents

### Working In This Directory
- StatelessWidget only
- BlocBuilder<OnboardingCubit, OnboardingState> wraps content
- Display step widget based on state.currentStep
- Previous/Next buttons call Cubit methods
- Progress indicator (step 1/6, etc.)
- Animated transitions between steps
- No direct navigation — Cubit emits success state

### Common Patterns
- Column with header (gradient), content area, footer (buttons)
- Animated page transitions (fade, slide)
- Validation feedback on button press
- Final step shows "Enregistrer" button

## Dependencies

### Internal
- `lib/core/theme/` — Colors, gradients
- Cubit from parent directory
- Widgets from sibling `widgets/` directory

### External
- `flutter_bloc` — BlocBuilder
- `google_fonts` — Typography

<!-- MANUAL: -->
