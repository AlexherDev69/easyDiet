<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# models

## Purpose
Data models for batch cooking: recipe info, page structure, step items.

## Key Files
| File | Description |
|------|-------------|
| `batch_cooking_models.dart` | BatchCookingRecipeInfo, BatchPage, RecipeStepItem, StepPhase enum |

## For AI Agents

### Working In This Directory
- Use freezed for immutability and copyWith()
- Define enums: StepPhase (PREP, COOK, FINISH)
- Keep models lightweight — mirror data layer
- Add @immutable or use freezed

### Common Patterns
- RecipeStepItem holds step text, phase, timer, completion status
- BatchPage groups steps by recipe and phase
- BatchCookingRecipeInfo embeds recipe metadata

## Dependencies

### Internal
- `lib/data/local/models/` — Recipe entities

### External
- `freezed_annotation` (if used)

<!-- MANUAL: -->
