<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# data

## Purpose
Data layer: Drift SQLite database (9 tables), 7 DAOs, 5 repository implementations, and JSON converters. Handles persistence and data access for all features.

## Key Files
| File | Description |
|------|-------------|
| `local/database.dart` | AppDatabase: Drift DB definition, 9 tables (v1), schema migrations |
| `local/seeder/database_seeder.dart` | Loads 96 recipes from assets/recipes/*.json at first launch |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `local/` | Drift database, tables, DAOs, converters, seeder |
| `repository/` | 5 repository implementations (UserProfile, Recipe, MealPlan, Shopping, WeightLog) |

## For AI Agents

### Working In This Directory
- **database.dart** defines the AppDatabase singleton and schema — modify to add tables or fields.
- **local/tables/*.dart** define Drift table definitions — add new table here, then run `dart run build_runner build`.
- **local/daos/*.dart** implement CRUD and custom queries — add DAO methods for new queries.
- **local/models/*.dart** define relations (RecipeWithDetails, MealWithRecipe, etc.) — add here for JOIN results.
- **local/converters/*.dart** convert custom Dart types to/from SQL — use for JSON fields in tables.
- **local/seeder/database_seeder.dart** populates recipes at first launch — modify to change seed data or add more.
- **repository/*.dart** implement domain interfaces — business logic for multi-DAO operations.

### Database Schema
9 tables: **UserProfiles** (singleton), **Recipes**, **RecipeSteps**, **Ingredients**, **WeekPlans**, **DayPlans**, **Meals**, **ShoppingItems**, **WeightLogs**.  
Relations: RecipeWithDetails, MealWithRecipe, DayPlanWithMeals, WeekPlanWithDays.  
Seed data: 96 recipes from `assets/recipes/*.json` (breakfast.json, lunch.json, dinner.json, snack.json).

### Schema Modifications
1. **Add a table**: Create `local/tables/new_table.dart` with @DataClassName and @TableName annotations.
2. **Add a field**: Modify table definition in `local/tables/*.dart`, update version in AppDatabase.
3. **Add a DAO**: Create `local/daos/new_dao.dart` extending Dao, add custom queries with @Query().
4. **Add a relation**: Create `local/models/new_with_relation.dart` with @DataClassName and includes.
5. Run: `dart run build_runner build --delete-conflicting-outputs`.

### Common Patterns
- Query: `final recipes = await getIt<RecipeDao>().getRecipesByCategory(category);`
- Stream: `final meals$ = getIt<MealDao>().watchMealsForDay(dayPlanId);`
- Insert: `await getIt<MealDao>().insertMeal(meal);`
- Update: `await getIt<DayPlanDao>().updateDayPlanDate(dayPlanId, newDate);`
- Transaction: `await db.transaction(() async { /* multiple DAOs */ });`

## Dependencies

### Internal
- `lib/core/di/` — DI registration
- `lib/features/*/domain/repositories/` — Repository interfaces

### External
- **drift** ^2.25.0 — ORM
- **sqlite3_flutter_libs** ^0.5.28 — SQLite native
- **freezed_annotation** ^2.4.4 — Model generation
- **json_serializable** — JSON converters

<!-- MANUAL: -->
