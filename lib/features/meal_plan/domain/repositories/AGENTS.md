<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose
MealPlanRepository interface — plan CRUD, meal swaps, shifts.

## Key Files
| File | Description |
|------|-------------|
| `meal_plan_repository.dart` | Interface with abstract methods |

## For AI Agents

### Working In This Directory
- Define interface only — no implementation
- Methods: create/delete plan, getDayPlanWithMeals, swapMealsBetweenDays, shiftProgramByOneDay, toggleMealConsumed, isCurrentPlanExpired, watchCurrentWeekPlan
- All async (Future or Stream)
- Return relations, not raw entities

### Common Patterns
- Stream watchers for reactive updates
- All methods nullable-safe
- Signature immutable — don't modify interface after release

## Dependencies

### Internal
- `lib/data/local/models/` — Relation types
- `lib/data/local/database.dart` — Entity types

### External
- None

<!-- MANUAL: -->
