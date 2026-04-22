<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# domain

## Purpose
Domain layer — dashboard data models and business logic.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `models/` | Dashboard data structures (see `models/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Define domain models: DayScheduleItem, NextMealInfo, NextBatchCookingInfo
- Keep immutable (@immutable or freezed)
- No Flutter imports
- Models are view-agnostic — represent pure data

### Common Patterns
- DayScheduleItem: meal, status, time
- NextMealInfo: name, time, macros
- NextBatchCookingInfo: recipes, time

## Dependencies

### Internal
- `lib/data/local/models/` — Meal, Recipe entities

### External
- None (pure Dart)

<!-- MANUAL: -->
