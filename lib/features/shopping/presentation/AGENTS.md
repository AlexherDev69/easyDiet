<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose

Cubit state management and UI for shopping list. Displays items grouped by supermarket section and trip, with filtering, toggles, and manual item management.

## Key Files

| File | Description |
|------|-------------|
| `cubit/shopping_cubit.dart` | Cubit; watches week plan, auto-generates list, manages item toggles, trip selection, manual adds |
| `cubit/shopping_state.dart` | State: `allItems`, `selectedTrip`, `filteredItems`, `totalTrips`, section groups, etc. |
| `pages/shopping_page.dart` | Full-screen list UI grouped by section and trip |
| `widgets/shopping_item_row.dart` | Individual item row (name, quantity, checkbox, actions) |
| `widgets/section_header.dart` | Section group header (e.g., "Produce", "Dairy") |
| `widgets/add_item_dialog.dart` | Dialog to manually add custom shopping item |
| `widgets/item_detail_dialog.dart` | Dialog showing item details and meal sources |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `cubit/` | (see `cubit/AGENTS.md`) |
| `pages/` | (see `pages/AGENTS.md`) |
| `widgets/` | (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- **Single Cubit**: `ShoppingCubit` for all list state and operations.
- **Reactive generation**: Subscribe to week plan; detect changes via hash; auto-generate list on change.
- **Material 3**: Cards for items, buttons for trips, dialogs for add/details.
- **French labels**: All UI text in French (e.g., "Courses", "Section", "Ajouter un article").
- **Trip filtering**: Show items for selected trip; selector at top or as tabs.
- **Item state**: Display checkbox (isChecked), quantity with unit, source meals, actions (detail, delete).

### Common Patterns

- **Trip selector**: Buttons or tabs (Trip 1, Trip 2, etc.) showing filtered items for that trip.
- **Section grouping**: Group items by `supermarketSection`; render section header above items.
- **Checkbox toggle**: Call `toggleItem()` on tap; update checked state.
- **Manual add**: Button opens dialog; call `addManualItem()` to insert custom item.
- **Item detail**: Tap item to show dialog with quantity breakdown by source meals.
- **Delete button**: Remove generated items only; preserve manual items.

## Dependencies

### Internal

- `lib/features/shopping/domain/repositories/` — `ShoppingRepository`
- `lib/features/shopping/domain/usecases/` — `ShoppingListGenerator`
- `lib/features/meal_plan/domain/repositories/` — `MealPlanRepository`
- `lib/features/settings/domain/repositories/` — `UserProfileRepository`
- `lib/features/shopping/presentation/cubit/` — Cubits and states
- `lib/features/shopping/presentation/widgets/` — Shared widgets
- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/core/utils/` — `QuantityFormatter`
- `lib/data/local/database.dart` — `ShoppingItem`, `WeekPlanWithDays`

### External

- `flutter_bloc` — `Cubit`, `BlocBuilder`
- `drift` — `Value()` for DB operations
- `convert` (dart:convert) — JSON parsing for sourceDetails
