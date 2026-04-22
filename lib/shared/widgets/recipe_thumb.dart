import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';

/// Square thumbnail for a recipe asset image.
///
/// Falls back to a colored tile with a `utensils` icon when [imagePath] is
/// null or the asset can't be resolved.
class RecipeThumb extends StatelessWidget {
  const RecipeThumb({
    required this.imagePath,
    this.size = 56,
    this.radius = 12,
    this.fallbackColor = AppColors.emeraldPrimary,
    this.fallbackIcon = LucideIcons.utensils,
    super.key,
  });

  final String? imagePath;
  final double size;
  final double radius;
  final Color fallbackColor;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    if (imagePath == null || imagePath!.isEmpty) {
      return _fallback(borderRadius);
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        imagePath!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(borderRadius),
      ),
    );
  }

  Widget _fallback(BorderRadius borderRadius) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fallbackColor.withValues(alpha: 0.14),
        borderRadius: borderRadius,
      ),
      child: Icon(
        fallbackIcon,
        size: size * 0.42,
        color: fallbackColor,
      ),
    );
  }
}
