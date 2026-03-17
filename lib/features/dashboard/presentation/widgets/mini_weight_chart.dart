import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/local/database.dart';

/// Small line chart with gradient fill for recent weight logs.
class MiniWeightChart extends StatelessWidget {
  const MiniWeightChart({
    required this.logs,
    this.height = 80,
    super.key,
  });

  final List<WeightLog> logs;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (logs.length < 2) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      child: CustomPaint(
        size: Size.infinite,
        painter: _WeightChartPainter(logs: logs),
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter({required this.logs});

  final List<WeightLog> logs;

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

    final dotPaint = Paint()..color = AppColors.emeraldPrimary;

    for (var i = 0; i < logs.length; i++) {
      final x = i * stepX;
      final y = size.height - ((logs[i].weightKg - minWeight) / range) * size.height;

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    // Fill gradient under curve
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
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
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.logs != logs;
  }
}
