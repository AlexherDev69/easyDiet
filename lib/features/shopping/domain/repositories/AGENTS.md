<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose

Abstract repository interface for shopping list CRUD and stream operations.

## Key Files

| File | Description |
|------|-------------|
| `shopping_repository.dart` | Interface: `watchItemsForWeek()`, CRUD methods, `uncheckAll()`, `deleteGeneratedItems()` |

## For AI Agents

### Working In This Directory

- **Interface only**: Concrete implementation in `data/repositories/`.
- **Stream contract**: `watchItemsForWeek()` returns `Stream<List<ShoppingItem>>` for reactive updates.
- **CRUD**: Create, read, update (toggle checked), delete methods.
- **Bulk operations**: `uncheckAll()` resets all checked flags; `deleteGeneratedItems()` removes auto-generated items (preserves manual).

## Dependencies

### Internal

- `lib/data/local/database.dart` — `ShoppingItem`

### External

- None
