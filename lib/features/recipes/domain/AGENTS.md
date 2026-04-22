<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# domain

## Purpose

Repository interface and business logic contracts for recipes. Abstracts data layer details.

## Key Files

| File | Description |
|------|-------------|
| `repositories/recipe_repository.dart` | Interface: `watchAllRecipes()`, `getRecipeWithDetails()`, `getRecipesByCategory()` |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `repositories/` | (see `repositories/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **No business logic**: Domain contains only abstractions (interfaces). Implementations live in `data/`.
- **Stream contracts**: Return `Stream<T>` for watch operations; `Future<T>` for one-off queries.
- **Immutable models**: Use `Recipe`, `RecipeStep`, `Ingredient` from Drift database.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `Recipe`, `RecipeWithDetails`

### External

- None (pure Dart)
