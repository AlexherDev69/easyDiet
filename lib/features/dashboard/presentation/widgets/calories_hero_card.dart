import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/radial_macro.dart';

/// Dashboard "Objectif du jour" hero card.
///
/// Port of the React mockup: gradient title + status pill, radial macro donut
/// paired with 3 linear macro bars, and an integrated hydration section.
class CaloriesHeroCard extends StatelessWidget {
  const CaloriesHeroCard({
    required this.todayCalories,
    required this.dailyTarget,
    required this.isFreeDay,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.waterTargetMl,
    super.key,
  });

  final int todayCalories;
  final int dailyTarget;
  final bool isFreeDay;
  final double protein;
  final double carbs;
  final double fat;
  final int waterTargetMl;

  // Macro targets: 25% P / 45% C / 30% F of daily calories, divided by
  // 4/4/9 kcal/g respectively.
  int get _proteinTarget =>
      dailyTarget > 0 ? ((dailyTarget * 0.25) / 4).round() : 0;
  int get _carbsTarget =>
      dailyTarget > 0 ? ((dailyTarget * 0.45) / 4).round() : 0;
  int get _fatTarget =>
      dailyTarget > 0 ? ((dailyTarget * 0.30) / 9).round() : 0;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(gradient: gradient, isFreeDay: isFreeDay),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RadialMacro(
                protein: protein,
                carbs: carbs,
                fat: fat,
                cal: todayCalories,
                target: dailyTarget,
                size: 140,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  children: [
                    _MacroBar(
                      color: const Color(0xFFF43F5E),
                      label: 'Proteines',
                      value: protein,
                      target: _proteinTarget,
                    ),
                    const SizedBox(height: 10),
                    _MacroBar(
                      color: const Color(0xFF10B981),
                      label: 'Glucides',
                      value: carbs,
                      target: _carbsTarget,
                    ),
                    const SizedBox(height: 10),
                    _MacroBar(
                      color: const Color(0xFFF59E0B),
                      label: 'Lipides',
                      value: fat,
                      target: _fatTarget,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (waterTargetMl > 0) ...[
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            ),
            const SizedBox(height: 14),
            _HydrationRow(waterTargetMl: waterTargetMl),
          ],
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.gradient, required this.isFreeDay});

  final Gradient gradient;
  final bool isFreeDay;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AUJOURD'HUI",
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              ShaderMask(
                shaderCallback: (rect) => gradient.createShader(rect),
                blendMode: BlendMode.srcIn,
                child: Text(
                  isFreeDay ? 'Jour libre' : 'Objectif du jour',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.trendingUp,
                size: 12,
                color: Color(0xFF059669),
              ),
              const SizedBox(width: 4),
              Text(
                'EN COURS',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.color,
    required this.label,
    required this.value,
    required this.target,
  });

  final Color color;
  final String label;
  final double value;
  final int target;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                    children: [
                      TextSpan(text: '${animValue.round()}g '),
                      TextSpan(
                        text: '/ ${target}g',
                        style: const TextStyle(color: Color(0x9964748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Stack(
                children: [
                  Container(
                    height: 5,
                    color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                  ),
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(height: 5, color: color),
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

class _HydrationRow extends StatelessWidget {
  const _HydrationRow({required this.waterTargetMl});

  final int waterTargetMl;

  @override
  Widget build(BuildContext context) {
    final targetL = (waterTargetMl / 1000).toStringAsFixed(1);

    return Row(
      children: [
        const Icon(
          LucideIcons.droplet,
          size: 16,
          color: Color(0xFF3B82F6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "Boire ${targetL}L d'eau aujourd'hui",
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}
