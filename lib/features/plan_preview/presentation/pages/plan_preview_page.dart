import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/database.dart';
import '../../../../navigation/app_router.dart';
import '../../../onboarding/presentation/widgets/plan_preview_step.dart';
import '../cubit/plan_preview_cubit.dart';
import '../cubit/plan_preview_state.dart';

/// Standalone plan preview screen — port of PlanPreviewScreen.kt.
class PlanPreviewPage extends StatelessWidget {
  const PlanPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanPreviewCubit, PlanPreviewState>(
      listenWhen: (prev, curr) {
        if (!prev.showMoveDialog && curr.showMoveDialog) return true;
        if (!prev.showReplaceDialog && curr.showReplaceDialog) return true;
        return false;
      },
      listener: (context, state) {
        final cubit = context.read<PlanPreviewCubit>();

        if (state.showMoveDialog && state.movingMeal != null) {
          _showMoveDialog(context, state, cubit);
        }
        if (state.showReplaceDialog && state.replacingMeal != null) {
          _showReplaceDialog(context, state, cubit);
        }
      },
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
                    showMoveDialog: false,
                    movingMeal: null,
                    moveTargetDays: const [],
                    onMoveMealClick: cubit.openMoveMealDialog,
                    onSelectTargetDay: (_) {},
                    onDismissMoveDialog: () {},
                    onReplaceMealClick: cubit.openReplaceDialog,
                    onSelectReplacement: (_, _) {},
                    onDismissReplaceDialog: () {},
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

  void _showMoveDialog(
    BuildContext context,
    PlanPreviewState state,
    PlanPreviewCubit cubit,
  ) {
    final meal = state.movingMeal!;

    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Deplacer le repas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Echanger "${meal.recipe.name}" avec le meme type de repas d\'un autre jour :',
            ),
            const SizedBox(height: 12),
            ...state.moveTargetDays.map((dayWithMeals) {
              final dayName = AppDateUtils.getDayOfWeekFrench(
                dayWithMeals.dayPlan.dayOfWeek,
              );
              final sameMeal = dayWithMeals.meals
                  .where((m) => m.meal.mealType == meal.meal.mealType)
                  .firstOrNull;
              final targetRecipeName =
                  sameMeal?.recipe.name ?? 'Aucun repas';

              return SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    cubit.moveMealToDay(dayWithMeals.dayPlan.id);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          targetRecipeName,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.dismissMoveDialog();
            },
            child: const Text('Annuler'),
          ),
        ],
      ),
    ).then((_) {
      if (cubit.state.showMoveDialog) {
        cubit.dismissMoveDialog();
      }
    });
  }

  void _showReplaceDialog(
    BuildContext context,
    PlanPreviewState state,
    PlanPreviewCubit cubit,
  ) {
    final meal = state.replacingMeal!;
    final sortedCandidates = List.of(state.replacementCandidates)
      ..sort((a, b) => a.name.compareTo(b.name));

    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => _ReplaceRecipePreviewDialog(
        currentRecipeName: meal.recipe.name,
        candidates: sortedCandidates,
        otherOccurrencesCount: state.otherOccurrencesCount,
        onSelectReplacement: (recipe, replaceAll) {
          Navigator.pop(dialogContext);
          cubit.replaceRecipe(recipe, replaceAll);
        },
        onDismiss: () {
          Navigator.pop(dialogContext);
          cubit.dismissReplaceDialog();
        },
      ),
    ).then((_) {
      if (cubit.state.showReplaceDialog) {
        cubit.dismissReplaceDialog();
      }
    });
  }
}

class _ReplaceRecipePreviewDialog extends StatefulWidget {
  const _ReplaceRecipePreviewDialog({
    required this.currentRecipeName,
    required this.candidates,
    required this.otherOccurrencesCount,
    required this.onSelectReplacement,
    required this.onDismiss,
  });

  final String currentRecipeName;
  final List<Recipe> candidates;
  final int otherOccurrencesCount;
  final void Function(Recipe recipe, bool replaceAll) onSelectReplacement;
  final VoidCallback onDismiss;

  @override
  State<_ReplaceRecipePreviewDialog> createState() =>
      _ReplaceRecipePreviewDialogState();
}

class _ReplaceRecipePreviewDialogState
    extends State<_ReplaceRecipePreviewDialog> {
  Recipe? _selectedRecipe;
  bool _showConfirmAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_showConfirmAll && _selectedRecipe != null) {
      final count = widget.otherOccurrencesCount;
      return AlertDialog(
        title: const Text(
          'Remplacer partout ?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '"${widget.currentRecipeName}" apparait aussi $count '
          'autre${count > 1 ? 's' : ''} jour${count > 1 ? 's' : ''}. '
          'Remplacer partout par "${_selectedRecipe!.name}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                widget.onSelectReplacement(_selectedRecipe!, false),
            child: const Text('Ce jour uniquement'),
          ),
          TextButton(
            onPressed: () =>
                widget.onSelectReplacement(_selectedRecipe!, true),
            child: const Text('Tout remplacer'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text(
        'Choisir une recette',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remplacer "${widget.currentRecipeName}" par :',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.candidates.isEmpty)
              Text(
                'Aucune recette compatible disponible.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.candidates.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final recipe = widget.candidates[index];
                    return SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (widget.otherOccurrencesCount > 0) {
                            setState(() {
                              _selectedRecipe = recipe;
                              _showConfirmAll = true;
                            });
                          } else {
                            widget.onSelectReplacement(recipe, false);
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                recipe.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${recipe.caloriesPerServing} kcal',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onDismiss,
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
