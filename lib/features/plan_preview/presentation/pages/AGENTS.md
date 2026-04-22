<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose

Full-screen page displaying the generated meal plan in preview mode. Includes move/replace dialogs and confirm/cancel buttons.

## Key Files

| File | Description |
|------|-------------|
| `plan_preview_page.dart` | Page widget observing `PlanPreviewCubit`, renders day cards and dialogs |

## For AI Agents

### Working In This Directory

- **BlocBuilder**: Observe cubit state; rebuild on changes to week plan, dialog visibility, loading state.
- **French labels**: All UI text in French (e.g., "Confirmer", "Annuler", "Modifier", "Déplacer").
- **Material 3**: Day cards in week plan; dialogs for move and replace actions.
- **Day display**: For each day in `state.weekPlan`, show day name, meals with recipe names and calories.
- **Meal actions**: Tap meal card to show context menu or buttons (move, replace, view details).
- **Dialog rendering**: Show move/replace dialogs when corresponding flags are true; pass candidate lists to dialogs.
- **Loading**: Show progress spinner overlay during `_generateNewPlan()` and `confirmPlan()`.
- **Error display**: Show `state.errorMessage` in snackbar.
- **Button state**: Disable "Confirm" button during loading; always show "Cancel" (or back button).

### Common Patterns

- **Day cards**: Render as `Card` with day name header and meal list inside. Tap meal to trigger context menu.
- **Move dialog**: Dropdown of target days; call `context.read<PlanPreviewCubit>().moveMealToDay(targetId)` on select.
- **Replace dialog**: Grid/list of recipes; call `context.read<PlanPreviewCubit>().replaceRecipe(recipe, replaceAll)`.
- **Confirm flow**: Tap "Confirm" → `confirmPlan()` → await generation → navigate to dashboard.
- **Cancel flow**: Tap "Cancel" → pop page (cubit.close() cleans up preview plan).

## Dependencies

### Internal

- `lib/features/plan_preview/presentation/cubit/` — `PlanPreviewCubit`, `PlanPreviewState`
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/data/local/models/` — `MealWithRecipe`, `WeekPlanWithDays`

### External

- `flutter` — Material widgets, navigation
- `flutter_bloc` — `BlocBuilder`, `BlocListener`
- `go_router` — Route navigation
