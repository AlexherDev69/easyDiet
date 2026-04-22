import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../shared/widgets/glass_card.dart';

/// Tile in the dashboard 2×2 quick-actions grid.
///
/// Layout: top row shows a coloured icon tile + arrow chevron, bottom
/// rows show the label and an optional subtitle.
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 18, color: accentColor),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  LucideIcons.arrowRight,
                  size: 14,
                  color: const Color(0xFF64748B).withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: const Color(0xFF0F172A),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 1),
            Text(
              subtitle!,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
