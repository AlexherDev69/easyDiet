import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

/// Donut chart showing macro split (protein/carbs/fat) by calorie share,
/// with the current calorie count vs. daily target in the center.
///
/// Animates smoothly from previous values whenever any input changes, so
/// that marking a meal consumed produces a visible fill animation. Respects
/// `MediaQuery.disableAnimations` for accessibility.
///
/// Port of `RadialMacro.jsx` handoff component.
class RadialMacro extends StatefulWidget {
  const RadialMacro({
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.cal,
    required this.target,
    this.size = 168,
    this.duration = const Duration(milliseconds: 700),
    super.key,
  });

  /// Grams of each macro — used to compute calorie shares (4/4/9).
  final double protein;
  final double carbs;
  final double fat;

  /// Calories consumed today (centered number).
  final int cal;

  /// Daily calorie target (shown under the count).
  final int target;

  /// Overall widget size (square).
  final double size;

  /// Duration of the cross-fade animation between two states.
  final Duration duration;

  @override
  State<RadialMacro> createState() => _RadialMacroState();
}

class _RadialMacroState extends State<RadialMacro>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _fromProtein;
  late double _fromCarbs;
  late double _fromFat;
  late int _fromCal;
  late double _toProtein;
  late double _toCarbs;
  late double _toFat;
  late int _toCal;

  @override
  void initState() {
    super.initState();
    // Start from zero so the initial mount plays the fill animation, even
    // when the widget is built with non-zero values already available.
    _fromProtein = 0;
    _fromCarbs = 0;
    _fromFat = 0;
    _fromCal = 0;
    _toProtein = widget.protein;
    _toCarbs = widget.carbs;
    _toFat = widget.fat;
    _toCal = widget.cal;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward(from: 0);
  }

  bool _reducedMotionApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reducedMotionApplied) return;
    _reducedMotionApplied = true;
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion) {
      _controller.duration = Duration.zero;
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(RadialMacro old) {
    super.didUpdateWidget(old);
    final changed = old.protein != widget.protein ||
        old.carbs != widget.carbs ||
        old.fat != widget.fat ||
        old.cal != widget.cal;
    if (!changed) return;

    final t = _controller.value;
    _fromProtein = _lerp(_fromProtein, _toProtein, t);
    _fromCarbs = _lerp(_fromCarbs, _toCarbs, t);
    _fromFat = _lerp(_fromFat, _toFat, t);
    _fromCal = (_fromCal + (_toCal - _fromCal) * t).round();

    _toProtein = widget.protein;
    _toCarbs = widget.carbs;
    _toFat = widget.fat;
    _toCal = widget.cal;

    final reducedMotion = MediaQuery.of(context).disableAnimations;
    _controller.duration =
        reducedMotion ? Duration.zero : widget.duration;
    _controller.forward(from: 0);
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = Curves.easeOutCubic.transform(_controller.value);
          final p = _lerp(_fromProtein, _toProtein, t);
          final c = _lerp(_fromCarbs, _toCarbs, t);
          final f = _lerp(_fromFat, _toFat, t);
          final kcal = (_fromCal + (_toCal - _fromCal) * t).round();

          final progress = widget.target > 0
              ? (kcal / widget.target).clamp(0.0, 1.0)
              : 0.0;
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(widget.size),
                painter: _RadialMacroPainter(
                  protein: p,
                  carbs: c,
                  fat: f,
                  progress: progress,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KCAL',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    '$kcal',
                    style: GoogleFonts.nunito(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      height: 1,
                      color: const Color(0xFF0F172A),
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '/ ${widget.target}',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RadialMacroPainter extends CustomPainter {
  _RadialMacroPainter({
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.progress,
  });

  final double protein;
  final double carbs;
  final double fat;
  final double progress;

  static const _stroke = 14.0;
  static const _gapDeg = 3.0;
  static const _arcColors = [
    Color(0xFFF43F5E), // protein
    Color(0xFF10B981), // carbs
    Color(0xFFF59E0B), // fat
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final r = (size.width - _stroke) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..color = AppColors.gray900.withValues(alpha: 0.06);
    canvas.drawCircle(center, r, bgPaint);

    final calP = protein * 4;
    final calC = carbs * 4;
    final calF = fat * 9;
    final total = calP + calC + calF;
    if (total <= 0) return;

    final fractions = [calP / total, calC / total, calF / total];
    final totalGap = _gapDeg * fractions.length;
    final availDeg = (360.0 - totalGap) * progress;
    if (availDeg <= 0) return;

    var startDeg = -90.0;
    final rect = Rect.fromCircle(center: center, radius: r);

    for (var i = 0; i < fractions.length; i++) {
      final sweep = fractions[i] * availDeg;
      if (sweep > 0) {
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _stroke
          ..strokeCap = StrokeCap.round
          ..color = _arcColors[i];
        canvas.drawArc(
          rect,
          _deg2rad(startDeg),
          _deg2rad(sweep),
          false,
          paint,
        );
      }
      startDeg += sweep + _gapDeg;
    }
  }

  double _deg2rad(double d) => d * math.pi / 180.0;

  @override
  bool shouldRepaint(_RadialMacroPainter old) =>
      old.protein != protein ||
      old.carbs != carbs ||
      old.fat != fat ||
      old.progress != progress;
}
