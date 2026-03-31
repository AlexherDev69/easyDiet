import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/meal_plan/domain/repositories/meal_plan_repository.dart';
import '../features/meal_plan/domain/usecases/meal_plan_generator.dart';
import '../features/meal_plan/domain/usecases/plan_edit_use_case.dart';
import '../features/meal_plan/presentation/cubit/meal_plan_cubit.dart';
import '../features/meal_plan/presentation/pages/meal_plan_page.dart';
import '../features/onboarding/domain/usecases/calorie_calculator.dart';
import '../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/batch_cooking/domain/usecases/batch_step_optimizer.dart';
import '../features/batch_cooking/presentation/cubit/batch_cooking_cubit.dart';
import '../features/batch_cooking/presentation/cubit/batch_cooking_mode_cubit.dart';
import '../features/batch_cooking/presentation/pages/batch_cooking_mode_page.dart';
import '../features/batch_cooking/presentation/pages/batch_cooking_page.dart';
import '../features/recipes/domain/repositories/recipe_repository.dart';
import '../features/recipes/presentation/cubit/recipe_detail_cubit.dart';
import '../features/recipes/presentation/cubit/recipe_list_cubit.dart';
import '../features/recipes/presentation/pages/cooking_mode_page.dart';
import '../features/recipes/presentation/pages/recipe_detail_page.dart';
import '../features/recipes/presentation/pages/recipe_list_page.dart';
import '../features/settings/domain/repositories/user_profile_repository.dart';
import '../features/shopping/domain/repositories/shopping_repository.dart';
import '../features/shopping/domain/usecases/shopping_list_generator.dart';
import '../features/shopping/presentation/cubit/shopping_cubit.dart';
import '../features/shopping/presentation/pages/shopping_page.dart';
import '../features/weight_log/domain/repositories/weight_log_repository.dart';
import '../features/weight_log/domain/usecases/weight_projection_calculator.dart';
import '../features/weight_log/presentation/cubit/weight_log_cubit.dart';
import '../features/weight_log/presentation/pages/weight_log_page.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/settings/presentation/pages/about_calculations_page.dart';
import '../features/plan_config/presentation/cubit/plan_config_cubit.dart';
import '../features/plan_config/presentation/pages/plan_config_page.dart';
import '../features/plan_preview/presentation/cubit/plan_preview_cubit.dart';
import '../features/plan_preview/presentation/pages/plan_preview_page.dart';
import 'scaffold_with_nav_bar.dart';

/// Route paths as constants.
class AppRoutes {
  AppRoutes._();

  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const mealPlan = '/meal-plan';
  static const shoppingList = '/shopping-list';
  static const recipeList = '/recipes';
  static const weightLog = '/weight-log';
  static const settings = '/settings';
  static const aboutCalculations = '/settings/about-calculations';
  static const planConfig = '/plan-config';
  static const planPreview = '/plan-preview';

  // Parameterized routes
  static String recipeDetail(int id, {double planServings = 0}) =>
      '/recipes/$id?servings=$planServings';
  static String cookingMode(int id, {double planServings = 0}) =>
      '/recipes/$id/cooking?servings=$planServings';
  static String batchCooking(int dayPlanId) =>
      '/batch-cooking/$dayPlanId';
  static String batchCookingMode(int dayPlanId) =>
      '/batch-cooking/$dayPlanId/mode';
}

/// Keys for the navigator shells.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Creates the app router with the given initial location.
GoRouter createAppRouter(String initialLocation) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: initialLocation,
  routes: [
    // ── Onboarding (full screen, no bottom bar) ─────────────────────
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => BlocProvider(
        create: (_) => OnboardingCubit(
          userProfileRepository: getIt<UserProfileRepository>(),
          weightLogRepository: getIt<WeightLogRepository>(),
          calorieCalculator: getIt<CalorieCalculator>(),
          mealPlanGenerator: getIt<MealPlanGenerator>(),
          mealPlanRepository: getIt<MealPlanRepository>(),
          shoppingListGenerator: getIt<ShoppingListGenerator>(),
          planEditUseCase: getIt<PlanEditUseCase>(),
        ),
        child: const OnboardingPage(),
      ),
    ),

    // ── Shell with bottom navigation bar ────────────────────────────
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) =>
          ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 150),
            child: BlocProvider(
              create: (_) => DashboardCubit(
                userProfileRepository: getIt<UserProfileRepository>(),
                mealPlanRepository: getIt<MealPlanRepository>(),
                weightLogRepository: getIt<WeightLogRepository>(),
                weightProjectionCalculator:
                    getIt<WeightProjectionCalculator>(),
              ),
              child: const DashboardPage(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.mealPlan,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 150),
            child: BlocProvider(
              create: (_) => MealPlanCubit(
                mealPlanRepository: getIt<MealPlanRepository>(),
                userProfileRepository: getIt<UserProfileRepository>(),
                recipeRepository: getIt<RecipeRepository>(),
                mealPlanGenerator: getIt<MealPlanGenerator>(),
                shoppingListGenerator: getIt<ShoppingListGenerator>(),
              ),
              child: const MealPlanPage(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.shoppingList,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 150),
            child: BlocProvider(
              create: (_) => ShoppingCubit(
                shoppingRepository: getIt<ShoppingRepository>(),
                mealPlanRepository: getIt<MealPlanRepository>(),
                shoppingListGenerator: getIt<ShoppingListGenerator>(),
                userProfileRepository: getIt<UserProfileRepository>(),
              ),
              child: const ShoppingPage(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.recipeList,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 150),
            child: BlocProvider(
              create: (_) => RecipeListCubit(
                recipeRepository: getIt<RecipeRepository>(),
                mealPlanRepository: getIt<MealPlanRepository>(),
              ),
              child: const RecipeListPage(),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.weightLog,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 150),
            child: BlocProvider(
              create: (_) => WeightLogCubit(
                weightLogRepository: getIt<WeightLogRepository>(),
                userProfileRepository: getIt<UserProfileRepository>(),
                weightProjectionCalculator:
                    getIt<WeightProjectionCalculator>(),
                calorieCalculator: getIt<CalorieCalculator>(),
              ),
              child: const WeightLogPage(),
            ),
          ),
        ),
      ],
    ),

    // ── Detail screens (full screen, no bottom bar) ─────────────────
    GoRoute(
      path: '/recipes/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        final servings = double.tryParse(
                state.uri.queryParameters['servings'] ?? '') ??
            0;
        return BlocProvider(
          create: (_) => RecipeDetailCubit(
            recipeRepository: getIt<RecipeRepository>(),
          ),
          child: RecipeDetailPage(
            recipeId: id,
            planServings: servings,
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'cooking',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            final servings = double.tryParse(
                    state.uri.queryParameters['servings'] ?? '') ??
                0;
            return BlocProvider(
              create: (_) => RecipeDetailCubit(
                recipeRepository: getIt<RecipeRepository>(),
              ),
              child: CookingModePage(
                recipeId: id,
                planServings: servings,
              ),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/batch-cooking/:dayPlanId',
      builder: (context, state) {
        final dayPlanId = int.tryParse(state.pathParameters['dayPlanId'] ?? '');
        if (dayPlanId == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Erreur')),
            body: const Center(child: Text('Route invalide')),
          );
        }
        return BlocProvider(
          create: (_) => BatchCookingCubit(
            mealPlanRepository: getIt<MealPlanRepository>(),
            recipeRepository: getIt<RecipeRepository>(),
          ),
          child: BatchCookingPage(dayPlanId: dayPlanId),
        );
      },
      routes: [
        GoRoute(
          path: 'mode',
          builder: (context, state) {
            final dayPlanId =
                int.tryParse(state.pathParameters['dayPlanId'] ?? '');
            if (dayPlanId == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Erreur')),
            body: const Center(child: Text('Route invalide')),
          );
        }
            return BlocProvider(
              create: (_) => BatchCookingModeCubit(
                mealPlanRepository: getIt<MealPlanRepository>(),
                recipeRepository: getIt<RecipeRepository>(),
                batchStepOptimizer: getIt<BatchStepOptimizer>(),
              ),
              child: BatchCookingModePage(dayPlanId: dayPlanId),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => BlocProvider(
        create: (_) => SettingsCubit(
          userProfileRepository: getIt<UserProfileRepository>(),
          mealPlanRepository: getIt<MealPlanRepository>(),
          weightLogRepository: getIt<WeightLogRepository>(),
          calorieCalculator: getIt<CalorieCalculator>(),
        ),
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.aboutCalculations,
      builder: (context, state) => const AboutCalculationsPage(),
    ),
    GoRoute(
      path: AppRoutes.planConfig,
      builder: (context, state) => BlocProvider(
        create: (_) => PlanConfigCubit(
          userProfileRepository: getIt<UserProfileRepository>(),
        ),
        child: const PlanConfigPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.planPreview,
      builder: (context, state) => BlocProvider(
        create: (_) => PlanPreviewCubit(
          mealPlanRepository: getIt<MealPlanRepository>(),
          mealPlanGenerator: getIt<MealPlanGenerator>(),
          userProfileRepository: getIt<UserProfileRepository>(),
          shoppingListGenerator: getIt<ShoppingListGenerator>(),
          planEditUseCase: getIt<PlanEditUseCase>(),
        ),
        child: const PlanPreviewPage(),
      ),
    ),
  ],
);
