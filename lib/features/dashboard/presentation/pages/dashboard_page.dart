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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

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

          // Hero Calories Card
          CaloriesHeroCard(
            todayCalories: s.todayCalories,
            dailyTarget: s.dailyTarget,
            isFreeDay: s.selectedDayIsFreeDay,
            protein: s.todayProtein,
            carbs: s.todayCarbs,
            fat: s.todayFat,
          ),
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

          // Hydration + Next Meal row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (s.dailyWaterMl > 0)
                Expanded(
                  child: HydrationCard(dailyWaterMl: s.dailyWaterMl),
                ),
              if (s.dailyWaterMl > 0 && s.nextMeal != null)
                const SizedBox(width: 12),
              if (s.nextMeal != null)
                Expanded(
                  child: NextMealCard(nextMeal: s.nextMeal!),
                ),
            ],
          ),
          const SizedBox(height: 16),

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
                  icon: Icons.fitness_center,
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
