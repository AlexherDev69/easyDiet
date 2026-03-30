import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../../data/local/database.dart';
import '../../../../shared/widgets/solid_card.dart';

// Duration constants — micro-interactions stay under 300ms.
const Duration _kCheckDuration = Duration(milliseconds: 250);

/// A single shopping item row with animated checkbox, background tint,
/// and animated strikethrough text when checked.
class ShoppingItemRow extends StatelessWidget {
  const ShoppingItemRow({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onShowDetail,
    super.key,
  });

  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onShowDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Checked state drives a green-tinted card background.
    final cardColor = item.isChecked
        ? AppColors.emeraldSurface.withValues(alpha: 0.6)
        : theme.colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: _kCheckDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cardColor,
        ),
        child: SolidCard(
          elevation: item.isChecked ? 0 : 1,
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          onTap: onShowDetail,
          child: Row(
            children: [
              // Animated check icon replaces the plain Checkbox.
              _AnimatedCheckbox(
                isChecked: item.isChecked,
                onToggle: onToggle,
              ),
              Expanded(
                child: _AnimatedItemLabel(
                  isChecked: item.isChecked,
                  label:
                      '${item.name} - ${QuantityFormatter.formatWithUnit(item.quantity, item.unit)}',
                ),
              ),
              if (item.isManuallyAdded)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, color: theme.colorScheme.error),
                  tooltip: 'Supprimer',
                )
              else
                IconButton(
                  onPressed: onShowDetail,
                  icon: Icon(
                    Icons.info,
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  tooltip: 'Informations',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated check icon that scales in when checked.
class _AnimatedCheckbox extends StatelessWidget {
  const _AnimatedCheckbox({
    required this.isChecked,
    required this.onToggle,
  });

  final bool isChecked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: isChecked,
      button: true,
      label: isChecked ? 'Decocher' : 'Cocher',
      child: GestureDetector(
        onTap: onToggle,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Center(
            child: AnimatedSwitcher(
              duration: _kCheckDuration,
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: isChecked
                  ? const Icon(
                      Icons.check_circle,
                      key: ValueKey('checked'),
                      color: AppColors.emeraldPrimary,
                      size: 24,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      key: const ValueKey('unchecked'),
                      color: AppColors.gray400,
                      size: 24,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Text label that fades to gray with an animated strikethrough when checked.
/// `TweenAnimationBuilder` drives the opacity from 1.0 to 0.45.
class _AnimatedItemLabel extends StatelessWidget {
  const _AnimatedItemLabel({
    required this.isChecked,
    required this.label,
  });

  final bool isChecked;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isChecked ? 0.45 : 1.0),
      duration: _kCheckDuration,
      curve: Curves.easeInOut,
      builder: (context, opacity, _) {
        return Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            // Blend toward gray400 at low opacity for a strikethrough feel.
            color: Color.lerp(baseColor, AppColors.gray400, 1.0 - opacity),
            decoration: isChecked ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.gray400,
          ),
        );
      },
    );
  }
}
