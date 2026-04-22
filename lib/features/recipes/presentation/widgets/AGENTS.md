<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# widgets

## Purpose

Reusable widget components for recipe list and detail pages.

## Key Files

| File | Description |
|------|-------------|
| `recipe_list_card.dart` | Card displaying single recipe (name, time, macros) |
| `category_filter_chips.dart` | Horizontal chip group for category selection |
| `category_header.dart` | Section header for recipe category |

## For AI Agents

### Working In This Directory

- **Const constructors**: All widgets use `const` where possible.
- **No state**: Stateless widgets only; pass callbacks to parent.
- **Reusability**: Each widget is single-purpose and parameterized.
- **Material 3**: Use `Card`, `Chip`, `Text` with theme-aware styling.
- **French strings**: Passed as parameters; no hardcoded UI text.

### Common Patterns

- **Card layout**: Image, title, macros, time; tap callback.
- **Chip group**: Filter list as chips, highlight selected; `onTap` callback.
- **Header**: Category name, optional recipe count; margin/padding for sections.

## Dependencies

### Internal

- `lib/core/theme/` — `AppColors`, `AppTheme`
- `lib/data/local/database.dart` — `Recipe`, `RecipeWithDetails`

### External

- `flutter` — Material widgets
