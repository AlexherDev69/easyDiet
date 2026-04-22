<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose
UserProfileRepository interface — profile CRUD operations.

## For AI Agents

### Working In This Directory
- Define abstract interface only
- Methods: getProfile, updateProfile, saveProfile, deleteProfile
- All async (Future)
- Nullable safe (return UserProfile?)
- No implementation — data/ layer handles that

### Common Patterns
- Singleton pattern (id=1)
- All mutations async
- Return or null

## Dependencies

### Internal
- `lib/data/local/database.dart` — UserProfile type

### External
- None

<!-- MANUAL: -->
