import 'package:drift/drift.dart';

import 'week_plan_table.dart';

/// Shopping list items derived from week plans.
class ShoppingItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weekPlanId =>
      integer().references(WeekPlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  TextColumn get supermarketSection => text()();
  BoolColumn get isChecked =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isManuallyAdded =>
      boolean().withDefault(const Constant(false))();
  TextColumn get sourceDetails =>
      text().withDefault(const Constant('[]'))();
  IntColumn get tripNumber => integer().withDefault(const Constant(1))();
}
