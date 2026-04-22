<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# assets

## Purpose
Static assets: seed recipe data in JSON format (breakfast, lunch, dinner, snack), loaded by database seeder at first app launch.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `recipes/` | 96 seed recipes in JSON format by meal type |

## For AI Agents

### Working In This Directory
- Modify recipe JSON files to update seed data: `breakfast.json`, `lunch.json`, `dinner.json`, `snack.json`.
- Each file contains recipes in array format: name, category, calories, macros, allergens, diet type, prep/cook time, steps, ingredients.
- Recipes are loaded once at first launch (idempotent via `isFirstRun` flag in seeder).
- Delete `isFirstRun` flag to reseed the database (for testing).
- JSON schema: `{ "name": "...", "category": "...", "calories": number, "macros": { ... }, "steps": [...], "ingredients": [...] }`.

## Dependencies

### Internal
- `lib/data/local/seeder/database_seeder.dart` — Loads JSON files

### External
- None (JSON is parsed by Dart's json library).

<!-- MANUAL: -->
