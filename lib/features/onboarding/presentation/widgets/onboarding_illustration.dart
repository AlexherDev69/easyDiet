import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Animated illustration with rotating gradient border for each onboarding step.
///
/// Each step gets a unique CustomPainter drawing inside a glass circle
/// with a rotating [SweepGradient] border. Respects reduced-motion settings.
class OnboardingIllustration extends StatefulWidget {
  const OnboardingIllustration({super.key, required this.step});

  final int step;

  @override
  State<OnboardingIllustration> createState() =>
      _OnboardingIllustrationState();
}

class _OnboardingIllustrationState extends State<OnboardingIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  static const double _outerSize = 140;
  static const double _innerSize = 120;
  static const double _borderWidth = 3;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    if (reduceMotion) {
      _rotationController.stop();
    } else if (!_rotationController.isAnimating) {
      _rotationController.repeat();
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: _outerSize,
        height: _outerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating gradient border ring
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(_outerSize, _outerSize),
                  painter: _GradientBorderPainter(
                    rotation: reduceMotion ? 0 : _rotationController.value,
                    borderWidth: _borderWidth,
                  ),
                );
              },
            ),
            // Glass inner circle with illustration
            Container(
              width: _innerSize,
              height: _innerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.6),
              ),
              child: CustomPaint(
                painter: _illustrationForStep(widget.step, isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static CustomPainter _illustrationForStep(int step, bool isDark) {
    return switch (step) {
      0 => _PersonIllustrationPainter(isDark: isDark),
      1 => _BodyMetricsIllustrationPainter(isDark: isDark),
      2 => _GoalIllustrationPainter(isDark: isDark),
      3 => _LifestyleIllustrationPainter(isDark: isDark),
      4 => _ShieldIllustrationPainter(isDark: isDark),
      5 => _CalendarIllustrationPainter(isDark: isDark),
      _ => _PersonIllustrationPainter(isDark: isDark),
    };
  }
}

/// Paints a rotating sweep gradient ring around the illustration.
class _GradientBorderPainter extends CustomPainter {
  const _GradientBorderPainter({
    required this.rotation,
    required this.borderWidth,
  });

  final double rotation;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - borderWidth / 2;

    final gradient = SweepGradient(
      startAngle: rotation * 2 * math.pi,
      endAngle: rotation * 2 * math.pi + 2 * math.pi,
      colors: const [
        AppColors.emeraldPrimary,
        AppColors.tealSecondary,
        AppColors.accentPurple,
        AppColors.emeraldPrimary,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Paint _fillPaint(Color color) => Paint()
  ..color = color
  ..style = PaintingStyle.fill;

Paint _strokePaint(Color color, double width) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

// ── Step 0: Personal (friendly person silhouette) ───────────────────────────

class _PersonIllustrationPainter extends CustomPainter {
  const _PersonIllustrationPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final backgroundPaint = _fillPaint(
      isDark ? AppColors.darkSurfaceVariant : AppColors.emeraldSurface,
    );

    // Soft circular background
    canvas.drawCircle(Offset(cx, size.height / 2), size.width * 0.44, backgroundPaint);

    // Head
    final headPaint = _fillPaint(
      isDark ? AppColors.emeraldLight : AppColors.emeraldPrimary,
    );
    canvas.drawCircle(Offset(cx, size.height * 0.30), size.width * 0.14, headPaint);

    // Body (rounded rectangle for torso)
    final bodyPaint = _fillPaint(
      isDark ? AppColors.emeraldPrimaryDark : AppColors.emeraldDark,
    );
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.58),
        width: size.width * 0.28,
        height: size.height * 0.24,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Smile - small arc on the head
    final smilePaint = _strokePaint(
      isDark ? AppColors.darkBackground : Colors.white,
      1.8,
    );
    final smileRect = Rect.fromCenter(
      center: Offset(cx, size.height * 0.305),
      width: size.width * 0.09,
      height: size.height * 0.05,
    );
    canvas.drawArc(smileRect, 0, math.pi, false, smilePaint);

    // Eyes
    final eyePaint = _fillPaint(
      isDark ? AppColors.darkBackground : Colors.white,
    );
    canvas.drawCircle(Offset(cx - size.width * 0.035, size.height * 0.284), 1.8, eyePaint);
    canvas.drawCircle(Offset(cx + size.width * 0.035, size.height * 0.284), 1.8, eyePaint);

    // Small leaf accent (diet app identity)
    final leafPaint = _fillPaint(AppColors.emeraldLight);
    final leafPath = Path()
      ..moveTo(cx + size.width * 0.20, size.height * 0.28)
      ..quadraticBezierTo(
        cx + size.width * 0.28, size.height * 0.20,
        cx + size.width * 0.24, size.height * 0.35,
      )
      ..quadraticBezierTo(
        cx + size.width * 0.16, size.height * 0.36,
        cx + size.width * 0.20, size.height * 0.28,
      );
    canvas.drawPath(leafPath, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Step 1: Body Metrics (ruler with scale tick marks) ──────────────────────

class _BodyMetricsIllustrationPainter extends CustomPainter {
  const _BodyMetricsIllustrationPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background circle
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.44,
      _fillPaint(isDark ? AppColors.darkSurfaceVariant : AppColors.emeraldSurface),
    );

    // Vertical ruler body
    final rulerColor = isDark ? AppColors.emeraldPrimaryDark : AppColors.emeraldPrimary;
    final rulerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx - size.width * 0.08, cy),
        width: size.width * 0.12,
        height: size.height * 0.60,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(rulerRect, _fillPaint(rulerColor));

    // Tick marks on ruler
    final tickPaint = _strokePaint(
      isDark ? AppColors.darkBackground : Colors.white,
      1.5,
    );
    final rulerLeft = cx - size.width * 0.14;
    final rulerRight = cx - size.width * 0.02;
    final rulerTop = cy - size.height * 0.30;
    final tickSpacing = size.height * 0.60 / 6;

    for (int i = 0; i <= 6; i++) {
      final y = rulerTop + i * tickSpacing;
      final isLong = i % 2 == 0;
      final tickStart = isLong ? rulerLeft + 2 : rulerLeft + size.width * 0.04;
      canvas.drawLine(Offset(tickStart, y), Offset(rulerRight - 2, y), tickPaint);
    }

    // Scale / weight icon (small circle with horizontal lines)
    final scaleColor = AppColors.accentAmber;
    final scaleCenter = Offset(cx + size.width * 0.14, cy);
    canvas.drawCircle(scaleCenter, size.width * 0.14, _fillPaint(scaleColor));

    // Scale lines inside circle
    final scaleLinePaint = _strokePaint(Colors.white, 1.5);
    for (int i = -1; i <= 1; i++) {
      final y = scaleCenter.dy + i * size.height * 0.045;
      canvas.drawLine(
        Offset(scaleCenter.dx - size.width * 0.08, y),
        Offset(scaleCenter.dx + size.width * 0.08, y),
        scaleLinePaint,
      );
    }

    // Arrow pointing between ruler and scale (shows measurement)
    final arrowPaint = _strokePaint(
      isDark ? AppColors.emeraldTertiaryDark : AppColors.emeraldDark,
      2.0,
    );
    canvas.drawLine(
      Offset(cx - size.width * 0.02, cy - size.height * 0.05),
      Offset(cx + size.width * 0.00, cy - size.height * 0.05),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Step 2: Goal (bullseye target with arrow) ────────────────────────────────

class _GoalIllustrationPainter extends CustomPainter {
  const _GoalIllustrationPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.44,
      _fillPaint(isDark ? AppColors.darkSurfaceVariant : AppColors.emeraldSurface),
    );

    // Bullseye rings - outer to inner
    final ringColors = isDark
        ? [AppColors.emeraldDark, AppColors.emeraldPrimary, AppColors.emeraldLight]
        : [AppColors.emeraldLight, AppColors.emeraldPrimary, AppColors.emeraldDark];

    final radii = [size.width * 0.34, size.width * 0.22, size.width * 0.11];

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(cx, cy),
        radii[i],
        _fillPaint(ringColors[i]),
      );
      if (i < 2) {
        // White gap between rings
        canvas.drawCircle(
          Offset(cx, cy),
          radii[i] - 3,
          _fillPaint(isDark ? AppColors.darkSurface : Colors.white),
        );
      }
    }

    // Arrow shaft (from top-right diagonal to center)
    final arrowPaint = _strokePaint(AppColors.accentAmber, 3.0);
    final arrowStart = Offset(cx + size.width * 0.30, cy - size.height * 0.30);
    final arrowEnd = Offset(cx + size.width * 0.03, cy + size.height * 0.03);
    canvas.drawLine(arrowStart, arrowEnd, arrowPaint);

    // Arrow head
    final arrowHeadPaint = _fillPaint(AppColors.accentAmber);
    final arrowPath = Path();
    // Direction vector
    final dx = arrowEnd.dx - arrowStart.dx;
    final dy = arrowEnd.dy - arrowStart.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    final nx = dx / len;
    final ny = dy / len;
    // Perpendicular
    const headLen = 10.0;
    const headWidth = 5.0;
    arrowPath.moveTo(arrowEnd.dx, arrowEnd.dy);
    arrowPath.lineTo(
      arrowEnd.dx - nx * headLen - ny * headWidth,
      arrowEnd.dy - ny * headLen + nx * headWidth,
    );
    arrowPath.lineTo(
      arrowEnd.dx - nx * headLen + ny * headWidth,
      arrowEnd.dy - ny * headLen - nx * headWidth,
    );
    arrowPath.close();
    canvas.drawPath(arrowPath, arrowHeadPaint);

    // Tail fletching lines
    final fletchPaint = _strokePaint(AppColors.accentAmber, 2.0);
    canvas.drawLine(
      Offset(arrowStart.dx, arrowStart.dy),
      Offset(arrowStart.dx - 6, arrowStart.dy - 2),
      fletchPaint,
    );
    canvas.drawLine(
      Offset(arrowStart.dx, arrowStart.dy),
      Offset(arrowStart.dx - 2, arrowStart.dy - 7),
      fletchPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Step 3: Lifestyle (fork & knife with leaf accent) ───────────────────────

class _LifestyleIllustrationPainter extends CustomPainter {
  const _LifestyleIllustrationPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.44,
      _fillPaint(isDark ? AppColors.darkSurfaceVariant : AppColors.emeraldSurface),
    );

    final utensil = isDark ? AppColors.emeraldPrimaryDark : AppColors.emeraldPrimary;
    final utensilPaint = _strokePaint(utensil, 3.5);
    final utensilCapPaint = _fillPaint(utensil);

    // ---- FORK (left of center) ----
    final forkX = cx - size.width * 0.14;
    final top = cy - size.height * 0.28;
    final bottom = cy + size.height * 0.28;

    // Fork handle
    canvas.drawLine(Offset(forkX, cy - size.height * 0.04), Offset(forkX, bottom), utensilPaint);

    // Fork tines (3 prongs)
    for (int i = -1; i <= 1; i++) {
      final x = forkX + i * size.width * 0.035;
      canvas.drawLine(Offset(x, top), Offset(x, cy - size.height * 0.06), utensilPaint);
    }
    // Bridge between tines
    canvas.drawLine(
      Offset(forkX - size.width * 0.035, cy - size.height * 0.10),
      Offset(forkX + size.width * 0.035, cy - size.height * 0.10),
      utensilPaint,
    );

    // ---- KNIFE (right of center) ----
    final knifeX = cx + size.width * 0.14;
    canvas.drawLine(Offset(knifeX, cy - size.height * 0.04), Offset(knifeX, bottom), utensilPaint);

    // Knife blade (slightly angled top)
    final bladePath = Path()
      ..moveTo(knifeX, top)
      ..lineTo(knifeX + size.width * 0.055, cy - size.height * 0.10)
      ..lineTo(knifeX, cy - size.height * 0.04);
    canvas.drawPath(bladePath, utensilCapPaint);

    // ---- LEAF accent (center-top) ----
    final leafPaint = _fillPaint(AppColors.emeraldLight);
    final leafCenter = Offset(cx, cy - size.height * 0.18);
    final leafPath = Path()
      ..moveTo(leafCenter.dx, leafCenter.dy - size.height * 0.10)
      ..quadraticBezierTo(
        leafCenter.dx + size.width * 0.10, leafCenter.dy,
        leafCenter.dx, leafCenter.dy + size.height * 0.06,
      )
      ..quadraticBezierTo(
        leafCenter.dx - size.width * 0.10, leafCenter.dy,
        leafCenter.dx, leafCenter.dy - size.height * 0.10,
      );
    canvas.drawPath(leafPath, leafPaint);

    // Leaf vein
    final veinPaint = _strokePaint(AppColors.emeraldDark, 1.0);
    canvas.drawLine(
      Offset(leafCenter.dx, leafCenter.dy - size.height * 0.09),
      Offset(leafCenter.dx, leafCenter.dy + size.height * 0.05),
      veinPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Step 4: Allergies (shield with checkmark) ───────────────────────────────

class _ShieldIllustrationPainter extends CustomPainter {
  const _ShieldIllustrationPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.44,
      _fillPaint(isDark ? AppColors.darkSurfaceVariant : AppColors.emeraldSurface),
    );

    // Shield shape
    final shieldColor = isDark ? AppColors.accentPurpleLight : AppColors.accentPurple;
    final shieldPath = Path();
    final sw = size.width * 0.38;
    final sh = size.height * 0.44;
    final sx = cx - sw / 2;
    final sy = cy - sh * 0.52;

    // Shield outline: flat top with curved sides tapering to a point at bottom
    shieldPath.moveTo(sx, sy + sh * 0.22);
    shieldPath.quadraticBezierTo(sx, sy, sx + sw * 0.08, sy);
    shieldPath.lineTo(sx + sw * 0.92, sy);
    shieldPath.quadraticBezierTo(sx + sw, sy, sx + sw, sy + sh * 0.22);
    shieldPath.lineTo(sx + sw, sy + sh * 0.55);
    shieldPath.quadraticBezierTo(sx + sw, sy + sh * 0.85, cx, sy + sh);
    shieldPath.quadraticBezierTo(sx, sy + sh * 0.85, sx, sy + sh * 0.55);
    shieldPath.close();

    canvas.drawPath(shieldPath, _fillPaint(shieldColor));

    // Shield inner highlight (slightly smaller, lighter)
    final innerShieldPaint = _fillPaint(
      isDark ? AppColors.accentPurple : AppColors.accentPurpleLight,
    );
    // ignore: deprecated_member_use
    final scaleMatrix = Matrix4.identity()
      // ignore: deprecated_member_use
      ..translate(cx, cy)
      // ignore: deprecated_member_use
      ..scale(0.78)
      // ignore: deprecated_member_use
      ..translate(-cx, -cy);
    canvas.drawPath(shieldPath.transform(scaleMatrix.storage), innerShieldPaint);

    // Checkmark
    final checkPaint = _strokePaint(Colors.white, 3.5);
    final checkPath = Path()
      ..moveTo(cx - size.width * 0.10, cy + size.height * 0.00)
      ..lineTo(cx - size.width * 0.02, cy + size.height * 0.08)
      ..lineTo(cx + size.width * 0.12, cy - size.height * 0.08);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Step 5: Plan (calendar grid with checkmark) ──────────────────────────────

class _CalendarIllustrationPainter extends CustomPainter {
  const _CalendarIllustrationPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.44,
      _fillPaint(isDark ? AppColors.darkSurfaceVariant : AppColors.emeraldSurface),
    );

    // Calendar body
    final calColor = isDark ? AppColors.emeraldPrimaryDark : AppColors.emeraldPrimary;
    final calRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + size.height * 0.02),
        width: size.width * 0.60,
        height: size.height * 0.56,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(calRect, _fillPaint(calColor));

    // Calendar header bar (darker top strip)
    final headerRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        cx - size.width * 0.30,
        cy - size.height * 0.26,
        size.width * 0.60,
        size.height * 0.14,
      ),
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
    );
    canvas.drawRRect(headerRect, _fillPaint(AppColors.emeraldDark));

    // Calendar binding hooks (two small rectangles on top)
    final hookPaint = _fillPaint(isDark ? AppColors.emeraldLight : Colors.white);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - size.width * 0.10, cy - size.height * 0.28), width: 6, height: 10),
        const Radius.circular(3),
      ),
      hookPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + size.width * 0.10, cy - size.height * 0.28), width: 6, height: 10),
        const Radius.circular(3),
      ),
      hookPaint,
    );

    // Day grid (2 rows x 3 cols of small dots representing days)
    final dotPaint = _fillPaint(
      isDark ? AppColors.emeraldDark : Colors.white.withAlpha(180),
    );
    final checkedDotPaint = _fillPaint(AppColors.accentAmber);
    final gridLeft = cx - size.width * 0.20;
    final gridTop = cy + size.height * 0.00;
    const cols = 3;
    const rows = 2;
    const dotRadius = 5.0;
    final colSpacing = size.width * 0.14;
    final rowSpacing = size.height * 0.14;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final dotCenter = Offset(
          gridLeft + c * colSpacing,
          gridTop + r * rowSpacing,
        );
        // Highlight first two dots as "checked/planned"
        final isHighlighted = (r == 0 && c < 2);
        canvas.drawCircle(dotCenter, dotRadius, isHighlighted ? checkedDotPaint : dotPaint);
      }
    }

    // Large checkmark overlay (plan confirmed feel)
    final checkPaint = _strokePaint(Colors.white, 3.0);
    final checkPath = Path()
      ..moveTo(cx + size.width * 0.04, cy + size.height * 0.14)
      ..lineTo(cx + size.width * 0.12, cy + size.height * 0.22)
      ..lineTo(cx + size.width * 0.26, cy + size.height * 0.04);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
