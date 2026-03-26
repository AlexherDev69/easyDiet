import 'package:drift/drift.dart';

/// Week container for meal plans.
class WeekPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weekStartDate => integer().unique()();
  IntColumn get createdAt => integer()();
}
