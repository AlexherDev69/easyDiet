enum ActivityLevel {
  sedentary(1.2, 'Sedentaire', 'Bureau, peu de mouvement'),
  lightlyActive(1.375, 'Legerement actif', '1-2 seances/semaine'),
  moderatelyActive(1.55, 'Moderement actif', '3-5 seances/semaine'),
  veryActive(1.725, 'Tres actif', '6-7 seances/semaine');

  const ActivityLevel(this.factor, this.displayName, this.description);
  final double factor;
  final String displayName;
  final String description;
}
