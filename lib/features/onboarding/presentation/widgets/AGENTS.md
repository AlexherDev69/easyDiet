<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose
Step widgets — reusable form components for 6-step onboarding.

## Key Files
| File | Description |
|------|-------------|
| `personal_info_step.dart` | Name, age input |
| `body_metrics_step.dart` | Height, weight, target weight inputs |
| `goal_step.dart` | Goal weight, timeline selection |
| `lifestyle_step.dart` | Activity level, loss pace selection |
| `allergies_step.dart` | Multi-select: allergies, excluded meats, diet type |
| `plan_preview_step.dart` | Show generated plan, confirm/regenerate |
| `onboarding_illustration.dart` | Decorative illustrations |
| `animated_gradient_background.dart` | Animated background |
| `onboarding_loading_animation.dart` | Loading indicator during plan generation |

## For AI Agents

### Working In This Directory
- Const constructors always
- Each step accepts data and callbacks
- Form widgets with validation feedback
- Material 3 design with Emerald accents
- All text in French
- No state management — callbacks only

### Common Patterns
- TextField for text/number input
- SegmentedButton or Dropdown for selection
- MultiSelect for allergies/meats
- Validation error messages below fields
- Loading states for async operations
- Animations (fade-in, slide-up)

## Dependencies

### Internal
- `lib/core/theme/` — Colors, typography, gradients
- `lib/core/utils/` — Input formatters, validators
- `lib/shared/widgets/` — Button base components

### External
- `flutter` — Material widgets
- `google_fonts` — Nunito
- Material 3 components (SegmentedButton, TextField, etc.)

<!-- MANUAL: -->
