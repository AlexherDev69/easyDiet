<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose

Abstract repository interface for user profile management.

## Key Files

| File | Description |
|------|-------------|
| `user_profile_repository.dart` | Interface with CRUD and reset methods |

## For AI Agents

### Working In This Directory

- **Interface only**: Concrete implementation in `data/repositories/`.
- **CRUD methods**: `getProfile()`, `saveProfile()`, `updateWeightAndCalories()`.
- **Reset**: `resetProfile()` clears all user data, meals, and shopping lists.
- **Async**: All methods return `Future`.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `UserProfile`, `UserProfilesCompanion`

### External

- None
