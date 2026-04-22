import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/models/day_plan_with_meals.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../shared/widgets/glass_dialog.dart';

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

    return GlassDialogContent(
      icon: Icons.swap_horiz,
      title: 'Deplacer le repas',
      subtitle: movingMeal.recipe.name,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...targetDays.map((dayWithMeals) {
            final date =
                AppDateUtils.fromEpochMillis(dayWithMeals.dayPlan.date);
            final dayName = AppDateUtils.getDayOfWeekFrench(date.weekday);
            // 3-letter abbreviation: "Lundi" -> "Lun", "Mercredi" -> "Mer"
            final dayAbbrev = dayName.length >= 3
                ? dayName.substring(0, 3)
                : dayName;

            final sameMeal = dayWithMeals.meals
                .where((m) => m.meal.mealType == movingMeal.meal.mealType)
                .firstOrNull;
            final targetRecipeName = sameMeal?.recipe.name ?? 'Aucun repas';

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassDialogListTile(
                onTap: () => onSelectDay(dayWithMeals.dayPlan.id),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    dayAbbrev,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.emeraldPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  dayName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  targetRecipeName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          GlassDialogButton(label: 'Annuler', onPressed: onDismiss),
        ],
      ),
    );
  }
}
