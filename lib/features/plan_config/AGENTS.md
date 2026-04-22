<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# plan_config

## Purpose

Allows users to configure plan parameters before meal plan generation: diet type, allergies, excluded meats, free days, meal type preferences, distinct meal counts, economic mode, and diet start date. Port of `PlanConfigViewModel.kt`.

## Key Files

| File | Description |
|------|-------------|
| `presentation/cubit/plan_config_cubit.dart` | State management; loads profile, updates config fields, saves to DB |
| `presentation/cubit/plan_config_state.dart` | State data model (diet type, allergies, free days, enabled meal types, etc.) |
| `presentation/pages/plan_config_page.dart` | UI page with form fields and save button |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `presentation/` | (see `presentation/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Cubit pattern**: One Cubit per screen; state via `emit(state.copyWith(...))`. Methods are named after actions: `updateDietType()`, `toggleAllergy()`, `toggleFreeDay()`, `saveAndProceed()`.
- **Profile loading**: Fetch from `UserProfileRepository` on init; parse JSON fields (allergies, excluded meats, meal types) using `ProfileJsonParser`.
- **French UI strings**: All labels in French (e.g., "Enregistrer", "Suivant"). Enum names stay in English.
- **Validation**: Free days limited to 3 max; meal types require at least 1 enabled.
- **Navigation**: After `saveAndProceed()`, emit state that page observes to navigate to plan preview.

### Common Patterns

- **Set<T> toggles**: Maintain immutable `Set` state for allergies, excluded meats, free days, meal types. Add/remove, re-emit.
- **Numeric pickers**: `distinctBreakfasts`, `distinctLunches`, etc. are simple int setters.
- **Date picker**: `updateDietStartDate()` saves as epoch millis via `AppDateUtils.toEpochMillis()`.
- **Profile save**: Reconstruct full `UserProfilesCompanion` with only changed fields, pass to `saveProfile()`.

## Dependencies

### Internal

- `lib/features/onboarding/domain/models/` — `DietType`, `Allergy`, `ExcludedMeat`, `MealType` enums
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/core/utils/` — `AppDateUtils`, `ProfileJsonParser`
- `lib/data/local/database.dart` — `UserProfilesCompanion`

### External

- `flutter_bloc` — `Cubit`, `emit()`
- `drift` — `Value()`
