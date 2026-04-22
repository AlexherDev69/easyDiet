<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose

Full-screen UI page for plan configuration form. Displays all plan settings and provides save button to proceed to plan preview.

## Key Files

| File | Description |
|------|-------------|
| `plan_config_page.dart` | Page widget with form, observes `PlanConfigCubit` state, renders config controls |

## For AI Agents

### Working In This Directory

- **BlocBuilder**: Observe `PlanConfigCubit` state to rebuild form and show loading/error states.
- **French labels**: All UI text (button labels, field hints, section headers) in French.
- **Material 3**: Use `Card`, `Switch`, `Chip`, `DropdownButton`, `TextFormField`, `ElevatedButton`.
- **Layout**: Single column scroll view with sections for: diet type, allergies, excluded meats, free days, meal types, distinct counts, economic mode, diet start date.
- **Error display**: Show `state.errorMessage` via `SnackBar` when present.
- **Save button**: Call `context.read<PlanConfigCubit>().saveAndProceed()` on tap; disable during loading.

### Common Patterns

- **Chip selector group**: Render set of items as `Chip` widgets, call toggle method on tap.
- **Weekday buttons**: 7 buttons (Mon–Sun) showing free days, call `toggleFreeDay(index)` on tap.
- **Spinner fields**: Use `TextFormField` with `TextInputType.number` for distinct counts, call update methods.
- **Switch toggle**: For economic mode, use `Switch` widget, call `toggleEconomicMode()`.
- **Date picker**: Tap date field to open `showDatePicker()`, call `updateDietStartDate()`.

## Dependencies

### Internal

- `lib/features/plan_config/presentation/cubit/` — `PlanConfigCubit`, `PlanConfigState`
- `lib/core/theme/` — `AppColors`, `AppTheme`

### External

- `flutter` — Material widgets
- `flutter_bloc` — `BlocBuilder`
- `go_router` — Navigation after save
