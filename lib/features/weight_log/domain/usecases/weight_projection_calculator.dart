import '../../../../data/local/database.dart';
import '../../../onboarding/domain/models/loss_pace.dart';

/// Projects goal dates based on weight loss pace and actual progress.
class WeightProjectionCalculator {
  const WeightProjectionCalculator();

  /// Estimated goal date based on target loss pace and diet adherence.
  DateTime? calculateEstimatedGoalDate({
    required double currentWeight,
    required double targetWeight,
    required LossPace lossPace,
    required int dietDaysPerWeek,
    DateTime? startDate,
  }) {
    if (currentWeight <= targetWeight) return null;
    final start = startDate ?? DateTime.now();
    final kgToLose = currentWeight - targetWeight;
    final adjustedWeeklyLoss = lossPace.kgPerWeek * (dietDaysPerWeek / 7.0);
    if (adjustedWeeklyLoss <= 0) return null;
    final weeksNeeded = kgToLose / adjustedWeeklyLoss;
    final daysNeeded = (weeksNeeded * 7).toInt();
    return start.add(Duration(days: daysNeeded));
  }

  /// Average weekly weight loss from log entries.
  ///
  /// When at least 7 entries are available, uses a 7-day simple moving average
  /// (SMA) over the last 7 data points to derive a more stable weekly rate.
  /// For fewer entries falls back to the first-to-last delta method.
  double calculateAverageWeeklyLoss(List<WeightLog> logs) {
    if (logs.length < 2) return 0;
    final sorted = List.of(logs)..sort((a, b) => a.date.compareTo(b.date));

    if (sorted.length >= 7) {
      final window = sorted.sublist(sorted.length - 7);
      final smaFirst = window.first.weightKg;
      final smaLast = window.last.weightKg;
      final daysDiff =
          (window.last.date - window.first.date) / (1000 * 60 * 60 * 24.0);
      if (daysDiff < 1) return 0;
      final weeksDiff = daysDiff / 7.0;
      return (smaFirst - smaLast) / weeksDiff;
    }

    // Fallback: first-to-last delta for sparse data.
    final firstWeight = sorted.first.weightKg;
    final lastWeight = sorted.last.weightKg;
    final daysDiff =
        (sorted.last.date - sorted.first.date) / (1000 * 60 * 60 * 24.0);
    if (daysDiff < 1) return 0;
    final weeksDiff = daysDiff / 7.0;
    return (firstWeight - lastWeight) / weeksDiff;
  }

  /// Simple total weight lost.
  double calculateTotalLost(double initialWeight, double currentWeight) {
    return initialWeight - currentWeight;
  }

  /// Projected goal date at current observed pace.
  /// Anchors to [referenceDate] (typically the latest log date) instead of
  /// DateTime.now() so retroactive entries produce correct projections.
  DateTime? calculateProjectedDateAtCurrentPace({
    required double currentWeight,
    required double targetWeight,
    required double averageWeeklyLoss,
    DateTime? referenceDate,
  }) {
    if (averageWeeklyLoss <= 0 || currentWeight <= targetWeight) return null;
    final kgToLose = currentWeight - targetWeight;
    final weeksNeeded = kgToLose / averageWeeklyLoss;
    final daysNeeded = (weeksNeeded * 7).toInt();
    final anchor = referenceDate ?? DateTime.now();
    return anchor.add(Duration(days: daysNeeded));
  }

  /// Whether the observed loss rate exceeds safe thresholds (> 1 kg/week).
  static const double aggressiveLossThreshold = 1.0;

  bool isAggressiveLossRate(double averageWeeklyLoss) {
    return averageWeeklyLoss > aggressiveLossThreshold;
  }
}
