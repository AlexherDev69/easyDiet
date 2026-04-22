<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# models

## Purpose
Domain enums and model definitions — 8 enums for all user profile options.

## Key Files
| File | Description |
|------|-------------|
| `sex.dart` | Sex enum (male, female) |
| `diet_type.dart` | DietType enum (omnivore, vegetarian, vegan) |
| `activity_level.dart` | ActivityLevel enum with TDEE factor |
| `loss_pace.dart` | LossPace enum (slow, moderate, aggressive) with deficit |
| `meal_type.dart` | MealType enum (breakfast, lunch, dinner, snack) |
| `allergy.dart` | Allergy enum (nuts, dairy, gluten, shellfish, etc.) |
| `excluded_meat.dart` | ExcludedMeat enum (beef, pork, chicken, fish, etc.) |
| `supermarket_section.dart` | SupermarketSection enum for shopping list |
| `models.dart` | Re-export all enums |

## For AI Agents

### Working In This Directory
- Each enum is a separate file + re-export in models.dart
- Add display name (String) or description to enums
- Enums are immutable constants
- Add extension methods if needed (e.g., displayName)

### Common Patterns
- Enum with String name, description, value
- ActivityLevel.sedentary.factor → 1.2
- LossPace.moderate.deficitKcal → 500
- Allergy/ExcludedMeat are flags/lists in profile JSON

## Dependencies

### Internal
- None

### External
- None

<!-- MANUAL: -->
