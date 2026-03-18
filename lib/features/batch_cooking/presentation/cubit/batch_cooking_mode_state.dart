import 'package:equatable/equatable.dart';

import '../../domain/usecases/batch_step_optimizer.dart';

/// Timer state for batch cooking mode.
class BatchTimerState extends Equatable {
  const BatchTimerState({
    required this.timerKey,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    required this.recipeName,
  });

  final String timerKey;
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final String recipeName;

  @override
  List<Object?> get props => [
        timerKey,
        totalSeconds,
        remainingSeconds,
        isRunning,
        recipeName,
      ];

  BatchTimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
  }) {
    return BatchTimerState(
      timerKey: timerKey,
      totalSeconds: totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      recipeName: recipeName,
    );
  }
}

/// State for the batch cooking mode screen.
class BatchCookingModeState extends Equatable {
  const BatchCookingModeState({
    this.pages = const [],
    this.currentPageIndex = 0,
    this.activeTimers = const {},
    this.completedSteps = const {},
    this.isLoading = true,
    this.sessionNumber = 1,
  });

  final List<BatchPage> pages;
  final int currentPageIndex;
  final Map<String, BatchTimerState> activeTimers;
  final Set<String> completedSteps;
  final bool isLoading;
  final int sessionNumber;

  @override
  List<Object?> get props => [
        pages,
        currentPageIndex,
        activeTimers,
        completedSteps,
        isLoading,
        sessionNumber,
      ];

  BatchCookingModeState copyWith({
    List<BatchPage>? pages,
    int? currentPageIndex,
    Map<String, BatchTimerState>? activeTimers,
    Set<String>? completedSteps,
    bool? isLoading,
    int? sessionNumber,
  }) {
    return BatchCookingModeState(
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      activeTimers: activeTimers ?? this.activeTimers,
      completedSteps: completedSteps ?? this.completedSteps,
      isLoading: isLoading ?? this.isLoading,
      sessionNumber: sessionNumber ?? this.sessionNumber,
    );
  }
}
