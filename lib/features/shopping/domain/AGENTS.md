<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# domain

## Purpose

Repository interface, use case, and model contracts for shopping list. Abstracts data layer.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `repositories/` | (see `repositories/AGENTS.md`) |
| `models/` | (see `models/AGENTS.md`) |
| `usecases/` | (see `usecases/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **No implementation**: Only interfaces and models. Concrete classes in `data/`.
- **Use case export**: `ShoppingListGenerator` is the primary business logic; exposes `generateShoppingList()`.
- **Model contract**: `IngredientSource` tracks recipe/meal source of ingredients.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `ShoppingItem`, `WeekPlanWithDays`

### External

- None (pure Dart)
