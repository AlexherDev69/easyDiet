<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# domain

## Purpose
Domain layer — business logic (generation, filtering, calculations) and interfaces.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `repositories/` | MealPlanRepository interface (see `repositories/AGENTS.md`) |
| `usecases/` | Generators, filters, calculators (see `usecases/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Write pure Dart logic — no Flutter/Database/IO dependencies
- Repositories are interfaces only — implementations in data/
- Usecases receive all needed data as parameters
- Return early, keep functions <40 lines
- Document complex algorithms

### Common Patterns
- Generator takes profile, recipes → returns week plan structure
- Filters are stateless, composable
- Calculators are pure (no side effects)

## Dependencies

### Internal
- `lib/features/recipes/` — Recipe entity types
- `lib/features/onboarding/domain/models/` — Enums

### External
- None (pure Dart)

<!-- MANUAL: -->
