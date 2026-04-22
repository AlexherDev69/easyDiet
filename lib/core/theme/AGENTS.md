<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# theme

## Purpose
Material 3 theming: Emerald palette, light/dark modes, typography (Nunito), meal-type colors, and ExtendedColors for custom Material 3 support.

## Key Files
| File | Description |
|------|-------------|
| `app_colors.dart` | Emerald palette (#10B981), dark colors, gradients, meal type colors (breakfast/lunch/dinner/snack) |
| `app_theme.dart` | Material 3 light/dark ThemeData, Nunito typography, ExtendedColors definition |

## For AI Agents

### Working In This Directory
- **app_colors.dart** defines the color palette — modify here for any color changes.
  - `primary`: #10B981 (Emerald)
  - Meal type colors: `mealTypeBreakfast`, `mealTypeLunch`, `mealTypeDinner`, `mealTypeSnack`
  - Dark colors for dark mode
  - Gradients for hero cards
- **app_theme.dart** builds Material 3 theme with Nunito — modify here for typography or theme structure changes.
  - Light theme: AppTheme.light()
  - Dark theme: AppTheme.dark()
  - ExtendedColors for Material 3 custom colors

### Common Patterns
- Access colors: `Theme.of(context).colorScheme.primary`, `AppColors.mealTypeBreakfast`, `AppColors.primaryGradient`.
- Use theme: `MaterialApp.router(theme: AppTheme.light(), darkTheme: AppTheme.dark())`.
- Typography: `Theme.of(context).textTheme.headlineSmall` (Nunito font inherited).
- Meal type color: `AppColors.mealTypeColor(MealType.breakfast)` returns the appropriate color.

### Material 3 & ExtendedColors
- Material 3 theme uses 5 tonal palettes + custom colors.
- ExtendedColors allows tonal variants (light, onLight, dark, onDark) per custom color.
- Define new ExtendedColors in `app_theme.dart` if adding custom theme colors.

## Dependencies

### Internal
- `lib/core/constants/` — May reference app constraints

### External
- **flutter** — Material 3 theming
- **google_fonts** ^6.2.1 — Nunito font loading

<!-- MANUAL: -->
