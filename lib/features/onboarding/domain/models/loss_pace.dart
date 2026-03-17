enum LossPace {
  gentle(250, 0.5, 'Doux', '0.5 kg/semaine'),
  moderate(400, 0.75, 'Modere', '0.75 kg/semaine'),
  fast(500, 1.0, 'Rapide', '1 kg/semaine');

  const LossPace(this.deficitKcal, this.kgPerWeek, this.displayName, this.description);
  final int deficitKcal;
  final double kgPerWeek;
  final String displayName;
  final String description;
}
