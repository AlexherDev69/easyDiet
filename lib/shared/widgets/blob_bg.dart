import 'dart:ui';

import 'package:flutter/material.dart';

/// Animated 3-blob gradient background — port of `BlobBG.jsx`.
///
/// Renders three large radial-gradient circles (emerald, teal, purple) that
/// drift and scale gently in and out. Respects `MediaQuery.disableAnimations`
/// (reduced-motion accessibility setting) by falling back to a static layout.
///
/// Place as the first child of a [Stack] that fills the screen.
class BlobBG extends StatefulWidget {
  const BlobBG({this.intensity = 1.0, this.paused = false, super.key});

  /// Multiplier on blob opacity. `1.0` matches the handoff design.
  final double intensity;

  /// When `true`, the three blob animation controllers are stopped so they
  /// no longer request a vsync frame every 16ms. Use this to pause the
  /// background animation while the user is actively scrolling a heavy
  /// list — even with `RepaintBoundary` isolating rasterization, the
  /// running tickers still schedule frames on the engine side.
  final bool paused;

  @override
  State<BlobBG> createState() => _BlobBGState();
}

class _BlobBGState extends State<BlobBG> with TickerProviderStateMixin {
  late final AnimationController _c1;
  late final AnimationController _c2;
  late final AnimationController _c3;

  @override
  void initState() {
    super.initState();
    _c1 = AnimationController(vsync: this, duration: const Duration(seconds: 18));
    _c2 = AnimationController(vsync: this, duration: const Duration(seconds: 22));
    _c3 = AnimationController(vsync: this, duration: const Duration(seconds: 26));
    if (!widget.paused) _startAll();
  }

  void _startAll() {
    _c1.repeat(reverse: true);
    _c2.repeat(reverse: true);
    _c3.repeat(reverse: true);
  }

  void _stopAll() {
    _c1.stop();
    _c2.stop();
    _c3.stop();
  }

  @override
  void didUpdateWidget(covariant BlobBG oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.paused != oldWidget.paused) {
      widget.paused ? _stopAll() : _startAll();
    }
  }

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    final intensity = widget.intensity;

    // RepaintBoundary isolates the animated blob layers from siblings
    // (scrollable content, nav bar) so scrolling never invalidates them.
    return RepaintBoundary(
      child: IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Container(
            width: w,
            height: h,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -1.0),
                radius: 1.4,
                colors: [
                  Color(0xFFECFDF5),
                  Color(0xFFF0FDF4),
                  Color(0xFFF0FDFA),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: ClipRect(
              child: Stack(
                children: [
                  _Blob(
                    controller: _c1,
                    reducedMotion: reducedMotion,
                    left: -0.20 * w,
                    top: -0.15 * h,
                    size: 0.75 * w,
                    baseColor: const Color(0xFF10B981),
                    opacity: 0.55 * intensity,
                    translate: const Offset(40, 60),
                    scaleTo: 1.10,
                  ),
                  _Blob(
                    controller: _c2,
                    reducedMotion: reducedMotion,
                    left: w - 0.55 * w,
                    top: 0.20 * h,
                    size: 0.80 * w,
                    baseColor: const Color(0xFF14B8A6),
                    opacity: 0.45 * intensity,
                    translate: const Offset(-30, 40),
                    scaleTo: 1.15,
                  ),
                  _Blob(
                    controller: _c3,
                    reducedMotion: reducedMotion,
                    left: 0.10 * w,
                    top: h - 0.50 * w,
                    size: 0.70 * w,
                    baseColor: const Color(0xFF8B5CF6),
                    opacity: 0.38 * intensity,
                    translate: const Offset(50, -40),
                    scaleTo: 0.92,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.controller,
    required this.reducedMotion,
    required this.left,
    required this.top,
    required this.size,
    required this.baseColor,
    required this.opacity,
    required this.translate,
    required this.scaleTo,
  });

  final AnimationController controller;
  final bool reducedMotion;
  final double left;
  final double top;
  final double size;
  final Color baseColor;
  final double opacity;
  final Offset translate;
  final double scaleTo;

  @override
  Widget build(BuildContext context) {
    final eased = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    return AnimatedBuilder(
      animation: eased,
      builder: (context, child) {
        final t = reducedMotion ? 0.0 : eased.value;
        final dx = translate.dx * t;
        final dy = translate.dy * t;
        final scale = 1.0 + (scaleTo - 1.0) * t;
        return Positioned(
          left: left + dx,
          top: top + dy,
          width: size,
          height: size,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      // RepaintBoundary here is CRITICAL for perf: it caches the blurred
      // blob as a raster texture. Without it, the ImageFilter.blur would
      // re-run on GPU every frame because the parent AnimatedBuilder
      // rebuilds the Transform on each tick. With it, the blur is computed
      // once and subsequent frames only re-composite the cached texture —
      // Transform.scale/Positioned are ~free GPU ops on a retained layer.
      child: RepaintBoundary(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.4, -0.4),
                radius: 0.7,
                colors: [
                  baseColor.withValues(alpha: opacity),
                  baseColor.withValues(alpha: 0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

