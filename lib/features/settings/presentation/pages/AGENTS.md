<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose

Pages for profile editing and calorie formula reference.

## Key Files

| File | Description |
|------|-------------|
| `settings_page.dart` | Main settings page with profile form and reset button |
| `about_calculations_page.dart` | Reference page explaining Mifflin-St Jeor formula and activity factors |

## For AI Agents

### Working In This Directory

- **SettingsPage**: BlocBuilder observing `SettingsCubit`. Scrollable form with fields, change indicator, save button. Show change summary before save.
- **AboutCalculationsPage**: Static reference page with formula explanation, activity factor table, example calculation. No state dependency.
- **French labels**: All UI text in French (e.g., "Enregistrer", "Réinitialiser", "Calories").
- **Material 3**: Form fields, buttons, cards; Emerald primary color.
- **Confirmation dialogs**: Before save (if changes detected), before reset (warn data loss).

### Common Patterns

- **Form layout**: Scrollable column with sections (personal info, metrics, preferences, allergies, meats, meal diversity, economic mode).
- **Text fields**: Name, age, height, weight, target weight; numeric keyboards where appropriate.
- **Dropdowns**: Sex, activity level, diet type.
- **Chip/checkbox groups**: Allergies, excluded meats.
- **Save button**: Disabled if no changes. Shows confirmation dialog before save.
- **Reset button**: Prominent button at bottom with warning color; confirmation dialog with data loss warning.

## Dependencies

### Internal

- `lib/features/settings/presentation/cubit/` — `SettingsCubit`, `SettingsState`
- `lib/features/settings/presentation/widgets/` — Form field widgets
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/core/constants/` — `AppConstants` (for formula reference)

### External

- `flutter` — Material widgets
- `flutter_bloc` — `BlocBuilder`, `BlocListener`
- `go_router` — Navigation
