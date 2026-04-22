<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# domain

## Purpose
Domain layer — pure business logic for batch cooking: step optimization and data models.

## Key Files
| File | Description |
|------|-------------|
| `usecases/batch_step_optimizer.dart` | Phase interleaving algorithm |
| `models/batch_cooking_models.dart` | BatchCookingRecipeInfo, BatchPage, RecipeStepItem |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `models/` | Data models (see `models/AGENTS.md`) |
| `usecases/` | Step optimizer (see `usecases/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Write pure Dart logic — no Flutter/UI dependencies
- Immutable models (freezed or @immutable)
- Return early, keep functions focused
- No async operations except in usecases
- Document complex algorithms with comments

### Common Patterns
- Optimizer returns sorted steps grouped by phase
- Models use copyWith() for immutability
- Validators for data integrity

## Dependencies

### Internal
- `lib/data/local/models/` — RecipeWithDetails

### External
- None (pure Dart)

<!-- MANUAL: -->
