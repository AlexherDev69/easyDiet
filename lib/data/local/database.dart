import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/day_plan_dao.dart';
import 'daos/meal_dao.dart';
import 'daos/recipe_dao.dart';
import 'daos/shopping_item_dao.dart';
import 'daos/user_profile_dao.dart';
import 'daos/week_plan_dao.dart';
import 'daos/weight_log_dao.dart';
import 'tables/day_plan_table.dart';
import 'tables/ingredient_table.dart';
import 'tables/meal_table.dart';
import 'tables/recipe_step_table.dart';
import 'tables/recipe_table.dart';
import 'tables/shopping_item_table.dart';
import 'tables/user_profile_table.dart';
import 'tables/week_plan_table.dart';
import 'tables/weight_log_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    Recipes,
    RecipeSteps,
    Ingredients,
    WeekPlans,
    DayPlans,
    Meals,
    ShoppingItems,
    WeightLogs,
  ],
  daos: [
    UserProfileDao,
    RecipeDao,
    WeekPlanDao,
    DayPlanDao,
    MealDao,
    ShoppingItemDao,
    WeightLogDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing with an in-memory database.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // For future schema changes, add migration steps here:
        // if (from < 2) { await m.addColumn(...); }
        await m.createAll();
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'easydiet.sqlite'));
    return NativeDatabase.createInBackground(file, setup: (db) {
      db.execute('PRAGMA foreign_keys = ON;');
    });
  });
}
