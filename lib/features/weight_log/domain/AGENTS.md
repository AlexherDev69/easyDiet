<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# domain

## Purpose

Repository interface and use case contracts for weight tracking. Abstracts data layer.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `repositories/` | (see `repositories/AGENTS.md`) |
| `usecases/` | (see `usecases/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **No implementation**: Only interfaces and use cases. Concrete classes in `data/`.
- **Use case export**: `WeightProjectionCalculator` is primary business logic; calculates projections.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `WeightLog`

### External

- None (pure Dart)
