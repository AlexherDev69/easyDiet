<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose

Cubit and state for settings/profile editor. Manages profile loading, field updates, saves, and app reset.

## Key Files

| File | Description |
|------|-------------|
| `settings_cubit.dart` | Cubit with: `_loadProfile()`, update methods for all fields, `saveDietProfile()`, `appReset()` |
| `settings_state.dart` | State: `isLoading`, all profile fields (name, age, sex, height, weight, target weight, activity level, diet type, allergies, excluded meats, free days, distinct counts, economic mode), `changed` flag, `errorMessage` |

## For AI Agents

### Working In This Directory

- **Init pattern**: On construction, call `_loadProfile()` to populate state.
- **Change tracking**: Store `_originalDietFields` snapshot. Track changes, only save if modifications detected.
- **Field updates**: One method per field (e.g., `updateName()`, `updateAge()`, `updateSex()`). Emit with `copyWith()`.
- **Save logic**: Reconstruct full `UserProfilesCompanion` with all fields. If diet-affecting fields change, recalculate daily calorie target.
- **Reset**: Delete all meals, shopping items, weight logs; reset profile fields to onboarding state. Trigger navigation back to onboarding.
- **Error handling**: Catch exceptions, emit `errorMessage`, log with `debugPrint()`.

### Common Patterns

- **Profile snapshot**: Store original state to detect changes. Emit `changed: true` when user modifies any field.
- **Calorie recalc**: On save, if sex/age/height/weight/activity level changed, recalculate daily target and emit.
- **Batch save**: Merge all changed fields into one `UserProfilesCompanion` and call `saveProfile()` once.
- **Reset guard**: Require user confirmation before calling `appReset()` (managed by page).

## Dependencies

### Internal

- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository`
- `lib/features/weight_log/domain/repositories/` — `WeightLogRepository`
- `lib/features/onboarding/domain/models/` — `DietType`, `ActivityLevel`, `LossPace`, `Sex`, `Allergy`, `ExcludedMeat`
- `lib/features/onboarding/domain/usecases/` — `CalorieCalculator`
- `lib/core/utils/` — `AppDateUtils`, `ProfileJsonParser`
- `lib/data/local/database.dart` — `UserProfile`, `UserProfilesCompanion`

### External

- `flutter_bloc` — `Cubit`
- `flutter/foundation.dart` — `debugPrint()`
- `drift` — `Value()`
