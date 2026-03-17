import '../../../../data/local/database.dart';
import '../../../../data/local/models/week_plan_with_days.dart';

/// Interface for meal plan management.
abstract class MealPlanRepository {
  Stream<WeekPlanWithDays?> watchCurrentWeekPlan();
  Future<WeekPlanWithDays?> getCurrentWeekPlan();
  Future<int> createWeekPlan(WeekPlansCompanion weekPlan);
  Future<int> createDayPlan(DayPlansCompanion dayPlan);
  Future<void> createMeals(List<MealsCompanion> meals);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteWeekPlans();
  Future<void> swapMealsBetweenDays(int mealId, int targetDayPlanId);
  Future<void> shiftProgramByOneDay();
  Future<void> toggleMealConsumed(int mealId, bool consumed);
  Future<bool> isCurrentPlanExpired();
}
