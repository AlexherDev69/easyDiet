import 'package:drift/drift.dart';

/// Base recipe data with macros and metadata.
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  IntColumn get caloriesPerServing => integer()();
  RealColumn get proteinGrams => real()();
  RealColumn get carbsGrams => real()();
  RealColumn get fatGrams => real()();
  IntColumn get servings => integer()();
  IntColumn get prepTimeMinutes => integer()();
  IntColumn get cookTimeMinutes => integer()();
  BoolColumn get isBatchFriendly => boolean()();
  TextColumn get allergens => text()();
  TextColumn get difficulty => text().withDefault(const Constant('EASY'))();
  TextColumn get dietType => text().withDefault(const Constant('OMNIVORE'))();
  TextColumn get meatTypes => text().withDefault(const Constant('[]'))();
}
