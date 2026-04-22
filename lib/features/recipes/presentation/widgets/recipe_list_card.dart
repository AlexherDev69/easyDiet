import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/models/recipe_with_details.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/recipe_thumb.dart';

/// Single recipe card in the list — glassmorphism style.
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
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: 20,
        onTap: onTap,
        child: Row(
          children: [
            // Colored left accent bar — sits flush inside the glass card
            Container(
              width: 4,
              height: 96,
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
              child: RecipeThumb(
                imagePath: r.imagePath,
                size: 72,
                radius: 14,
                fallbackColor: categoryColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + difficulty badge
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

    // Semi-transparent glass tint badge — lighter than the old solid tint
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
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
