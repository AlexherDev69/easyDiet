<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# settings

## Purpose

User profile management and app settings. Allows editing of personal info, body metrics, diet preferences, and provides calorie calculation formula reference. Includes app reset to onboarding. Port of `SettingsViewModel.kt`.

## Key Files

| File | Description |
|------|-------------|
| `domain/repositories/user_profile_repository.dart` | Interface for profile CRUD and updates |
| `presentation/cubit/settings_cubit.dart` | State management for profile editing, saving, reset |
| `presentation/cubit/settings_state.dart` | State model with profile fields |
| `presentation/pages/settings_page.dart` | Main settings/profile editor page |
| `presentation/pages/about_calculations_page.dart` | Reference page explaining calorie formula |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `domain/` | (see `domain/AGENTS.md`) |
| `presentation/` | (see `presentation/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Cubit pattern**: `SettingsCubit` loads profile on init, tracks original state for change detection, handles save/reset.
- **Change detection**: Compare current state to `_originalDietFields` before save to avoid unnecessary updates.
- **Save logic**: Only update changed fields; full profile reconstruction on save.
- **Reset**: Clear all data (meals, shopping, weights) and return to onboarding.
- **French UI strings**: All labels, buttons, hints in French.
- **Calorie formula**: Display Mifflin-St Jeor formula and activity factor explanation in separate page.

### Common Patterns

- **Profile form**: Name, age, sex, height, weight, target weight, activity level, diet type, etc.
- **Change tracking**: Store original snapshot; emit state with changed flag when user edits.
- **Save guards**: Warn if deleting active plan or resetting entire app.
- **Calorie recalc**: If diet parameters change, recalculate daily target.
- **Async operations**: Show loading overlay during save/reset; emit error on failure.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `UserProfile`, `UserProfilesCompanion`
- `lib/features/onboarding/domain/models/` — `DietType`, `ActivityLevel`, `LossPace`, `Sex`, `Allergy`, `ExcludedMeat`
- `lib/features/onboarding/domain/usecases/` — `CalorieCalculator`
- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository`
- `lib/features/weight_log/domain/repositories/` — `WeightLogRepository`
- `lib/core/utils/` — `AppDateUtils`, `ProfileJsonParser`
- `lib/core/theme/` — `AppColors`, `AppTheme`

### External

- `flutter_bloc` — `Cubit`
- `drift` — `Value()`
