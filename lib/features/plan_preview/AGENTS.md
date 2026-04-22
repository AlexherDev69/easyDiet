<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# plan_preview

## Purpose

Preview a newly generated meal plan before confirmation. Allows user to move meals between days, replace recipes, and then confirm or discard the plan. Port of `PlanPreviewViewModel.kt`.

## Key Files

| File | Description |
|------|-------------|
| `presentation/cubit/plan_preview_cubit.dart` | State management; generates plan, handles move/replace dialogs, confirms plan, generates shopping list |
| `presentation/cubit/plan_preview_state.dart` | State data model (week plan, move/replace dialog state, candidates) |
| `presentation/pages/plan_preview_page.dart` | UI displaying week plan with cards, dialogs, and action buttons |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `presentation/` | (see `presentation/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Cubit pattern**: One Cubit per screen. On init, auto-calls `_generateNewPlan()`.
- **Plan lifecycle**: New plan generated, shown in preview. If confirmed, old plan deleted and shopping list generated. If dismissed, new plan deleted (cleanup in `close()`).
- **Move dialog**: `openMoveMealDialog()` shows movable target days; `moveMealToDay()` persists change.
- **Replace dialog**: `openReplaceDialog()` fetches compatible recipes; `replaceRecipe()` handles single or all-week replacement.
- **Error handling**: Catch exceptions in all async methods, emit `errorMessage`.
- **Navigation**: After confirmation, page observes state to navigate to next screen (usually dashboard).

### Common Patterns

- **State deletion on close**: Override `close()` to clean up preview plan if not confirmed.
- **Candidate filtering**: Use `PlanEditUseCase` to get compatible recipes for replacement.
- **Dialog state tracking**: Use flags (`showMoveDialog`, `showReplaceDialog`) and candidate lists to control dialog rendering.
- **Async confirmation**: `confirmPlan()` marks state as confirmed, generates shopping list, emits final state.

## Dependencies

### Internal

- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository`
- `lib/features/meal_plan/domain/usecases/` — `MealPlanGenerator`, `PlanEditUseCase`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/features/shopping/domain/usecases/` — `ShoppingListGenerator`
- `lib/data/local/database.dart` — `Recipe`, `WeekPlanWithDays`
- `lib/data/local/models/` — `MealWithRecipe`

### External

- `flutter_bloc` — `Cubit`
- `flutter/foundation.dart` — `debugPrint()`
