<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# shared

## Purpose
Reusable UI widgets and utilities shared across features: gradient/solid cards, dialogs, text fields, step cards, and section dividers.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `widgets/` | 9 reusable UI components (GradientCard, SolidCard, FreeDaysSection, StepperCard, GlassCard, etc.) |

## For AI Agents

### Working In This Directory
- **shared/widgets/*.dart** are used across multiple features — keep them generic and parameterized.
- Examples: GradientCard (hero cards), SolidCard (info cards), FreeDaysSection (calendar widget), StepperCard (form stepper).
- Add new shared widget here if multiple features need it; otherwise keep it in feature's `presentation/widgets/`.
- Import: `import 'package:easydiet/shared/widgets/gradient_card.dart';`

## Dependencies

### Internal
- `lib/core/theme/` — Colors, theming

### External
- **flutter** — Material widgets, StatelessWidget
- **flutter_bloc** — BlocBuilder if state-aware

<!-- MANUAL: -->
