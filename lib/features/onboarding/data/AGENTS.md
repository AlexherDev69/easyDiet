<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# data

## Purpose
Data layer — repository implementations for user profile operations.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `repositories/` | UserProfileRepository implementation (see `repositories/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Implement domain repository interfaces
- Call DAOs from lib/data/local/daos/
- Handle type conversions
- No business logic

### Common Patterns
- Repository delegates to DAO
- Map types as needed

## Dependencies

### Internal
- `lib/data/local/daos/` — UserProfileDao
- `lib/data/local/database.dart` — UserProfile entity

### External
- `drift` — Database access

<!-- MANUAL: -->
