import 'package:drift/drift.dart';

import '../database.dart';
import '../models/day_plan_with_meals.dart';
import '../models/meal_with_recipe.dart';
import '../tables/day_plan_table.dart';
import '../tables/meal_table.dart';
import '../tables/recipe_table.dart';

part 'day_plan_dao.g.dart';

@DriftAccessor(tables: [DayPlans, Meals, Recipes])
class DayPlanDao extends DatabaseAccessor<AppDatabase>
    with _$DayPlanDaoMixin {
  DayPlanDao(super.db);

  /// Watch days for a week plan.
  Stream<List<DayPlanWithMeals>> watchDaysForWeek(int weekPlanId) {
    final query = select(dayPlans)
      ..where((t) => t.weekPlanId.equals(weekPlanId))
      ..orderBy([(t) => OrderingTerm.asc(t.date)]);

    return query.watch().asyncMap((dayList) async {
      final result = <DayPlanWithMeals>[];
      for (final day in dayList) {
        final mealsWithRecipes = await _getMealsWithRecipes(day.id);
        result.add(DayPlanWithMeals(dayPlan: day, meals: mealsWithRecipes));
      }
      return result;
    });
  }

  /// Watch a day plan by date.
  Stream<DayPlanWithMeals?> watchDayPlanByDate(int dateMillis) {
    final query = select(dayPlans)
      ..where((t) => t.date.equals(dateMillis))
      ..limit(1);

    return query.watchSingleOrNull().asyncMap((day) async {
      if (day == null) return null;
      final mealsWithRecipes = await _getMealsWithRecipes(day.id);
      return DayPlanWithMeals(dayPlan: day, meals: mealsWithRecipes);
    });
  }

  /// Insert a day plan and return its ID.
  Future<int> insertDayPlan(DayPlansCompanion dayPlan) {
    return into(dayPlans).insert(dayPlan);
  }

  /// Get day plans from a specific date onward.
  Future<List<DayPlan>> getDayPlansFromDate(int weekPlanId, int fromDate) {
    return (select(dayPlans)
          ..where(
            (t) => t.weekPlanId.equals(weekPlanId) & t.date.isBiggerOrEqualValue(fromDate),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  /// Update a day plan's date and day of week.
  Future<void> updateDayPlanDate(int dayPlanId, int newDate, int newDayOfWeek) {
    return (update(dayPlans)..where((t) => t.id.equals(dayPlanId))).write(
      DayPlansCompanion(
        date: Value(newDate),
        dayOfWeek: Value(newDayOfWeek),
      ),
    );
  }

  /// Update free day and batch cooking session.
  Future<void> updateDayPlanStatus(
    int dayPlanId,
    bool isFreeDay,
    int? batchSession,
  ) {
    return (update(dayPlans)..where((t) => t.id.equals(dayPlanId))).write(
      DayPlansCompanion(
        isFreeDay: Value(isFreeDay),
        batchCookingSession: Value(batchSession),
      ),
    );
  }

  /// Delete a day plan by ID.
  Future<void> deleteById(int dayPlanId) {
    return (delete(dayPlans)..where((t) => t.id.equals(dayPlanId))).go();
  }

  /// Get a day plan with meals by ID.
  Future<DayPlanWithMeals?> getDayPlanWithMealsById(int dayPlanId) async {
    final day = await (select(dayPlans)
          ..where((t) => t.id.equals(dayPlanId)))
        .getSingleOrNull();
    if (day == null) return null;
    final mealsWithRecipes = await _getMealsWithRecipes(day.id);
    return DayPlanWithMeals(dayPlan: day, meals: mealsWithRecipes);
  }

  /// Delete all days for a week plan.
  Future<void> deleteByWeekPlan(int weekPlanId) {
    return (delete(dayPlans)..where((t) => t.weekPlanId.equals(weekPlanId)))
        .go();
  }

  /// Get the max date in a week plan.
  Future<int?> getMaxDate(int weekPlanId) async {
    final maxDate = dayPlans.date.max();
    final query = selectOnly(dayPlans)
      ..addColumns([maxDate])
      ..where(dayPlans.weekPlanId.equals(weekPlanId));
    final result = await query.getSingle();
    return result.read(maxDate);
  }

  Future<List<MealWithRecipe>> _getMealsWithRecipes(int dayPlanId) async {
    final mealRows = await (select(meals)
          ..where((t) => t.dayPlanId.equals(dayPlanId)))
        .get();

    final result = <MealWithRecipe>[];
    for (final meal in mealRows) {
      final recipe = await (select(recipes)
            ..where((t) => t.id.equals(meal.recipeId)))
          .getSingleOrNull();
      if (recipe == null) continue;
      result.add(MealWithRecipe(meal: meal, recipe: recipe));
    }
    return result;
  }
}
