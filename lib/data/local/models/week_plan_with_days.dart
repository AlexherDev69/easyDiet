import '../database.dart';
import 'day_plan_with_meals.dart';

/// A week plan joined with all its days (each including meals + recipes).
class WeekPlanWithDays {
  const WeekPlanWithDays({
    required this.weekPlan,
    required this.days,
  });

  final WeekPlan weekPlan;
  final List<DayPlanWithMeals> days;
}
