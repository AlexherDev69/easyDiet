import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/user_profile_table.dart';

part 'user_profile_dao.g.dart';

@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  /// Watch the singleton profile (id=1).
  Stream<UserProfile?> watchProfile() {
    return (select(userProfiles)..where((t) => t.id.equals(1)))
        .watchSingleOrNull();
  }

  /// Get profile once.
  Future<UserProfile?> getProfile() {
    return (select(userProfiles)..where((t) => t.id.equals(1)))
        .getSingleOrNull();
  }

  /// Insert or update the profile (singleton id=1).
  Future<void> insertOrUpdate(UserProfilesCompanion profile) async {
    final existing = await getProfile();
    final withId = profile.copyWith(id: const Value(1));
    if (existing == null) {
      await into(userProfiles).insert(withId);
    } else {
      await (update(userProfiles)..where((t) => t.id.equals(1)))
          .write(withId);
    }
  }

  /// Update weight and recalculated calories.
  Future<void> updateWeightAndCalories({
    required double weightKg,
    required int calories,
    required int waterMl,
  }) {
    return (update(userProfiles)..where((t) => t.id.equals(1))).write(
      UserProfilesCompanion(
        weightKg: Value(weightKg),
        dailyCalorieTarget: Value(calories),
        dailyWaterMl: Value(waterMl),
      ),
    );
  }

  /// Delete all profiles (for app reset).
  Future<void> deleteAll() => delete(userProfiles).go();
}
