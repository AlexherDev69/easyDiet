import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_text_styles.dart';

/// Section header: "RAYON" uppercase emerald + divider + x/y counter.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.itemCount,
    required this.checkedCount,
    required this.isCollapsed,
    required this.onToggle,
    super.key,
  });

  final String title;
  final int itemCount;
  final int checkedCount;
  final bool isCollapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Row(
          children: [
            Icon(
              isCollapsed
                  ? LucideIcons.chevronRight
                  : LucideIcons.chevronDown,
              size: 14,
              color: const Color(0xFF059669),
            ),
            const SizedBox(width: 4),
            Text(
              title.toUpperCase(),
              style: AppText.eyebrow11,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF0F172A).withValues(alpha: 0.08),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$checkedCount/$itemCount',
              style: AppText.counter10,
            ),
          ],
        ),
      ),
    );
  }
}
