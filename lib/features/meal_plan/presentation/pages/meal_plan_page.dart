import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../navigation/app_router.dart';
import '../../../../shared/widgets/blob_bg.dart';
import '../../../../shared/widgets/glass_dialog.dart';
import '../../../onboarding/domain/models/meal_type.dart';
import '../cubit/meal_plan_cubit.dart';
import '../cubit/meal_plan_state.dart';
import '../widgets/macro_summary_card.dart';
import '../widgets/meal_card.dart';
import '../widgets/move_meal_dialog.dart';
import '../widgets/swap_meal_dialog.dart';

/// Weekly meal plan screen.
class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealPlanCubit, MealPlanState>(
      listenWhen: (prev, curr) {
        if (prev.swapDialogMeal == null && curr.swapDialogMeal != null) {
          return true;
        }
        if (!prev.showMoveDialog && curr.showMoveDialog) return true;
        return false;
      },
      listener: (context, state) {
        final cubit = context.read<MealPlanCubit>();
        if (state.swapDialogMeal != null) _showSwapDialog(context, state, cubit);
        if (state.showMoveDialog && state.movingMeal != null) {
          _showMoveDialog(context, state, cubit);
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
            else if (state.errorMessage != null)
              _ErrorView(onRetry: () => context.push(AppRoutes.planConfig))
            else if (state.weekPlan == null)
              _EmptyView(onGenerate: () => context.push(AppRoutes.planConfig))
            else
              _MealPlanContent(state: state),
          ],
        );
      },
    );
  }

  void _showSwapDialog(
    BuildContext context,
    MealPlanState state,
    MealPlanCubit cubit,
  ) {
    final currentRecipeName = state.weekPlan?.days
            .expand((d) => d.meals)
            .where((m) => m.meal.id == state.swapDialogMeal!.id)
            .firstOrNull
            ?.recipe
            .name ??
        '';

    showDialog<void>(
      context: context,
      useRootNavigator: true,
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
      if (cubit.state.swapDialogMeal != null) cubit.closeSwapDialog();
    });
  }

  void _showMoveDialog(
    BuildContext context,
    MealPlanState state,
    MealPlanCubit cubit,
  ) {
    showDialog<void>(
      context: context,
      useRootNavigator: true,
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
      if (cubit.state.showMoveDialog) cubit.closeMoveDialog();
    });
  }
}

class _MealPlanContent extends StatefulWidget {
  const _MealPlanContent({required this.state});

  final MealPlanState state;

  @override
  State<_MealPlanContent> createState() => _MealPlanContentState();
}

class _MealPlanContentState extends State<_MealPlanContent> {
  int _previousIndex = 0;
  bool _isGoingForward = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MealPlanCubit>();
    final sortedDays = widget.state.sortedDays;
    final selectedIndex =
        widget.state.selectedDayIndex.clamp(0, sortedDays.length - 1);
    final selectedDay =
        sortedDays.isNotEmpty ? sortedDays[selectedIndex] : null;
    final topPadding = MediaQuery.of(context).padding.top;

    if (selectedIndex != _previousIndex) {
      _isGoingForward = selectedIndex > _previousIndex ||
          (selectedIndex == 0 && _previousIndex == sortedDays.length - 1);
      _previousIndex = selectedIndex;
    }

    final weekStartDay = sortedDays.isNotEmpty
        ? AppDateUtils.fromEpochMillis(sortedDays.first.dayPlan.date).day
        : null;

    return Column(
      children: [
        SizedBox(height: topPadding + 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _Header(
            weekStartDay: weekStartDay,
            isRegenerating: widget.state.isRegenerating,
            onShift: () => _showShiftDialog(context, cubit),
            onRegenerate: () => _showRegenerateDialog(context),
          ),
        ),
        const SizedBox(height: 16),
        if (sortedDays.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _DayTabs(
              days: sortedDays,
              selectedIndex: selectedIndex,
              onSelect: cubit.selectDay,
            ),
          ),
        const SizedBox(height: 14),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              final begin = _isGoingForward
                  ? const Offset(1, 0)
                  : const Offset(-1, 0);
              return SlideTransition(
                position: animation
                    .drive(Tween(begin: begin, end: Offset.zero)),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: selectedDay != null
                ? KeyedSubtree(
                    key: ValueKey<int>(selectedDay.dayPlan.id),
                    child: _DayBody(dayPlan: selectedDay),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ),
      ],
    );
  }

  void _showShiftDialog(BuildContext context, MealPlanCubit cubit) {
    final theme = Theme.of(context);
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
              style: theme.textTheme.bodyMedium,
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
                  cubit.shiftByOneDay();
                  Navigator.pop(dialogContext);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegenerateDialog(BuildContext context) {
    final theme = Theme.of(context);
    showGlassDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => GlassDialogContent(
        icon: Icons.swap_horiz,
        title: 'Regenerer le plan ?',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Votre plan actuel sera supprime et un nouveau plan '
              'sera genere avec vos parametres actuels.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GlassDialogActions(
              secondary: GlassDialogButton(
                label: 'Annuler',
                onPressed: () => Navigator.pop(dialogContext),
              ),
              primary: GlassDialogPrimaryButton(
                label: 'Regenerer',
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.push(AppRoutes.planConfig);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.weekStartDay,
    required this.isRegenerating,
    required this.onShift,
    required this.onRegenerate,
  });

  final int? weekStartDay;
  final bool isRegenerating;
  final VoidCallback onShift;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weekStartDay != null ? 'SEMAINE DU $weekStartDay' : 'SEMAINE',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              ShaderMask(
                shaderCallback: (rect) => gradient.createShader(rect),
                blendMode: BlendMode.srcIn,
                child: Text(
                  'Plan de la semaine',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _CircleButton(
          icon: LucideIcons.rotateCcw,
          onTap: onShift,
          tooltip: 'Decaler le programme',
        ),
        const SizedBox(width: 8),
        _CircleButton(
          icon: LucideIcons.arrowLeftRight,
          onTap: isRegenerating ? null : onRegenerate,
          tooltip: 'Regenerer',
          loading: isRegenerating,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.loading = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Ink(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF475569),
                    ),
                  )
                : Icon(icon, size: 18, color: const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }
}

class _DayTabs extends StatelessWidget {
  const _DayTabs({
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<DayPlanWithMeals> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final date = AppDateUtils.fromEpochMillis(days[i].dayPlan.date);
          final label =
              AppDateUtils.getDayOfWeekFrench(date.weekday).substring(0, 3);
          return _DayTab(
            label: label,
            isSelected: i == selectedIndex,
            onTap: () => onSelect(i),
          );
        },
      ),
    );
  }
}

class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: isSelected ? gradient : null,
            color: isSelected ? null : Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color:
                          const Color(0xFF10B981).withValues(alpha: 0.30),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DayBody extends StatelessWidget {
  const _DayBody({required this.dayPlan});

  final DayPlanWithMeals dayPlan;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MealPlanCubit>();

    if (dayPlan.dayPlan.isFreeDay) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Jour libre',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Pas de plan prevu pour ce jour.",
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      );
    }

    const mealOrder = [
      MealType.breakfast,
      MealType.lunch,
      MealType.snack,
      MealType.dinner,
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
      children: [
        MacroSummaryCard(meals: sorted),
        const SizedBox(height: 14),
        // Batch cooking — TEMPORAIREMENT MASQUE
        // if (dayPlan.dayPlan.batchCookingSession != null) ...[
        //   _BatchPill(
        //     label:
        //         'Batch cooking - Session ${dayPlan.dayPlan.batchCookingSession}',
        //     onTap: () => context.push(
        //       AppRoutes.batchCooking(dayPlan.dayPlan.id),
        //     ),
        //   ),
        //   const SizedBox(height: 14),
        // ],
        ...sorted.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MealCard(
                mealWithRecipe: m,
                onSwap: () => cubit.openSwapDialog(m.meal),
                onMove: () => cubit.openMoveDialog(m, dayPlan.dayPlan.id),
                onClick: () => context.push(
                  AppRoutes.recipeDetail(
                    m.meal.recipeId,
                    planServings: m.meal.servings,
                  ),
                ),
                onToggleConsumed: () => cubit.toggleMealConsumed(
                  m.meal.id,
                  m.meal.isConsumed,
                ),
              ),
            )),
      ],
    );
  }
}

// ignore: unused_element
class _BatchPill extends StatelessWidget {
  const _BatchPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF59E0B).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.package,
                  size: 14,
                  color: Color(0xFFB45309),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB45309),
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.triangleAlert,
              size: 48,
              color: Color(0xFFF43F5E),
            ),
            const SizedBox(height: 12),
            Text(
              'Erreur lors de la generation du plan',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Reessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onGenerate});

  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Aucun plan pour cette semaine',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onGenerate,
              child: const Text('Generer un plan'),
            ),
          ],
        ),
      ),
    );
  }
}
