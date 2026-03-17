import 'package:drift/drift.dart';

import '../database.dart';
import '../models/day_plan_with_meals.dart';
import '../models/meal_with_recipe.dart';
import '../models/week_plan_with_days.dart';
import '../tables/day_plan_table.dart';
import '../tables/meal_table.dart';
import '../tables/recipe_table.dart';
import '../tables/week_plan_table.dart';

part 'week_plan_dao.g.dart';

@DriftAccessor(tables: [WeekPlans, DayPlans, Meals, Recipes])
class WeekPlanDao extends DatabaseAccessor<AppDatabase>
    with _$WeekPlanDaoMixin {
  WeekPlanDao(super.db);

  /// Watch the latest week plan with all nested data.
  /// Listens to changes on weekPlans, dayPlans AND meals tables
  /// so that toggling a meal's consumed status triggers a refresh.
  Stream<WeekPlanWithDays?> watchCurrentWeekPlan() async* {
    // Emit initial value immediately.
    yield await getCurrentWeekPlan();

    // Then re-emit whenever any of the 3 related tables change.
    yield* db
        .tableUpdates(
          TableUpdateQuery.onAllTables([weekPlans, dayPlans, meals]),
        )
        .asyncMap((_) => getCurrentWeekPlan());
  }

  /// Get the latest week plan with all nested data (one-shot).
  Future<WeekPlanWithDays?> getCurrentWeekPlan() async {
    final wp = await (select(weekPlans)
          ..orderBy([(t) => OrderingTerm.desc(t.weekStartDate)])
          ..limit(1))
        .getSingleOrNull();
    if (wp == null) return null;
    return _buildWeekPlanWithDays(wp);
  }

  /// Insert a week plan and return its ID.
  Future<int> insertWeekPlan(WeekPlansCompanion plan) {
    return into(weekPlans).insert(plan);
  }

  /// Delete all week plans (cascade deletes days + meals).
  Future<void> deleteAll() => delete(weekPlans).go();

  Future<WeekPlanWithDays> _buildWeekPlanWithDays(WeekPlan wp) async {
    final dayList = await (select(dayPlans)
          ..where((t) => t.weekPlanId.equals(wp.id))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    final daysWithMeals = <DayPlanWithMeals>[];
    for (final day in dayList) {
      final mealRows = await (select(meals)
            ..where((t) => t.dayPlanId.equals(day.id)))
          .get();

      final mealsWithRecipes = <MealWithRecipe>[];
      for (final meal in mealRows) {
        final recipe = await (select(recipes)
              ..where((t) => t.id.equals(meal.recipeId)))
            .getSingle();
        mealsWithRecipes.add(MealWithRecipe(meal: meal, recipe: recipe));
      }

      daysWithMeals.add(
        DayPlanWithMeals(dayPlan: day, meals: mealsWithRecipes),
      );
    }

    return WeekPlanWithDays(weekPlan: wp, days: daysWithMeals);
  }
}
