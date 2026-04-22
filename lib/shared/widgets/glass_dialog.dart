import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

/// Shows a glassmorphism-styled dialog with frosted glass background.
Future<T?> showGlassDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    useRootNavigator: useRootNavigator,
    transitionDuration: const Duration(milliseconds: 240),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return builder(context);
    },
  );
}

// ── Dialog container ───────────────────────────────────────────────────────

/// Glassmorphism dialog container matching the app redesign.
class GlassDialogContent extends StatelessWidget {
  const GlassDialogContent({
    required this.child,
    this.icon,
    this.iconColor,
    this.iconGradient,
    this.title,
    this.subtitle,
    super.key,
  });

  final Widget child;
  final IconData? icon;
  final Color? iconColor;
  final Gradient? iconGradient;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      _IconBadge(
                        icon: icon!,
                        color: iconColor,
                        gradient: iconGradient,
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (title != null) ...[
                      Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                    if (title != null || icon != null)
                      const SizedBox(height: 18),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, this.color, this.gradient});

  final IconData icon;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final base = color ?? AppColors.emeraldPrimary;
    final effectiveGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [base, base.withValues(alpha: 0.82)],
        );

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: base.withValues(alpha: 0.32),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}

// ── Buttons ────────────────────────────────────────────────────────────────

/// Glass-style secondary button (cancel, dismiss).
class GlassDialogButton extends StatelessWidget {
  const GlassDialogButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}

/// Emerald gradient primary button.
class GlassDialogPrimaryButton extends StatelessWidget {
  const GlassDialogPrimaryButton({
    required this.label,
    required this.onPressed,
    this.color,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final base = color ?? AppColors.emeraldPrimary;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: disabled ? 0.45 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [base, base.withValues(alpha: 0.85)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color: base.withValues(alpha: 0.4),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
            ),
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Danger (rose) button for destructive actions.
class GlassDialogDangerButton extends StatelessWidget {
  const GlassDialogDangerButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassDialogPrimaryButton(
      label: label,
      onPressed: onPressed,
      color: AppColors.accentRose,
    );
  }
}

/// Row of two action buttons.
class GlassDialogActions extends StatelessWidget {
  const GlassDialogActions({
    required this.secondary,
    required this.primary,
    super.key,
  });

  final Widget secondary;
  final Widget primary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: secondary),
        const SizedBox(width: 10),
        Expanded(child: primary),
      ],
    );
  }
}

// ── List tile ──────────────────────────────────────────────────────────────

/// Selectable glass row used in list dialogs.
class GlassDialogListTile extends StatelessWidget {
  const GlassDialogListTile({
    required this.onTap,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final VoidCallback onTap;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      DefaultTextStyle(
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.1,
                          color: const Color(0xFF0F172A),
                        ),
                        child: title!,
                      ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      DefaultTextStyle(
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                        child: subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
