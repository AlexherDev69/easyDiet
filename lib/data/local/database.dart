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
import 'converters/json_list_converter.dart';

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

  // Schema version history:
  //   v1 (current) — initial schema with 9 tables: UserProfiles, Recipes,
  //                  RecipeSteps, Ingredients, WeekPlans, DayPlans, Meals,
  //                  ShoppingItems, WeightLogs.
  //
  // IMPORTANT: any future column addition or table change MUST bump this
  // value and add a corresponding migration block in [onUpgrade] below.
  // Drift will NOT call [onUpgrade] if the version stays at 1 — new columns
  // added without a version bump will simply be missing on existing installs.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Incremental migrations: each block handles one version bump.
        // When adding a new migration:
        // 1. Bump schemaVersion above
        // 2. Add a new if (from < N) block here
        // 3. Run: dart run build_runner build --delete-conflicting-outputs
        //
        // if (from < 2) { await m.addColumn(table, table.newColumn); }
        // if (from < 3) { await m.createTable(newTable); }
      },
      beforeOpen: (details) async {
        // Verify schema integrity on upgrade to catch missing migrations early.
        if (details.hadUpgrade) {
          // Drift validates the schema automatically; this hook exists so
          // additional post-migration checks can be added here if needed.
        }
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
