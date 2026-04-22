import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';

/// Greeting header with gradient first-name and circular settings button.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    required this.userName,
    required this.onSettingsClick,
    super.key,
  });

  final String userName;
  final VoidCallback onSettingsClick;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Bonjour';
    if (hour >= 12 && hour < 18) return 'Bon apres-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting,',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              ShaderMask(
                shaderCallback: (rect) => gradient.createShader(rect),
                blendMode: BlendMode.srcIn,
                child: Text(
                  userName,
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    height: 1.1,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _SettingsButton(
          isDark: isDark,
          onTap: onSettingsClick,
        ),
      ],
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.isDark, required this.onTap});

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Ink(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.65),
          border: Border.all(
            color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Tooltip(
            message: 'Parametres',
            child: const Center(
              child: Icon(
                LucideIcons.settings,
                color: Color(0xFF475569),
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
