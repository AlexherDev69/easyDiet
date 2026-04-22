import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/glass_dialog.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/calories_hero_card.dart';
import '../widgets/current_weight_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/day_meals_section.dart';
import '../widgets/day_selector.dart';
// import '../widgets/next_batch_cooking_card.dart'; // batch cooking masque
import '../widgets/next_meal_card.dart';
import '../widgets/quick_action_card.dart';

/// Main dashboard screen.
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
        return Stack(
          children: [
            const Positioned.fill(child: BlobBG()),
            if (state.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.emeraldPrimary,
                ),
              )
            else
              _DashboardContent(state: state),
          ],
        );
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.state});

  final DashboardState state;

  void _showShiftConfirmation(BuildContext context) {
    showGlassDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => GlassDialogContent(
        icon: Icons.swap_vert,
        title: 'Decaler le programme ?',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Aujourd'hui deviendra un jour libre et tous les repas "
              "suivants seront decales d'un jour.",
              style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                    color:
                        Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GlassDialogActions(
              secondary: GlassDialogButton(
                label: 'Annuler',
                onPressed: () => Navigator.pop(dialogContext),
              ),
              primary: GlassDialogPrimaryButton(
                label: 'Decaler',
                onPressed: () {
                  context.read<DashboardCubit>().shiftByOneDay();
                  Navigator.pop(dialogContext);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = state;
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: topPadding + 14,
        bottom: 110,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(
            userName: s.userName.isEmpty ? '' : s.userName,
            onSettingsClick: () => context.push(AppRoutes.settings),
          ),
          const SizedBox(height: 20),

          if (s.weekSchedule.isNotEmpty) ...[
            DaySelector(
              weekSchedule: s.weekSchedule,
              selectedIndex: s.selectedDayIndex,
              onSelectDay: context.read<DashboardCubit>().selectDay,
            ),
            const SizedBox(height: 14),
          ],

          CaloriesHeroCard(
            todayCalories: s.todayCalories,
            dailyTarget: s.dailyTarget,
            isFreeDay: s.selectedDayIsFreeDay,
            protein: s.todayProtein,
            carbs: s.todayCarbs,
            fat: s.todayFat,
            waterTargetMl: s.dailyWaterMl,
          ),
          const SizedBox(height: 14),

          if (s.nextMeal != null) ...[
            NextMealCard(nextMeal: s.nextMeal!),
            const SizedBox(height: 14),
          ],

          // Batch cooking — TEMPORAIREMENT MASQUE
          // if (s.nextBatchCooking != null) ...[
          //   NextBatchCookingCard(
          //     batch: s.nextBatchCooking!,
          //     onTap: () => context.push(
          //       AppRoutes.batchCooking(s.nextBatchCooking!.dayPlanId),
          //     ),
          //   ),
          //   const SizedBox(height: 14),
          // ],

          if (s.recentWeightLogs.length >= 2) ...[
            CurrentWeightCard(
              logs: s.recentWeightLogs,
              onTap: () => context.go(AppRoutes.weightLog),
            ),
            const SizedBox(height: 14),
          ],

          if (s.selectedDayMeals.isNotEmpty || s.selectedDayIsFreeDay) ...[
            DayMealsSection(
              meals: s.selectedDayMeals,
              isFreeDay: s.selectedDayIsFreeDay,
              onToggleConsumed:
                  context.read<DashboardCubit>().toggleMealConsumed,
              onOpenRecipe: (recipeId) =>
                  context.push(AppRoutes.recipeDetail(recipeId)),
            ),
            const SizedBox(height: 14),
          ],

          _QuickActionsGrid(
            kgRemaining: s.kgRemaining,
            totalLost: s.totalLost,
          ),
          const SizedBox(height: 14),

          _ShiftButton(onTap: () => _showShiftConfirmation(context)),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.kgRemaining, required this.totalLost});

  final double kgRemaining;
  final double totalLost;

  @override
  Widget build(BuildContext context) {
    final weightSubtitle = totalLost.abs() > 0.05
        ? '${totalLost > 0 ? "-" : "+"}${totalLost.abs().toStringAsFixed(1)} kg'
        : 'Suivi poids';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: LucideIcons.shoppingCart,
                label: 'Courses',
                subtitle: 'Liste de la semaine',
                accentColor: const Color(0xFF3B82F6),
                onTap: () => context.go(AppRoutes.shoppingList),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                icon: LucideIcons.package,
                label: 'Plan repas',
                subtitle: 'Vos repas de la semaine',
                accentColor: const Color(0xFFF59E0B),
                onTap: () => context.go(AppRoutes.mealPlan),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: LucideIcons.bookOpen,
                label: 'Recettes',
                subtitle: 'Bibliotheque',
                accentColor: const Color(0xFF8B5CF6),
                onTap: () => context.go(AppRoutes.recipeList),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                icon: LucideIcons.scale,
                label: 'Poids',
                subtitle: weightSubtitle,
                accentColor: const Color(0xFFEC4899),
                onTap: () => context.go(AppRoutes.weightLog),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShiftButton extends StatelessWidget {
  const _ShiftButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.rotateCcw,
                size: 16,
                color: Color(0xFF475569),
              ),
              const SizedBox(width: 8),
              Text(
                'Decaler le programme',
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
    );
  }
}
