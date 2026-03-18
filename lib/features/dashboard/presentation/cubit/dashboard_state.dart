import 'package:equatable/equatable.dart';

import '../../../../data/local/database.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../domain/models/dashboard_models.dart';

/// Dashboard UI state — mirrors DashboardUiState from Kotlin.
class DashboardState extends Equatable {
  const DashboardState({
    this.userName = '',
    this.todayMeals,
    this.todayCalories = 0,
    this.todayProtein = 0,
    this.todayCarbs = 0,
    this.todayFat = 0,
    this.dailyTarget = 0,
    this.currentWeight = 0,
    this.targetWeight = 0,
    this.initialWeight = 0,
    this.totalLost = 0,
    this.kgRemaining = 0,
    this.estimatedGoalDate,
    this.dailyWaterMl = 0,
    this.nextMeal,
    this.nextBatchCooking,
    this.weekSchedule = const [],
    this.recentWeightLogs = const [],
    this.isLoading = true,
    this.isPlanExpired = false,
    this.selectedDayIndex = -1,
    this.selectedDayMeals = const [],
    this.selectedDayIsFreeDay = false,
  });

  final String userName;
  final DayPlanWithMeals? todayMeals;
  final int todayCalories;
  final double todayProtein;
  final double todayCarbs;
  final double todayFat;
  final int dailyTarget;
  final double currentWeight;
  final double targetWeight;
  final double initialWeight;
  final double totalLost;
  final double kgRemaining;
  final DateTime? estimatedGoalDate;
  final int dailyWaterMl;
  final NextMealInfo? nextMeal;
  final NextBatchCookingInfo? nextBatchCooking;
  final List<DayScheduleItem> weekSchedule;
  final List<WeightLog> recentWeightLogs;
  final bool isLoading;
  final bool isPlanExpired;
  final int selectedDayIndex;
  final List<MealWithRecipe> selectedDayMeals;
  final bool selectedDayIsFreeDay;

  @override
  List<Object?> get props => [
        userName,
        todayMeals,
        todayCalories,
        todayProtein,
        todayCarbs,
        todayFat,
        dailyTarget,
        currentWeight,
        targetWeight,
        initialWeight,
        totalLost,
        kgRemaining,
        estimatedGoalDate,
        dailyWaterMl,
        nextMeal,
        nextBatchCooking,
        weekSchedule,
        recentWeightLogs,
        isLoading,
        isPlanExpired,
        selectedDayIndex,
        selectedDayMeals,
        selectedDayIsFreeDay,
      ];

  DashboardState copyWith({
    String? userName,
    DayPlanWithMeals? todayMeals,
    bool clearTodayMeals = false,
    int? todayCalories,
    double? todayProtein,
    double? todayCarbs,
    double? todayFat,
    int? dailyTarget,
    double? currentWeight,
    double? targetWeight,
    double? initialWeight,
    double? totalLost,
    double? kgRemaining,
    DateTime? estimatedGoalDate,
    bool clearEstimatedGoalDate = false,
    int? dailyWaterMl,
    NextMealInfo? nextMeal,
    bool clearNextMeal = false,
    NextBatchCookingInfo? nextBatchCooking,
    bool clearNextBatchCooking = false,
    List<DayScheduleItem>? weekSchedule,
    List<WeightLog>? recentWeightLogs,
    bool? isLoading,
    bool? isPlanExpired,
    int? selectedDayIndex,
    List<MealWithRecipe>? selectedDayMeals,
    bool? selectedDayIsFreeDay,
  }) {
    return DashboardState(
      userName: userName ?? this.userName,
      todayMeals:
          clearTodayMeals ? null : (todayMeals ?? this.todayMeals),
      todayCalories: todayCalories ?? this.todayCalories,
      todayProtein: todayProtein ?? this.todayProtein,
      todayCarbs: todayCarbs ?? this.todayCarbs,
      todayFat: todayFat ?? this.todayFat,
      dailyTarget: dailyTarget ?? this.dailyTarget,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      initialWeight: initialWeight ?? this.initialWeight,
      totalLost: totalLost ?? this.totalLost,
      kgRemaining: kgRemaining ?? this.kgRemaining,
      estimatedGoalDate: clearEstimatedGoalDate
          ? null
          : (estimatedGoalDate ?? this.estimatedGoalDate),
      dailyWaterMl: dailyWaterMl ?? this.dailyWaterMl,
      nextMeal: clearNextMeal ? null : (nextMeal ?? this.nextMeal),
      nextBatchCooking: clearNextBatchCooking
          ? null
          : (nextBatchCooking ?? this.nextBatchCooking),
      weekSchedule: weekSchedule ?? this.weekSchedule,
      recentWeightLogs: recentWeightLogs ?? this.recentWeightLogs,
      isLoading: isLoading ?? this.isLoading,
      isPlanExpired: isPlanExpired ?? this.isPlanExpired,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      selectedDayMeals: selectedDayMeals ?? this.selectedDayMeals,
      selectedDayIsFreeDay: selectedDayIsFreeDay ?? this.selectedDayIsFreeDay,
    );
  }
}
