<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose

Full-screen shopping list page with trip selection, section grouping, and item management dialogs.

## Key Files

| File | Description |
|------|-------------|
| `shopping_page.dart` | Main page with trip selector, items grouped by section, add/detail dialogs |

## For AI Agents

### Working In This Directory

- **BlocBuilder**: Observe `ShoppingCubit` state; rebuild on item changes, trip selection, loading state.
- **Trip selector**: Buttons or tabs (Trip 1, Trip 2, etc.); call `selectTrip()` on tap.
- **Section grouping**: Group `filteredItems` by `supermarketSection`; render section header + items.
- **French labels**: All UI text in French (e.g., "Courses", "Section", "Ajouter un article").
- **Material 3**: Cards, buttons, checkboxes, dialogs; Emerald primary color.
- **Error display**: Show `state.errorMessage` in snackbar.
- **Loading state**: Show progress spinner during list generation.
- **Floating action button**: "+" button to open add item dialog.
- **Bulk actions**: "Check all" / "Uncheck all" buttons at top; "Delete all generated" button.

### Common Patterns

- **Trip tabs**: Show trip numbers (1..totalTrips). Selected trip highlighted. Call `selectTrip(n)` on tap.
- **Section headers**: Render category (Produce, Dairy, Meat, etc.) as bold text above items in that section.
- **Item row**: Checkbox, item name, quantity + unit. Tap for detail dialog; long-press or icon button for delete.
- **Add item dialog**: Text fields for name, quantity, unit, section. Call `addManualItem()` on confirm.
- **Detail dialog**: Show item details, breakdown by meal sources. Call `deleteItem()` on delete button.
- **Empty state**: Show message if no items for selected trip.

## Dependencies

### Internal

- `lib/features/shopping/presentation/cubit/` — `ShoppingCubit`, `ShoppingState`
- `lib/features/shopping/presentation/widgets/` — Item, section, add, detail widgets
- `lib/core/theme/` — `AppColors`, `AppTheme`

### External

- `flutter` — Material widgets
- `flutter_bloc` — `BlocBuilder`, `BlocListener`
