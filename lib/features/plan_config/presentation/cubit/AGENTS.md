<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose

Cubit and state for plan configuration. Manages loading profile, updating all config fields (diet type, allergies, meats, free days, meal types, distinct counts), and saving to database.

## Key Files

| File | Description |
|------|-------------|
| `plan_config_cubit.dart` | Cubit with methods: `updateDietType()`, `toggleAllergy()`, `toggleExcludedMeat()`, `toggleFreeDay()`, `toggleMealType()`, `updateDistinct*()`, `toggleEconomicMode()`, `saveAndProceed()` |
| `plan_config_state.dart` | State: `isLoading`, `dietType`, `selectedAllergies`, `excludedMeats`, `freeDays`, `enabledMealTypes`, `distinctBreakfasts/Lunches/Dinners/Snacks`, `economicMode`, `dietStartDate`, `errorMessage` |

## For AI Agents

### Working In This Directory

- **Init pattern**: On `PlanConfigCubit()` construction, call `_loadProfile()` automatically.
- **State emission**: All methods call `emit(state.copyWith(...))` with updated fields only.
- **Profile save**: `saveAndProceed()` reconstructs full `UserProfilesCompanion`, calls `_userProfileRepository.saveProfile()`.
- **Set toggles**: Maintain `Set<T>` immutability. For `toggleFreeDay()`, enforce max 3 free days.
- **Error handling**: Catch exceptions, emit `errorMessage`, log with `debugPrint()`.
- **Date handling**: Convert to/from epoch millis using `AppDateUtils`.

### Common Patterns

- **Toggle methods**: Add to set if not present, remove if present (e.g., `toggleAllergy()`).
- **Constraint enforcement**: In `toggleFreeDay()`, check `updated.length < 3` before adding.
- **Meal type validation**: In `toggleMealType()`, ensure at least one type remains enabled.
- **Batch profile save**: All fields saved together; use `Value()` from Drift for each field.

## Dependencies

### Internal

- `lib/features/onboarding/domain/models/` — `DietType`, `Allergy`, `ExcludedMeat`, `MealType`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/core/utils/` — `AppDateUtils`, `ProfileJsonParser`
- `lib/data/local/database.dart` — `UserProfilesCompanion`

### External

- `flutter_bloc` — `Cubit`
- `drift` — `Value()`
- `flutter/foundation.dart` — `debugPrint()`
