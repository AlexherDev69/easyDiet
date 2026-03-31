import 'package:drift/drift.dart';

import '../local/database.dart';
import '../local/daos/day_plan_dao.dart';
import '../local/daos/meal_dao.dart';
import '../local/daos/week_plan_dao.dart';
import '../local/models/day_plan_with_meals.dart';
import '../local/models/week_plan_with_days.dart';
import '../../core/utils/date_utils.dart';
import '../../features/meal_plan/domain/repositories/meal_plan_repository.dart';

class MealPlanRepositoryImpl implements MealPlanRepository {
  MealPlanRepositoryImpl(
    this._weekPlanDao,
    this._dayPlanDao,
    this._mealDao,
  );

  final WeekPlanDao _weekPlanDao;
  final DayPlanDao _dayPlanDao;
  final MealDao _mealDao;

  @override
  Stream<WeekPlanWithDays?> watchCurrentWeekPlan() =>
      _weekPlanDao.watchCurrentWeekPlan();

  @override
  Future<WeekPlanWithDays?> getCurrentWeekPlan() =>
      _weekPlanDao.getCurrentWeekPlan();

  @override
  Future<int> createWeekPlan(WeekPlansCompanion weekPlan) =>
      _weekPlanDao.insertWeekPlan(weekPlan);

  @override
  Future<int> createDayPlan(DayPlansCompanion dayPlan) =>
      _dayPlanDao.insertDayPlan(dayPlan);

  @override
  Future<void> createMeals(List<MealsCompanion> meals) =>
      _mealDao.insertAll(meals);

  @override
  Future<void> updateMeal(Meal meal) => _mealDao.updateMeal(meal);

  @override
  Future<void> updateMeals(List<Meal> meals) => _mealDao.updateAll(meals);

  @override
  Future<void> deleteWeekPlans() => _weekPlanDao.deleteAll();

  @override
  Future<void> deleteWeekPlanById(int weekPlanId) =>
      _weekPlanDao.deleteById(weekPlanId);

  @override
  Future<void> swapMealsBetweenDays(int mealId, int targetDayPlanId) async {
    await _mealDao.runInTransaction(() async {
      final sourceMeal = await _mealDao.getMealById(mealId);
      if (sourceMeal == null) return;

      final targetMeals = await _mealDao.getMealsForDay(targetDayPlanId);
      final targetMeal = targetMeals
          .where((m) => m.mealType == sourceMeal.mealType)
          .firstOrNull;

      if (targetMeal != null) {
        // Swap recipeId + servings between the two meals
        await _mealDao.updateMeal(sourceMeal.copyWith(
          recipeId: targetMeal.recipeId,
          servings: targetMeal.servings,
        ));
        await _mealDao.updateMeal(targetMeal.copyWith(
          recipeId: sourceMeal.recipeId,
          servings: sourceMeal.servings,
        ));
      } else {
        // Target day has no meal of this type → just move the meal
        await _mealDao.updateMeal(sourceMeal.copyWith(
          dayPlanId: targetDayPlanId,
        ));
      }
    });
  }

  @override
  Future<void> shiftProgramByOneDay() async {
    final weekPlan = await _weekPlanDao.getCurrentWeekPlan();
    if (weekPlan == null) return;

    final todayMillis = AppDateUtils.todayMillis();
    final futureDays = await _dayPlanDao.getDayPlansFromDate(
      weekPlan.weekPlan.id,
      todayMillis,
    );
    if (futureDays.length < 2) return;

    await _mealDao.runInTransaction(() async {
      // Create a new day after the last one to receive its meals.
      final lastDay = futureDays.last;
      final lastDate = DateTime.fromMillisecondsSinceEpoch(lastDay.date);
      final newDate = lastDate.add(const Duration(days: 1));
      final newDayId = await _dayPlanDao.insertDayPlan(
        DayPlansCompanion.insert(
          weekPlanId: weekPlan.weekPlan.id,
          date: AppDateUtils.toEpochMillis(newDate),
          dayOfWeek: newDate.weekday,
          isFreeDay: const Value(false),
        ),
      );

      // Move last day's meals to the new day, copy its status.
      await _mealDao.reassignMeals(lastDay.id, newDayId);
      await _dayPlanDao.updateDayPlanStatus(
        newDayId,
        lastDay.isFreeDay,
        lastDay.batchCookingSession,
      );

      // Move meals forward for the remaining days (end → start).
      for (var i = futureDays.length - 1; i >= 1; i--) {
        await _mealDao.deleteByDayPlan(futureDays[i].id);
        await _mealDao.reassignMeals(futureDays[i - 1].id, futureDays[i].id);
        await _dayPlanDao.updateDayPlanStatus(
          futureDays[i].id,
          futureDays[i - 1].isFreeDay,
          futureDays[i - 1].batchCookingSession,
        );
      }

      // Today becomes a free day (its meals were moved to tomorrow).
      await _dayPlanDao.updateDayPlanStatus(futureDays.first.id, true, null);
    });
  }

  @override
  Future<void> toggleMealConsumed(int mealId, bool consumed) =>
      _mealDao.updateConsumed(mealId, consumed);

  @override
  Future<bool> isCurrentPlanExpired() async {
    final weekPlan = await _weekPlanDao.getCurrentWeekPlan();
    if (weekPlan == null) return false;
    final maxDate = await _dayPlanDao.getMaxDate(weekPlan.weekPlan.id);
    if (maxDate == null) return false;
    return AppDateUtils.todayMillis() > maxDate;
  }

  @override
  Future<DayPlanWithMeals?> getDayPlanWithMealsById(int dayPlanId) =>
      _dayPlanDao.getDayPlanWithMealsById(dayPlanId);
}
