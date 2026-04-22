import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/generation_loading_view.dart';
import '../../../meal_plan/presentation/widgets/move_meal_dialog.dart'
    as meal_plan_dialogs;
import '../../../onboarding/presentation/widgets/plan_preview_step.dart';
import '../cubit/plan_preview_cubit.dart';
import '../cubit/plan_preview_state.dart';

/// Standalone plan preview screen — redesigned to match the onboarding
/// aesthetic (blob background, glass top bar, gradient action button).
class PlanPreviewPage extends StatelessWidget {
  const PlanPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanPreviewCubit, PlanPreviewState>(
      builder: (context, state) {
        final cubit = context.read<PlanPreviewCubit>();

        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: GenerationLoadingView(),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.emeraldBackground,
          body: Stack(
            children: [
              const BlobBG(),
              SafeArea(
                child: Column(
                  children: [
                    const _TopBar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                        child: PlanPreviewStep(
                          weekPlan: state.weekPlan,
                          isLoading: state.isLoading,
                          showMoveDialog: false,
                          movingMeal: null,
                          moveTargetDays: const [],
                          onMoveMealClick: cubit.openMoveMealDialog,
                          onSelectTargetDay: cubit.moveMealToDay,
                          onDismissMoveDialog: cubit.dismissMoveDialog,
                          onReplaceMealClick: cubit.openReplaceDialog,
                          onSelectReplacement: cubit.replaceRecipe,
                          onDismissReplaceDialog: cubit.dismissReplaceDialog,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: _ValidateButton(
                        enabled: state.weekPlan != null && !state.isLoading,
                        onPressed: () async {
                          await cubit.confirmPlan();
                          if (context.mounted) {
                            context.go(AppRoutes.dashboard);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (state.showMoveDialog && state.movingMeal != null)
                meal_plan_dialogs.MoveMealDialog(
                  movingMeal: state.movingMeal!,
                  targetDays: state.moveTargetDays,
                  onSelectDay: cubit.moveMealToDay,
                  onDismiss: cubit.dismissMoveDialog,
                ),
              if (state.showReplaceDialog && state.replacingMeal != null)
                ReplaceRecipeDialog(
                  currentRecipeName: state.replacingMeal!.recipe.name,
                  candidates: state.replacementCandidates,
                  otherOccurrencesCount: state.otherOccurrencesCount,
                  onSelectReplacement: cubit.replaceRecipe,
                  onDismiss: cubit.dismissReplaceDialog,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
      child: Row(
        children: [
          _GlassIconButton(
            icon: LucideIcons.arrowLeft,
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nouveau plan',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.7),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF0F172A)),
        ),
      ),
    );
  }
}

class _ValidateButton extends StatelessWidget {
  const _ValidateButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [AppColors.emeraldPrimary, AppColors.emeraldDark],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.emeraldPrimary.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Valider le plan',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.2,
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
