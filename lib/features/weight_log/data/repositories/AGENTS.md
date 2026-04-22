<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose

Concrete repository implementations for weight logs. Delegates to Drift DAOs.

## For AI Agents

### Working In This Directory

- **DAO delegation**: Implement `WeightLogRepository` interface by calling `WeightLogDao` methods.
- **Stream wrapping**: Expose watch methods; wrap queries in futures.
- **Error propagation**: Let DB exceptions bubble up to Cubit for handling.

## Dependencies

### Internal

- `lib/features/weight_log/domain/repositories/` — `WeightLogRepository` interface
- `lib/data/local/database.dart` — `WeightLogDao`, `WeightLog`

### External

- `drift` — DAO classes
