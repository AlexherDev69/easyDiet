import '../local/database.dart';
import '../local/daos/user_profile_dao.dart';
import '../../features/settings/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this._dao);

  final UserProfileDao _dao;

  @override
  Stream<UserProfile?> watchProfile() => _dao.watchProfile();

  @override
  Future<UserProfile?> getProfile() => _dao.getProfile();

  @override
  Future<void> saveProfile(UserProfilesCompanion profile) =>
      _dao.insertOrUpdate(profile);

  @override
  Future<void> updateWeightAndCalories({
    required double weightKg,
    required int calories,
    required int waterMl,
  }) =>
      _dao.updateWeightAndCalories(
        weightKg: weightKg,
        calories: calories,
        waterMl: waterMl,
      );

  @override
  Future<void> deleteAll() => _dao.deleteAll();
}
