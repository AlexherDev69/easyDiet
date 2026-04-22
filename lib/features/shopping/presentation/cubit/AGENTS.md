<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# cubit

## Purpose

Cubit and state for shopping list. Manages list generation, item operations, trip filtering, and manual item management.

## Key Files

| File | Description |
|------|-------------|
| `shopping_cubit.dart` | Cubit: `_loadShoppingList()`, `selectTrip()`, `toggleItem()`, `addManualItem()`, `deleteItem()`, `uncheckAll()` |
| `shopping_state.dart` | State: `allItems`, `filteredItems`, `selectedTrip`, `totalTrips`, `isLoading`, `errorMessage` |

## For AI Agents

### Working In This Directory

- **Init pattern**: On construction, call `_loadShoppingList()` to subscribe to week plan and generate list.
- **Reactive generation**: Subscribe to both week plan and shopping items. Detect plan changes via hash (`_lastPlanHash`); regenerate list only if plan changed.
- **Trip filtering**: `selectTrip(n)` filters items to trip N; emit filtered list.
- **Item operations**: `toggleItem()` updates `isChecked`; `addManualItem()` inserts custom item; `deleteItem()` removes item.
- **Bulk operations**: `uncheckAll()` resets all checked flags; `deleteGeneratedItems()` removes auto-generated items.
- **Error handling**: Catch exceptions, emit `errorMessage`, log with `debugPrint()`.
- **State const**: Use `copyWith()` for immutable updates.

### Common Patterns

- **Plan hash**: Compute hash of all meal ingredients weekly. If hash differs from `_lastPlanHash`, regenerate list.
- **Generating flag**: Use `_isGenerating` to prevent concurrent regenerations.
- **Week plan ID tracking**: Store `_currentWeekPlanId` to detect plan changes.
- **Trip filtering**: Call `_filterByTrip()` to subset items; re-emit filtered state.
- **Manual item preservation**: When regenerating, preserve `isManuallyAdded: true` items; only replace generated items.

## Dependencies

### Internal

- `lib/features/shopping/domain/repositories/` — `ShoppingRepository`
- `lib/features/shopping/domain/usecases/` — `ShoppingListGenerator`
- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/core/utils/` — `QuantityFormatter`
- `lib/data/local/database.dart` — `ShoppingItem`, `WeekPlanWithDays`
- `lib/data/local/models/` — `MealWithRecipe`

### External

- `flutter_bloc` — `Cubit`
- `flutter/foundation.dart` — `debugPrint()`
- `drift` — `Value()`
- `convert` (dart:convert) — JSON encoding
