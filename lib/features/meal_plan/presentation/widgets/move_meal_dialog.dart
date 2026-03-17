import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';

/// Dialog to move a meal to a different day.
class MoveMealDialog extends StatelessWidget {
  const MoveMealDialog({
    required this.movingMeal,
    required this.targetDays,
    required this.onSelectDay,
    required this.onDismiss,
    super.key,
  });

  final MealWithRecipe movingMeal;
  final List<DayPlanWithMeals> targetDays;
  final void Function(int dayPlanId) onSelectDay;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text(
        'Deplacer le repas',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Echanger "${movingMeal.recipe.name}" avec le meme type '
            "de repas d'un autre jour :",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ...targetDays.map((dayWithMeals) {
            final date =
                AppDateUtils.fromEpochMillis(dayWithMeals.dayPlan.date);
            final dayName = AppDateUtils.getDayOfWeekFrench(date.weekday);
            final sameMeal = dayWithMeals.meals
                .where(
                    (m) => m.meal.mealType == movingMeal.meal.mealType)
                .firstOrNull;
            final targetRecipeName =
                sameMeal?.recipe.name ?? 'Aucun repas';

            return TextButton(
              onPressed: () => onSelectDay(dayWithMeals.dayPlan.id),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              ),
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
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
