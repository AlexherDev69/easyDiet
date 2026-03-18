import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/recipe_repository.dart';
import 'recipe_detail_state.dart';

/// Manages recipe detail + cooking timers — port of RecipeDetailViewModel.kt.
class RecipeDetailCubit extends Cubit<RecipeDetailState> {
  RecipeDetailCubit({
    required RecipeRepository recipeRepository,
  })  : _recipeRepository = recipeRepository,
        super(const RecipeDetailState());

  final RecipeRepository _recipeRepository;

  StreamSubscription<dynamic>? _recipeSubscription;
  Timer? _ticker;
  bool _initialLoadDone = false;

  // ── Public actions ──────────────────────────────────────────────────

  void loadRecipe(int recipeId, {double planServings = 0}) {
    if (_initialLoadDone && state.recipe?.recipe.id == recipeId) return;

    _recipeSubscription?.cancel();
    _recipeSubscription =
        _recipeRepository.watchRecipeWithDetails(recipeId).listen((recipe) {
      if (!_initialLoadDone) {
        final defaultServings = planServings > 0
            ? planServings.clamp(0.5, 12.0)
            : (recipe?.recipe.servings.toDouble() ?? 1.0);
        emit(state.copyWith(
          recipe: recipe,
          servings: defaultServings,
          isLoading: false,
        ));
        _initialLoadDone = true;
      } else {
        emit(state.copyWith(recipe: recipe, isLoading: false));
      }
    });
  }

  void increaseServings() {
    emit(state.copyWith(servings: (state.servings + 0.5).clamp(0.5, 12.0)));
  }

  void decreaseServings() {
    emit(state.copyWith(servings: (state.servings - 0.5).clamp(0.5, 12.0)));
  }

  void startTimer(int stepIndex, int seconds) {
    final timers = Map.of(state.activeTimers);
    timers[stepIndex] = CookingTimerState(
      stepIndex: stepIndex,
      totalSeconds: seconds,
      remainingSeconds: seconds,
      isRunning: true,
    );
    emit(state.copyWith(activeTimers: timers));
    _ensureTickerRunning();
  }

  void toggleTimer(int stepIndex) {
    final timers = Map.of(state.activeTimers);
    final timer = timers[stepIndex];
    if (timer == null) return;
    timers[stepIndex] = timer.copyWith(isRunning: !timer.isRunning);
    emit(state.copyWith(activeTimers: timers));
  }

  void dismissTimer(int stepIndex) {
    final timers = Map.of(state.activeTimers);
    timers.remove(stepIndex);
    emit(state.copyWith(activeTimers: timers));
    if (timers.isEmpty) {
      _stopTicker();
    }
  }

  void toggleStepCompleted(int stepIndex) {
    final completed = Set.of(state.completedSteps);
    if (completed.contains(stepIndex)) {
      completed.remove(stepIndex);
    } else {
      completed.add(stepIndex);
    }
    emit(state.copyWith(completedSteps: completed));
  }

  bool get hasRunningTimers =>
      state.activeTimers.values.any((t) => t.remainingSeconds > 0);

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
    _recipeSubscription?.cancel();
    _stopTicker();
    return super.close();
  }
}
