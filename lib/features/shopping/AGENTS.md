<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# shopping

## Purpose

Smart shopping list generation and management. Aggregates ingredients from meal plan, normalizes units/names, deduplicates, splits by supermarket trips, and provides manual item management. Port of `ShoppingViewModel.kt`.

## Key Files

| File | Description |
|------|-------------|
| `domain/repositories/shopping_repository.dart` | Interface for shopping item CRUD |
| `domain/usecases/shopping_list_generator.dart` | ~400 lines; aggregates ingredients, normalizes, deduplicates, splits by trips |
| `domain/models/ingredient_source.dart` | DTO tracking recipe/meal source of ingredients |
| `presentation/cubit/shopping_cubit.dart` | State; manages list, item toggles, manual add, trip selection |
| `presentation/cubit/shopping_state.dart` | State model with items, filtered by trip, section, etc. |
| `presentation/pages/shopping_page.dart` | Full-screen list UI grouped by supermarket section |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `data/` | Data layer (if present) |
| `data/repositories/` | (see `data/repositories/AGENTS.md` if exists) |
| `domain/` | (see `domain/AGENTS.md`) |
| `domain/repositories/` | (see `domain/repositories/AGENTS.md`) |
| `domain/models/` | (see `domain/models/AGENTS.md`) |
| `domain/usecases/` | (see `domain/usecases/AGENTS.md`) |
| `presentation/` | (see `presentation/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Cubit pattern**: `ShoppingCubit` subscribes to week plan; auto-generates list on plan change. Detects plan hash to avoid regenerating unchanged plans.
- **Shopping list generation**: Aggregate ingredients from all meals, normalize units (kg→g, l→ml), apply synonym rules, dedup by normalized name, split into trips.
- **Trip selection**: Filter items by trip; user selects trip to see only items for that supermarket visit.
- **Manual items**: Allow user to add custom items (not from recipes); tracked with `isManuallyAdded` flag.
- **Sections**: Group items by supermarket section (Produce, Dairy, Meat, etc.).
- **Item management**: Toggle checked state, delete generated/manual items, check/uncheck all.
- **French UI strings**: All labels in French (e.g., "Courses", "Section", "Quantité").

### Common Patterns

- **Ingredient normalization**: Apply 500+ synonym rules from `IngredientNormalizer`, convert units.
- **Plan hash**: Hash meal plan weekly ingredients to detect changes; only regenerate on change.
- **Trip splitting**: Assign items to trips (1, 2, etc.) based on `shoppingTripsPerWeek` profile setting.
- **Item state**: `isChecked` (user toggled), `isManuallyAdded` (custom), `sourceDetails` (JSON tracking meals).
- **Auto-generation**: On meal plan change, regenerate list automatically; preserve manual items.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `ShoppingItem`, `WeekPlan`, `Meal`, `Recipe`
- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/core/utils/` — `IngredientNormalizer`, `QuantityFormatter`
- `lib/data/local/models/` — `WeekPlanWithDays`, `MealWithRecipe`

### External

- `flutter_bloc` — `Cubit`
- `drift` — `Value()`
- `convert` (dart:convert) — JSON encoding/decoding for sourceDetails
