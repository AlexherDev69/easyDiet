<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose

Cubit state management and UI for settings/profile editor and calorie formula reference.

## Key Files

| File | Description |
|------|-------------|
| `cubit/settings_cubit.dart` | Cubit; loads profile, tracks changes, saves/resets |
| `cubit/settings_state.dart` | State model with all profile fields and change flags |
| `pages/settings_page.dart` | Profile editor form page |
| `pages/about_calculations_page.dart` | Reference page for calorie formula explanation |
| `widgets/settings_widgets.dart` | Reusable form field widgets |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `cubit/` | (see `cubit/AGENTS.md`) |
| `pages/` | (see `pages/AGENTS.md`) |
| `widgets/` | (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Single Cubit**: `SettingsCubit` for profile state and operations.
- **Material 3**: Form with text fields, dropdowns, spinners; Emerald primary color.
- **French labels**: All UI text in French.
- **Change detection**: Highlight changed fields; warn before saving diet-affecting changes.
- **Two pages**: Main settings page + reference page for calorie formula.
- **Loading states**: Show spinner during save; lock form during async operations.

### Common Patterns

- **Form fields**: Name, age, sex, height (cm), weight (kg), target weight, activity level, diet type.
- **Allergen/meat lists**: Display as checkboxes or chips; toggles managed by cubit.
- **Free days selector**: 7 weekday buttons (limited to 3 selections).
- **Distinct meal counts**: Spinners or text fields for breakfast, lunch, dinner, snack variety.
- **Reset button**: Show confirmation dialog before clearing all data.

## Dependencies

### Internal

- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/features/settings/presentation/cubit/` — Cubits and states
- `lib/features/onboarding/domain/models/` — `DietType`, `ActivityLevel`, etc.
- `lib/features/onboarding/domain/usecases/` — `CalorieCalculator`
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/core/utils/` — `AppDateUtils`, `ProfileJsonParser`

### External

- `flutter_bloc` — `Cubit`, `BlocBuilder`
- `go_router` — Navigation to detail pages
