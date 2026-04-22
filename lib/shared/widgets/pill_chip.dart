import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Pill-shaped selection chip with glassmorphism style.
///
/// When [selected], shows an emerald gradient fill with white text.
/// When unselected, shows a semi-transparent glass background.
class PillChip extends StatelessWidget {
  const PillChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Optional leading icon widget (use [Icon], not emoji text).
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = selected
        ? Colors.white
        : theme.textTheme.bodyMedium?.color ?? Colors.black87;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        splashColor: AppColors.emeraldPrimary.withValues(alpha: 0.15),
        highlightColor: AppColors.emeraldPrimary.withValues(alpha: 0.08),
        child: AnimatedScale(
          scale: selected ? 1.0 : 0.97,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Ink(
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              gradient: selected
                  ? const LinearGradient(
                      colors: [
                        AppColors.emeraldPrimary,
                        AppColors.emeraldDark,
                      ],
                    )
                  : null,
              color: selected ? null : Colors.white.withValues(alpha: 0.7),
              shadows: selected
                  ? [
                      BoxShadow(
                        color:
                            AppColors.emeraldPrimary.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    IconTheme(
                      data: IconThemeData(color: textColor, size: 18),
                      child: icon!,
                    ),
                    const SizedBox(width: 6),
                  ],
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: textColor,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                    child: Text(label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
