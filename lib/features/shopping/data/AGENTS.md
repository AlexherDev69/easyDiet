<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# data

## Purpose

Data layer for shopping feature. Repository implementations.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `repositories/` | (see `repositories/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Separation of concerns**: Data layer abstracts Drift/DB details from domain.
- **Repository pattern**: Implements `ShoppingRepository` interface from domain.

## Dependencies

### Internal

- `lib/features/shopping/domain/` — Interfaces and models
- `lib/data/local/database.dart` — Drift DAOs

### External

- `drift` — Database access
