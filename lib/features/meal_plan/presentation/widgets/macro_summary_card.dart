import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/local/models/meal_with_recipe.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Daily macro summary card: consumed vs target kcal + 3 macro bars.
class MacroSummaryCard extends StatelessWidget {
  const MacroSummaryCard({required this.meals, super.key});

  final List<MealWithRecipe> meals;

  @override
  Widget build(BuildContext context) {
    final consumedKcal = meals.fold<int>(
      0,
      (sum, m) => sum +
          (m.meal.isConsumed
              ? (m.recipe.caloriesPerServing * m.meal.servings).round()
              : 0),
    );
    final targetKcal = meals.fold<int>(
      0,
      (sum, m) =>
          sum + (m.recipe.caloriesPerServing * m.meal.servings).round(),
    );

    final protein = meals.fold<double>(
      0,
      (sum, m) => sum +
          (m.meal.isConsumed ? m.recipe.proteinGrams * m.meal.servings : 0),
    );
    final carbs = meals.fold<double>(
      0,
      (sum, m) => sum +
          (m.meal.isConsumed ? m.recipe.carbsGrams * m.meal.servings : 0),
    );
    final fat = meals.fold<double>(
      0,
      (sum, m) => sum +
          (m.meal.isConsumed ? m.recipe.fatGrams * m.meal.servings : 0),
    );

    final proteinTarget =
        targetKcal > 0 ? ((targetKcal * 0.25) / 4).round() : 0;
    final carbsTarget =
        targetKcal > 0 ? ((targetKcal * 0.45) / 4).round() : 0;
    final fatTarget = targetKcal > 0 ? ((targetKcal * 0.30) / 9).round() : 0;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resume macro',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text.rich(
                TextSpan(
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  children: [
                    TextSpan(
                      text: '$consumedKcal',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    TextSpan(text: ' / $targetKcal kcal'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MacroBar(
            label: 'Proteines',
            value: protein,
            target: proteinTarget,
            color: const Color(0xFFF43F5E),
          ),
          const SizedBox(height: 10),
          _MacroBar(
            label: 'Glucides',
            value: carbs,
            target: carbsTarget,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 10),
          _MacroBar(
            label: 'Lipides',
            value: fat,
            target: fatTarget,
            color: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  final String label;
  final double value;
  final int target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    final duration =
        reducedMotion ? Duration.zero : const Duration(milliseconds: 700);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animValue, _) {
        final ratio = target > 0 ? (animValue / target).clamp(0.0, 1.0) : 0.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '${animValue.round()}g / ${target}g',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                  ),
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(height: 6, color: color),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
