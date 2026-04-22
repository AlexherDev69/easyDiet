import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/gradient_title.dart';
import '../../../../shared/widgets/pill_chip.dart';
import '../../domain/models/models.dart';

/// Step 2: Target weight, loss pace, activity, diet type, calorie display.
class GoalStep extends StatelessWidget {
  const GoalStep({
    required this.targetWeight,
    required this.currentWeight,
    required this.lossPace,
    required this.activityLevel,
    required this.dietType,
    required this.calculatedCalories,
    required this.calculatedWaterMl,
    required this.onTargetWeightChange,
    required this.onLossPaceChange,
    required this.onActivityLevelChange,
    required this.onDietTypeChange,
    super.key,
  });

  final String targetWeight;
  final String currentWeight;
  final LossPace lossPace;
  final ActivityLevel activityLevel;
  final DietType dietType;
  final int calculatedCalories;
  final int calculatedWaterMl;
  final ValueChanged<String> onTargetWeightChange;
  final ValueChanged<LossPace> onLossPaceChange;
  final ValueChanged<ActivityLevel> onActivityLevelChange;
  final ValueChanged<DietType> onDietTypeChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GradientTitle('Objectifs'),
          const SizedBox(height: 8),
          Text(
            'Definissez votre objectif de poids et votre rythme.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Loss pace — one GlassCard per option with emerald left-border accent
          Text('Rythme de perte', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...LossPace.values.map(
            (pace) => _SelectableOptionCard(
              title: pace.displayName,
              subtitle: pace.description,
              selected: lossPace == pace,
              onTap: () => onLossPaceChange(pace),
            ),
          ),
          const SizedBox(height: 16),

          // Activity level — same pattern
          Text('Niveau d\'activite', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...ActivityLevel.values.map(
            (level) => _SelectableOptionCard(
              title: level.displayName,
              subtitle: level.description,
              selected: activityLevel == level,
              onTap: () => onActivityLevelChange(level),
            ),
          ),
          const SizedBox(height: 16),

          // Diet type — PillChip
          Text('Type de regime', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DietType.values.map((dt) {
              return PillChip(
                label: dt.displayName,
                selected: dietType == dt,
                onTap: () => onDietTypeChange(dt),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Target weight — slider
          Text('Objectif', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: _TargetWeightSlider(
              targetWeight: targetWeight,
              currentWeight: currentWeight,
              onChanged: onTargetWeightChange,
            ),
          ),
          const SizedBox(height: 24),

          // Calorie summary — GlassCard
          if (calculatedCalories > 0)
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CalorieInfo(
                    label: 'Calories / jour',
                    value: calculatedCalories.toString(),
                    unit: 'kcal',
                  ),
                  _CalorieInfo(
                    label: 'Eau / jour',
                    value: (calculatedWaterMl / 1000).toStringAsFixed(1),
                    unit: 'L',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Glassmorphism selectable option card.
///
/// Shows a 4px emerald left-border accent when [selected] to give a clear
/// but non-intrusive selection state without resorting to a full color fill.
class _SelectableOptionCard extends StatelessWidget {
  const _SelectableOptionCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        // Remove clip so our custom left-border container shows cleanly
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: selected
                    ? AppColors.emeraldPrimary
                    : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? AppColors.emeraldPrimary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Checkmark replaces radio icon — cleaner in glass context
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: selected ? 1 : 0,
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.emeraldPrimary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TargetWeightSlider extends StatelessWidget {
  const _TargetWeightSlider({
    required this.targetWeight,
    required this.currentWeight,
    required this.onChanged,
  });

  final String targetWeight;
  final String currentWeight;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const sliderMin = 40.0;
    const sliderMax = 180.0;

    final current = double.tryParse(currentWeight);
    final upperBound =
        current != null ? (current - 0.5).clamp(sliderMin, sliderMax) : sliderMax;

    final parsedTarget = double.tryParse(targetWeight);
    final fallback = current != null
        ? (current - 5).clamp(sliderMin, upperBound)
        : 70.0;
    final value = (parsedTarget ?? fallback).clamp(sliderMin, upperBound);

    final divisions = ((upperBound - sliderMin) * 2).round().clamp(1, 10000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.flag,
                size: 18,
                color: Color(0xFFF43F5E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Poids cible',
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
                '${value.toStringAsFixed(1)} kg',
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
            min: sliderMin,
            max: upperBound,
            divisions: divisions,
            onChanged: (v) => onChanged((((v * 2).round()) / 2).toStringAsFixed(1)),
          ),
        ),
        if (current != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Difference : ${(current - value).toStringAsFixed(1)} kg',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
      ],
    );
  }
}

class _CalorieInfo extends StatelessWidget {
  const _CalorieInfo({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(unit, style: theme.textTheme.labelSmall),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
