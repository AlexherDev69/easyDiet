import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Animated donut chart showing protein / carbs / fat proportions.
///
/// Three concentric arcs are drawn with rounded stroke caps, each animating
/// from 0 to its final sweep angle. A compact legend row with coloured dots
/// sits beneath the canvas.
class MacroRadialChart extends StatelessWidget {
  const MacroRadialChart({
    required this.protein,
    required this.carbs,
    required this.fat,
    super.key,
  });

  final double protein;
  final double carbs;
  final double fat;

  static const double _canvasSize = 80;
  static const Duration _animationDuration = Duration(milliseconds: 900);

  @override
  Widget build(BuildContext context) {
    final total = protein + carbs + fat;

    // Normalised fractions in [0, 1]; default to equal thirds when no data.
    final proteinFraction = total > 0 ? (protein / total).clamp(0.0, 1.0) : 0.0;
    final carbsFraction = total > 0 ? (carbs / total).clamp(0.0, 1.0) : 0.0;
    final fatFraction = total > 0 ? (fat / total).clamp(0.0, 1.0) : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated donut
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: _animationDuration,
          curve: Curves.easeOutCubic,
          builder: (context, progress, _) {
            return SizedBox(
              width: _canvasSize,
              height: _canvasSize,
              child: CustomPaint(
                painter: _MacroRadialPainter(
                  proteinFraction: proteinFraction * progress,
                  carbsFraction: carbsFraction * progress,
                  fatFraction: fatFraction * progress,
                  trackColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        // Legend row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LegendDot(
              color: AppColors.macroProtein,
              label: 'P',
              grams: protein,
            ),
            const SizedBox(width: 8),
            _LegendDot(
              color: AppColors.macroCarbs,
              label: 'C',
              grams: carbs,
            ),
            const SizedBox(width: 8),
            _LegendDot(
              color: AppColors.macroFat,
              label: 'L',
              grams: fat,
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Custom painter
// ---------------------------------------------------------------------------

/// Draws three concentric arcs (protein outer, carbs middle, fat inner).
///
/// Each arc starts at the top (−90°) and sweeps clockwise. A subtle dark
/// shadow ring is painted behind each arc to give them depth.
class _MacroRadialPainter extends CustomPainter {
  _MacroRadialPainter({
    required this.proteinFraction,
    required this.carbsFraction,
    required this.fatFraction,
    required this.trackColor,
  });

  final double proteinFraction;
  final double carbsFraction;
  final double fatFraction;
  final Color trackColor;

  // Arc geometry constants
  static const double _strokeWidth = 8.0;
  static const double _gapBetweenArcs = 4.0;
  static const double _startAngle = -math.pi / 2; // 12 o'clock

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    // Radii for outer → inner rings
    final outerRadius = maxRadius - _strokeWidth / 2;
    final middleRadius = outerRadius - _strokeWidth - _gapBetweenArcs;
    final innerRadius = middleRadius - _strokeWidth - _gapBetweenArcs;

    _drawArcTrack(canvas, center, outerRadius);
    _drawArcTrack(canvas, center, middleRadius);
    _drawArcTrack(canvas, center, innerRadius);

    _drawArc(
      canvas,
      center,
      outerRadius,
      proteinFraction,
      AppColors.macroProtein,
    );
    _drawArc(
      canvas,
      center,
      middleRadius,
      carbsFraction,
      AppColors.macroCarbs,
    );
    _drawArc(
      canvas,
      center,
      innerRadius,
      fatFraction,
      AppColors.macroFat,
    );
  }

  void _drawArcTrack(Canvas canvas, Offset center, double radius) {
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
  }

  void _drawArc(
    Canvas canvas,
    Offset center,
    double radius,
    double fraction,
    Color color,
  ) {
    if (fraction <= 0) return;

    final sweepAngle = fraction * 2 * math.pi;

    // Shadow arc for depth — slightly thicker and offset
    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth + 3
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, _startAngle, sweepAngle, false, shadowPaint);

    // Gradient arc — use a SweepGradient shader centred on the arc.
    final gradientColors = [
      color,
      Color.lerp(color, Colors.white, 0.35) ?? color,
      color,
    ];

    final gradientPaint = Paint()
      ..shader = SweepGradient(
        colors: gradientColors,
        stops: const [0.0, 0.5, 1.0],
        startAngle: _startAngle,
        endAngle: _startAngle + sweepAngle,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, _startAngle, sweepAngle, false, gradientPaint);
  }

  @override
  bool shouldRepaint(_MacroRadialPainter oldDelegate) {
    return oldDelegate.proteinFraction != proteinFraction ||
        oldDelegate.carbsFraction != carbsFraction ||
        oldDelegate.fatFraction != fatFraction ||
        oldDelegate.trackColor != trackColor;
  }
}

// ---------------------------------------------------------------------------
// Legend dot
// ---------------------------------------------------------------------------

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    required this.grams,
  });

  final Color color;
  final String label;
  final double grams;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          '$label ${grams.round()}g',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
