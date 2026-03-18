import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../navigation/app_router.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../cubit/meal_plan_cubit.dart';
import '../cubit/meal_plan_state.dart';
import '../widgets/macro_summary_card.dart';
import '../widgets/meal_card.dart';
import '../widgets/move_meal_dialog.dart';
import '../widgets/swap_meal_dialog.dart';

/// Weekly meal plan screen — port of WeeklyMealPlanScreen.kt.
class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealPlanCubit, MealPlanState>(
      listenWhen: (prev, curr) {
        // Show swap dialog
        if (prev.swapDialogMeal == null && curr.swapDialogMeal != null) {
          return true;
        }
        // Show move dialog
        if (!prev.showMoveDialog && curr.showMoveDialog) return true;
        return false;
      },
      listener: (context, state) {
        final cubit = context.read<MealPlanCubit>();

        if (state.swapDialogMeal != null) {
          _showSwapDialog(context, state, cubit);
        }
        if (state.showMoveDialog && state.movingMeal != null) {
          _showMoveDialog(context, state, cubit);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.emeraldPrimary,
            ),
          );
        }

        if (state.weekPlan == null) {
          return Center(
            child: Text(
              'Aucun plan pour cette semaine',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        }

        return _MealPlanContent(state: state);
      },
    );
  }

  void _showSwapDialog(
    BuildContext context,
    MealPlanState state,
    MealPlanCubit cubit,
  ) {
    // Find the recipe name for the current meal
    final currentRecipeName = state.weekPlan?.days
            .expand((d) => d.meals)
            .where((m) => m.meal.id == state.swapDialogMeal!.id)
            .firstOrNull
            ?.recipe
            .name ??
        '';

    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => SwapMealDialog(
        alternatives: state.swapAlternatives,
        otherOccurrencesCount: state.swapOtherOccurrencesCount,
        currentRecipeName: currentRecipeName,
        onSelectRecipe: (recipe, replaceAll) {
          Navigator.pop(dialogContext);
          cubit.swapMeal(recipe, replaceAll: replaceAll);
        },
        onDismiss: () {
          Navigator.pop(dialogContext);
          cubit.closeSwapDialog();
        },
      ),
    ).then((_) {
      // Ensure dialog state is cleaned up if dismissed by tapping outside
      if (cubit.state.swapDialogMeal != null) {
        cubit.closeSwapDialog();
      }
    });
  }

  void _showMoveDialog(
    BuildContext context,
    MealPlanState state,
    MealPlanCubit cubit,
  ) {
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => MoveMealDialog(
        movingMeal: state.movingMeal!,
        targetDays: state.moveTargetDays,
        onSelectDay: (dayPlanId) {
          Navigator.pop(dialogContext);
          cubit.moveMealToDay(dayPlanId);
        },
        onDismiss: () {
          Navigator.pop(dialogContext);
          cubit.closeMoveDialog();
        },
      ),
    ).then((_) {
      if (cubit.state.showMoveDialog) {
        cubit.closeMoveDialog();
      }
    });
  }
}

class _MealPlanContent extends StatelessWidget {
  const _MealPlanContent({required this.state});

  final MealPlanState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MealPlanCubit>();
    final sortedDays = state.sortedDays;
    final selectedIndex =
        state.selectedDayIndex.clamp(0, sortedDays.length - 1);

    return Column(
      children: [
        // App bar
        AppBar(
          title: const Text(
            'Plan de la semaine',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          actions: [
            // Copy JSON
            IconButton(
              onPressed: () async {
                final json = await cubit.exportWeekPlanJson();
                if (json.isNotEmpty && context.mounted) {
                  await Clipboard.setData(ClipboardData(text: json));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Plan semaine copie !'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.content_copy),
              tooltip: 'Copier le plan',
            ),
            // Shift
            IconButton(
              onPressed: () => _showShiftDialog(context, cubit),
              icon: const Icon(Icons.move_down),
              tooltip: 'Decaler le plan',
            ),
            // Navigate to plan config / regenerate
            IconButton(
              onPressed: state.isRegenerating
                  ? null
                  : () => _showRegenerateDialog(context),
              icon: state.isRegenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.swap_horiz),
              tooltip: 'Regenerer le plan',
            ),
          ],
        ),

        // Day tabs
        if (sortedDays.isNotEmpty)
          ScrollableTabBar(
            tabs: sortedDays
                .map((d) => AppDateUtils.getDayOfWeekFrench(
                    AppDateUtils.fromEpochMillis(d.dayPlan.date).weekday))
                .toList(),
            selectedIndex: selectedIndex,
            onSelectDay: cubit.selectDay,
          ),

        // Day content
        if (sortedDays.isNotEmpty)
          Expanded(
            child: _DayMealsList(
              dayPlan: sortedDays[selectedIndex],
            ),
          ),
      ],
    );
  }

  void _showShiftDialog(BuildContext context, MealPlanCubit cubit) {
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Decaler le programme ?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Aujourd'hui deviendra un jour libre et tous les repas "
          "suivants seront decales d'un jour.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              cubit.shiftByOneDay();
              Navigator.pop(dialogContext);
            },
            child: const Text('Decaler'),
          ),
        ],
      ),
    );
  }

  void _showRegenerateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Regenerer le plan ?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Votre plan actuel sera supprime et un nouveau plan '
          'sera genere avec vos parametres actuels.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.push(AppRoutes.planConfig);
            },
            child: const Text(
              'Regenerer',
              style: TextStyle(color: AppColors.emeraldPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Scrollable tab row for day selection.
class ScrollableTabBar extends StatelessWidget {
  const ScrollableTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelectDay,
    super.key,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelectDay;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: selectedIndex,
      child: TabBar(
        isScrollable: true,
        onTap: onSelectDay,
        tabs: tabs
            .map((t) => Tab(
                  text: t,
                ))
            .toList(),
      ),
    );
  }
}

class _DayMealsList extends StatelessWidget {
  const _DayMealsList({required this.dayPlan});

  final DayPlanWithMeals dayPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<MealPlanCubit>();

    if (dayPlan.dayPlan.isFreeDay) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Jour libre',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pas de plan prevu pour aujourd'hui.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Sort meals
    const mealOrder = [
      MealType.breakfast,
      MealType.lunch,
      MealType.dinner,
      MealType.snack,
    ];
    final sorted = List.of(dayPlan.meals)
      ..sort((a, b) {
        final aIdx = mealOrder.indexWhere(
          (t) => t.name.toUpperCase() == a.meal.mealType,
        );
        final bIdx = mealOrder.indexWhere(
          (t) => t.name.toUpperCase() == b.meal.mealType,
        );
        return aIdx.compareTo(bIdx);
      });

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Macro summary
        MacroSummaryCard(meals: sorted),
        const SizedBox(height: 12),

        // Batch cooking chip
        if (dayPlan.dayPlan.batchCookingSession != null) ...[
          ActionChip(
            label: Text(
              'Batch cooking - Session ${dayPlan.dayPlan.batchCookingSession}',
            ),
            onPressed: () => context.push(
              AppRoutes.batchCooking(dayPlan.dayPlan.id),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Meal cards
        ...sorted.map((mealWithRecipe) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MealCard(
                mealWithRecipe: mealWithRecipe,
                onSwap: () => cubit.openSwapDialog(mealWithRecipe.meal),
                onMove: () =>
                    cubit.openMoveDialog(mealWithRecipe, dayPlan.dayPlan.id),
                onClick: () => context.push(
                  AppRoutes.recipeDetail(
                    mealWithRecipe.meal.recipeId,
                    planServings: mealWithRecipe.meal.servings,
                  ),
                ),
                onToggleConsumed: () => cubit.toggleMealConsumed(
                  mealWithRecipe.meal.id,
                  mealWithRecipe.meal.isConsumed,
                ),
              ),
            )),
      ],
    );
  }
}
