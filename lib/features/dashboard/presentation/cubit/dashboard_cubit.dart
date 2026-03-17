import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../../meal_plan/domain/repositories/meal_plan_repository.dart';
import '../../../onboarding/domain/models/loss_pace.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../../../settings/domain/repositories/user_profile_repository.dart';
import '../../../weight_log/domain/repositories/weight_log_repository.dart';
import '../../../weight_log/domain/usecases/weight_projection_calculator.dart';
import '../../domain/models/dashboard_models.dart';
import 'dashboard_state.dart';

/// Manages the dashboard screen — port of DashboardViewModel.kt.
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required UserProfileRepository userProfileRepository,
    required MealPlanRepository mealPlanRepository,
    required WeightLogRepository weightLogRepository,
    required WeightProjectionCalculator weightProjectionCalculator,
  })  : _userProfileRepository = userProfileRepository,
        _mealPlanRepository = mealPlanRepository,
        _weightLogRepository = weightLogRepository,
        _weightProjectionCalculator = weightProjectionCalculator,
        super(const DashboardState()) {
    _loadDashboard();
  }

  final UserProfileRepository _userProfileRepository;
  final MealPlanRepository _mealPlanRepository;
  final WeightLogRepository _weightLogRepository;
  final WeightProjectionCalculator _weightProjectionCalculator;

  WeekPlanWithDays? _cachedWeekPlan;
  StreamSubscription<WeekPlanWithDays?>? _planSubscription;
  StreamSubscription<dynamic>? _weightSubscription;

  // ── Public actions ──────────────────────────────────────────────────

  void selectDay(int index) {
    emit(state.copyWith(selectedDayIndex: index));
    _refreshSelectedDay();
  }

  Future<void> toggleMealConsumed(int mealId, bool currentlyConsumed) async {
    await _mealPlanRepository.toggleMealConsumed(mealId, !currentlyConsumed);
  }

  Future<void> shiftByOneDay() async {
    await _mealPlanRepository.shiftProgramByOneDay();
  }

  // ── Private loading ─────────────────────────────────────────────────

  Future<void> _loadDashboard() async {
    // Load profile + weight data
    final profile = await _userProfileRepository.getProfile();
    if (profile == null) return;

    final latestWeight = await _weightLogRepository.getLatestLog();
    final firstLog = await _weightLogRepository.getFirstLog();
    final currentWeight = latestWeight?.weightKg ?? profile.weightKg;
    final initialWeight = firstLog?.weightKg ?? profile.weightKg;

    final lossPace = LossPace.values.firstWhere(
      (p) => p.name == profile.lossPace,
      orElse: () => LossPace.moderate,
    );
    final goalDate = _weightProjectionCalculator.calculateEstimatedGoalDate(
      currentWeight: currentWeight,
      targetWeight: profile.targetWeightKg,
      lossPace: lossPace,
      dietDaysPerWeek: profile.dietDaysPerWeek,
    );

    final planExpired = await _mealPlanRepository.isCurrentPlanExpired();

    emit(state.copyWith(
      userName: profile.name,
      dailyTarget: profile.dailyCalorieTarget,
      dailyWaterMl: profile.dailyWaterMl,
      currentWeight: currentWeight,
      targetWeight: profile.targetWeightKg,
      initialWeight: initialWeight,
      totalLost: initialWeight - currentWeight,
      kgRemaining: (currentWeight - profile.targetWeightKg)
          .clamp(0, double.infinity),
      estimatedGoalDate: goalDate,
      isPlanExpired: planExpired,
      isLoading: false,
    ));

    // Watch the week plan stream
    _planSubscription =
        _mealPlanRepository.watchCurrentWeekPlan().listen(_onWeekPlanUpdate);

    // Watch recent weight logs
    _weightSubscription =
        _weightLogRepository.watchRecentLogs().listen((logs) {
      final sorted = List.of(logs)..sort((a, b) => a.date.compareTo(b.date));
      emit(state.copyWith(recentWeightLogs: sorted));
    });
  }

  void _onWeekPlanUpdate(WeekPlanWithDays? weekPlan) {
    if (weekPlan == null) return;

    _cachedWeekPlan = weekPlan;
    final today = AppDateUtils.today();
    final weekSchedule = _computeWeekSchedule(weekPlan, today);

    // Auto-select today if no day selected yet
    final currentIndex = state.selectedDayIndex;
    final todayIndex = weekSchedule.isEmpty
        ? 0
        : currentIndex == -1
            ? weekSchedule.indexWhere((d) => d.isToday).clamp(0, weekSchedule.length - 1)
            : currentIndex.clamp(0, weekSchedule.length - 1);

    final selectedDay = todayIndex < weekSchedule.length
        ? weekSchedule[todayIndex]
        : null;
    final selectedMeals = selectedDay?.meals ?? [];
    final consumedMeals = selectedMeals.where((m) => m.meal.isConsumed);

    final calories = consumedMeals.fold<int>(
      0,
      (sum, m) =>
          sum + (m.recipe.caloriesPerServing * m.meal.servings).round(),
    );
    final protein = consumedMeals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.proteinGrams * m.meal.servings,
    );
    final carbs = consumedMeals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.carbsGrams * m.meal.servings,
    );
    final fat = consumedMeals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.fatGrams * m.meal.servings,
    );

    // Find today's plan for next meal computation
    final todayMillis = AppDateUtils.todayMillis();
    final todayPlan = weekPlan.days
        .where((d) => d.dayPlan.date == todayMillis)
        .firstOrNull;

    // Find selected day plan for todayMeals
    final selectedDate = selectedDay?.date;
    final selectedDayPlan = selectedDate != null
        ? weekPlan.days
            .where((d) =>
                d.dayPlan.date ==
                AppDateUtils.toEpochMillis(selectedDate))
            .firstOrNull
        : null;

    emit(state.copyWith(
      todayMeals: selectedDayPlan,
      todayCalories: calories,
      todayProtein: protein,
      todayCarbs: carbs,
      todayFat: fat,
      nextMeal: _computeNextMeal(todayPlan),
      nextBatchCooking: _computeNextBatchCooking(weekPlan, today),
      weekSchedule: weekSchedule,
      selectedDayIndex: todayIndex,
      selectedDayMeals: selectedMeals,
      selectedDayIsFreeDay: selectedDay?.isFreeDay ?? false,
    ));
  }

  void _refreshSelectedDay() {
    final weekPlan = _cachedWeekPlan;
    if (weekPlan == null) return;

    final index = state.selectedDayIndex;
    final schedule = state.weekSchedule;
    if (index < 0 || index >= schedule.length) return;

    final scheduleDay = schedule[index];
    final selectedMeals = scheduleDay.meals;
    final consumedMeals = selectedMeals.where((m) => m.meal.isConsumed);

    final calories = consumedMeals.fold<int>(
      0,
      (sum, m) =>
          sum + (m.recipe.caloriesPerServing * m.meal.servings).round(),
    );
    final protein = consumedMeals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.proteinGrams * m.meal.servings,
    );
    final carbs = consumedMeals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.carbsGrams * m.meal.servings,
    );
    final fat = consumedMeals.fold<double>(
      0,
      (sum, m) => sum + m.recipe.fatGrams * m.meal.servings,
    );

    final selectedDate = scheduleDay.date;
    final selectedDayPlan = weekPlan.days
        .where((d) =>
            d.dayPlan.date == AppDateUtils.toEpochMillis(selectedDate))
        .firstOrNull;

    emit(state.copyWith(
      todayMeals: selectedDayPlan,
      todayCalories: calories,
      todayProtein: protein,
      todayCarbs: carbs,
      todayFat: fat,
      selectedDayMeals: selectedMeals,
      selectedDayIsFreeDay: scheduleDay.isFreeDay,
    ));
  }

  // ── Computed helpers ────────────────────────────────────────────────

  NextMealInfo? _computeNextMeal(DayPlanWithMeals? todayPlan) {
    if (todayPlan == null || todayPlan.dayPlan.isFreeDay) return null;

    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final currentMinutes = hour * 60 + minute;

    const mealOrder = [
      MealType.breakfast,
      MealType.lunch,
      MealType.snack,
      MealType.dinner,
    ];
    const mealThresholds = {
      MealType.breakfast: 10 * 60, // 10:00
      MealType.lunch: 14 * 60, // 14:00
      MealType.snack: 17 * 60, // 17:00
      MealType.dinner: 22 * 60, // 22:00
    };

    for (final type in mealOrder) {
      final threshold = mealThresholds[type]!;
      if (currentMinutes < threshold) {
        final meal = todayPlan.meals
            .where(
                (m) => !m.meal.isConsumed && m.meal.mealType == type.name.toUpperCase())
            .firstOrNull;
        if (meal != null) {
          return NextMealInfo(
            mealType: type,
            recipeName: meal.recipe.name,
            caloriesPerServing: meal.recipe.caloriesPerServing,
            servings: meal.meal.servings,
            prepTimeMinutes:
                meal.recipe.prepTimeMinutes + meal.recipe.cookTimeMinutes,
          );
        }
      }
    }
    return null;
  }

  NextBatchCookingInfo? _computeNextBatchCooking(
    WeekPlanWithDays weekPlan,
    DateTime today,
  ) {
    final todayMillis = AppDateUtils.toEpochMillis(today);
    final nextBatch = weekPlan.days
        .where((d) => d.dayPlan.batchCookingSession != null)
        .where((d) => d.dayPlan.date >= todayMillis)
        .toList()
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));

    if (nextBatch.isEmpty) return null;
    final batch = nextBatch.first;
    final date = AppDateUtils.fromEpochMillis(batch.dayPlan.date);

    return NextBatchCookingInfo(
      dayPlanId: batch.dayPlan.id,
      dayName: AppDateUtils.formatDayName(date),
      date: date,
      sessionNumber: batch.dayPlan.batchCookingSession ?? 1,
      meals: batch.meals,
    );
  }

  List<DayScheduleItem> _computeWeekSchedule(
    WeekPlanWithDays weekPlan,
    DateTime today,
  ) {
    final planDaysByDate = <int, DayPlanWithMeals>{};
    for (final day in weekPlan.days) {
      planDaysByDate[day.dayPlan.date] = day;
    }

    final planDates = planDaysByDate.keys.toList();
    if (planDates.isEmpty) return [];

    final todayMillis = AppDateUtils.toEpochMillis(today);
    final minDate = planDates.reduce((a, b) => a < b ? a : b);
    final maxDate = planDates.reduce((a, b) => a > b ? a : b);

    final rangeStartMillis =
        todayMillis < minDate ? todayMillis : minDate;
    final rangeEndMillis =
        todayMillis > maxDate ? todayMillis : maxDate;

    final rangeStart = AppDateUtils.fromEpochMillis(rangeStartMillis);
    final rangeEnd = AppDateUtils.fromEpochMillis(rangeEndMillis);

    final items = <DayScheduleItem>[];
    var current = rangeStart;
    while (!current.isAfter(rangeEnd)) {
      final millis = AppDateUtils.toEpochMillis(current);
      final planDay = planDaysByDate[millis];
      items.add(DayScheduleItem(
        dayName: AppDateUtils.getDayOfWeekFrench(current.weekday),
        date: current,
        isFreeDay: planDay?.dayPlan.isFreeDay ?? false,
        isToday: millis == todayMillis,
        isBatchCooking: planDay?.dayPlan.batchCookingSession != null,
        meals: planDay?.meals ?? [],
        hasPlan: planDay != null,
      ));
      current = current.add(const Duration(days: 1));
    }
    return items;
  }

  @override
  Future<void> close() {
    _planSubscription?.cancel();
    _weightSubscription?.cancel();
    return super.close();
  }
}
