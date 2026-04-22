<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose
Reusable UI components for batch cooking pages.

## Subdirectories
(Empty — widgets for batch cooking are minimal; larger components use lib/shared/widgets/)

## For AI Agents

### Working In This Directory
- Const constructors for all widgets
- Accept data and callbacks via constructor params
- No state management — pass data down, callbacks up
- Keep widget files focused: one main widget per file
- Document complex layouts with comments

### Common Patterns
- RecipeCard: displays recipe name, times, meal type
- StepCard: shows step text, phase badge, timer, completion toggle
- ProgressBar: visual progress through steps
- TimerWidget: countdown display

## Dependencies

### Internal
- `lib/core/theme/` — Colors, typography
- `lib/core/utils/` — Formatters
- `lib/shared/widgets/` — Base card components

### External
- `flutter` — Material widgets
- `google_fonts` — Typography

<!-- MANUAL: -->
