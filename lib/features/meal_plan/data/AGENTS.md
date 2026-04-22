<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# data

## Purpose
Data layer — repository implementations for meal plan CRUD.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `repositories/` | MealPlanRepository implementation (see `repositories/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Implement domain repository interfaces
- Call DAOs from lib/data/local/daos/
- Handle type conversions between entities and domain models
- No business logic — only data access and transformation

### Common Patterns
- Repository delegates to DAO
- Map DAO returns to domain models
- Handle nulls gracefully

## Dependencies

### Internal
- `lib/data/local/` — DAOs, database
- `lib/data/local/models/` — Relations

### External
- `drift` — Database access

<!-- MANUAL: -->
