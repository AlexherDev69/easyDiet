import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_title.dart';

/// Step 1: Height and weight — slider-based input.
class BodyMetricsStep extends StatelessWidget {
  const BodyMetricsStep({
    required this.height,
    required this.weight,
    required this.onHeightChange,
    required this.onWeightChange,
    super.key,
  });

  final String height;
  final String weight;
  final ValueChanged<String> onHeightChange;
  final ValueChanged<String> onWeightChange;

  static const _heightMin = 140.0;
  static const _heightMax = 210.0;
  static const _weightMin = 40.0;
  static const _weightMax = 180.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final heightValue =
        (double.tryParse(height) ?? 170).clamp(_heightMin, _heightMax);
    final weightValue =
        (double.tryParse(weight) ?? 70).clamp(_weightMin, _weightMax);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GradientTitle('Mensurations'),
          const SizedBox(height: 8),
          Text(
            'Ces donnees permettent de calculer vos besoins caloriques.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _SliderField(
                  icon: LucideIcons.ruler,
                  iconColor: const Color(0xFF0EA5E9),
                  label: 'Taille',
                  unit: 'cm',
                  value: heightValue,
                  min: _heightMin,
                  max: _heightMax,
                  divisions: (_heightMax - _heightMin).toInt(),
                  decimals: 0,
                  onChanged: (v) => onHeightChange(v.round().toString()),
                ),
                const SizedBox(height: 20),
                _SliderField(
                  icon: LucideIcons.scale,
                  iconColor: const Color(0xFFF59E0B),
                  label: 'Poids',
                  unit: 'kg',
                  value: weightValue,
                  min: _weightMin,
                  max: _weightMax,
                  divisions: ((_weightMax - _weightMin) * 2).toInt(),
                  decimals: 1,
                  onChanged: (v) =>
                      onWeightChange((((v * 2).round()) / 2).toStringAsFixed(1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  const _SliderField({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.decimals,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String unit;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final int decimals;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final display = decimals == 0
        ? value.round().toString()
        : value.toStringAsFixed(decimals);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.emeraldPrimary, AppColors.emeraldDark],
                ),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '$display $unit',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.emeraldPrimary,
            inactiveTrackColor: const Color(0xFF0F172A).withValues(alpha: 0.08),
            thumbColor: Colors.white,
            overlayColor: AppColors.emeraldPrimary.withValues(alpha: 0.15),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12,
              elevation: 4,
            ),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
