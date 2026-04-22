import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/dashboard_models.dart';

/// Horizontal day selector — vertical 54×68 pill tiles.
///
/// Selected tile uses the emerald primary gradient with soft emerald shadow;
/// unselected tiles are frosted-glass style (white 65 %, 1 px border).
class DaySelector extends StatelessWidget {
  const DaySelector({
    required this.weekSchedule,
    required this.selectedIndex,
    required this.onSelectDay,
    super.key,
  });

  final List<DayScheduleItem> weekSchedule;
  final int selectedIndex;
  final ValueChanged<int> onSelectDay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: weekSchedule.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = weekSchedule[index];
          final isSelected = index == selectedIndex;
          return _DayPill(
            day: day,
            isSelected: isSelected,
            onTap: () => onSelectDay(index),
          );
        },
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final DayScheduleItem day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = ExtendedColorsProvider.of(context).primaryGradient;
    final abbrev = day.dayName.length >= 3
        ? day.dayName.substring(0, 3).toUpperCase()
        : day.dayName.toUpperCase();

    final textColor = isSelected ? Colors.white : const Color(0xFF0F172A);
    final abbrevOpacity = isSelected ? 0.85 : 0.55;

    return Semantics(
      label: '${day.dayName}, ${day.date.day}'
          '${day.isToday ? ", aujourd'hui" : ""}',
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            width: 54,
            height: 68,
            decoration: BoxDecoration(
              gradient: isSelected ? gradient : null,
              color: isSelected
                  ? null
                  : Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(18),
              border: isSelected
                  ? null
                  : Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.30),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  abbrev,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: textColor.withValues(alpha: abbrevOpacity),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${day.date.day}',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
