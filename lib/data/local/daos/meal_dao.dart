import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/meal_table.dart';

part 'meal_dao.g.dart';

@DriftAccessor(tables: [Meals])
class MealDao extends DatabaseAccessor<AppDatabase> with _$MealDaoMixin {
  MealDao(super.db);

  /// Insert a meal and return its ID.
  Future<int> insertMeal(MealsCompanion meal) {
    return into(meals).insert(meal);
  }

  /// Insert multiple meals.
  Future<void> insertAll(List<MealsCompanion> items) {
    return batch((b) => b.insertAll(meals, items));
  }

  /// Update a meal.
  Future<void> updateMeal(Meal meal) {
    return update(meals).replace(meal);
  }

  /// Update multiple meals in a single batch.
  Future<void> updateAll(List<Meal> items) {
    return batch((b) {
      for (final meal in items) {
        b.replace(meals, meal);
      }
    });
  }

  /// Get meals for a day plan.
  Future<List<Meal>> getMealsForDay(int dayPlanId) {
    return (select(meals)..where((t) => t.dayPlanId.equals(dayPlanId))).get();
  }

  /// Get a meal by ID.
  Future<Meal?> getMealById(int mealId) {
    return (select(meals)..where((t) => t.id.equals(mealId))).getSingleOrNull();
  }

  /// Delete all meals for a day plan.
  Future<void> deleteByDayPlan(int dayPlanId) {
    return (delete(meals)..where((t) => t.dayPlanId.equals(dayPlanId))).go();
  }

  /// Update consumed status.
  Future<void> updateConsumed(int mealId, bool consumed) {
    return (update(meals)..where((t) => t.id.equals(mealId))).write(
      MealsCompanion(isConsumed: Value(consumed)),
    );
  }

  /// Reassign all meals from one day plan to another.
  Future<void> reassignMeals(int fromDayPlanId, int toDayPlanId) {
    return (update(meals)..where((t) => t.dayPlanId.equals(fromDayPlanId)))
        .write(MealsCompanion(dayPlanId: Value(toDayPlanId)));
  }

  /// Run a callback inside a database transaction.
  Future<T> runInTransaction<T>(Future<T> Function() action) {
    return attachedDatabase.transaction(action);
  }
}
