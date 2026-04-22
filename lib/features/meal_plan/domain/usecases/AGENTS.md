<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# usecases

## Purpose
Core meal plan business logic — generation, filtering, servings calculations.

## Key Files
| File | Description |
|------|-------------|
| `meal_plan_generator.dart` | ~940-line generator: filter, select, assign, validate |
| `recipe_filter.dart` | Stateless filters: allergens, diet type, excluded meats |
| `servings_calculator.dart` | Meal share × daily target / recipe calories |
| `plan_edit_use_case.dart` | Swap, move, shift operations |

## For AI Agents

### Working In This Directory
- meal_plan_generator: reads CLAUDE.md for meal shares (breakfast 25%, lunch 35%, dinner 30%, snack 10%)
- Filter: OMNIVORE→all, VEGETARIAN→VEG+VEGAN, VEGAN→VEGAN
- Servings: 0.5 increments, rounded for cooking
- Select: random or economic mode (ingredient overlap)
- Validation: ±10% daily calories, no repeats in week
- Keep functions pure — no side effects

### Common Patterns
- Filter returns filtered list, no mutation
- Generate returns Map<MealType, List<Recipe>> for the week
- Assign servings with macro validation
- Economic mode scores recipes by ingredient overlap

## Dependencies

### Internal
- `lib/data/local/models/` — Recipe types
- `lib/features/onboarding/domain/models/` — Enums
- `lib/core/utils/ingredient_normalizer.dart` — Synonym normalization

### External
- `dart:math` — Random selection, calculations

<!-- MANUAL: -->
