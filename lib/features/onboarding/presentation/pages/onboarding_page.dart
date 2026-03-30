import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../navigation/app_router.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/allergies_step.dart';
import '../widgets/body_metrics_step.dart';
import '../widgets/goal_step.dart';
import '../widgets/lifestyle_step.dart';
import '../widgets/onboarding_illustration.dart';
import '../widgets/personal_info_step.dart';
import '../widgets/plan_preview_step.dart';

/// Main onboarding screen with progress bar, step content, navigation buttons.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (prev, curr) =>
          prev.isOnboardingCompleted != curr.isOnboardingCompleted,
      listener: (context, state) {
        if (state.isOnboardingCompleted) {
          context.go(AppRoutes.dashboard);
        }
      },
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          // Full-screen loading overlay during plan generation / finish
          if (state.isLoading && state.currentStep != 5) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Preparation de votre plan...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return PopScope(
            canPop: state.currentStep == 0,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop && state.currentStep > 0) {
                context.read<OnboardingCubit>().previousStep();
              }
            },
            child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Progress bar
                    _ProgressBar(
                      currentStep: state.currentStep,
                      totalSteps: state.totalSteps,
                    ),
                    const SizedBox(height: 12),

                    // Step dots + label
                    _StepIndicator(
                      currentStep: state.currentStep,
                      totalSteps: state.totalSteps,
                    ),
                    const SizedBox(height: 24),

                    // Step content
                    Expanded(
                      child: _buildStepContent(context, state),
                    ),

                    // Navigation buttons
                    _NavigationButtons(
                      currentStep: state.currentStep,
                      totalSteps: state.totalSteps,
                      isValid: state.isCurrentStepValid,
                    ),
                  ],
                ),
              ),
            ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, OnboardingState state) {
    final cubit = context.read<OnboardingCubit>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: KeyedSubtree(
        key: ValueKey(state.currentStep),
        child: switch (state.currentStep) {
          0 => _StepWithIllustration(
              step: 0,
              child: PersonalInfoStep(
                name: state.name,
                age: state.age,
                sex: state.sex,
                onNameChange: cubit.updateName,
                onAgeChange: cubit.updateAge,
                onSexChange: cubit.updateSex,
              ),
            ),
          1 => _StepWithIllustration(
              step: 1,
              child: BodyMetricsStep(
                height: state.heightCm,
                weight: state.weightKg,
                onHeightChange: cubit.updateHeight,
                onWeightChange: cubit.updateWeight,
              ),
            ),
          2 => _StepWithIllustration(
              step: 2,
              child: GoalStep(
                targetWeight: state.targetWeightKg,
                currentWeight: state.weightKg,
                lossPace: state.lossPace,
                activityLevel: state.activityLevel,
                dietType: state.dietType,
                calculatedCalories: state.calculatedCalories,
                calculatedWaterMl: state.calculatedWaterMl,
                onTargetWeightChange: cubit.updateTargetWeight,
                onLossPaceChange: cubit.updateLossPace,
                onActivityLevelChange: cubit.updateActivityLevel,
                onDietTypeChange: cubit.updateDietType,
              ),
            ),
          3 => _StepWithIllustration(
              step: 3,
              child: LifestyleStep(
                freeDays: state.freeDays,
                batchCookingEnabled: state.batchCookingEnabled,
                batchCooking: state.batchCookingSessions,
                shoppingTrips: state.shoppingTrips,
                distinctBreakfasts: state.distinctBreakfasts,
                distinctLunches: state.distinctLunches,
                distinctDinners: state.distinctDinners,
                distinctSnacks: state.distinctSnacks,
                enabledMealTypes: state.enabledMealTypes,
                dietStartDate: state.dietStartDate,
                batchCookingBeforeDiet: state.batchCookingBeforeDiet,
                showBatchCookingInfo: state.showBatchCookingInfo,
                economicMode: state.economicMode,
                onToggleMealType: cubit.toggleMealType,
                onToggleFreeDay: cubit.toggleFreeDay,
                onBatchCookingEnabledChange: cubit.updateBatchCookingEnabled,
                onBatchCookingChange: cubit.updateBatchCooking,
                onShoppingTripsChange: cubit.updateShoppingTrips,
                onDistinctBreakfastsChange: cubit.updateDistinctBreakfasts,
                onDistinctLunchesChange: cubit.updateDistinctLunches,
                onDistinctDinnersChange: cubit.updateDistinctDinners,
                onDistinctSnacksChange: cubit.updateDistinctSnacks,
                onDietStartDateChange: cubit.updateDietStartDate,
                onBatchCookingBeforeDietChange: cubit.updateBatchCookingBeforeDiet,
                onEconomicModeChange: cubit.updateEconomicMode,
                onShowBatchCookingInfo: cubit.showBatchCookingInfo,
                onHideBatchCookingInfo: cubit.hideBatchCookingInfo,
              ),
            ),
          4 => _StepWithIllustration(
              step: 4,
              child: AllergiesStep(
                selectedAllergies: state.selectedAllergies,
                excludedMeats: state.excludedMeats,
                onToggleAllergy: cubit.toggleAllergy,
                onToggleExcludedMeat: cubit.toggleExcludedMeat,
              ),
            ),
          5 => _buildPlanPreview(context, state, cubit),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildPlanPreview(
    BuildContext context,
    OnboardingState state,
    OnboardingCubit cubit,
  ) {
    return Stack(
      children: [
        PlanPreviewStep(
          weekPlan: state.generatedWeekPlan,
          isLoading: state.isLoading,
          showMoveDialog: state.showMoveDialog,
          movingMeal: state.movingMeal,
          moveTargetDays: state.moveTargetDays,
          onMoveMealClick: cubit.openMoveMealDialog,
          onSelectTargetDay: (id) => cubit.moveMealToDay(id),
          onDismissMoveDialog: cubit.dismissMoveDialog,
          showReplaceDialog: state.showReplaceDialog,
          replacingMeal: state.replacingMeal,
          replacementCandidates: state.replacementCandidates,
          otherOccurrencesCount: state.otherOccurrencesCount,
          onReplaceMealClick: (meal) => cubit.openReplaceDialog(meal),
          onSelectReplacement: (recipe, replaceAll) =>
              cubit.replaceRecipe(recipe, replaceAll),
          onDismissReplaceDialog: cubit.dismissReplaceDialog,
        ),

        // Move dialog overlay
        if (state.showMoveDialog && state.movingMeal != null)
          MoveMealDialog(
            mealName: state.movingMeal!.recipe.name,
            mealType: state.movingMeal!.meal.mealType,
            targetDays: state.moveTargetDays,
            onSelectDay: (id) => cubit.moveMealToDay(id),
            onDismiss: cubit.dismissMoveDialog,
          ),

        // Replace dialog overlay
        if (state.showReplaceDialog && state.replacingMeal != null)
          ReplaceRecipeDialog(
            currentRecipeName: state.replacingMeal!.recipe.name,
            candidates: state.replacementCandidates,
            otherOccurrencesCount: state.otherOccurrencesCount,
            onSelectReplacement: (recipe, replaceAll) =>
                cubit.replaceRecipe(recipe, replaceAll),
            onDismiss: cubit.dismissReplaceDialog,
          ),
      ],
    );
  }
}

// ── Internal widgets ──────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emeraldPrimary),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index <= currentStep
                    ? AppColors.emeraldPrimary
                    : theme.colorScheme.outlineVariant,
              ),
            );
          }),
        ),
        Text(
          'Etape ${currentStep + 1} / $totalSteps',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.currentStep,
    required this.totalSteps,
    required this.isValid,
  });

  final int currentStep;
  final int totalSteps;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep > 0)
          OutlinedButton(
            onPressed: cubit.previousStep,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Precedent'),
          )
        else
          const Spacer(),
        if (currentStep < totalSteps - 1)
          FilledButton(
            onPressed: isValid ? cubit.nextStep : null,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Suivant',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )
        else
          FilledButton(
            onPressed: isValid ? cubit.finishOnboarding : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.emeraldPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Terminer',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }
}

/// Wraps a step widget with its illustration centered above it.
///
/// Uses a [Column] so the illustration sits directly above the step content.
/// The step content is placed inside an [Expanded] + [SingleChildScrollView]
/// so long forms (e.g. LifestyleStep) remain scrollable without the
/// illustration being pushed off screen.
class _StepWithIllustration extends StatelessWidget {
  const _StepWithIllustration({
    required this.step,
    required this.child,
  });

  final int step;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: OnboardingIllustration(step: step)),
        const SizedBox(height: 16),
        Expanded(child: child),
      ],
    );
  }
}
