import 'package:equatable/equatable.dart';

import '../../../../data/local/models/recipe_with_details.dart';

/// Timer state for a cooking step.
class CookingTimerState extends Equatable {
  const CookingTimerState({
    required this.stepIndex,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
  });

  final int stepIndex;
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;

  @override
  List<Object?> get props => [
        stepIndex,
        totalSeconds,
        remainingSeconds,
        isRunning,
      ];

  CookingTimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
  }) {
    return CookingTimerState(
      stepIndex: stepIndex,
      totalSeconds: totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

/// State for the recipe detail / cooking mode screen.
class RecipeDetailState extends Equatable {
  const RecipeDetailState({
    this.recipe,
    this.servings = 1,
    this.isLoading = true,
    this.activeTimers = const {},
    this.completedSteps = const {},
    this.errorMessage,
  });

  final RecipeWithDetails? recipe;
  final double servings;
  final bool isLoading;
  final Map<int, CookingTimerState> activeTimers;
  final Set<int> completedSteps;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        recipe,
        servings,
        isLoading,
        activeTimers,
        completedSteps,
        errorMessage,
      ];

  RecipeDetailState copyWith({
    RecipeWithDetails? recipe,
    double? servings,
    bool? isLoading,
    Map<int, CookingTimerState>? activeTimers,
    Set<int>? completedSteps,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RecipeDetailState(
      recipe: recipe ?? this.recipe,
      servings: servings ?? this.servings,
      isLoading: isLoading ?? this.isLoading,
      activeTimers: activeTimers ?? this.activeTimers,
      completedSteps: completedSteps ?? this.completedSteps,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
