import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/local/daos/day_plan_dao.dart';
import '../../../../data/local/models/recipe_with_details.dart';
import '../../../recipes/domain/repositories/recipe_repository.dart';
import '../../domain/usecases/batch_step_optimizer.dart';
import 'batch_cooking_mode_state.dart';

/// Manages batch cooking mode — port of BatchCookingModeViewModel.kt.
class BatchCookingModeCubit extends Cubit<BatchCookingModeState> {
  BatchCookingModeCubit({
    required DayPlanDao dayPlanDao,
    required RecipeRepository recipeRepository,
    required BatchStepOptimizer batchStepOptimizer,
  })  : _dayPlanDao = dayPlanDao,
        _recipeRepository = recipeRepository,
        _batchStepOptimizer = batchStepOptimizer,
        super(const BatchCookingModeState());

  final DayPlanDao _dayPlanDao;
  final RecipeRepository _recipeRepository;
  final BatchStepOptimizer _batchStepOptimizer;
  Timer? _ticker;

  // ── Public actions ──────────────────────────────────────────────────

  Future<void> loadBatchSteps(int dayPlanId) async {
    try {
      final dayPlan = await _dayPlanDao.getDayPlanWithMealsById(dayPlanId);
      if (dayPlan == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final recipePairs = <(BatchRecipeInfo, RecipeWithDetails)>[];
      for (final mealWithRecipe in dayPlan.meals) {
        final details = await _recipeRepository
            .getRecipeWithDetails(mealWithRecipe.recipe.id);
        if (details == null) continue;

        final info = BatchRecipeInfo(
          recipeId: mealWithRecipe.recipe.id,
          recipeName: mealWithRecipe.recipe.name,
          servings: mealWithRecipe.meal.servings,
          servingsMultiplier:
              mealWithRecipe.meal.servings / mealWithRecipe.recipe.servings,
        );
        recipePairs.add((info, details));
      }

      final pages = _batchStepOptimizer.optimizeSteps(recipePairs);

      emit(state.copyWith(
        pages: pages,
        sessionNumber: dayPlan.dayPlan.batchCookingSession ?? 1,
        isLoading: false,
      ));
    } catch (e) {
      debugPrint('Error in loadBatchSteps: $e');
    }
  }

  void nextPage() {
    final nextIndex =
        (state.currentPageIndex + 1).clamp(0, state.pages.length - 1);
    emit(state.copyWith(currentPageIndex: nextIndex));
  }

  void previousPage() {
    final prevIndex = (state.currentPageIndex - 1).clamp(0, state.pages.length - 1);
    emit(state.copyWith(currentPageIndex: prevIndex));
  }

  void toggleStepCompleted(int pageIndex, int recipeId) {
    final key = '$pageIndex-$recipeId';
    final completed = Set.of(state.completedSteps);
    if (completed.contains(key)) {
      completed.remove(key);
    } else {
      completed.add(key);
    }
    emit(state.copyWith(completedSteps: completed));
  }

  void startTimer(int pageIndex, int recipeId, String recipeName) {
    final page = state.pages.elementAtOrNull(pageIndex);
    if (page == null) return;
    final step = page.recipeSteps
        .where((s) => s.recipeId == recipeId)
        .firstOrNull;
    if (step == null) return;
    final timerSeconds = step.timerSeconds;
    if (timerSeconds == null || timerSeconds <= 0) return;

    final key = '$pageIndex-$recipeId';
    final timers = Map.of(state.activeTimers);
    timers[key] = BatchTimerState(
      timerKey: key,
      totalSeconds: timerSeconds,
      remainingSeconds: timerSeconds,
      isRunning: true,
      recipeName: recipeName,
    );
    emit(state.copyWith(activeTimers: timers));
    _ensureTickerRunning();
  }

  void toggleTimer(String timerKey) {
    final timers = Map.of(state.activeTimers);
    final timer = timers[timerKey];
    if (timer == null) return;
    timers[timerKey] = timer.copyWith(isRunning: !timer.isRunning);
    emit(state.copyWith(activeTimers: timers));
  }

  void dismissTimer(String timerKey) {
    final timers = Map.of(state.activeTimers);
    timers.remove(timerKey);
    emit(state.copyWith(activeTimers: timers));
    if (timers.isEmpty) {
      _stopTicker();
    }
  }

  // ── Private ───────────────────────────────────────────────────────

  void _ensureTickerRunning() {
    if (_ticker != null) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final timers = Map.of(state.activeTimers);
      var changed = false;
      var hasRunning = false;
      for (final entry in timers.entries.toList()) {
        final timer = entry.value;
        if (timer.isRunning && timer.remainingSeconds > 0) {
          timers[entry.key] =
              timer.copyWith(remainingSeconds: timer.remainingSeconds - 1);
          changed = true;
          hasRunning = true;
        } else if (timer.isRunning && timer.remainingSeconds > 0) {
          hasRunning = true;
        }
      }
      if (changed) {
        emit(state.copyWith(activeTimers: timers));
      }
      if (!hasRunning) {
        _stopTicker();
      }
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }
}
