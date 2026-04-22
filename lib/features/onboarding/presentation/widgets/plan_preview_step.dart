import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../../../shared/widgets/generation_loading_view.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_title.dart';
import '../../../../shared/widgets/pill_chip.dart';
import '../../domain/models/meal_type.dart';

// Duration of the slide transition when switching day content.
const Duration _kSlideDuration = Duration(milliseconds: 300);

// Stagger delay per meal card entrance animation.
const Duration _kStaggerStep = Duration(milliseconds: 80);

// Duration for the kcal counter scale-pop animation.
const Duration _kKcalPopDuration = Duration(milliseconds: 300);

/// Step 5: Week plan preview with glassmorphism design, auto-scrolling day
/// carousel, staggered meal card entrance, and animated kcal counter.
class PlanPreviewStep extends StatefulWidget {
  const PlanPreviewStep({
    required this.weekPlan,
    required this.isLoading,
    required this.showMoveDialog,
    required this.movingMeal,
    required this.moveTargetDays,
    required this.onMoveMealClick,
    required this.onSelectTargetDay,
    required this.onDismissMoveDialog,
    this.showReplaceDialog = false,
    this.replacingMeal,
    this.replacementCandidates = const [],
    this.otherOccurrencesCount = 0,
    this.onReplaceMealClick,
    this.onSelectReplacement,
    this.onDismissReplaceDialog,
    super.key,
  });

  final WeekPlanWithDays? weekPlan;
  final bool isLoading;
  final bool showMoveDialog;
  final MealWithRecipe? movingMeal;
  final List<DayPlanWithMeals> moveTargetDays;
  final void Function(MealWithRecipe meal, int sourceDayPlanId) onMoveMealClick;
  final ValueChanged<int> onSelectTargetDay;
  final VoidCallback onDismissMoveDialog;
  final bool showReplaceDialog;
  final MealWithRecipe? replacingMeal;
  final List<Recipe> replacementCandidates;
  final int otherOccurrencesCount;
  final ValueChanged<MealWithRecipe>? onReplaceMealClick;
  final void Function(Recipe recipe, bool replaceAll)? onSelectReplacement;
  final VoidCallback? onDismissReplaceDialog;

  @override
  State<PlanPreviewStep> createState() => _PlanPreviewStepState();
}

class _PlanPreviewStepState extends State<PlanPreviewStep>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;

  // Tracks direction so the slide can go left or right accordingly.
  bool _isGoingForward = true;

  /// ID of the meal whose recipe preview is expanded inline, or null.
  int? _expandedMealId;

  final ScrollController _tabScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
  }

  void _onManualTabTap(int index) {
    _selectTab(index, isAutoScroll: false);
  }

  void _selectTab(int index, {required bool isAutoScroll}) {
    if (!mounted) return;
    setState(() {
      _isGoingForward = index > _selectedTabIndex ||
          // wrap-around case: going from last to first is "forward"
          (index == 0 && _selectedTabIndex == (_sortedDays.length - 1));
      _selectedTabIndex = index;
    });
    _scrollToTab(index);
  }

  // Smoothly centers the active pill chip inside the horizontal scroll view.
  void _scrollToTab(int index) {
    if (!_tabScrollController.hasClients) return;
    // Approximate chip width + padding to center it.
    const chipWidth = 72.0;
    final viewportWidth =
        _tabScrollController.position.viewportDimension;
    final targetOffset =
        (chipWidth * index) - (viewportWidth / 2) + (chipWidth / 2);
    _tabScrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _tabScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  List<DayPlanWithMeals> get _sortedDays {
    if (widget.weekPlan == null) return const [];
    return List<DayPlanWithMeals>.from(widget.weekPlan!.days)
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isLoading || widget.weekPlan == null) {
      return const GenerationLoadingView();
    }

    final sortedDays = _sortedDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientTitle(
          'Votre plan de la semaine',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Verifiez et ajustez les repas si besoin.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal pill-chip day selector.
        SizedBox(
          height: 48,
          child: ListView.separated(
            controller: _tabScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: sortedDays.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final day = sortedDays[index];
              final dayName = _shortDayName(
                AppDateUtils.getDayOfWeekFrench(day.dayPlan.dayOfWeek),
              );
              return PillChip(
                label: dayName,
                selected: index == _selectedTabIndex,
                onTap: () => _onManualTabTap(index),
                // Palm tree icon marks free days without an emoji character.
                icon: day.dayPlan.isFreeDay
                    ? const Icon(Icons.beach_access_outlined)
                    : null,
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Day content with slide transition.
        Expanded(
          child: AnimatedSwitcher(
            duration: _kSlideDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              // Slide from right when going forward, from left when going back.
              final begin =
                  _isGoingForward ? const Offset(1.0, 0) : const Offset(-1.0, 0);
              final tween = Tween(begin: begin, end: Offset.zero);
              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: KeyedSubtree(
              // Key change triggers the AnimatedSwitcher transition.
              key: ValueKey<int>(_selectedTabIndex),
              child: _buildDayContent(
                sortedDays.elementAtOrNull(_selectedTabIndex),
              ),
            ),
          ),
        ),

      ],
    );
  }

  // Abbreviate "Lundi" -> "Lun", "Mardi" -> "Mar", etc.
  String _shortDayName(String fullName) {
    if (fullName.length <= 3) return fullName;
    return fullName.substring(0, 3);
  }

  Widget _buildDayContent(DayPlanWithMeals? day) {
    if (day == null) return const SizedBox.shrink();
    if (day.dayPlan.isFreeDay) return const _FreeDayContent();

    final mealOrder = [
      MealType.breakfast.name.toUpperCase(),
      MealType.lunch.name.toUpperCase(),
      MealType.dinner.name.toUpperCase(),
      MealType.snack.name.toUpperCase(),
    ];
    final sortedMeals = List<MealWithRecipe>.from(day.meals)
      ..sort((a, b) =>
          mealOrder.indexOf(a.meal.mealType) -
          mealOrder.indexOf(b.meal.mealType));

    // Daily kcal total for the animated counter.
    final totalKcal = sortedMeals.fold<int>(
      0,
      (sum, mwr) =>
          sum + (mwr.recipe.caloriesPerServing * mwr.meal.servings).round(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animated kcal counter with scale-pop on day change.
        TweenAnimationBuilder<double>(
          key: ValueKey<int>(totalKcal),
          tween: Tween(begin: 0.8, end: 1.0),
          duration: _kKcalPopDuration,
          curve: Curves.elasticOut,
          builder: (context, scale, child) => Transform.scale(
            scale: scale,
            child: child,
          ),
          child: _KcalSummaryRow(totalKcal: totalKcal),
        ),
        const SizedBox(height: 10),

        Expanded(
          child: ListView.separated(
            itemCount: sortedMeals.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final mwr = sortedMeals[index];
              // Staggered entrance: each card fades in + slides up with offset.
              final staggerDelay = _kStaggerStep * index;
              return TweenAnimationBuilder<double>(
                // Re-trigger when day changes via the parent KeyedSubtree.
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(
                  milliseconds:
                      _kSlideDuration.inMilliseconds + staggerDelay.inMilliseconds,
                ),
                curve: Interval(
                  staggerDelay.inMilliseconds /
                      (_kSlideDuration.inMilliseconds +
                          _kStaggerStep.inMilliseconds *
                              (sortedMeals.length - 1)),
                  1.0,
                  curve: Curves.easeOut,
                ),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                ),
                child: _MealPreviewCard(
                  mealWithRecipe: mwr,
                  isExpanded: _expandedMealId == mwr.meal.id,
                  onMoveClick: () =>
                      widget.onMoveMealClick(mwr, day.dayPlan.id),
                  onReplaceClick: () => widget.onReplaceMealClick?.call(mwr),
                  onRecipeClick: () => setState(() {
                    _expandedMealId = _expandedMealId == mwr.meal.id
                        ? null
                        : mwr.meal.id;
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

/// Small summary row showing total kcal for the day.
class _KcalSummaryRow extends StatelessWidget {
  const _KcalSummaryRow({required this.totalKcal});

  final int totalKcal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.local_fire_department_rounded,
          size: 18,
          color: AppColors.accentAmber,
        ),
        const SizedBox(width: 6),
        Text(
          '$totalKcal kcal',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.accentAmber,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'aujourd\'hui',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _FreeDayContent extends StatelessWidget {
  const _FreeDayContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.beach_access_outlined,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Jour libre',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Pas de regime prevu ce jour',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealPreviewCard extends StatelessWidget {
  const _MealPreviewCard({
    required this.mealWithRecipe,
    required this.isExpanded,
    required this.onMoveClick,
    required this.onReplaceClick,
    required this.onRecipeClick,
  });

  final MealWithRecipe mealWithRecipe;
  final bool isExpanded;
  final VoidCallback onMoveClick;
  final VoidCallback onReplaceClick;
  final VoidCallback onRecipeClick;

  Color _mealColor(String mealType) {
    return switch (mealType) {
      'BREAKFAST' => AppColors.breakfastColor,
      'LUNCH' => AppColors.lunchColor,
      'DINNER' => AppColors.dinnerColor,
      'SNACK' => AppColors.snackColor,
      _ => AppColors.emeraldPrimary,
    };
  }

  String _mealLabel(String mealType) {
    return switch (mealType) {
      'BREAKFAST' => MealType.breakfast.displayName,
      'LUNCH' => MealType.lunch.displayName,
      'DINNER' => MealType.dinner.displayName,
      'SNACK' => MealType.snack.displayName,
      _ => '',
    };
  }

  // Each meal type gets a distinct leading icon to aid recognition at a glance.
  IconData _mealIcon(String mealType) {
    return switch (mealType) {
      'BREAKFAST' => Icons.wb_sunny_outlined,
      'LUNCH' => Icons.restaurant_outlined,
      'DINNER' => Icons.nightlight_round_outlined,
      'SNACK' => Icons.cookie_outlined,
      _ => Icons.food_bank_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mealType = mealWithRecipe.meal.mealType;
    final color = _mealColor(mealType);
    final label = _mealLabel(mealType);
    final icon = _mealIcon(mealType);
    final calories = (mealWithRecipe.recipe.caloriesPerServing *
            mealWithRecipe.meal.servings)
        .round();

    final recipe = mealWithRecipe.recipe;
    final difficultyLabel = switch (recipe.difficulty) {
      'EASY' => 'Facile',
      'MEDIUM' => 'Moyen',
      'HARD' => 'Difficile',
      _ => recipe.difficulty,
    };
    final totalTime = recipe.prepTimeMinutes + recipe.cookTimeMinutes;

    return GlassCard(
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: onRecipeClick,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      recipe.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$calories kcal',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: onReplaceClick,
                iconSize: 20,
                tooltip: 'Remplacer',
                constraints:
                    const BoxConstraints.tightFor(width: 36, height: 36),
                icon: Icon(
                  Icons.autorenew,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                onPressed: onMoveClick,
                iconSize: 20,
                tooltip: 'Deplacer',
                constraints:
                    const BoxConstraints.tightFor(width: 36, height: 36),
                icon: Icon(
                  Icons.swap_horiz,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          // Inline expandable recipe preview
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Text(
                    recipe.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _MacroItem(
                        label: 'Calories',
                        value: '${recipe.caloriesPerServing}',
                        unit: 'kcal',
                        color: AppColors.emeraldPrimary,
                      ),
                      const SizedBox(width: 16),
                      _MacroItem(
                        label: 'Proteines',
                        value: recipe.proteinGrams.round().toString(),
                        unit: 'g',
                        color: AppColors.macroProtein,
                      ),
                      const SizedBox(width: 16),
                      _MacroItem(
                        label: 'Glucides',
                        value: recipe.carbsGrams.round().toString(),
                        unit: 'g',
                        color: AppColors.macroCarbs,
                      ),
                      const SizedBox(width: 16),
                      _MacroItem(
                        label: 'Lipides',
                        value: recipe.fatGrams.round().toString(),
                        unit: 'g',
                        color: AppColors.macroFat,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '$totalTime min (${recipe.prepTimeMinutes} prep + ${recipe.cookTimeMinutes} cuisson)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Difficulte : $difficultyLabel',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  const _MacroItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          unit,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Move meal dialog - glassmorphism bottom sheet overlay.
class MoveMealDialog extends StatelessWidget {
  const MoveMealDialog({
    required this.mealName,
    required this.mealType,
    required this.targetDays,
    required this.onSelectDay,
    required this.onDismiss,
    super.key,
  });

  final String mealName;
  final String mealType;
  final List<DayPlanWithMeals> targetDays;
  final ValueChanged<int> onSelectDay;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return _GlassBottomSheet(
      onDismiss: onDismiss,
      child: _MoveMealContent(
        mealName: mealName,
        mealType: mealType,
        targetDays: targetDays,
        onSelectDay: onSelectDay,
        onDismiss: onDismiss,
      ),
    );
  }
}

class _MoveMealContent extends StatelessWidget {
  const _MoveMealContent({
    required this.mealName,
    required this.mealType,
    required this.targetDays,
    required this.onSelectDay,
    required this.onDismiss,
  });

  final String mealName;
  final String mealType;
  final List<DayPlanWithMeals> targetDays;
  final ValueChanged<int> onSelectDay;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.emeraldPrimary, AppColors.emeraldDark],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deplacer le repas',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    mealName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.emeraldPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Echanger avec le meme type de repas :',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ...targetDays.map((dayWithMeals) {
          final dayName = AppDateUtils.getDayOfWeekFrench(
            dayWithMeals.dayPlan.dayOfWeek,
          );
          final sameMeal = dayWithMeals.meals
              .where((m) => m.meal.mealType == mealType)
              .firstOrNull;
          final targetRecipeName = sameMeal?.recipe.name ?? 'Aucun repas';

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelectDay(dayWithMeals.dayPlan.id),
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.emeraldPrimary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              dayName.substring(0, 3),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.emeraldPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dayName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                targetRecipeName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        _GlassCancelButton(onPressed: onDismiss),
      ],
    );
  }
}

/// Replace recipe dialog - glassmorphism bottom sheet overlay.
class ReplaceRecipeDialog extends StatefulWidget {
  const ReplaceRecipeDialog({
    required this.currentRecipeName,
    required this.candidates,
    required this.otherOccurrencesCount,
    required this.onSelectReplacement,
    required this.onDismiss,
    super.key,
  });

  final String currentRecipeName;
  final List<Recipe> candidates;
  final int otherOccurrencesCount;
  final void Function(Recipe recipe, bool replaceAll) onSelectReplacement;
  final VoidCallback onDismiss;

  @override
  State<ReplaceRecipeDialog> createState() => _ReplaceRecipeDialogState();
}

class _ReplaceRecipeDialogState extends State<ReplaceRecipeDialog> {
  Recipe? _selectedRecipe;
  bool _showConfirmAll = false;

  @override
  Widget build(BuildContext context) {
    return _GlassBottomSheet(
      onDismiss: widget.onDismiss,
      child: _showConfirmAll && _selectedRecipe != null
          ? _buildConfirmAll(context)
          : _buildRecipeList(context),
    );
  }

  Widget _buildConfirmAll(BuildContext context) {
    final theme = Theme.of(context);
    final count = widget.otherOccurrencesCount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade400,
                Colors.orange.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.info_outline, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 16),
        Text(
          'Remplacer partout ?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '"${widget.currentRecipeName}" apparait aussi $count '
          'autre${count > 1 ? 's' : ''} jour${count > 1 ? 's' : ''}.\n'
          'Remplacer partout par "${_selectedRecipe!.name}" ?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _GlassActionButton(
                label: 'Ce jour uniquement',
                onPressed: () {
                  widget.onSelectReplacement(_selectedRecipe!, false);
                  setState(() {
                    _showConfirmAll = false;
                    _selectedRecipe = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GradientActionButton(
                label: 'Tout remplacer',
                onPressed: () {
                  widget.onSelectReplacement(_selectedRecipe!, true);
                  setState(() {
                    _showConfirmAll = false;
                    _selectedRecipe = null;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.emeraldPrimary, AppColors.emeraldDark],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choisir une recette',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Remplacer "${widget.currentRecipeName}"',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.candidates.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Aucune recette compatible disponible.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.candidates.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final recipe = widget.candidates[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (widget.otherOccurrencesCount > 0) {
                        setState(() {
                          _selectedRecipe = recipe;
                          _showConfirmAll = true;
                        });
                      } else {
                        widget.onSelectReplacement(recipe, false);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${recipe.caloriesPerServing} kcal',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.emeraldPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 12),
        _GlassCancelButton(onPressed: widget.onDismiss),
      ],
    );
  }
}

// ── Glass bottom sheet wrapper ─────────────────────────────────────────────

class _GlassBottomSheet extends StatelessWidget {
  const _GlassBottomSheet({
    required this.child,
    required this.onDismiss,
  });

  final Widget child;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.3),
        child: GestureDetector(
          onTap: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared dialog buttons ──────────────────────────────────────────────────

class _GlassCancelButton extends StatelessWidget {
  const _GlassCancelButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Text(
                  'Annuler',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassActionButton extends StatelessWidget {
  const _GlassActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  const _GradientActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [AppColors.emeraldPrimary, AppColors.emeraldDark],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
