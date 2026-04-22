<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# utils

## Purpose
Cross-cutting utility functions: date formatting (French), ingredient normalization (500+ synonyms), quantity rounding for recipes, decimal input handling, and JSON parsing for user profiles.

## Key Files
| File | Description |
|------|-------------|
| `date_utils.dart` | AppDateUtils: today(), epoch calc, French month/date formatting, localized weekday names |
| `ingredient_normalizer.dart` | 500+ ingredient synonym rules, accent normalization, quantity parsing, unit conversion |
| `quantity_formatter.dart` | roundForCooking(): intelligent rounding (1.3→1.25, 2.7→2.5) for recipe quantities |
| `decimal_input_formatter.dart` | TextInputFormatter: comma↔dot conversion, single decimal place max |
| `profile_json_parser.dart` | Parse user profile JSON fields (allergies, excluded meats as lists) |

## For AI Agents

### Working In This Directory
- **date_utils.dart** handles all French date formatting — use for recipe prep times, plan dates, weight logs.
  - `AppDateUtils.today()` — current date
  - `AppDateUtils.toFrenchDate(date)` — e.g., "20 avril 2026"
  - `AppDateUtils.toFrenchMonth(date)` — e.g., "avril"
  - `AppDateUtils.toFrenchWeekday(date)` — e.g., "lundi"
- **ingredient_normalizer.dart** normalizes recipe ingredients — add new synonyms if recipes use unrecognized names.
  - `AppIngredientNormalizer.normalize('name')` → canonical form
  - Handles accents, case, plurals, common aliases
- **quantity_formatter.dart** rounds quantities intelligently for cooking.
  - `QuantityFormatter.roundForCooking(1.35)` → 1.25 (preferred cooking measurements)
- **decimal_input_formatter.dart** formats numeric input (comma → dot).
  - Use in TextFormField for servings, weight inputs
- **profile_json_parser.dart** parses JSON fields in user profile.

### Common Patterns
- Date display: `AppDateUtils.toFrenchDate(DateTime.now())`
- Ingredient cleanup: `AppIngredientNormalizer.normalize(ingredientName)`
- Quantity rounding: `QuantityFormatter.roundForCooking(servings)`
- Form input: `DecimalInputFormatter()` for decimal TextFormFields

## Dependencies

### Internal
- `lib/core/constants/` — May use constants for formatting

### External
- **intl** ^0.20.2 — Localization, French date formatting
- **flutter** — TextInputFormatter base class

<!-- MANUAL: -->
