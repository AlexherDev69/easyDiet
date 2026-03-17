import 'package:drift/drift.dart';

import 'day_plan_table.dart';
import 'recipe_table.dart';

/// Meal assignment within a day (N:1 to DayPlan, N:1 to Recipe).
class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dayPlanId =>
      integer().references(DayPlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get mealType => text()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  RealColumn get servings => real().withDefault(const Constant(1.0))();
  BoolColumn get isConsumed =>
      boolean().withDefault(const Constant(false))();
}
