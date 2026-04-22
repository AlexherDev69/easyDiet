import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/gradient_title.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../../../../shared/widgets/generation_loading_view.dart';
import '../widgets/allergies_step.dart';
import '../widgets/body_metrics_step.dart';
import '../widgets/goal_step.dart';
import '../widgets/lifestyle_step.dart';
import '../widgets/onboarding_loading_animation.dart';
import '../widgets/personal_info_step.dart';
import '../widgets/plan_preview_step.dart';
import '../widgets/welcome_step.dart';
import '../../../meal_plan/presentation/widgets/move_meal_dialog.dart' as meal_plan_dialogs;

/// Main onboarding screen — handoff visual (BlobBG + hero icon + GradText).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (prev, curr) =>
          prev.isOnboardingCompleted != curr.isOnboardingCompleted ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.isOnboardingCompleted) {
          context.go(AppRoutes.dashboard);
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Une erreur est survenue. Veuillez reessayer.',
              ),
              backgroundColor: Colors.red.shade700,
              action: SnackBarAction(
                label: 'Reessayer',
                textColor: Colors.white,
                onPressed: () {
                  context.read<OnboardingCubit>().nextStep();
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          if (state.isLoading) {
            // Step 5 = generating plan (pre-preview). Show hero loader.
            final isGeneratingPlan = state.currentStep == 5;
            return isGeneratingPlan
                ? const Scaffold(
                    backgroundColor: Colors.transparent,
                    body: GenerationLoadingView(),
                  )
                : const OnboardingLoadingAnimation();
          }

          return PopScope(
            canPop: state.currentStep == 0,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop && state.currentStep > 0) {
                context.read<OnboardingCubit>().previousStep();
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.emeraldBackground,
              body: Stack(
                children: [
                  const BlobBG(),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                      child: Column(
                        children: [
                          _ProgressBar(
                            currentStep: state.currentStep,
                            totalSteps: state.totalSteps,
                          ),
                          const SizedBox(height: 16),
                          _HeroIcon(step: state.currentStep),
                          const SizedBox(height: 14),
                          _StepTitles(step: state.currentStep),
                          const SizedBox(height: 18),
                          Expanded(
                            child: _buildStepContent(context, state),
                          ),
                          const SizedBox(height: 12),
                          _NavBar(
                            currentStep: state.currentStep,
                            totalSteps: state.totalSteps,
                            isValid: state.isCurrentStepValid,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
          0 => const WelcomeStep(),
          1 => PersonalInfoStep(
              name: state.name,
              age: state.age,
              sex: state.sex,
              onNameChange: cubit.updateName,
              onAgeChange: cubit.updateAge,
              onSexChange: cubit.updateSex,
            ),
          2 => BodyMetricsStep(
              height: state.heightCm,
              weight: state.weightKg,
              onHeightChange: cubit.updateHeight,
              onWeightChange: cubit.updateWeight,
            ),
          3 => GoalStep(
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
          4 => LifestyleStep(
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
              onBatchCookingBeforeDietChange:
                  cubit.updateBatchCookingBeforeDiet,
              onEconomicModeChange: cubit.updateEconomicMode,
              onShowBatchCookingInfo: cubit.showBatchCookingInfo,
              onHideBatchCookingInfo: cubit.hideBatchCookingInfo,
            ),
          5 => AllergiesStep(
              selectedAllergies: state.selectedAllergies,
              excludedMeats: state.excludedMeats,
              onToggleAllergy: cubit.toggleAllergy,
              onToggleExcludedMeat: cubit.toggleExcludedMeat,
            ),
          6 => _buildPlanPreview(context, state, cubit),
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
        if (state.showMoveDialog && state.movingMeal != null)
          meal_plan_dialogs.MoveMealDialog(
            movingMeal: state.movingMeal!,
            targetDays: state.moveTargetDays,
            onSelectDay: (id) => cubit.moveMealToDay(id),
            onDismiss: cubit.dismissMoveDialog,
          ),
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

// ── Progress bar (current segment wider) ───────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.currentStep, required this.totalSteps});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: Row(
        children: List.generate(totalSteps, (i) {
          final done = i < currentStep;
          final cur = i == currentStep;
          return Expanded(
            flex: cur ? 2 : 1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: cur
                    ? const LinearGradient(
                        colors: [
                          AppColors.emeraldPrimary,
                          AppColors.emeraldDark,
                        ],
                      )
                    : null,
                color: cur
                    ? null
                    : done
                        ? AppColors.emeraldPrimary
                        : const Color(0xFF0F172A).withValues(alpha: 0.08),
                boxShadow: cur
                    ? [
                        BoxShadow(
                          color:
                              AppColors.emeraldPrimary.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Hero icon per step ──────────────────────────────────────────────────────

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.step});

  final int step;

  static const _meta = [
    (LucideIcons.sparkles, Color(0xFF10B981)),
    (LucideIcons.user, Color(0xFF8B5CF6)),
    (LucideIcons.ruler, Color(0xFF0EA5E9)),
    (LucideIcons.target, Color(0xFFF43F5E)),
    (LucideIcons.activity, Color(0xFFF59E0B)),
    (LucideIcons.leaf, Color(0xFF10B981)),
    (LucideIcons.calendarCheck, Color(0xFF10B981)),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = step.clamp(0, _meta.length - 1);
    final (icon, tint) = _meta[idx];

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.3, -0.4),
              colors: [
                tint,
                tint.withValues(alpha: 0.55),
                tint.withValues(alpha: 0.2),
              ],
              stops: const [0, 0.6, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: tint.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
        ),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: tint.withValues(alpha: 0.35),
            ),
          ),
        ),
        Icon(icon, size: 52, color: Colors.white),
      ],
    );
  }
}

// ── Step title block (eyebrow + gradient title + subtitle) ─────────────────

class _StepTitles extends StatelessWidget {
  const _StepTitles({required this.step});

  final int step;

  static const _titles = [
    ('Bienvenue', 'EasyDiet',
        'Votre plan de repas, sur mesure et hors-ligne.'),
    ('Faisons connaissance', 'Parlez-nous de vous',
        'Ces infos restent sur votre appareil.'),
    ('Vos mesures', 'Votre silhouette',
        'Pour adapter vos besoins energetiques.'),
    ('Votre objectif', 'Quel rythme ?',
        'Choisissez une cadence soutenable.'),
    ('Votre quotidien', 'Mode de vie',
        'Activite, repas et organisation.'),
    ('Derniere etape', 'Allergies',
        'Nous les eviterons dans vos recettes.'),
    ('Votre plan', 'Apercu de la semaine',
        'Ajustez avant de valider.'),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = step.clamp(0, _titles.length - 1);
    final (eyebrow, title, sub) = _titles[idx];

    return Column(
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.emeraldDark,
          ),
        ),
        const SizedBox(height: 4),
        GradientTitle(
          title,
          style: GoogleFonts.nunito(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          sub,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.45,
            color: const Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}

// ── Bottom navigation ───────────────────────────────────────────────────────

class _NavBar extends StatelessWidget {
  const _NavBar({
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
    final isLast = currentStep >= totalSteps - 1;
    final isPreGenerate = currentStep == totalSteps - 2;

    final String label;
    final VoidCallback? action;
    if (isLast) {
      label = 'Valider le plan';
      action = isValid ? cubit.finishOnboarding : null;
    } else if (isPreGenerate) {
      label = 'Creer mon plan';
      action = isValid ? cubit.generateAndShowPreview : null;
    } else if (currentStep == 0) {
      label = 'Commencer';
      action = isValid ? cubit.nextStep : null;
    } else {
      label = 'Suivant';
      action = isValid ? cubit.nextStep : null;
    }

    return Row(
      children: [
        if (currentStep > 0) ...[
          _GlassBackButton(onPressed: cubit.previousStep),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: _GradientNextButton(label: label, onPressed: action),
        ),
      ],
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.chevronLeft,
                    size: 16,
                    color: Color(0xFF475569),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Precedent',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientNextButton extends StatelessWidget {
  const _GradientNextButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: disabled ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.emeraldPrimary, AppColors.emeraldDark],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color:
                            AppColors.emeraldPrimary.withValues(alpha: 0.45),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
