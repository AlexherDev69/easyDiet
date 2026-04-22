<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose

Cubit state management and UI for plan preview. Displays the generated meal plan with move and replace dialogs, confirmation button, and loading/error states.

## Key Files

| File | Description |
|------|-------------|
| `cubit/plan_preview_cubit.dart` | Cubit; generates plan, handles dialogs, confirms/discards |
| `cubit/plan_preview_state.dart` | State model with week plan, dialog states, and candidates |
| `pages/plan_preview_page.dart` | Full-screen page displaying plan and dialogs |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `cubit/` | (see `cubit/AGENTS.md`) |
| `pages/` | (see `pages/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **State const**: Use `state.copyWith()` for immutable updates.
- **UI strings in French**: All labels and button text in French.
- **Material 3**: Cards for days, dialogs for move/replace actions, loading overlay during generation.
- **Dialog control**: Flags `showMoveDialog`, `showReplaceDialog` control visibility; state fields hold meal and candidates.
- **Error display**: Show `state.errorMessage` in snackbar or error widget.
- **Two-button pattern**: "Confirm" to accept (generates shopping list), "Cancel" to discard plan.

### Common Patterns

- **Day cards**: Render each day in week plan with meals; tap meal to open action menu (move, replace, delete).
- **Move meal dialog**: Show dropdown of valid target days, call `moveMealToDay()` on selection.
- **Replace meal dialog**: Show grid/list of compatible recipes with filters (category, allergens); call `replaceRecipe(replaceAll: true/false)`.
- **Async state**: Show spinner during `_generateNewPlan()`, `confirmPlan()`; disable buttons during loading.
- **Confirmation flow**: User taps "Confirm" → `confirmPlan()` generates shopping list → page observes completion and navigates.

## Dependencies

### Internal

- `lib/features/plan_preview/presentation/cubit/` — `PlanPreviewCubit`, `PlanPreviewState`
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/data/local/models/` — `MealWithRecipe`, `WeekPlanWithDays`

### External

- `flutter_bloc` — `BlocBuilder`, `BlocListener`
- `go_router` — Navigation after confirmation
