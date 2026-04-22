<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# seeder

## Purpose
Database initialization: loads 96 seed recipes from `assets/recipes/*.json` (breakfast, lunch, dinner, snack) at first app launch.

## Key Files
| File | Description |
|------|-------------|
| `database_seeder.dart` | Checks isFirstRun flag, parses JSON, inserts recipes with steps and ingredients |

## For AI Agents

### Working In This Directory
- **database_seeder.dart** runs once at app startup (bootstrapped in `main.dart`).
- Loads recipes from: `assets/recipes/breakfast.json`, `lunch.json`, `dinner.json`, `snack.json`.
- Parses recipe structure: name, category, calories, macros, allergens, diet type, prep/cook time, steps, ingredients.
- Idempotent: checks `isFirstRun` flag in SharedPreferences to avoid re-seeding.
- Modify recipe JSON files in `assets/recipes/` to update seed data.

### Seeding Pattern
```dart
final seeder = getIt<DatabaseSeeder>();
await seeder.seedDatabase();
// Checks if first run, parses JSON, inserts all recipes + steps + ingredients
```

## Dependencies

### Internal
- `lib/data/local/database.dart` — AppDatabase, DAOs
- `lib/data/local/tables/*.dart` — Table structures

### External
- **drift** ^2.25.0 — Database access
- **flutter/services.dart** — Asset loading
- **json** — JSON parsing

<!-- MANUAL: -->
