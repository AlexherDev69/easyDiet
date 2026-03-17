import 'package:intl/intl.dart';

/// Port of DateUtils.kt — date formatting and helpers.
class AppDateUtils {
  AppDateUtils._();

  static final _frenchFormatter = DateFormat('d MMMM yyyy', 'fr_FR');
  static final _shortFormatter = DateFormat('d MMM', 'fr_FR');
  static final _dayFormatter = DateFormat('EEEE d', 'fr_FR');

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static int todayMillis() => today().millisecondsSinceEpoch;

  static int toEpochMillis(DateTime date) =>
      DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;

  static DateTime fromEpochMillis(int millis) =>
      DateTime.fromMillisecondsSinceEpoch(millis);

  /// Returns the Monday of the week containing [date].
  static DateTime getWeekStartDate([DateTime? date]) {
    final d = date ?? today();
    final weekday = d.weekday; // Monday = 1
    return d.subtract(Duration(days: weekday - 1));
  }

  /// e.g. "15 mars 2026"
  static String formatFrenchDate(DateTime date) =>
      _frenchFormatter.format(date);

  /// e.g. "15 mars"
  static String formatShortDate(DateTime date) =>
      _shortFormatter.format(date);

  /// e.g. "Lundi 15"
  static String formatDayName(DateTime date) {
    final formatted = _dayFormatter.format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  /// Day of week number (1=Monday) to French name.
  static String getDayOfWeekFrench(int dayOfWeek) {
    const days = {
      1: 'Lundi',
      2: 'Mardi',
      3: 'Mercredi',
      4: 'Jeudi',
      5: 'Vendredi',
      6: 'Samedi',
      7: 'Dimanche',
    };
    return days[dayOfWeek] ?? '';
  }
}
