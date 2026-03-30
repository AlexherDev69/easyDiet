import '../../../../core/constants/app_constants.dart';

enum LossPace {
  gentle(350, 'Doux'),
  moderate(500, 'Modere'),
  fast(750, 'Rapide');

  const LossPace(this.deficitKcal, this.displayName);
  final int deficitKcal;
  final String displayName;

  /// Accurate kg/week derived from the deficit and the energy density of fat.
  double get kgPerWeek =>
      (deficitKcal * 7) / AppConstants.kcalPerKgFat;

  String get description =>
      '${kgPerWeek.toStringAsFixed(1)} kg/semaine';
}
