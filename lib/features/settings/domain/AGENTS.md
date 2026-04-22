<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# domain

## Purpose

Repository interface for user profile data access. Abstracts DB details.

## Key Files

| File | Description |
|------|-------------|
| `repositories/user_profile_repository.dart` | Interface: `getProfile()`, `saveProfile()`, `updateWeightAndCalories()`, `resetProfile()` |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `repositories/` | (see `repositories/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **No business logic**: Interfaces only. Implementations in `data/repositories/`.
- **Profile contract**: `getProfile()` returns `Future<UserProfile?>`, `saveProfile()` takes `UserProfilesCompanion`.
- **Reset contract**: `resetProfile()` clears all user data and resets to onboarding state.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `UserProfile`, `UserProfilesCompanion`

### External

- None
