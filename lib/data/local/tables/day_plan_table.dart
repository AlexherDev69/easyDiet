import 'package:drift/drift.dart';

import 'week_plan_table.dart';

/// Day within a week plan (N:1 to WeekPlan).
class DayPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weekPlanId =>
      integer().references(WeekPlans, #id, onDelete: KeyAction.cascade)();
  IntColumn get date => integer()();
  IntColumn get dayOfWeek => integer()();
  BoolColumn get isFreeDay =>
      boolean().withDefault(const Constant(false))();
  IntColumn get batchCookingSession => integer().nullable()();
}
