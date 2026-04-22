import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_title.dart';

/// Step 0: Welcome screen — EasyDiet hero + 4 feature bullets.
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  static const _bullets = <_Bullet>[
    _Bullet(
      icon: LucideIcons.chefHat,
      color: Color(0xFF10B981),
      title: 'Plans personnalises',
      subtitle: '96 recettes adaptees a vos objectifs.',
    ),
    _Bullet(
      icon: LucideIcons.shoppingBasket,
      color: Color(0xFF8B5CF6),
      title: 'Liste de courses auto',
      subtitle: 'Genere en un clic pour la semaine.',
    ),
    _Bullet(
      icon: LucideIcons.flame,
      color: Color(0xFFF59E0B),
      title: 'Suivi calorique precis',
      subtitle: 'Ajuste a votre metabolisme et votre rythme.',
    ),
    _Bullet(
      icon: LucideIcons.wifiOff,
      color: Color(0xFF0EA5E9),
      title: 'Tout hors-ligne',
      subtitle: 'Vos donnees restent sur votre appareil.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GradientTitle('Bienvenue'),
          const SizedBox(height: 8),
          Text(
            'EasyDiet cree un plan de repas adapte a votre corps, votre rythme et vos preferences.',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 20),
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                for (var i = 0; i < _bullets.length; i++) ...[
                  _BulletRow(bullet: _bullets[i]),
                  if (i != _bullets.length - 1)
                    const Divider(
                      height: 20,
                      thickness: 1,
                      color: Color(0x140F172A),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.emeraldPrimary.withValues(alpha: 0.12),
                  AppColors.emeraldDark.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.emeraldPrimary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.sparkles,
                  size: 18,
                  color: AppColors.emeraldDark,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Quelques minutes pour configurer votre plan.',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.emeraldDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet {
  const _Bullet({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.bullet});

  final _Bullet bullet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bullet.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(bullet.icon, size: 20, color: bullet.color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bullet.title,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                bullet.subtitle,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
