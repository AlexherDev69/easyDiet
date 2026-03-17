enum DietType {
  omnivore('Omnivore'),
  vegetarian('Vegetarien'),
  vegan('Vegetalien');

  const DietType(this.displayName);
  final String displayName;
}
