<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# repositories

## Purpose

Abstract repository interface for weight log CRUD and stream operations.

## Key Files

| File | Description |
|------|-------------|
| `weight_log_repository.dart` | Interface: `watchAllLogs()`, `watchLogsSince()`, `getLatestLog()`, `getFirstLog()`, CRUD methods |

## For AI Agents

### Working In This Directory

- **Interface only**: Concrete implementation in `data/repositories/`.
- **Stream contracts**: `watchAllLogs()`, `watchLogsSince()` return streams for reactive updates.
- **Query methods**: `getLatestLog()`, `getFirstLog()`, `getLogByDate()` return futures.
- **CRUD**: Insert (upsert), delete methods.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `WeightLog`

### External

- None
