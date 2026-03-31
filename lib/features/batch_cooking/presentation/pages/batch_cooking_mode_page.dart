import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../domain/usecases/batch_step_optimizer.dart';
import '../cubit/batch_cooking_mode_cubit.dart';
import '../cubit/batch_cooking_mode_state.dart';

/// Batch cooking mode screen — port of BatchCookingModeScreen.kt.
class BatchCookingModePage extends StatefulWidget {
  const BatchCookingModePage({
    required this.dayPlanId,
    super.key,
  });

  final int dayPlanId;

  @override
  State<BatchCookingModePage> createState() => _BatchCookingModePageState();
}

class _BatchCookingModePageState extends State<BatchCookingModePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<BatchCookingModeCubit>()
        .loadBatchSteps(widget.dayPlanId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BatchCookingModeCubit, BatchCookingModeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.emeraldPrimary,
              ),
            ),
          );
        }

        if (state.pages.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                'Aucune etape disponible',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          );
        }

        return _BatchCookingModeContent(state: state);
      },
    );
  }
}

class _BatchCookingModeContent extends StatelessWidget {
  const _BatchCookingModeContent({required this.state});

  final BatchCookingModeState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BatchCookingModeCubit>();
    final currentPage = state.pages[state.currentPageIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Batch Cooking - Session ${state.sessionNumber}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
          tooltip: 'Fermer',
        ),
      ),
      body: Column(
        children: [
          // Active timers bar
          if (state.activeTimers.isNotEmpty)
            _ActiveTimersBar(
              timers: state.activeTimers,
              onToggle: cubit.toggleTimer,
              onDismiss: cubit.dismissTimer,
            ),

          // Progress dots + phase badge
          _ProgressSection(
            currentIndex: state.currentPageIndex,
            pages: state.pages,
            completedSteps: state.completedSteps,
            currentPhase: currentPage.phase,
          ),

          // Page content
          Expanded(
            child: _PageContent(
              page: currentPage,
              pageIndex: state.currentPageIndex,
              completedSteps: state.completedSteps,
              activeTimers: state.activeTimers,
              onToggleComplete: (recipeId) =>
                  cubit.toggleStepCompleted(state.currentPageIndex, recipeId),
              onStartTimer: (recipeId, recipeName) => cubit.startTimer(
                state.currentPageIndex,
                recipeId,
                recipeName,
              ),
            ),
          ),

          // Navigation bar
          _NavigationBar(
            currentIndex: state.currentPageIndex,
            totalPages: state.pages.length,
            onPrevious: cubit.previousPage,
            onNext: cubit.nextPage,
            onFinish: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class _ActiveTimersBar extends StatelessWidget {
  const _ActiveTimersBar({
    required this.timers,
    required this.onToggle,
    required this.onDismiss,
  });

  final Map<String, BatchTimerState> timers;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: timers.values.map((timer) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _TimerChip(
                timer: timer,
                onToggle: () => onToggle(timer.timerKey),
                onDismiss: () => onDismiss(timer.timerKey),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({
    required this.timer,
    required this.onToggle,
    required this.onDismiss,
  });

  final BatchTimerState timer;
  final VoidCallback onToggle;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isFinished = timer.remainingSeconds <= 0;
    final bgColor = isFinished
        ? AppColors.accentRose
        : timer.isRunning
            ? AppColors.emeraldPrimary
            : AppColors.accentAmber;
    final minutes = timer.remainingSeconds ~/ 60;
    final seconds = timer.remainingSeconds % 60;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFinished
                  ? Icons.check
                  : timer.isRunning
                      ? Icons.pause
                      : Icons.play_arrow,
              size: 16,
              color: bgColor,
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timer.recipeName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: bgColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isFinished
                      ? 'Termine !'
                      : '${minutes.toString().padLeft(2, '0')}:'
                          '${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: bgColor,
                  ),
                ),
              ],
            ),
            if (isFinished) ...[
              const SizedBox(width: 6),
              IconButton(
                onPressed: onDismiss,
                icon: Icon(Icons.close, size: 14, color: bgColor),
                iconSize: 14,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                tooltip: 'Ignorer le minuteur',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.currentIndex,
    required this.pages,
    required this.completedSteps,
    required this.currentPhase,
  });

  final int currentIndex;
  final List<BatchPage> pages;
  final Set<String> completedSteps;
  final StepPhase currentPhase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color) = switch (currentPhase) {
      StepPhase.prep => ('Preparation', AppColors.emeraldPrimary),
      StepPhase.cook => ('Cuisson', AppColors.accentAmber),
      StepPhase.finish => ('Finition', AppColors.accentRose),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          // Progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pages.length, (i) {
              final page = pages[i];
              final allDone = page.recipeSteps.every(
                (s) => completedSteps.contains('$i-${s.recipeId}'),
              );
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: i == currentIndex ? 10 : 7,
                height: i == currentIndex ? 10 : 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: allDone
                      ? AppColors.emeraldPrimary
                      : i == currentIndex
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),

          // Phase badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({
    required this.page,
    required this.pageIndex,
    required this.completedSteps,
    required this.activeTimers,
    required this.onToggleComplete,
    required this.onStartTimer,
  });

  final BatchPage page;
  final int pageIndex;
  final Set<String> completedSteps;
  final Map<String, BatchTimerState> activeTimers;
  final ValueChanged<int> onToggleComplete;
  final void Function(int recipeId, String recipeName) onStartTimer;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: page.recipeSteps.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final recipeStep = page.recipeSteps[index];
        final stepKey = '$pageIndex-${recipeStep.recipeId}';
        final isCompleted = completedSteps.contains(stepKey);
        final hasActiveTimer = activeTimers.containsKey(stepKey);

        return _RecipeStepCard(
          recipeStep: recipeStep,
          isCompleted: isCompleted,
          hasActiveTimer: hasActiveTimer,
          onToggleComplete: () => onToggleComplete(recipeStep.recipeId),
          onStartTimer: () =>
              onStartTimer(recipeStep.recipeId, recipeStep.recipeName),
        );
      },
    );
  }
}

class _RecipeStepCard extends StatelessWidget {
  const _RecipeStepCard({
    required this.recipeStep,
    required this.isCompleted,
    required this.hasActiveTimer,
    required this.onToggleComplete,
    required this.onStartTimer,
  });

  final RecipeStepItem recipeStep;
  final bool isCompleted;
  final bool hasActiveTimer;
  final VoidCallback onToggleComplete;
  final VoidCallback onStartTimer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isCompleted
        ? AppColors.emeraldPrimary.withValues(alpha: 0.4)
        : AppColors.emeraldPrimary.withValues(alpha: 0.15);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: SolidCard(
        cornerRadius: 16,
        elevation: 2,
        backgroundColor: isCompleted
            ? AppColors.emeraldPrimary.withValues(alpha: 0.04)
            : theme.colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe name + portions badges
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    recipeStep.recipeName,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.emeraldPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentAmber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${QuantityFormatter.formatServings(recipeStep.servings)} portions',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentAmber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Instruction
            Text(
              recipeStep.instruction,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                decoration:
                    isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted
                    ? theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5)
                    : theme.colorScheme.onSurface,
              ),
            ),

            // Ingredient chips
            if (recipeStep.ingredients.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: recipeStep.ingredients.map((ingredient) {
                  final qtyText = QuantityFormatter.formatWithUnit(
                    ingredient.quantity,
                    ingredient.unit,
                  );
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accentAmber.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ingredient.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          qtyText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentAmber,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],

            // Timer button
            if (recipeStep.timerSeconds != null &&
                recipeStep.timerSeconds! > 0 &&
                !hasActiveTimer) ...[
              const SizedBox(height: 12),
              _TimerStartButton(
                seconds: recipeStep.timerSeconds!,
                onStart: onStartTimer,
              ),
            ],

            // Check button
            const SizedBox(height: 12),
            _CheckStepButton(
              isCompleted: isCompleted,
              onToggle: onToggleComplete,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerStartButton extends StatelessWidget {
  const _TimerStartButton({
    required this.seconds,
    required this.onStart,
  });

  final int seconds;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final label = minutes > 0 ? '${minutes}min ${secs}s' : '${secs}s';

    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: onStart,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accentAmber.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, color: AppColors.accentAmber, size: 18),
            const SizedBox(width: 6),
            Text(
              'Lancer le timer ($label)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.accentAmber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckStepButton extends StatelessWidget {
  const _CheckStepButton({
    required this.isCompleted,
    required this.onToggle,
  });

  final bool isCompleted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = isCompleted
        ? AppColors.emeraldPrimary
        : theme.colorScheme.surfaceContainerHighest;
    final contentColor = isCompleted
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: bgColor.withValues(alpha: isCompleted ? 1 : 0.6),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, size: 18, color: contentColor),
                const SizedBox(width: 6),
                Text(
                  isCompleted ? 'Fait !' : 'Marquer comme fait',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.currentIndex,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    required this.onFinish,
  });

  final int currentIndex;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: theme.colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: currentIndex > 0 ? onPrevious : null,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Icon(Icons.arrow_back, size: 18),
          ),
          Text(
            '${currentIndex + 1} / $totalPages',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (currentIndex < totalPages - 1)
            FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Suivant'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            )
          else
            FilledButton(
              onPressed: onFinish,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.emeraldPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Terminer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
