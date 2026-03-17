import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/database.dart';

/// Custom line chart for weight log — port of WeightLineChart Canvas.
class WeightLineChart extends StatelessWidget {
  const WeightLineChart({
    super.key,
    required this.logs,
    required this.targetWeight,
  });

  final List<WeightLog> logs;
  final double targetWeight;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 250),
      painter: _WeightLineChartPainter(
        logs: logs,
        targetWeight: targetWeight,
        lineColor: AppColors.accentPurple,
        fillColorStart: AppColors.accentPurpleLight.withValues(alpha: 0.4),
        fillColorEnd: AppColors.accentPurpleLight.withValues(alpha: 0.0),
        targetColor: AppColors.accentRose,
        labelColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _WeightLineChartPainter extends CustomPainter {
  _WeightLineChartPainter({
    required this.logs,
    required this.targetWeight,
    required this.lineColor,
    required this.fillColorStart,
    required this.fillColorEnd,
    required this.targetColor,
    required this.labelColor,
  });

  final List<WeightLog> logs;
  final double targetWeight;
  final Color lineColor;
  final Color fillColorStart;
  final Color fillColorEnd;
  final Color targetColor;
  final Color labelColor;

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

      for (var i = 0; i < logs.length; i++) {
        final x = paddingLeft + i * stepX;
        final y =
            chartHeight - ((logs[i].weightKg - minWeight) / range) * chartHeight;

        if (i == 0) {
          linePath.moveTo(x, y);
          fillPath.moveTo(x, y);
        } else {
          linePath.lineTo(x, y);
          fillPath.lineTo(x, y);
        }

        // Data point dots.
        canvas.drawCircle(
          Offset(x, y),
          4.0,
          Paint()..color = lineColor,
        );
      }

      // Close fill path.
      final lastX = paddingLeft + (logs.length - 1) * stepX;
      fillPath.lineTo(lastX, chartHeight);
      fillPath.lineTo(paddingLeft, chartHeight);
      fillPath.close();

      // Gradient fill.
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(0, 0),
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
        oldDelegate.targetWeight != targetWeight;
  }
}
