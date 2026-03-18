import 'package:drift/drift.dart';

import 'recipe_table.dart';

/// Ingredients per recipe (1:N to Recipe).
@TableIndex(name: 'idx_ingredients_recipe', columns: {#recipeId})
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  TextColumn get supermarketSection => text()();
}
