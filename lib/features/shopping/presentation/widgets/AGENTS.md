<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose

Reusable widgets for shopping list page.

## Key Files

| File | Description |
|------|-------------|
| `shopping_item_row.dart` | Individual item row with checkbox, name, quantity, actions |
| `section_header.dart` | Section category header (e.g., "Produce", "Dairy") |
| `add_item_dialog.dart` | Dialog for manually adding custom shopping item |
| `item_detail_dialog.dart` | Dialog showing item details and meal sources breakdown |

## For AI Agents

### Working In This Directory

- **Const constructors**: All widgets use `const` where possible.
- **Stateless**: No state management; pass values and callbacks.
- **Material 3**: Use theme-aware colors and typography.
- **Accessibility**: Proper labels and semantic roles.

### Common Patterns

- **Item row**: Checkbox on left, name/quantity center, action icons (detail, delete) right.
- **Section header**: Bold category name (e.g., "Produce") with optional item count.
- **Add dialog**: Text fields for name, quantity, unit, dropdown for section. Two buttons: Cancel, Add.
- **Detail dialog**: Item name, total quantity, breakdown by meals (recipe name, meal type, quantity). Delete button.
- **Actions**: Call callbacks like `onToggle()`, `onDelete()`, `onTap()`.

## Dependencies

### Internal

- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/core/utils/` — `QuantityFormatter`
- `lib/data/local/database.dart` — `ShoppingItem`

### External

- `flutter` — Material widgets
