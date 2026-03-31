import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../shared/widgets/solid_card.dart';
import '../../../onboarding/domain/models/meal_type.dart';

/// Card for a single meal in the plan with swap, move, consume actions.
class MealCard extends StatelessWidget {
  const MealCard({
    required this.mealWithRecipe,
    required this.onSwap,
    required this.onMove,
    required this.onClick,
    required this.onToggleConsumed,
    super.key,
  });

  final MealWithRecipe mealWithRecipe;
  final VoidCallback onSwap;
  final VoidCallback onMove;
  final VoidCallback onClick;
  final VoidCallback onToggleConsumed;

  MealType? get _mealType {
    try {
      return MealType.values.firstWhere(
        (t) => t.name.toUpperCase() == mealWithRecipe.meal.mealType,
      );
    } catch (_) {
      return null;
    }
  }

  String get _mealTypeName =>
      _mealType?.displayName ?? mealWithRecipe.meal.mealType;

  Color get _mealTypeColor {
    switch (_mealType) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isConsumed = mealWithRecipe.meal.isConsumed;
    final recipe = mealWithRecipe.recipe;
    final servings = mealWithRecipe.meal.servings;
    final totalCalories = (recipe.caloriesPerServing * servings).round();

    // Consumed meals use a muted card background so text stays readable.
    final consumedBackgroundColor = theme.colorScheme.surfaceContainerHighest;

    return SolidCard(
      contentPadding: EdgeInsets.zero,
      onTap: onClick,
      backgroundColor: isConsumed ? consumedBackgroundColor : null,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Color bar on the left
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: _mealTypeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal type + servings + consumed icon
                    Row(
                      children: [
                        Text(
                          _mealTypeName,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _mealTypeColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentAmber.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${QuantityFormatter.formatServings(servings)} portions',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentAmber,
                            ),
                          ),
                        ),
                        AnimatedScale(
                          scale: isConsumed ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.elasticOut,
                          child: isConsumed
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: AppColors.emeraldPrimary,
                                    size: 18,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Recipe name — grey text when consumed to keep readability.
                    Text(
                      recipe.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isConsumed ? FontWeight.normal : FontWeight.bold,
                        color: isConsumed
                            ? theme.colorScheme.onSurfaceVariant
                            : null,
                        decoration:
                            isConsumed ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Calories + macros + actions
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '$totalCalories kcal',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _mealTypeColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _MacroDot(
                                color: AppColors.macroProtein,
                                value: (recipe.proteinGrams * servings).round(),
                              ),
                              const SizedBox(width: 6),
                              _MacroDot(
                                color: AppColors.macroCarbs,
                                value: (recipe.carbsGrams * servings).round(),
                              ),
                              const SizedBox(width: 6),
                              _MacroDot(
                                color: AppColors.macroFat,
                                value: (recipe.fatGrams * servings).round(),
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: isConsumed,
                          onChanged: (_) => onToggleConsumed(),
                          activeColor: AppColors.emeraldPrimary,
                        ),
                        PopupMenuButton<String>(
                          iconSize: 20,
                          icon: Icon(
                            Icons.more_vert,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          tooltip: 'Actions',
                          onSelected: (value) {
                            if (value == 'move') onMove();
                            if (value == 'swap') onSwap();
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'move',
                              child: ListTile(
                                leading: Icon(Icons.move_down),
                                title: Text('Deplacer'),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'swap',
                              child: ListTile(
                                leading: Icon(Icons.find_replace),
                                title: Text('Remplacer'),
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroDot extends StatelessWidget {
  const _MacroDot({required this.color, required this.value});

  final Color color;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          '${value}g',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
