import '../../../../data/local/database.dart';

/// Interface for weight log persistence.
abstract class WeightLogRepository {
  Stream<List<WeightLog>> watchAllLogs();
  Stream<List<WeightLog>> watchLogsSince(int startDate);
  Stream<List<WeightLog>> watchRecentLogs();
  Future<WeightLog?> getLatestLog();
  Future<WeightLog?> getFirstLog();
  Future<void> insertLog(WeightLogsCompanion log);
  Future<WeightLog?> getLogByDate(int date);
  Future<void> deleteLog(WeightLog log);
  Future<void> deleteAll();
}
