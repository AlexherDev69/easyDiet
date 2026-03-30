import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gradient_card.dart';
import 'macro_radial_chart.dart';

/// Main hero card showing animated circular calorie progress + macro donut.
class CaloriesHeroCard extends StatelessWidget {
  const CaloriesHeroCard({
    required this.todayCalories,
    required this.dailyTarget,
    required this.isFreeDay,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    super.key,
  });

  final int todayCalories;
  final int dailyTarget;
  final bool isFreeDay;
  final double protein;
  final double carbs;
  final double fat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = dailyTarget > 0
        ? (todayCalories / dailyTarget).clamp(0.0, 1.0)
        : 0.0;

    return GradientCard(
      gradientColors: [
        AppColors.emeraldPrimary.withValues(alpha: 0.08),
        AppColors.emeraldLight.withValues(alpha: 0.12),
      ],
      contentPadding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Repas du jour',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isFreeDay)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Jour libre',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Animated circular progress.
          // ValueKey(progress) forces a full restart from 0 each time the
          // target changes (e.g. after marking a meal consumed), so every
          // update produces a visible animated fill rather than a no-op.
          SizedBox(
            width: 160,
            height: 160,
            child: TweenAnimationBuilder<double>(
              key: ValueKey(progress),
              tween: Tween(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, animatedProgress, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: animatedProgress,
                        strokeWidth: 14,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.emeraldPrimary,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated counter — tabular figures prevent digit
                        // width changes from making the layout jump.
                        _AnimatedCalorieCounter(
                          targetValue: todayCalories,
                          style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ) ??
                              const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                        ),
                        Text(
                          '/ $dailyTarget kcal',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // Macro donut chart replaces the linear bars for a more visual feel
          if (protein + carbs + fat > 0) ...[
            const SizedBox(height: 12),
            MacroRadialChart(
              protein: protein,
              carbs: carbs,
              fat: fat,
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated integer counter that counts up to the target value.
class _AnimatedCalorieCounter extends StatelessWidget {
  const _AnimatedCalorieCounter({
    required this.targetValue,
    required this.style,
  });

  final int targetValue;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    // ValueKey(targetValue) restarts the count-up animation from 0 each time
    // the calorie total changes rather than interpolating from the old value.
    return TweenAnimationBuilder<int>(
      key: ValueKey(targetValue),
      tween: IntTween(begin: 0, end: targetValue),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text('$value', style: style);
      },
    );
  }
}

