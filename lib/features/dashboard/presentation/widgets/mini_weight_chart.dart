import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/database.dart';

/// Small line chart with gradient fill for recent weight logs.
/// Animates with a left-to-right draw-in effect on first render and whenever
/// a new entry is added.
class MiniWeightChart extends StatefulWidget {
  const MiniWeightChart({
    required this.logs,
    this.height = 80,
    super.key,
  });

  final List<WeightLog> logs;
  final double height;

  @override
  State<MiniWeightChart> createState() => _MiniWeightChartState();
}

class _MiniWeightChartState extends State<MiniWeightChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.logs.length < 2) return const SizedBox.shrink();

    // Use Material inverseSurface so the tooltip adapts to light/dark mode
    // without a hardcoded color in the CustomPainter.
    final colorScheme = Theme.of(context).colorScheme;

    // ValueKey(logs.length) re-triggers the draw-in whenever a new entry is
    // added, so the chart always "arrives" with the reveal animation.
    return TweenAnimationBuilder<double>(
      key: ValueKey(widget.logs.length),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, drawProgress, _) {
        return Semantics(
          label: 'Mini graphique de poids',
          child: GestureDetector(
            onTapDown: (details) => _handleTap(details.localPosition),
            child: SizedBox(
              height: widget.height,
              child: CustomPaint(
                size: Size.infinite,
                painter: _WeightChartPainter(
                  logs: widget.logs,
                  selectedIndex: _selectedIndex,
                  tooltipBgColor: colorScheme.inverseSurface,
                  tooltipTextColor: colorScheme.onInverseSurface,
                  drawProgress: drawProgress,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset localPosition) {
    if (widget.logs.length < 2) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final chartWidth = renderBox.size.width;
    final stepX = chartWidth / (widget.logs.length - 1);

    final weights = widget.logs.map((l) => l.weightKg).toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b) - 0.5;
    final maxWeight = weights.reduce((a, b) => a > b ? a : b) + 0.5;
    final range = (maxWeight - minWeight).clamp(1.0, double.infinity);

    int? closest;
    var closestDist = double.infinity;

    for (var i = 0; i < widget.logs.length; i++) {
      final x = i * stepX;
      final y = widget.height -
          ((widget.logs[i].weightKg - minWeight) / range) * widget.height;
      final dist = (Offset(x, y) - localPosition).distance;
      if (dist < closestDist && dist < 30) {
        closestDist = dist;
        closest = i;
      }
    }

    setState(() {
      _selectedIndex = closest == _selectedIndex ? null : closest;
    });
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter({
    required this.logs,
    required this.selectedIndex,
    required this.tooltipBgColor,
    required this.tooltipTextColor,
    required this.drawProgress,
  });

  final List<WeightLog> logs;
  final int? selectedIndex;

  /// Background of the tap tooltip bubble - injected from the widget so the
  /// painter has no direct dependency on BuildContext or Theme.
  final Color tooltipBgColor;
  final Color tooltipTextColor;

  /// 0.0 to 1.0 left-to-right draw-in progress driven by TweenAnimationBuilder.
  /// At 0.5, only the left half of the chart line is visible; at 1.0 it is
  /// fully drawn. This gives a satisfying "charting" reveal on entry.
  final double drawProgress;

  @override
  void paint(Canvas canvas, Size size) {
    if (logs.length < 2) return;

    final weights = logs.map((l) => l.weightKg).toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b) - 0.5;
    final maxWeight = weights.reduce((a, b) => a > b ? a : b) + 0.5;
    final range = (maxWeight - minWeight).clamp(1.0, double.infinity);

    final stepX = size.width / (logs.length - 1);
    final linePath = Path();
    final fillPath = Path();

    // The x-coordinate frontier up to which the chart is currently drawn.
    final maxDrawX = size.width * drawProgress;

    final dotPaint = Paint()..color = AppColors.emeraldPrimary;

    for (var i = 0; i < logs.length; i++) {
      final rawX = i * stepX;
      // Clamp drawn x to the current frontier so the line never exceeds it.
      final x = rawX.clamp(0.0, maxDrawX);
      final y =
          size.height - ((logs[i].weightKg - minWeight) / range) * size.height;

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Only draw dots for points whose natural x has been revealed.
      if (rawX <= maxDrawX) {
        final isSelected = i == selectedIndex;
        canvas.drawCircle(Offset(rawX, y), isSelected ? 6 : 4, dotPaint);
      }
    }

    // Close the fill path at the current draw frontier.
    fillPath.lineTo(maxDrawX, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(0, size.height),
        [
          AppColors.emeraldLight.withValues(alpha: 0.3),
          AppColors.emeraldLight.withValues(alpha: 0.0),
        ],
      );
    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = AppColors.emeraldPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    // Selected point tooltip - only shown once the draw-in animation has
    // completed so it never appears before its data point has been rendered.
    if (drawProgress >= 1.0 &&
        selectedIndex != null &&
        selectedIndex! >= 0 &&
        selectedIndex! < logs.length) {
      final i = selectedIndex!;
      final x = i * stepX;
      final y = size.height -
          ((logs[i].weightKg - minWeight) / range) * size.height;
      final date = AppDateUtils.fromEpochMillis(logs[i].date);
      final label =
          '${logs[i].weightKg.toStringAsFixed(1)} kg - ${date.day}/${date.month}';

      _drawTooltip(canvas, Offset(x, y), label, size.width);
    }
  }

  void _drawTooltip(
      Canvas canvas, Offset point, String label, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: tooltipTextColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const padding = 6.0;
    final boxWidth = textPainter.width + padding * 2;
    final boxHeight = textPainter.height + padding * 2;

    var left = point.dx - boxWidth / 2;
    left = left.clamp(4.0, maxWidth - boxWidth - 4);
    var top = point.dy - boxHeight - 8;
    if (top < 0) {
      top = point.dy + 8;
    }

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, boxWidth, boxHeight),
      const Radius.circular(6),
    );

    canvas.drawRRect(rect, Paint()..color = tooltipBgColor);
    textPainter.paint(canvas, Offset(left + padding, top + padding));
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.logs != logs ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.drawProgress != drawProgress ||
        oldDelegate.tooltipBgColor != tooltipBgColor ||
        oldDelegate.tooltipTextColor != tooltipTextColor;
  }
}
