<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# tables

## Purpose
9 Drift table definitions: schema structure, column types, constraints, and foreign keys for the SQLite database.

## Key Files
| File | Description |
|------|-------------|
| `user_profile_table.dart` | UserProfiles: singleton settings (name, age, sex, height, weight, calories, allergies JSON, etc.) |
| `recipe_table.dart` | Recipes: catalog (name, category, calories, macros, allergens JSON, diet type, prep/cook time) |
| `recipe_step_table.dart` | RecipeSteps: instructions (recipeId FK, stepNumber, instruction text, timer) |
| `ingredient_table.dart` | Ingredients: recipe ingredients (recipeId FK, name, quantity, unit, supermarket section) |
| `week_plan_table.dart` | WeekPlans: week container (weekStartDate, createdAt) |
| `day_plan_table.dart` | DayPlans: days in week (weekPlanId FK, date, dayOfWeek, isFreeDay, batchCookingSession) |
| `meal_table.dart` | Meals: meal assignments (dayPlanId FK, mealType, recipeId FK, servings, isConsumed) |
| `shopping_item_table.dart` | ShoppingItems: shopping list (weekPlanId FK, name, quantity, unit, section, isChecked, tripNumber) |
| `weight_log_table.dart` | WeightLogs: weight tracking (date unique, weightKg, createdAt) |

## For AI Agents

### Working In This Directory
- Each file defines one Drift table via @DataClass + table definition.
- Modify column types, add fields, or add constraints here.
- Foreign keys reference other tables — ensure cascade deletes are defined.
- JSON columns use custom converters (e.g., allergies as JSON array).
- Primary keys are auto-increment by default unless specified.

### Table Pattern
```dart
class UserProfilesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get allergies => text().nullable()(); // JSON via converter
  
  @override
  Set<Column> get primaryKey => {id};
}
```

### Schema Changes
1. Add field: Add column in table definition.
2. Change type: Modify column definition, update AppDatabase version, run build_runner.
3. Add constraint: Use `references()`, `unique()`, `check()` on column.
4. Cascade delete: Set `onDeleteSet: SetNull` or `onDeleteCascade` on FK.

## Dependencies

### Internal
- `lib/data/local/database.dart` — AppDatabase registration

### External
- **drift** ^2.25.0 — Table, IntColumn, TextColumn, etc.
- **flutter/material.dart** — UI types if needed

<!-- MANUAL: -->
