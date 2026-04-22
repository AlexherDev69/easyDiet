<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose

Abstract repository interface for recipe data access. Implemented by data layer.

## Key Files

| File | Description |
|------|-------------|
| `recipe_repository.dart` | `RecipeRepository` interface with watch/get methods |

## For AI Agents

### Working In This Directory

- **Interface only**: No implementation. Concrete class in `data/repositories/`.
- **Stream contracts**: `watchAllRecipes()` returns `Stream<List<Recipe>>` for reactive updates.
- **Query methods**: `getRecipesByCategory()`, `getRecipeWithDetails()` return `Future`.
- **Error handling**: Implementations catch Drift/DB errors; interfaces define contracts.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `Recipe`, `RecipeWithDetails`

### External

- None
