<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# domain

## Purpose
Domain layer — pure business logic and interfaces.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `models/` | 8 enums and model defs (see `models/AGENTS.md`) |
| `repositories/` | UserProfileRepository interface (see `repositories/AGENTS.md`) |
| `usecases/` | CalorieCalculator (see `usecases/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Define enums, interfaces, and pure logic
- No Flutter/Database/IO imports
- Keep functions small and testable

### Common Patterns
- Enums define domain values
- Interfaces abstract external concerns
- Usecases are pure functions

## Dependencies

### Internal
- None

### External
- None (pure Dart)

<!-- MANUAL: -->
