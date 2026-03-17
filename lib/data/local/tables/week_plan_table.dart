import 'package:drift/drift.dart';

/// Week container for meal plans.
class WeekPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weekStartDate => integer()();
  IntColumn get createdAt => integer()();
}
