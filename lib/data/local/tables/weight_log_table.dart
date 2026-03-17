import 'package:drift/drift.dart';

/// Weight tracking — one entry per day.
class WeightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get date => integer().unique()();
  RealColumn get weightKg => real()();
  IntColumn get createdAt => integer()();
}
