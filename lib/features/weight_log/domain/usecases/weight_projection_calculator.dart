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
  double calculateAverageWeeklyLoss(List<WeightLog> logs) {
    if (logs.length < 2) return 0;
    final sorted = List.of(logs)..sort((a, b) => a.date.compareTo(b.date));
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
  DateTime? calculateProjectedDateAtCurrentPace({
    required double currentWeight,
    required double targetWeight,
    required double averageWeeklyLoss,
  }) {
    if (averageWeeklyLoss <= 0 || currentWeight <= targetWeight) return null;
    final kgToLose = currentWeight - targetWeight;
    final weeksNeeded = kgToLose / averageWeeklyLoss;
    final daysNeeded = (weeksNeeded * 7).toInt();
    return DateTime.now().add(Duration(days: daysNeeded));
  }
}
