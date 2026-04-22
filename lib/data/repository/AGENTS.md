<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repository

## Purpose
Repository implementations: 5 concrete classes that implement domain interfaces, orchestrating DAOs and use cases for business logic.

## Key Files
| File | Description |
|------|-------------|
| `user_profile_repository_impl.dart` | UserProfileRepository impl: profile CRUD, weight/calories updates |
| `recipe_repository_impl.dart` | RecipeRepository impl: recipe list/detail queries, category filtering |
| `meal_plan_repository_impl.dart` | MealPlanRepository impl: week plan CRUD, swap/move meals, plan expiry, shift by day |
| `shopping_repository_impl.dart` | ShoppingRepository impl: shopping item CRUD, check/uncheck, generate lists |
| `weight_log_repository_impl.dart` | WeightLogRepository impl: weight tracking CRUD, watch streams, projections |

## For AI Agents

### Working In This Directory
- Each repository implements a domain interface (defined in `lib/features/{feature}/domain/repositories/`).
- Repositories orchestrate multiple DAOs and use cases for complex business logic.
- Use transactions for multi-DAO operations (e.g., swap meals between days).
- Register implementations in `lib/core/di/injection.dart` by interface.
- Examples:
  - `swapMealsBetweenDays()` — update two Meals, log changes
  - `isCurrentPlanExpired()` — check week date vs today
  - `generateShoppingList()` — call ShoppingListGenerator, insert items

### Repository Pattern
```dart
class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDao _dao;
  
  UserProfileRepositoryImpl(this._dao);
  
  @override
  Stream<UserProfile?> watchProfile() => _dao.watchProfile();
  
  @override
  Future<void> updateProfile(UserProfile profile) async {
    await _dao.updateProfile(profile);
  }
}
```

## Dependencies

### Internal
- `lib/data/local/daos/` — All 7 DAOs
- `lib/features/*/domain/repositories/` — Repository interfaces
- `lib/features/*/domain/usecases/` — Use case implementations

### External
- **drift** ^2.25.0 — Database access

<!-- MANUAL: -->
