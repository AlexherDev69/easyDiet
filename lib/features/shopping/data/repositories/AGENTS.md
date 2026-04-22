<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose

Concrete repository implementations for shopping items. Delegates to Drift DAOs.

## For AI Agents

### Working In This Directory

- **DAO delegation**: Implement `ShoppingRepository` interface by calling `ShoppingItemDao` methods.
- **Stream wrapping**: Expose watch methods as streams; wrap queries in futures.
- **Error propagation**: Let DB exceptions bubble up to caller; handle/log at Cubit level.

## Dependencies

### Internal

- `lib/features/shopping/domain/repositories/` — `ShoppingRepository` interface
- `lib/data/local/database.dart` — `ShoppingItemDao`, `ShoppingItem`

### External

- `drift` — DAO classes
