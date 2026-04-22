<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose
MealPlanRepository implementation — week plan CRUD, day/meal queries, swaps, shifts.

## Key Files
| File | Description |
|------|-------------|
| Implementation file (name varies) | CRUD, swapMealsBetweenDays(), shiftProgramByOneDay(), etc. |

## For AI Agents

### Working In This Directory
- Implement MealPlanRepository interface from domain/
- Call MealDao, DayPlanDao, WeekPlanDao from lib/data/local/daos/
- swapMealsBetweenDays(): swap two meals, update DB
- shiftProgramByOneDay(): cascade meals forward, add new day, mark today free
- isCurrentPlanExpired(): check if plan is >7 days old
- No caching — let Cubit handle it

### Common Patterns
- All methods async
- Return relations (DayPlanWithMeals) not raw entities
- Handle transaction semantics for multi-step operations

## Dependencies

### Internal
- `lib/data/local/daos/` — All DAOs
- `lib/data/local/models/` — Relations

### External
- `drift` — Database access

<!-- MANUAL: -->
