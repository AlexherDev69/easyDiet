import 'package:flutter/material.dart';

/// A simple rounded card with solid background and shadow.
/// Port of SolidCard.kt.
class SolidCard extends StatelessWidget {
  const SolidCard({
    required this.child,
    this.backgroundColor,
    this.cornerRadius = 20,
    this.elevation = 2,
    this.contentPadding = const EdgeInsets.all(16),
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;
  final double cornerRadius;
  final double elevation;
  final EdgeInsets contentPadding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? Theme.of(context).colorScheme.surface;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    );

    return Material(
      elevation: elevation,
      shape: shape,
      color: bgColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: contentPadding,
          child: child,
        ),
      ),
    );
  }
}
