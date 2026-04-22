import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Animated background with drifting gradient blobs for glassmorphism effect.
///
/// Three colored circles slowly drift around the screen, blurred heavily
/// to create a soft glow. Respects reduced-motion accessibility settings.
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    if (reduceMotion) {
      return _StaticBackground(isDark: isDark);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value * 2 * math.pi;
        return _BackgroundPainter(t: t, isDark: isDark);
      },
    );
  }
}

class _StaticBackground extends StatelessWidget {
  const _StaticBackground({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _BackgroundPainter(t: 0, isDark: isDark);
  }
}

class _BackgroundPainter extends StatelessWidget {
  const _BackgroundPainter({required this.t, required this.isDark});

  final double t;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final opacityFactor = isDark ? 0.5 : 1.0;

    return IgnorePointer(
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Emerald blob
            Positioned(
              left: size.width * 0.1 + math.sin(t) * 30,
              top: size.height * 0.15 + math.cos(t * 0.8) * 25,
              child: _Blob(
                size: 200,
                color: AppColors.emeraldPrimary
                    .withValues(alpha: 0.25 * opacityFactor),
              ),
            ),
            // Teal blob
            Positioned(
              right: size.width * 0.05 + math.cos(t * 0.7) * 35,
              top: size.height * 0.45 + math.sin(t * 0.9) * 20,
              child: _Blob(
                size: 180,
                color: AppColors.tealSecondary
                    .withValues(alpha: 0.15 * opacityFactor),
              ),
            ),
            // Purple blob
            Positioned(
              left: size.width * 0.3 + math.sin(t * 0.6 + 1) * 25,
              bottom: size.height * 0.08 + math.cos(t * 0.5) * 30,
              child: _Blob(
                size: 160,
                color: AppColors.accentPurple
                    .withValues(alpha: 0.10 * opacityFactor),
              ),
            ),
            // Global blur overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
