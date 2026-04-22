<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# models

## Purpose
Data structures for dashboard display.

## Key Files
| File | Description |
|------|-------------|
| `dashboard_models.dart` | DayScheduleItem, NextMealInfo, NextBatchCookingInfo |

## For AI Agents

### Working In This Directory
- Define simple, immutable models using freezed or @immutable
- Models hold display data only — no logic
- Use enums for status (e.g., MealStatus)

### Common Patterns
- DayScheduleItem: wraps meal with display metadata
- NextMealInfo: meal details + countdown to next meal
- NextBatchCookingInfo: batch cooking session metadata

## Dependencies

### Internal
- `lib/data/local/database.dart` — Meal, Recipe types

### External
- `freezed_annotation` (if used)

<!-- MANUAL: -->
