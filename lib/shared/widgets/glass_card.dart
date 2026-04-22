import 'package:flutter/material.dart';

/// Glassmorphism-style card.
///
/// Historically used a [BackdropFilter] blur, but that made long scrollable
/// lists janky on mobile (every visible card re-samples the pixels behind it
/// on each frame). The current implementation uses a slightly higher opacity
/// fill with a subtle gradient to preserve the frosted look without the
/// per-frame blur cost. Visually near-identical, massively cheaper to paint.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.accentColor,
    this.compact = false,
    @Deprecated('No longer applied — kept for source compatibility.')
    this.blur = 0,
    super.key,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final double blur;
  final VoidCallback? onTap;

  /// Optional colour for the left accent strip. If `null`, no strip is drawn.
  final Color? accentColor;

  /// Compact mode — intended for list items. Drops the double drop-shadow
  /// to a single light one and skips the `Material + InkWell` ripple stack
  /// when there's no `onTap`, which is a significant repaint cost on long
  /// scrollable lists. Tappable compact cards still get a `GestureDetector`
  /// (no Material ripple).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topOpacity = isDark ? 0.18 : 0.82;
    final bottomOpacity = isDark ? 0.10 : 0.70;
    final borderOpacity = isDark ? 0.12 : 0.55;
    final radius = BorderRadius.circular(borderRadius);
    final accent = accentColor;

    final shadows = compact
        ? <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
        : <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ];

    final decoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: topOpacity),
          Colors.white.withValues(alpha: bottomOpacity),
        ],
      ),
      borderRadius: radius,
      border: Border.all(
        color: Colors.white.withValues(alpha: borderOpacity),
      ),
      boxShadow: shadows,
    );

    final body = Stack(
      children: [
        if (accent != null)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  bottomLeft: Radius.circular(borderRadius),
                ),
              ),
            ),
          ),
        Padding(
          padding: accent != null
              ? EdgeInsets.fromLTRB(
                  padding.left + 6,
                  padding.top,
                  padding.right,
                  padding.bottom,
                )
              : padding,
          child: child,
        ),
      ],
    );

    // Compact list cards skip the Material+Ink+InkWell ripple stack: the
    // Material 3 state-layer has known lag issues after many taps (Flutter
    // #105675) and the extra layers add overdraw on every row during
    // scroll. A plain GestureDetector is enough for a tap callback.
    if (compact) {
      final decorated = DecoratedBox(
        decoration: decoration,
        child: body,
      );
      if (onTap == null) return decorated;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: decorated,
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: body,
        ),
      ),
    );
  }
}
