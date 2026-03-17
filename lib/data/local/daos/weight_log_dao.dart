import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/weight_log_table.dart';

part 'weight_log_dao.g.dart';

@DriftAccessor(tables: [WeightLogs])
class WeightLogDao extends DatabaseAccessor<AppDatabase>
    with _$WeightLogDaoMixin {
  WeightLogDao(super.db);

  /// Watch all logs ordered by date descending.
  Stream<List<WeightLog>> watchAllLogs() {
    return (select(weightLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Watch logs since a specific date.
  Stream<List<WeightLog>> watchLogsSince(int startDate) {
    return (select(weightLogs)
          ..where((t) => t.date.isBiggerOrEqualValue(startDate))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }

  /// Watch the last 7 entries.
  Stream<List<WeightLog>> watchRecentLogs() {
    return (select(weightLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(7))
        .watch();
  }

  /// Get the latest log entry.
  Future<WeightLog?> getLatestLog() {
    return (select(weightLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get the first log entry.
  Future<WeightLog?> getFirstLog() {
    return (select(weightLogs)
          ..orderBy([(t) => OrderingTerm.asc(t.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get a log by ID.
  Future<WeightLog?> getById(int id) {
    return (select(weightLogs)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get a log by date.
  Future<WeightLog?> getByDate(int date) {
    return (select(weightLogs)..where((t) => t.date.equals(date)))
        .getSingleOrNull();
  }

  /// Insert or replace a weight log entry (upsert on unique date).
  Future<void> insertLog(WeightLogsCompanion log) {
    return into(weightLogs).insert(
      log,
      onConflict: DoUpdate(
        (old) => WeightLogsCompanion(
          weightKg: log.weightKg,
          createdAt: log.createdAt,
        ),
        target: [weightLogs.date],
      ),
    );
  }

  /// Delete a weight log entry.
  Future<void> deleteLog(WeightLog log) {
    return delete(weightLogs).delete(log);
  }

  /// Delete all logs (for app reset).
  Future<void> deleteAll() => delete(weightLogs).go();
}
