<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose
UserProfileRepository implementation — CRUD for singleton profile.

## For AI Agents

### Working In This Directory
- Implement UserProfileRepository interface
- Call UserProfileDao for all operations
- getProfile(), updateProfile(), saveProfile()
- Singleton: UserProfile with id=1

### Common Patterns
- All methods async
- Return typed models, not raw entities

## Dependencies

### Internal
- `lib/data/local/daos/user_profile_dao.dart`
- `lib/data/local/database.dart`

### External
- `drift` — Database access

<!-- MANUAL: -->
