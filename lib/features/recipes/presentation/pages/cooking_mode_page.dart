import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../batch_cooking/domain/usecases/batch_step_optimizer.dart';
import '../cubit/recipe_detail_cubit.dart';
import '../cubit/recipe_detail_state.dart';

/// Cooking mode screen — port of CookingModeScreen.kt.
class CookingModePage extends StatefulWidget {
  const CookingModePage({
    required this.recipeId,
    this.planServings = 0,
    super.key,
  });

  final int recipeId;
  final double planServings;

  @override
  State<CookingModePage> createState() => _CookingModePageState();
}

class _CookingModePageState extends State<CookingModePage> {
  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    context
        .read<RecipeDetailCubit>()
        .loadRecipe(widget.recipeId, planServings: widget.planServings);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
      builder: (context, state) {
        if (state.isLoading || state.recipe == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.emeraldPrimary,
              ),
            ),
          );
        }

        final recipe = state.recipe!;
        final steps = List.of(recipe.steps)
          ..sort((a, b) => a.stepNumber.compareTo(b.stepNumber));
        if (steps.isEmpty) return const SizedBox.shrink();

        // Clamp step index
        if (_currentStepIndex >= steps.length) {
          _currentStepIndex = steps.length - 1;
        }

        final currentStep = steps[_currentStepIndex];
        final cubit = context.read<RecipeDetailCubit>();
        final servingsMultiplier =
            state.servings / recipe.recipe.servings;

        return PopScope(
          canPop: !cubit.hasRunningTimers,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _showExitConfirmation(context, cubit);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Etape ${_currentStepIndex + 1} / ${steps.length}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  if (cubit.hasRunningTimers) {
                    _showExitConfirmation(context, cubit);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                tooltip: 'Fermer',
              ),
            ),
            body: Column(
              children: [
                // Active timers bar
                if (state.activeTimers.isNotEmpty)
                  _ActiveTimersBar(
                    timers: state.activeTimers,
                    steps: steps,
                    onToggle: cubit.toggleTimer,
                    onDismiss: cubit.dismissTimer,
                  ),

                // Progress dots
                _ProgressDots(
                  total: steps.length,
                  current: _currentStepIndex,
                  completedSteps: state.completedSteps,
                ),

                // Step content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Instruction
                        _StepInstruction(
                          instruction: currentStep.instruction,
                          isCompleted:
                              state.completedSteps.contains(_currentStepIndex),
                        ),
                        const SizedBox(height: 16),

                        // Ingredients for this step
                        _StepIngredients(
                          instruction: currentStep.instruction,
                          allIngredients: recipe.ingredients,
                          servingsMultiplier: servingsMultiplier,
                        ),

                        // Timer button
                        if (currentStep.timerSeconds != null &&
                            currentStep.timerSeconds! > 0 &&
                            !state.activeTimers
                                .containsKey(_currentStepIndex))
                          _TimerStartButton(
                            seconds: currentStep.timerSeconds!,
                            onStart: () => cubit.startTimer(
                              _currentStepIndex,
                              currentStep.timerSeconds!,
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Check button
                        _CheckStepButton(
                          isCompleted: state.completedSteps
                              .contains(_currentStepIndex),
                          onToggle: () =>
                              cubit.toggleStepCompleted(_currentStepIndex),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                // Navigation buttons
                _NavigationBar(
                  currentIndex: _currentStepIndex,
                  totalSteps: steps.length,
                  onPrevious: () =>
                      setState(() => _currentStepIndex--),
                  onNext: () =>
                      setState(() => _currentStepIndex++),
                  onFinish: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExitConfirmation(
    BuildContext context,
    RecipeDetailCubit cubit,
  ) {
    final timerCount = cubit.state.activeTimers.values
        .where((t) => t.remainingSeconds > 0)
        .length;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quitter la cuisson ?'),
        content: Text(
          'Vous avez $timerCount minuteur${timerCount > 1 ? 's' : ''} '
          'en cours. Ils seront perdus si vous quittez.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // close dialog
              Navigator.pop(context); // exit cooking
            },
            child: const Text(
              'Quitter',
              style: TextStyle(color: AppColors.accentRose),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ────────────────────────────────────────────────────────────

class _ActiveTimersBar extends StatelessWidget {
  const _ActiveTimersBar({
    required this.timers,
    required this.steps,
    required this.onToggle,
    required this.onDismiss,
  });

  final Map<int, CookingTimerState> timers;
  final List<RecipeStep> steps;
  final ValueChanged<int> onToggle;
  final ValueChanged<int> onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: timers.values.map((timer) {
          return _TimerChip(
            timer: timer,
            stepLabel: 'Etape ${timer.stepIndex + 1}',
            onToggle: () => onToggle(timer.stepIndex),
            onDismiss: () => onDismiss(timer.stepIndex),
          );
        }).toList(),
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({
    required this.timer,
    required this.stepLabel,
    required this.onToggle,
    required this.onDismiss,
  });

  final CookingTimerState timer;
  final String stepLabel;
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  stepLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: bgColor,
                  ),
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
              GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close, size: 14, color: bgColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({
    required this.total,
    required this.current,
    required this.completedSteps,
  });

  final int total;
  final int current;
  final Set<int> completedSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (index) {
          final isCompleted = completedSteps.contains(index);
          final isCurrent = index == current;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isCurrent ? 10 : 8,
            height: isCurrent ? 10 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? AppColors.emeraldPrimary
                  : isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
            ),
          );
        }),
      ),
    );
  }
}

class _StepInstruction extends StatelessWidget {
  const _StepInstruction({
    required this.instruction,
    required this.isCompleted,
  });

  final String instruction;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Text(
        instruction,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.4,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted
              ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
              : theme.colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _StepIngredients extends StatelessWidget {
  const _StepIngredients({
    required this.instruction,
    required this.allIngredients,
    required this.servingsMultiplier,
  });

  final String instruction;
  final List<Ingredient> allIngredients;
  final double servingsMultiplier;

  @override
  Widget build(BuildContext context) {
    final matched = BatchStepOptimizer.matchIngredientsForStep(
      instruction,
      allIngredients,
      servingsMultiplier,
    );

    if (matched.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: matched.map((ingredient) {
          return _IngredientChip(ingredient: ingredient);
        }).toList(),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.ingredient});

  final IngredientInfo ingredient;

  @override
  Widget build(BuildContext context) {
    final qtyText =
        QuantityFormatter.formatWithUnit(ingredient.quantity, ingredient.unit);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.tonal(
          onPressed: onStart,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accentAmber.withValues(alpha: 0.15),
            shape: RoundedCornerShape(12),
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
    required this.totalSteps,
    required this.onPrevious,
    required this.onNext,
    required this.onFinish,
  });

  final int currentIndex;
  final int totalSteps;
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
          OutlinedButton.icon(
            onPressed: currentIndex > 0 ? onPrevious : null,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Precedent'),
            style: OutlinedButton.styleFrom(
              shape: RoundedCornerShape(16),
            ),
          ),
          if (currentIndex < totalSteps - 1)
            FilledButton.icon(
              onPressed: onNext,
              icon: const Text('Suivant'),
              label: const Icon(Icons.arrow_forward, size: 18),
              style: FilledButton.styleFrom(
                shape: RoundedCornerShape(16),
              ),
            )
          else
            FilledButton(
              onPressed: onFinish,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.emeraldPrimary,
                shape: RoundedCornerShape(16),
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

/// Helper to create a RoundedRectangleBorder.
// ignore: non_constant_identifier_names
RoundedRectangleBorder RoundedCornerShape(double radius) =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
