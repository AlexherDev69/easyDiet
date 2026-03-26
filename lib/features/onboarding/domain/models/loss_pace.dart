enum LossPace {
  gentle(350, 0.3, 'Doux', '0.3 kg/semaine'),
  moderate(500, 0.5, 'Modere', '0.5 kg/semaine'),
  fast(750, 0.7, 'Rapide', '0.7 kg/semaine');

  const LossPace(this.deficitKcal, this.kgPerWeek, this.displayName, this.description);
  final int deficitKcal;
  final double kgPerWeek;
  final String displayName;
  final String description;
}
