import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/database.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../data/local/models/week_plan_with_days.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../domain/models/meal_type.dart';

/// Step 5: Week plan preview with move/replace dialogs.
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
  Recipe? _previewRecipe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isLoading || widget.weekPlan == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Preparation de votre plan...',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final sortedDays = List<DayPlanWithMeals>.from(widget.weekPlan!.days)
      ..sort((a, b) => a.dayPlan.date.compareTo(b.dayPlan.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Votre plan de la semaine',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          'Verifiez et ajustez les repas si besoin.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),

        // Day tabs
        DefaultTabController(
          length: sortedDays.length,
          child: Expanded(
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                  onTap: (i) => setState(() => _selectedTabIndex = i),
                  tabs: sortedDays.map((day) {
                    final dayName = AppDateUtils.getDayOfWeekFrench(
                      day.dayPlan.dayOfWeek,
                    );
                    return Tab(
                      text: day.dayPlan.isFreeDay
                          ? '$dayName \u{1F334}'
                          : dayName,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildDayContent(
                    sortedDays.elementAtOrNull(_selectedTabIndex),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Dialogs
        if (_previewRecipe != null)
          _RecipePreviewDialog(
            recipe: _previewRecipe!,
            onDismiss: () => setState(() => _previewRecipe = null),
          ),
      ],
    );
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

    return ListView.separated(
      itemCount: sortedMeals.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final mwr = sortedMeals[index];
        return _MealPreviewCard(
          mealWithRecipe: mwr,
          onMoveClick: () =>
              widget.onMoveMealClick(mwr, day.dayPlan.id),
          onReplaceClick: () => widget.onReplaceMealClick?.call(mwr),
          onRecipeClick: () => setState(() => _previewRecipe = mwr.recipe),
        );
      },
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────

class _FreeDayContent extends StatelessWidget {
  const _FreeDayContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('\u{1F334}', style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('Jour libre',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
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
    required this.onMoveClick,
    required this.onReplaceClick,
    required this.onRecipeClick,
  });

  final MealWithRecipe mealWithRecipe;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _mealColor(mealWithRecipe.meal.mealType);
    final label = _mealLabel(mealWithRecipe.meal.mealType);
    final calories = (mealWithRecipe.recipe.caloriesPerServing *
            mealWithRecipe.meal.servings)
        .round();

    return SolidCard(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      cornerRadius: 12,
      contentPadding: const EdgeInsets.all(12),
      onTap: onRecipeClick,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  mealWithRecipe.recipe.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$calories kcal',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onReplaceClick,
            iconSize: 20,
            tooltip: 'Remplacer',
            constraints: const BoxConstraints.tightFor(
              width: 36,
              height: 36,
            ),
            icon: Icon(
              Icons.autorenew,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          IconButton(
            onPressed: onMoveClick,
            iconSize: 20,
            tooltip: 'Deplacer',
            constraints: const BoxConstraints.tightFor(
              width: 36,
              height: 36,
            ),
            icon: Icon(
              Icons.swap_horiz,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipePreviewDialog extends StatelessWidget {
  const _RecipePreviewDialog({
    required this.recipe,
    required this.onDismiss,
  });

  final Recipe recipe;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final difficultyLabel = switch (recipe.difficulty) {
      'EASY' => 'Facile',
      'MEDIUM' => 'Moyen',
      'HARD' => 'Difficile',
      _ => recipe.difficulty,
    };
    final totalTime = recipe.prepTimeMinutes + recipe.cookTimeMinutes;

    return AlertDialog(
      title: Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MacroItem(
                  label: 'Calories',
                  value: '${recipe.caloriesPerServing}',
                  unit: 'kcal',
                  color: AppColors.emeraldPrimary,
                ),
              ),
              Expanded(
                child: _MacroItem(
                  label: 'Proteines',
                  value: recipe.proteinGrams.round().toString(),
                  unit: 'g',
                  color: AppColors.macroProtein,
                ),
              ),
              Expanded(
                child: _MacroItem(
                  label: 'Glucides',
                  value: recipe.carbsGrams.round().toString(),
                  unit: 'g',
                  color: AppColors.macroCarbs,
                ),
              ),
              Expanded(
                child: _MacroItem(
                  label: 'Lipides',
                  value: recipe.fatGrams.round().toString(),
                  unit: 'g',
                  color: AppColors.macroFat,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '$totalTime min (${recipe.prepTimeMinutes} prep + ${recipe.cookTimeMinutes} cuisson)',
                  style: theme.textTheme.bodySmall,
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
          if (recipe.isBatchFriendly) ...[
            const SizedBox(height: 4),
            Text(
              'Compatible batch cooking',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: onDismiss, child: const Text('Fermer')),
      ],
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
        Text(unit, style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        )),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        )),
      ],
    );
  }
}

/// Move meal dialog — shown when user taps the swap icon.
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
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Deplacer le repas',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Echanger "$mealName" avec le meme type de repas d\'un autre jour :',
            style: theme.textTheme.bodyMedium,
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

            return SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => onSelectDay(dayWithMeals.dayPlan.id),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dayName,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        targetRecipeName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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
        TextButton(onPressed: onDismiss, child: const Text('Annuler')),
      ],
    );
  }
}

/// Replace recipe dialog — shown when user taps the replace icon.
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
    final theme = Theme.of(context);

    if (_showConfirmAll && _selectedRecipe != null) {
      final count = widget.otherOccurrencesCount;
      return AlertDialog(
        title: const Text('Remplacer partout ?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          '"${widget.currentRecipeName}" apparait aussi $count '
          'autre${count > 1 ? 's' : ''} jour${count > 1 ? 's' : ''}. '
          'Remplacer partout par "${_selectedRecipe!.name}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSelectReplacement(_selectedRecipe!, false);
              setState(() {
                _showConfirmAll = false;
                _selectedRecipe = null;
              });
            },
            child: const Text('Ce jour uniquement'),
          ),
          TextButton(
            onPressed: () {
              widget.onSelectReplacement(_selectedRecipe!, true);
              setState(() {
                _showConfirmAll = false;
                _selectedRecipe = null;
              });
            },
            child: const Text('Tout remplacer'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Choisir une recette',
          style: TextStyle(fontWeight: FontWeight.bold)),
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
              Flexible(
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
                              child: Text(recipe.name),
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
        TextButton(onPressed: widget.onDismiss, child: const Text('Annuler')),
      ],
    );
  }
}

/// Helper for rounded corner shape shorthand.
RoundedRectangleBorder roundedCornerShape(double radius) =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
