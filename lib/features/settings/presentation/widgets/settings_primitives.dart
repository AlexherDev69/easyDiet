import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Section wrapper matching handoff: eyebrow label + title + glass card body.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.eyebrow,
    required this.title,
    required this.children,
    super.key,
  });

  final String eyebrow;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.emeraldDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          GlassCard(
            padding: const EdgeInsets.all(12),
            borderRadius: 18,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section inner divider (subtle hairline).
class SettingsRowDivider extends StatelessWidget {
  const SettingsRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
    );
  }
}

/// Tappable row with colored icon badge + label + optional value + chevron.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.icon,
    required this.color,
    required this.label,
    this.value,
    this.onTap,
    this.last = false,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
              child: Row(
                children: [
                  _IconBadge(icon: icon, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.1,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  if (value != null) ...[
                    Text(
                      value!,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (onTap != null)
                    Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: const Color(0xFF64748B).withValues(alpha: 0.5),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!last) const SettingsRowDivider(),
      ],
    );
  }
}

/// Row with toggle switch, colored icon badge, label + optional subtitle.
class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.last = false,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
          child: Row(
            children: [
              _IconBadge(icon: icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
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
              ),
              _GradientSwitch(value: value, onChanged: onChanged),
            ],
          ),
        ),
        if (!last) const SettingsRowDivider(),
      ],
    );
  }
}

/// Compact chip used for allergies / excluded meats.
class SettingsChip extends StatelessWidget {
  const SettingsChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.color = AppColors.emeraldPrimary,
    super.key,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: active
                ? color.withValues(alpha: 0.13)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? color.withValues(alpha: 0.27)
                  : const Color(0xFF0F172A).withValues(alpha: 0.06),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
              color: active ? color : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon tile (34x34, colored tinted background).
class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

/// Handoff-style gradient switch (44x26, emerald gradient when on).
class _GradientSwitch extends StatelessWidget {
  const _GradientSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          gradient: value
              ? const LinearGradient(
                  colors: [
                    AppColors.emeraldPrimary,
                    Color(0xFF059669),
                  ],
                )
              : null,
          color: value ? null : const Color(0xFF0F172A).withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(13),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              top: 3,
              left: value ? 21 : 3,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Back pill (40x40 glass circle with chevron).
class BackPill extends StatelessWidget {
  const BackPill({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          child: const Icon(
            LucideIcons.chevronLeft,
            size: 18,
            color: Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
