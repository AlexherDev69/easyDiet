import 'package:get_it/get_it.dart';

import '../../data/local/database.dart';
import '../../data/local/daos/day_plan_dao.dart';
import '../../data/local/daos/meal_dao.dart';
import '../../data/local/daos/recipe_dao.dart';
import '../../data/local/daos/shopping_item_dao.dart';
import '../../data/local/daos/user_profile_dao.dart';
import '../../data/local/daos/week_plan_dao.dart';
import '../../data/local/daos/weight_log_dao.dart';
import '../../data/local/seeder/database_seeder.dart';
import '../../data/repository/meal_plan_repository_impl.dart';
import '../../data/repository/recipe_repository_impl.dart';
import '../../data/repository/shopping_repository_impl.dart';
import '../../data/repository/user_profile_repository_impl.dart';
import '../../data/repository/weight_log_repository_impl.dart';
import '../../features/meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../features/recipes/domain/repositories/recipe_repository.dart';
import '../../features/settings/domain/repositories/user_profile_repository.dart';
import '../../features/shopping/domain/repositories/shopping_repository.dart';
import '../../features/batch_cooking/domain/usecases/batch_step_optimizer.dart';
import '../../features/meal_plan/domain/usecases/meal_plan_generator.dart';
import '../../features/onboarding/domain/usecases/calorie_calculator.dart';
import '../../features/shopping/domain/usecases/shopping_list_generator.dart';
import '../../features/weight_log/domain/repositories/weight_log_repository.dart';
import '../../features/weight_log/domain/usecases/weight_projection_calculator.dart';

final getIt = GetIt.instance;

/// Registers all dependencies. Call once at app startup.
Future<void> configureDependencies() async {
  // ── Database ────────────────────────────────────────────────────────
  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);

  // ── DAOs ────────────────────────────────────────────────────────────
  getIt.registerSingleton<UserProfileDao>(UserProfileDao(db));
  getIt.registerSingleton<RecipeDao>(RecipeDao(db));
  getIt.registerSingleton<WeekPlanDao>(WeekPlanDao(db));
  getIt.registerSingleton<DayPlanDao>(DayPlanDao(db));
  getIt.registerSingleton<MealDao>(MealDao(db));
  getIt.registerSingleton<ShoppingItemDao>(ShoppingItemDao(db));
  getIt.registerSingleton<WeightLogDao>(WeightLogDao(db));

  // ── Seeder ──────────────────────────────────────────────────────────
  getIt.registerSingleton<DatabaseSeeder>(
    DatabaseSeeder(getIt<RecipeDao>()),
  );

  // ── Repositories ────────────────────────────────────────────────────
  getIt.registerSingleton<UserProfileRepository>(
    UserProfileRepositoryImpl(getIt<UserProfileDao>()),
  );
  getIt.registerSingleton<RecipeRepository>(
    RecipeRepositoryImpl(getIt<RecipeDao>()),
  );
  getIt.registerSingleton<MealPlanRepository>(
    MealPlanRepositoryImpl(
      getIt<WeekPlanDao>(),
      getIt<DayPlanDao>(),
      getIt<MealDao>(),
    ),
  );
  getIt.registerSingleton<ShoppingRepository>(
    ShoppingRepositoryImpl(getIt<ShoppingItemDao>()),
  );
  getIt.registerSingleton<WeightLogRepository>(
    WeightLogRepositoryImpl(getIt<WeightLogDao>()),
  );

  // ── Use Cases ──────────────────────────────────────────────────────
  getIt.registerSingleton<CalorieCalculator>(const CalorieCalculator());
  getIt.registerSingleton<MealPlanGenerator>(
    MealPlanGenerator(
      getIt<MealPlanRepository>(),
      getIt<RecipeRepository>(),
    ),
  );
  getIt.registerSingleton<ShoppingListGenerator>(
    ShoppingListGenerator(
      getIt<RecipeRepository>(),
      getIt<ShoppingRepository>(),
    ),
  );
  getIt.registerSingleton<BatchStepOptimizer>(const BatchStepOptimizer());
  getIt.registerSingleton<WeightProjectionCalculator>(
    const WeightProjectionCalculator(),
  );

  // ── Seed recipes if empty ───────────────────────────────────────────
  final recipeCount = await getIt<RecipeDao>().getRecipeCount();
  if (recipeCount == 0) {
    await getIt<DatabaseSeeder>().seedRecipes();
  }
}
