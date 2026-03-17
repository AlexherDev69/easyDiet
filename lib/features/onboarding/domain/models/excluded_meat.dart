enum ExcludedMeat {
  pork('Porc'),
  beef('Boeuf'),
  lamb('Agneau'),
  shellfishMeat('Fruits de mer'),
  allMeat('Toute viande'),
  allFish('Tout poisson');

  const ExcludedMeat(this.displayName);
  final String displayName;
}
