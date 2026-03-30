import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/local/database.dart';

const double _chartHeight = 250.0;

/// Custom line chart for weight log — port of WeightLineChart Canvas.
/// Animates with a left-to-right draw-in on first render and on period change.
class WeightLineChart extends StatefulWidget {
  const WeightLineChart({
    super.key,
    required this.logs,
    required this.targetWeight,
  });

  final List<WeightLog> logs;
  final double targetWeight;

  @override
  State<WeightLineChart> createState() => _WeightLineChartState();
}

class _WeightLineChartState extends State<WeightLineChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelColor = colorScheme.onSurfaceVariant;
    // Use Material inverseSurface for the tooltip bubble so it adapts to
    // both light and dark mode without a hardcoded hex color.
    final tooltipBgColor = colorScheme.inverseSurface;
    final tooltipTextColor = colorScheme.onInverseSurface;

    // ValueKey(logs.length) re-triggers the 800ms draw-in whenever the log
    // list changes length (new entry added or period filter changed).
    return TweenAnimationBuilder<double>(
      key: ValueKey(widget.logs.length),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, drawProgress, _) {
        return Semantics(
          label: 'Graphique de poids',
          child: GestureDetector(
            onTapDown: (details) => _handleTap(details.localPosition),
            child: CustomPaint(
              size: const Size(double.infinity, _chartHeight),
              painter: _WeightLineChartPainter(
                logs: widget.logs,
                targetWeight: widget.targetWeight,
                selectedIndex: _selectedIndex,
                lineColor: AppColors.accentPurple,
                fillColorStart:
                    AppColors.accentPurpleLight.withValues(alpha: 0.4),
                fillColorEnd:
                    AppColors.accentPurpleLight.withValues(alpha: 0.0),
                targetColor: AppColors.accentRose,
                labelColor: labelColor,
                tooltipBgColor: tooltipBgColor,
                tooltipTextColor: tooltipTextColor,
                drawProgress: drawProgress,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(Offset localPosition) {
    if (widget.logs.length < 2) return;

    const paddingLeft = 48.0;
    const paddingBottom = 24.0;
    final chartWidth =
        (context.findRenderObject() as RenderBox).size.width - paddingLeft;
    final chartHeight = _chartHeight - paddingBottom;
    final stepX = chartWidth / (widget.logs.length - 1);

    final weights = widget.logs.map((l) => l.weightKg).toList();
    final allValues = [...weights, widget.targetWeight];
    final minWeight = allValues.reduce(min) - 1.0;
    final maxWeight = allValues.reduce(max) + 1.0;
    final range = max(maxWeight - minWeight, 1.0);

    int? closest;
    var closestDist = double.infinity;

    for (var i = 0; i < widget.logs.length; i++) {
      final x = paddingLeft + i * stepX;
      final y = chartHeight -
          ((widget.logs[i].weightKg - minWeight) / range) * chartHeight;
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

class _WeightLineChartPainter extends CustomPainter {
  _WeightLineChartPainter({
    required this.logs,
    required this.targetWeight,
    required this.selectedIndex,
    required this.lineColor,
    required this.fillColorStart,
    required this.fillColorEnd,
    required this.targetColor,
    required this.labelColor,
    required this.tooltipBgColor,
    required this.tooltipTextColor,
    required this.drawProgress,
  });

  final List<WeightLog> logs;
  final double targetWeight;
  final int? selectedIndex;
  final Color lineColor;
  final Color fillColorStart;
  final Color fillColorEnd;
  final Color targetColor;
  final Color labelColor;

  /// Background color for the tap tooltip bubble. Passed from the widget
  /// so the painter stays theme-agnostic (CustomPainters have no BuildContext).
  final Color tooltipBgColor;

  /// Text color inside the tooltip bubble.
  final Color tooltipTextColor;

  /// 0.0 to 1.0 left-to-right draw-in progress driven by TweenAnimationBuilder.
  /// Points beyond the current frontier are withheld, creating a smooth
  /// "chart drawing itself" reveal animation on screen entry.
  final double drawProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final weights = logs.map((l) => l.weightKg).toList();
    final allValues = [...weights, targetWeight];
    final minWeight = allValues.reduce(min) - 1.0;
    final maxWeight = allValues.reduce(max) + 1.0;
    final range = max(maxWeight - minWeight, 1.0);

    const paddingLeft = 48.0;
    const paddingBottom = 24.0;
    final chartWidth = size.width - paddingLeft;
    final chartHeight = size.height - paddingBottom;

    // Target line (dashed).
    final targetY =
        chartHeight - ((targetWeight - minWeight) / range) * chartHeight;
    _drawDashedLine(
      canvas,
      Offset(paddingLeft, targetY),
      Offset(size.width, targetY),
      Paint()
        ..color = targetColor.withValues(alpha: 0.5)
        ..strokeWidth = 2.0,
    );

    // Weight line with gradient fill.
    if (logs.length >= 2) {
      final stepX = chartWidth / (logs.length - 1);
      final linePath = Path();
      final fillPath = Path();

      // The x-coordinate frontier up to which the chart is currently drawn.
      final maxDrawX = paddingLeft + chartWidth * drawProgress;

      for (var i = 0; i < logs.length; i++) {
        final rawX = paddingLeft + i * stepX;
        // Clamp drawn x to the current frontier.
        final x = rawX.clamp(0.0, maxDrawX);
        final y =
            chartHeight - ((logs[i].weightKg - minWeight) / range) * chartHeight;

        if (i == 0) {
          linePath.moveTo(x, y);
          fillPath.moveTo(x, y);
        } else {
          linePath.lineTo(x, y);
          fillPath.lineTo(x, y);
        }

        // Only draw dots for points whose natural x has been revealed.
        if (rawX <= maxDrawX) {
          final isSelected = i == selectedIndex;
          canvas.drawCircle(
            Offset(rawX, y),
            isSelected ? 6.0 : 4.0,
            Paint()..color = lineColor,
          );
        }
      }

      // Close fill path at the current draw frontier.
      fillPath.lineTo(maxDrawX, chartHeight);
      fillPath.lineTo(paddingLeft, chartHeight);
      fillPath.close();

      // Gradient fill.
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset.zero,
            Offset(0, chartHeight),
            [fillColorStart, fillColorEnd],
          ),
      );

      // Line stroke.
      canvas.drawPath(
        linePath,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      // Selected point tooltip — only shown once the draw-in is complete so
      // it never appears before its data point has been rendered.
      if (drawProgress >= 1.0 &&
          selectedIndex != null &&
          selectedIndex! >= 0 &&
          selectedIndex! < logs.length) {
        final i = selectedIndex!;
        final x = paddingLeft + i * stepX;
        final y = chartHeight -
            ((logs[i].weightKg - minWeight) / range) * chartHeight;
        final date = AppDateUtils.fromEpochMillis(logs[i].date);
        final label =
            '${logs[i].weightKg.toStringAsFixed(1)} kg\n${date.day}/${date.month}';

        _drawTooltip(canvas, Offset(x, y), label, size.width);
      }
    }

    // Y-axis labels.
    const labelCount = 5;
    for (var i = 0; i <= labelCount; i++) {
      final weight = minWeight + (range * i / labelCount);
      final y = chartHeight - (i / labelCount) * chartHeight;
      final textPainter = TextPainter(
        text: TextSpan(
          text: weight.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 11,
            color: labelColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(2, y - textPainter.height / 2));
    }
  }

  void _drawTooltip(
      Canvas canvas, Offset point, String label, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: tooltipTextColor,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    const padding = 8.0;
    const arrowHeight = 6.0;
    final boxWidth = textPainter.width + padding * 2;
    final boxHeight = textPainter.height + padding * 2;

    // Position above the point, clamped to chart bounds.
    var left = point.dx - boxWidth / 2;
    left = left.clamp(4.0, maxWidth - boxWidth - 4);
    // If tooltip would go above canvas, show it below the point instead.
    var top = point.dy - boxHeight - arrowHeight - 4;
    if (top < 0) {
      top = point.dy + arrowHeight + 4;
    }

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, boxWidth, boxHeight),
      const Radius.circular(6),
    );

    canvas.drawRRect(
      rect,
      Paint()..color = tooltipBgColor,
    );

    textPainter.paint(
      canvas,
      Offset(left + padding, top + padding),
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 10.0;
    const dashSpace = 10.0;
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final length = sqrt(dx * dx + dy * dy);
    final unitDx = dx / length;
    final unitDy = dy / length;

    var drawn = 0.0;
    while (drawn < length) {
      final start = Offset(
        p1.dx + unitDx * drawn,
        p1.dy + unitDy * drawn,
      );
      final end = Offset(
        p1.dx + unitDx * min(drawn + dashWidth, length),
        p1.dy + unitDy * min(drawn + dashWidth, length),
      );
      canvas.drawLine(start, end, paint);
      drawn += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _WeightLineChartPainter oldDelegate) {
    return oldDelegate.logs != logs ||
        oldDelegate.targetWeight != targetWeight ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.drawProgress != drawProgress ||
        oldDelegate.tooltipBgColor != tooltipBgColor ||
        oldDelegate.tooltipTextColor != tooltipTextColor;
  }
}
