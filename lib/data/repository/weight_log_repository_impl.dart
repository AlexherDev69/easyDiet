import '../local/database.dart';
import '../local/daos/weight_log_dao.dart';
import '../../features/weight_log/domain/repositories/weight_log_repository.dart';

class WeightLogRepositoryImpl implements WeightLogRepository {
  WeightLogRepositoryImpl(this._dao);

  final WeightLogDao _dao;

  @override
  Stream<List<WeightLog>> watchAllLogs() => _dao.watchAllLogs();

  @override
  Stream<List<WeightLog>> watchLogsSince(int startDate) =>
      _dao.watchLogsSince(startDate);

  @override
  Stream<List<WeightLog>> watchRecentLogs() => _dao.watchRecentLogs();

  @override
  Future<WeightLog?> getLatestLog() => _dao.getLatestLog();

  @override
  Future<WeightLog?> getFirstLog() => _dao.getFirstLog();

  @override
  Future<void> insertLog(WeightLogsCompanion log) => _dao.insertLog(log);

  @override
  Future<WeightLog?> getLogByDate(int date) => _dao.getByDate(date);

  @override
  Future<void> deleteLog(WeightLog log) => _dao.deleteLog(log);

  @override
  Future<void> deleteAll() => _dao.deleteAll();
}
