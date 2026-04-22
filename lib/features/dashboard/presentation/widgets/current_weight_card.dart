import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../data/local/database.dart';
import '../../../../shared/widgets/glass_card.dart';

/// "Poids actuel" card — big weight + delta pill on the left, mini bar chart
/// on the right.
class CurrentWeightCard extends StatelessWidget {
  const CurrentWeightCard({
    required this.logs,
    this.onTap,
    super.key,
  });

  final List<WeightLog> logs;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }
    final sorted = [...logs]..sort((a, b) => a.date.compareTo(b.date));
    final latest = sorted.last.weightKg;
    final first = sorted.first.weightKg;
    final delta = first - latest;
    final lossPositive = delta > 0;
    final deltaPillColor =
        lossPositive ? const Color(0xFFF43F5E) : const Color(0xFF64748B);
    final weights = sorted.map((e) => e.weightKg).toList();

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'POIDS ACTUEL',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      latest.toStringAsFixed(1),
                      style: GoogleFonts.nunito(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'kg',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                if (delta.abs() > 0.05) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: deltaPillColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          lossPositive
                              ? LucideIcons.trendingDown
                              : LucideIcons.trendingUp,
                          size: 11,
                          color: deltaPillColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${lossPositive ? "-" : "+"}${delta.abs().toStringAsFixed(1)} kg',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: deltaPillColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(
            width: 110,
            height: 38,
            child: CustomPaint(
              painter: _MiniBarsPainter(weights: weights),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBarsPainter extends CustomPainter {
  _MiniBarsPainter({required this.weights});

  final List<double> weights;

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.isEmpty) return;
    final max = weights.reduce((a, b) => a > b ? a : b);
    final min = weights.reduce((a, b) => a < b ? a : b);
    final range = (max - min) == 0 ? 1.0 : max - min;

    const barWidth = 9.0;
    const step = 13.0;
    final count = weights.length;
    for (var i = 0; i < count; i++) {
      final v = weights[i];
      final h = ((v - min) / range) * (size.height - 8) + 6;
      final x = i * step;
      final y = size.height - h;
      final isLast = i == count - 1;
      final paint = Paint()
        ..color = isLast
            ? const Color(0xFF10B981)
            : const Color(0xFF10B981).withValues(alpha: 0.28);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, h),
        const Radius.circular(3),
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(_MiniBarsPainter old) => old.weights != weights;
}
