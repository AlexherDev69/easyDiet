<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose

Cubit and state for plan preview. Manages plan generation, move/replace dialogs, confirmation flow, and cleanup.

## Key Files

| File | Description |
|------|-------------|
| `plan_preview_cubit.dart` | Cubit with: `_generateNewPlan()`, `confirmPlan()`, `openMoveMealDialog()`, `moveMealToDay()`, `openReplaceDialog()`, `replaceRecipe()`, `close()` override |
| `plan_preview_state.dart` | State: `isLoading`, `weekPlan`, `showMoveDialog`, `movingMeal`, `moveTargetDays`, `showReplaceDialog`, `replacingMeal`, `replacementCandidates`, `otherOccurrencesCount`, `errorMessage` |

## For AI Agents

### Working In This Directory

- **Lifecycle management**: Store `_previousWeekPlanId` on preview generation to track old plan for cleanup. On confirm, delete old. On close without confirm, delete preview.
- **Dialog state pattern**: Emit state with dialog flags and relevant meal/candidates. Page reads flags to show/hide dialogs.
- **Error propagation**: Catch exceptions, emit `errorMessage`, log with `debugPrint()`.
- **Use case delegation**: Use `PlanEditUseCase` for move/replace logic; use `MealPlanGenerator` for plan generation.
- **Shopping list**: Only generated on confirmation, delegated to `ShoppingListGenerator`.

### Common Patterns

- **Move meal logic**: Call `_planEditUseCase.getMovableTargetDays()` to get valid targets, then `moveMealToDay()` to persist.
- **Replace meal logic**: Call `_planEditUseCase.getReplaceDialogData()` to fetch candidates and occurrence count; `replaceRecipe()` handles single or bulk replacement.
- **Plan deletion**: In `close()`, only delete preview plan if `!_confirmed` to preserve user's choice.
- **Async state**: Set `isLoading: true` at start of async operation, `false` at end; disable UI during loading.

## Dependencies

### Internal

- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository`
- `lib/features/meal_plan/domain/usecases/` — `MealPlanGenerator`, `PlanEditUseCase`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/features/shopping/domain/usecases/` — `ShoppingListGenerator`
- `lib/data/local/database.dart` — `Recipe`
- `lib/data/local/models/` — `MealWithRecipe`, `WeekPlanWithDays`

### External

- `flutter_bloc` — `Cubit`
- `flutter/foundation.dart` — `debugPrint()`
