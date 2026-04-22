<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# data

## Purpose

Data layer for weight log feature. Repository implementations.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `repositories/` | (see `repositories/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Separation of concerns**: Data layer abstracts Drift/DB from domain.
- **Repository pattern**: Implements `WeightLogRepository` interface.

## Dependencies

### Internal

- `lib/features/weight_log/domain/` — Interfaces
- `lib/data/local/database.dart` — Drift DAOs

### External

- `drift` — Database access
