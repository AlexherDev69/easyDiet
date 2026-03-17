import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../navigation/app_router.dart';
import '../../../onboarding/presentation/widgets/plan_preview_step.dart';
import '../cubit/plan_preview_cubit.dart';
import '../cubit/plan_preview_state.dart';

/// Standalone plan preview screen — port of PlanPreviewScreen.kt.
class PlanPreviewPage extends StatelessWidget {
  const PlanPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanPreviewCubit, PlanPreviewState>(
      builder: (context, state) {
        final cubit = context.read<PlanPreviewCubit>();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Nouveau plan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PlanPreviewStep(
                    weekPlan: state.weekPlan,
                    isLoading: state.isLoading,
                    showMoveDialog: state.showMoveDialog,
                    movingMeal: state.movingMeal,
                    moveTargetDays: state.moveTargetDays,
                    onMoveMealClick: cubit.openMoveMealDialog,
                    onSelectTargetDay: cubit.moveMealToDay,
                    onDismissMoveDialog: cubit.dismissMoveDialog,
                    showReplaceDialog: state.showReplaceDialog,
                    replacingMeal: state.replacingMeal,
                    replacementCandidates: state.replacementCandidates,
                    otherOccurrencesCount: state.otherOccurrencesCount,
                    onReplaceMealClick: cubit.openReplaceDialog,
                    onSelectReplacement: cubit.replaceRecipe,
                    onDismissReplaceDialog: cubit.dismissReplaceDialog,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state.weekPlan != null && !state.isLoading
                        ? () async {
                            await cubit.confirmPlan();
                            if (context.mounted) {
                              context.go(AppRoutes.dashboard);
                            }
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.emeraldPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Valider le plan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
