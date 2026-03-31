import 'package:drift/drift.dart';

import '../converters/json_list_converter.dart';

/// Singleton user profile (id=1). Stores preferences, goals, and dietary info.
class UserProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get sex => text()();
  IntColumn get heightCm => integer()();
  RealColumn get weightKg => real()();
  RealColumn get targetWeightKg => real()();
  TextColumn get lossPace => text()();
  TextColumn get activityLevel => text()();
  IntColumn get dietDaysPerWeek => integer()();
  IntColumn get batchCookingSessionsPerWeek => integer()();
  IntColumn get shoppingTripsPerWeek => integer()();
  TextColumn get dietType => text().withDefault(const Constant('OMNIVORE'))();
  IntColumn get distinctBreakfasts => integer().withDefault(const Constant(2))();
  IntColumn get distinctLunches => integer().withDefault(const Constant(3))();
  IntColumn get distinctDinners => integer().withDefault(const Constant(3))();
  IntColumn get distinctSnacks => integer().withDefault(const Constant(2))();
  TextColumn get allergies =>
      text().map(const JsonStringListConverter())();
  TextColumn get customAllergies => text()();
  IntColumn get dailyCalorieTarget => integer()();
  IntColumn get dailyWaterMl => integer().withDefault(const Constant(2000))();
  TextColumn get enabledMealTypes => text()
      .withDefault(
        const Constant('["breakfast","lunch","dinner","snack"]'),
      )
      .map(const JsonStringListConverter())();
  IntColumn get dietStartDate => integer()();
  TextColumn get freeDays => text()
      .withDefault(const Constant('[]'))
      .map(const JsonIntListConverter())();
  BoolColumn get batchCookingBeforeDiet =>
      boolean().withDefault(const Constant(true))();
  TextColumn get excludedMeats => text()
      .withDefault(const Constant('[]'))
      .map(const JsonStringListConverter())();
  BoolColumn get economicMode =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
