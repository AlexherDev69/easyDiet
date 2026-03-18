import 'package:drift/drift.dart';

import 'recipe_table.dart';

/// Instructions with optional timers (1:N to Recipe).
@TableIndex(name: 'idx_recipe_steps_recipe', columns: {#recipeId})
class RecipeSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get stepNumber => integer()();
  TextColumn get instruction => text()();
  IntColumn get timerSeconds => integer().nullable()();
}
