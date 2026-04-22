<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# usecases

## Purpose
Core business logic: phase-interleaved step optimizer for batch cooking.

## Key Files
| File | Description |
|------|-------------|
| `batch_step_optimizer.dart` | Interleave prep/cook/finish phases, sorted by time |

## For AI Agents

### Working In This Directory
- Pure logic — no Database/Repository direct access
- Given list of RecipeWithDetails, return optimized BatchPage list
- Algorithm: extract steps → group by phase → sort by time → return
- Deterministic, no side effects

### Common Patterns
- Phase mapping: step type → PREP/COOK/FINISH
- Time sorting: concurrent phases, sequential across phases
- Dedup identical steps across recipes (e.g., "Preheat oven")

## Dependencies

### Internal
- `lib/data/local/models/` — RecipeWithDetails
- `batch_cooking_models.dart` — Data structures

### External
- None (pure Dart)

<!-- MANUAL: -->
