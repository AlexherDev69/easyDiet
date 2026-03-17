import '../../../../data/local/database.dart';

/// Interface for user profile persistence.
abstract class UserProfileRepository {
  Stream<UserProfile?> watchProfile();
  Future<UserProfile?> getProfile();
  Future<void> saveProfile(UserProfilesCompanion profile);
  Future<void> updateWeightAndCalories({
    required double weightKg,
    required int calories,
    required int waterMl,
  });
  Future<void> deleteAll();
}
