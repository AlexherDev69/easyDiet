<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose

Cubit state management and UI for plan configuration. Single page with form controls for diet type, allergies, excluded meats, free days, meal types, distinct counts, and economic mode.

## Key Files

| File | Description |
|------|-------------|
| `cubit/plan_config_cubit.dart` | Cubit; loads/saves profile, manages config state |
| `cubit/plan_config_state.dart` | State model with all config fields |
| `pages/plan_config_page.dart` | Full-screen form UI |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `cubit/` | (see `cubit/AGENTS.md`) |
| `pages/` | (see `pages/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **State const**: Emit new state with `state.copyWith()`, not direct mutation.
- **UI strings in French**: All labels, buttons, hints are French. No hardcoded English UI.
- **Form layout**: Use Material 3 cards, switches, dropdowns, chip selectors (allergies, meats), multi-select buttons (meal types).
- **Error display**: Show `state.errorMessage` in snackbar or error widget.
- **Loading state**: Disable save button and show progress during `saveAndProceed()`.

### Common Patterns

- **Toggle chip groups**: Render `state.selectedAllergies`, `state.excludedMeats`, `state.enabledMealTypes` as tap-to-toggle chips.
- **Free days selector**: Show 7 weekday buttons; limited to 3 selections max.
- **Dropdown for diet type**: Observer pattern on `state.dietType`, call `updateDietType()`.
- **Numeric input**: Spinners or text fields for distinct meal counts, call `updateDistinct*()`.

## Dependencies

### Internal

- `lib/features/plan_config/presentation/cubit/` — `PlanConfigCubit`, `PlanConfigState`
- `lib/features/onboarding/domain/models/` — `DietType`, `Allergy`, `ExcludedMeat`, `MealType`
- `lib/core/theme/` — `AppColors`, `AppTheme`

### External

- `flutter_bloc` — `BlocBuilder`, `BlocListener`
- `go_router` — Navigation on save success
