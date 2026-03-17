import 'package:flutter/material.dart';

/// A card with a linear gradient background and rounded corners.
/// Port of GradientCard.kt.
class GradientCard extends StatelessWidget {
  const GradientCard({
    required this.child,
    this.gradientColors,
    this.cornerRadius = 20,
    this.elevation = 4,
    this.contentPadding = const EdgeInsets.all(16),
    super.key,
  });

  final Widget child;
  final List<Color>? gradientColors;
  final double cornerRadius;
  final double elevation;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [
          Theme.of(context).colorScheme.primaryContainer,
          Theme.of(context).colorScheme.secondaryContainer,
        ];
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    );

    return Material(
      elevation: elevation,
      shadowColor: colors.first.withValues(alpha: 0.25),
      shape: shape,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cornerRadius),
          gradient: LinearGradient(colors: colors),
        ),
        padding: contentPadding,
        width: double.infinity,
        child: child,
      ),
    );
  }
}
