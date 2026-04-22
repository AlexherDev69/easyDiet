<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose

Reusable form field widgets for settings page.

## Key Files

| File | Description |
|------|-------------|
| `settings_widgets.dart` | Shared form components (text field, dropdown, spinner, chip group, header) |

## For AI Agents

### Working In This Directory

- **Const constructors**: All widgets use `const` where possible.
- **Stateless**: No state management; pass values and callbacks to parent.
- **Material 3**: Use theme-aware colors and typography.
- **Accessibility**: Proper labels, hints, semantic roles.

### Common Patterns

- **Text field wrapper**: Custom text input with label, hint, keyboard type, validation.
- **Dropdown wrapper**: Select field with options and on-change callback.
- **Spinner**: Increment/decrement buttons with value display.
- **Chip group**: Multi-select or single-select chips with on-change callback.
- **Section header**: Category label with optional subtitle.

## Dependencies

### Internal

- `lib/core/theme/` — `AppColors`, `AppTheme`

### External

- `flutter` — Material widgets
