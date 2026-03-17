import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../../onboarding/domain/models/meal_type.dart';

/// List of meals for the selected day with toggle consumed checkbox.
class DayMealsSection extends StatelessWidget {
  const DayMealsSection({
    required this.meals,
    required this.isFreeDay,
    required this.onToggleConsumed,
    super.key,
  });

  final List<MealWithRecipe> meals;
  final bool isFreeDay;
  final void Function(int mealId, bool currentlyConsumed) onToggleConsumed;

  static const _mealOrder = [
    MealType.breakfast,
    MealType.lunch,
    MealType.snack,
    MealType.dinner,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SolidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Programme du jour',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (isFreeDay)
            Text(
              'Jour libre',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else if (meals.isEmpty)
            Text(
              'Aucun repas prevu',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            ..._buildSortedMeals(theme),
        ],
      ),
    );
  }

  List<Widget> _buildSortedMeals(ThemeData theme) {
    final sorted = List.of(meals)
      ..sort((a, b) {
        final aIndex = _mealOrder.indexWhere(
          (t) => t.name.toUpperCase() == a.meal.mealType,
        );
        final bIndex = _mealOrder.indexWhere(
          (t) => t.name.toUpperCase() == b.meal.mealType,
        );
        return aIndex.compareTo(bIndex);
      });

    final widgets = <Widget>[];
    for (var i = 0; i < sorted.length; i++) {
      widgets.add(
        _DashboardMealRow(
          mealWithRecipe: sorted[i],
          onToggleConsumed: () => onToggleConsumed(
            sorted[i].meal.id,
            sorted[i].meal.isConsumed,
          ),
        ),
      );
      if (i < sorted.length - 1) {
        widgets.add(Divider(
          height: 8,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ));
      }
    }
    return widgets;
  }
}

class _DashboardMealRow extends StatelessWidget {
  const _DashboardMealRow({
    required this.mealWithRecipe,
    required this.onToggleConsumed,
  });

  final MealWithRecipe mealWithRecipe;
  final VoidCallback onToggleConsumed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isConsumed = mealWithRecipe.meal.isConsumed;
    final mealType = _parseMealType(mealWithRecipe.meal.mealType);
    final mealTypeName = mealType?.displayName ?? mealWithRecipe.meal.mealType;
    final mealTypeColor = _mealColor(mealType);
    final totalCalories =
        (mealWithRecipe.recipe.caloriesPerServing * mealWithRecipe.meal.servings)
            .round();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onToggleConsumed,
            constraints: const BoxConstraints(maxWidth: 36, maxHeight: 36),
            padding: EdgeInsets.zero,
            iconSize: 22,
            icon: Icon(
              isConsumed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isConsumed
                  ? AppColors.emeraldPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealTypeName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: mealTypeColor,
                  ),
                ),
                Text(
                  mealWithRecipe.recipe.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        isConsumed ? FontWeight.normal : FontWeight.w600,
                    decoration:
                        isConsumed ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$totalCalories kcal',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isConsumed
                  ? AppColors.emeraldPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  MealType? _parseMealType(String raw) {
    try {
      return MealType.values.firstWhere(
        (t) => t.name.toUpperCase() == raw,
      );
    } catch (_) {
      return null;
    }
  }

  Color _mealColor(MealType? type) {
    switch (type) {
      case MealType.breakfast:
        return AppColors.breakfastColor;
      case MealType.lunch:
        return AppColors.lunchColor;
      case MealType.dinner:
        return AppColors.dinnerColor;
      case MealType.snack:
        return AppColors.snackColor;
      case null:
        return AppColors.emeraldPrimary;
    }
  }
}
