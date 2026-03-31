import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Animated loading screen for onboarding plan generation.
/// Shows a growing leaf + cycling encouraging texts.
class OnboardingLoadingAnimation extends StatefulWidget {
  const OnboardingLoadingAnimation({super.key});

  @override
  State<OnboardingLoadingAnimation> createState() =>
      _OnboardingLoadingAnimationState();
}

class _OnboardingLoadingAnimationState extends State<OnboardingLoadingAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _leafController;
  late final AnimationController _textController;
  late final Animation<double> _leafGrow;
  late final Animation<double> _leafSway;

  int _textIndex = 0;

  static const _messages = [
    'Calcul de vos calories...',
    'Selection des recettes...',
    'Equilibrage des macros...',
    'Optimisation du plan...',
    'Presque pret !',
  ];

  @override
  void initState() {
    super.initState();

    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _leafGrow = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _leafController, curve: Curves.easeInOutSine),
    );
    _leafSway = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _leafController, curve: Curves.easeInOutSine),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textController.forward();
    _cycleText();
  }

  Future<void> _cycleText() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 2200));
      if (!mounted) return;
      await _textController.reverse();
      if (!mounted) return;
      setState(() => _textIndex = (_textIndex + 1) % _messages.length);
      _textController.forward();
    }
  }

  @override
  void dispose() {
    _leafController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated leaf
            AnimatedBuilder(
              animation: _leafController,
              builder: (context, child) => Transform.scale(
                scale: _leafGrow.value,
                child: Transform.rotate(
                  angle: _leafSway.value,
                  child: child,
                ),
              ),
              child: CustomPaint(
                size: const Size(80, 80),
                painter: _LeafPainter(
                  color: AppColors.emeraldPrimary,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Cycling text with fade
            FadeTransition(
              opacity: _textController,
              child: Text(
                _messages[_textIndex],
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.emeraldPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Subtle progress dots
            _ProgressDots(textIndex: _textIndex, total: _messages.length),
          ],
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.textIndex, required this.total});

  final int textIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isActive = i <= textIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 10 : 6,
          height: isActive ? 10 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.emeraldPrimary
                : AppColors.emeraldPrimary.withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }
}

/// Paints a simple stylized leaf shape using cubic beziers.
class _LeafPainter extends CustomPainter {
  _LeafPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Main leaf body
    final leafPath = Path()
      ..moveTo(w * 0.5, h * 0.05)
      ..cubicTo(w * 0.15, h * 0.25, w * 0.1, h * 0.65, w * 0.5, h * 0.95)
      ..cubicTo(w * 0.9, h * 0.65, w * 0.85, h * 0.25, w * 0.5, h * 0.05)
      ..close();

    final leafPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.7),
          color,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(leafPath, leafPaint);

    // Central vein
    final veinPath = Path()
      ..moveTo(w * 0.5, h * 0.15)
      ..lineTo(w * 0.5, h * 0.85);

    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(veinPath, veinPaint);

    // Side veins
    for (var i = 1; i <= 3; i++) {
      final y = h * (0.25 + i * 0.15);
      final spread = w * 0.15 * (1 + i * 0.2);

      final leftVein = Path()
        ..moveTo(w * 0.5, y)
        ..quadraticBezierTo(w * 0.5 - spread * 0.5, y - 8, w * 0.5 - spread, y - 4);
      final rightVein = Path()
        ..moveTo(w * 0.5, y)
        ..quadraticBezierTo(w * 0.5 + spread * 0.5, y - 8, w * 0.5 + spread, y - 4);

      canvas.drawPath(leftVein, veinPaint);
      canvas.drawPath(rightVein, veinPaint);
    }

    // Small stem at bottom
    final stemPath = Path()
      ..moveTo(w * 0.5, h * 0.9)
      ..quadraticBezierTo(w * 0.52, h, w * 0.55, h);

    final stemPaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(stemPath, stemPaint);
  }

  @override
  bool shouldRepaint(covariant _LeafPainter oldDelegate) =>
      color != oldDelegate.color;
}
