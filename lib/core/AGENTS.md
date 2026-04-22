<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# core

## Purpose
Cross-cutting concerns: application constants, Material 3 theming with Emerald palette, dependency injection, and utility functions for date formatting, ingredient normalization, quantity rounding, and decimal input handling.

## Key Files
| File | Description |
|------|-------------|
| `di/injection.dart` | GetIt service locator registration: database, DAOs, repos, use cases |
| `theme/app_colors.dart` | Emerald palette (#10B981), dark theme colors, gradients, meal type colors |
| `theme/app_theme.dart` | Material 3 light/dark themes, Nunito typography, ExtendedColors |
| `constants/app_constants.dart` | Min calories (1200F/1500M), kcal per kg fat, water calc formula |
| `utils/date_utils.dart` | AppDateUtils: today, epoch calc, French date/month formatting |
| `utils/ingredient_normalizer.dart` | 500+ synonym rules, accent normalization, quantity parsing |
| `utils/quantity_formatter.dart` | roundForCooking(): intelligent rounding for recipe quantities |
| `utils/decimal_input_formatter.dart` | TextInputFormatter: comma↔dot conversion, single decimal |
| `utils/profile_json_parser.dart` | JSON parsing for user profile (allergies, excluded meats as lists) |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `constants/` | App-wide constants (see Key Files) |
| `di/` | Dependency injection setup (see Key Files) |
| `theme/` | Material 3 colors, theme definitions, typography |
| `utils/` | Date, ingredient, quantity, decimal formatting utilities |

## For AI Agents

### Working In This Directory
- **injection.dart** is the DI bootstrap — add new services (repos, use cases) here when creating features.
- **app_colors.dart** defines the Emerald palette and meal-type-specific colors — modify for UI changes.
- **app_theme.dart** builds the Material 3 theme with Nunito font — modify typography or Material 3 configs here.
- **app_constants.dart** holds BMR/TDEE formulae, min calories, water targets — modify for nutrition changes.
- **date_utils.dart** handles French date formatting — use `AppDateUtils.today()`, `AppDateUtils.toFrenchDate()`, etc.
- **ingredient_normalizer.dart** normalizes recipe ingredient names (e.g., "oeufs" → "egg", accent removal) — add new synonyms here.
- **quantity_formatter.dart** rounds cooking quantities intelligently (1.3 → 1.25, 2.7 → 2.5) — modify if rounding rules change.
- **decimal_input_formatter.dart** converts comma to dot for numeric input — modify for different input handling.

### Common Patterns
- Register new Cubits in `injection.dart`: `getIt.registerSingleton<MyCubit>(MyCubit(getIt<Repo>()))`.
- Access DI: `final repo = getIt<SomeRepository>();` anywhere after bootstrap.
- Color usage: `AppColors.primary`, `AppColors.mealtypeBreakfast`, etc. from `app_colors.dart`.
- Date formatting: `AppDateUtils.toFrenchMonth(date)` for French month names.
- Ingredient normalization: `AppIngredientNormalizer.normalize('name')` for synonym mapping.

### Key Constants
- **Min Calories**: 1200 kcal (female), 1500 kcal (male) — in `app_constants.dart`.
- **kcal per kg fat**: 7700 (for deficit/surplus calc) — in `app_constants.dart`.
- **Water target**: 1 ml per kcal, clamped by sex-specific min/max — in `app_constants.dart`.
- **Primary color**: #10B981 (Emerald) — in `app_colors.dart`.
- **Font**: Google Fonts Nunito — in `app_theme.dart`.

## Dependencies

### Internal
None (core has no internal dependencies).

### External
- **flutter_bloc** — For Cubit in DI
- **get_it** ^8.0.3 — Service locator
- **drift** — Database singleton registration
- **google_fonts** ^6.2.1 — Nunito font
- **intl** ^0.20.2 — Date/locale formatting

<!-- MANUAL: -->
