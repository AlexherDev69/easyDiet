<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# daos

## Purpose
7 Data Access Objects (DAOs) for Drift database: CRUD operations and custom queries for all 9 tables.

## Key Files
| File | Description |
|------|-------------|
| `user_profile_dao.dart` | CRUD + watchProfile(), updateWeightAndCalories() — singleton user settings |
| `recipe_dao.dart` | Query recipes by category, watch/get with details (steps + ingredients), insert + cascade |
| `week_plan_dao.dart` | Create/delete week plans, watch current week, cascade deletes to days + meals |
| `day_plan_dao.dart` | CRUD days, watch days for week, update date/status, batch operations |
| `meal_dao.dart` | CRUD meals, getMealsForDay(), toggleConsumed(), reassignMeals() |
| `shopping_item_dao.dart` | CRUD shopping items, watch by week, uncheckAll(), deleteGeneratedItems() |
| `weight_log_dao.dart` | Watch logs (all/since/recent), getByDate(), insert (upsert), delete |

## For AI Agents

### Working In This Directory
- Each DAO corresponds to 1-2 tables and encapsulates their queries.
- Add custom @Query() methods for domain-specific lookups (filtering, sorting, aggregation).
- Use watch() for Cubits to stream state changes; use get/getAll for one-time reads.
- Transactions: use `db.transaction(() async { /* multiple DAOs */ })` for multi-DAO operations.
- Cascading deletes: defineConstraints in tables and handle cleanup in DAOs.

### DAO Structure
```dart
@DriftAccessor(tables: [UserProfilesTable])
class UserProfileDao extends DatabaseAccessor<AppDatabase> {
  @override
  final AppDatabase db;
  
  // Watch for real-time updates
  Stream<UserProfile?> watchProfile() => select(userProfiles).watchSingle();
  
  // One-time read
  Future<UserProfile?> getProfile() => select(userProfiles).getSingleOrNull();
  
  // Custom query
  @Query('SELECT * FROM user_profiles WHERE id = :id')
  Future<UserProfile?> getProfileById(int id);
  
  // Modify
  Future<void> updateProfile(UserProfile profile) => update(userProfiles).replace(profile);
}
```

## Dependencies

### Internal
- `lib/data/local/database.dart` — AppDatabase reference
- `lib/data/local/tables/*.dart` — Table definitions
- `lib/data/local/models/*.dart` — Relation models

### External
- **drift** ^2.25.0 — Dao, DatabaseAccessor, Query annotations

<!-- MANUAL: -->
