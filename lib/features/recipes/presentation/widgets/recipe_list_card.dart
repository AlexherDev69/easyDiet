import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/models/recipe_with_details.dart';
import '../../../../shared/widgets/solid_card.dart';

/// Single recipe card in the list.
class RecipeListCard extends StatelessWidget {
  const RecipeListCard({
    required this.recipe,
    required this.categoryColor,
    required this.onTap,
    super.key,
  });

  final RecipeWithDetails recipe;
  final Color categoryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = recipe.recipe;
    final totalTime = r.prepTimeMinutes + r.cookTimeMinutes;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SolidCard(
        elevation: 2,
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        child: Row(
          children: [
            // Color accent bar
            Container(
              width: 4,
              height: 90,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + difficulty
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            r.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _DifficultyBadge(difficulty: r.difficulty),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      r.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Calories + time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${r.caloriesPerServing} kcal/portion',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$totalTime min',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
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

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (difficulty) {
      'EASY' => ('Facile', AppColors.emeraldPrimary),
      'MEDIUM' => ('Moyen', AppColors.accentAmber),
      'HARD' => ('Difficile', AppColors.errorRed),
      _ => (difficulty, AppColors.gray500),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
