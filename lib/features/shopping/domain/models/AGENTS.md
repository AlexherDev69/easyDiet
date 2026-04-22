<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# models

## Purpose

Domain model DTOs for shopping feature.

## Key Files

| File | Description |
|------|-------------|
| `ingredient_source.dart` | DTO: tracks recipe ID, recipe name, meal type (breakfast/lunch/etc.) of each ingredient |

## For AI Agents

### Working In This Directory

- **DTO only**: Immutable data class (use `@freezed` or final fields).
- **Source tracking**: Used in shopping list to show origin of each ingredient (e.g., "Pasta (from Pasta Carbonara - Lunch)").
- **JSON serialization**: Serialize to JSON for storage in `ShoppingItem.sourceDetails` column.

## Dependencies

### Internal

- None

### External

- `freezed_annotation` (optional, if using Freezed)
