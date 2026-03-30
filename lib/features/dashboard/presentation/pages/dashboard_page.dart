import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/calories_hero_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/day_meals_section.dart';
import '../widgets/day_selector.dart';
import '../widgets/hydration_card.dart';
import '../widgets/mini_weight_chart.dart';
import '../widgets/next_batch_cooking_card.dart';
import '../widgets/next_meal_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_action_card.dart';

/// Main dashboard screen — port of DashboardScreen.kt.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listenWhen: (prev, curr) =>
          !prev.isPlanExpired && curr.isPlanExpired,
      listener: (context, state) {
        if (state.isPlanExpired) {
          context.push(AppRoutes.planPreview);
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

        return _DashboardContent(state: state);
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.state});

  final DashboardState state;

  void _showShiftConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Decaler le programme ?'),
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
              context.read<DashboardCubit>().shiftByOneDay();
              Navigator.pop(dialogContext);
            },
            child: const Text('Decaler'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = state;

    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20, top: topPadding + 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header
          DashboardHeader(
            userName: s.userName,
            onSettingsClick: () => context.push(AppRoutes.settings),
          ),
          const SizedBox(height: 16),

          // Day selector
          if (s.weekSchedule.isNotEmpty) ...[
            DaySelector(
              weekSchedule: s.weekSchedule,
              selectedIndex: s.selectedDayIndex,
              onSelectDay: context.read<DashboardCubit>().selectDay,
            ),
            const SizedBox(height: 16),
          ],

          // Bento grid: CaloriesHeroCard (60 %) + stacked Hydration/NextMeal (40 %)
          _BentoGrid(state: s),
          const SizedBox(height: 16),

          // Day meals program
          if (s.selectedDayMeals.isNotEmpty || s.selectedDayIsFreeDay) ...[
            DayMealsSection(
              meals: s.selectedDayMeals,
              isFreeDay: s.selectedDayIsFreeDay,
              onToggleConsumed:
                  context.read<DashboardCubit>().toggleMealConsumed,
            ),
            const SizedBox(height: 16),
          ],

          // Next batch cooking
          if (s.nextBatchCooking != null) ...[
            NextBatchCookingCard(
              batch: s.nextBatchCooking!,
              onTap: () => context.push(
                AppRoutes.batchCooking(s.nextBatchCooking!.dayPlanId),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Progress card
          ProgressCard(
            totalLost: s.totalLost,
            kgRemaining: s.kgRemaining,
            initialWeight: s.initialWeight,
            targetWeight: s.targetWeight,
            estimatedGoalDate: s.estimatedGoalDate,
          ),
          const SizedBox(height: 16),

          // Weight chart
          if (s.recentWeightLogs.length >= 2) ...[
            SolidCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Poids cette semaine',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  MiniWeightChart(
                    logs: s.recentWeightLogs,
                    height: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Quick actions
          Text(
            'Actions rapides',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  icon: Icons.restaurant_menu,
                  label: 'Plan',
                  accentColor: AppColors.emeraldPrimary,
                  onTap: () => context.go(AppRoutes.mealPlan),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickActionCard(
                  icon: Icons.shopping_bag,
                  label: 'Courses',
                  accentColor: AppColors.accentAmber,
                  onTap: () => context.go(AppRoutes.shoppingList),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  icon: Icons.menu_book,
                  label: 'Recettes',
                  accentColor: AppColors.accentPurple,
                  onTap: () => context.go(AppRoutes.recipeList),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickActionCard(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Peser',
                  accentColor: AppColors.accentRose,
                  onTap: () => context.go(AppRoutes.weightLog),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Shift button
          SolidCard(
            elevation: 1,
            contentPadding: const EdgeInsets.all(16),
            onTap: () => _showShiftConfirmation(context),
            child: Row(
              children: [
                Icon(
                  Icons.swap_vert,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  "Decaler le programme d'un jour",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento grid
// ---------------------------------------------------------------------------

/// 2-column asymmetric bento grid layout.
///
/// Left column (60 % width): CaloriesHeroCard spanning full height.
/// Right column (40 % width): HydrationCard on top, NextMealCard below,
/// each taking roughly half the available height via intrinsic sizing.
///
/// When neither hydration nor next-meal data is available the CaloriesHeroCard
/// renders full-width, matching the previous layout so no data is ever hidden.
class _BentoGrid extends StatelessWidget {
  const _BentoGrid({required this.state});

  final DashboardState state;

  bool get _hasRightColumn =>
      state.dailyWaterMl > 0 || state.nextMeal != null;

  @override
  Widget build(BuildContext context) {
    final caloriesCard = CaloriesHeroCard(
      todayCalories: state.todayCalories,
      dailyTarget: state.dailyTarget,
      isFreeDay: state.selectedDayIsFreeDay,
      protein: state.todayProtein,
      carbs: state.todayCarbs,
      fat: state.todayFat,
    );

    if (!_hasRightColumn) {
      // Fall back to the old full-width card when no companion data exists.
      return caloriesCard;
    }

    return SizedBox(
      height: 320,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left — calories (60 %)
          Expanded(
            flex: 60,
            child: caloriesCard,
          ),
          const SizedBox(width: 12),
          // Right — hydration stacked above next meal (40 %)
          Expanded(
            flex: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.dailyWaterMl > 0)
                  Expanded(
                    child: HydrationCard(dailyWaterMl: state.dailyWaterMl),
                  ),
                if (state.dailyWaterMl > 0 && state.nextMeal != null)
                  const SizedBox(height: 12),
                if (state.nextMeal != null)
                  Expanded(
                    child: NextMealCard(nextMeal: state.nextMeal!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
