enum ExcludedMeat {
  pork('Porc', ['PORK']),
  beef('Boeuf', ['BEEF']),
  lamb('Agneau', ['LAMB']),
  shellfishMeat('Fruits de mer', ['SHELLFISH']),
  allMeat('Toute viande',
      ['PORK', 'BEEF', 'POULTRY', 'VEAL', 'LAMB', 'FISH', 'SHELLFISH']),
  allFish('Tout poisson', ['FISH', 'SHELLFISH']);

  const ExcludedMeat(this.displayName, this.jsonKeys);
  final String displayName;

  /// Canonical uppercase keys used in recipe JSON `meatTypes`.
  /// Aggregate values (allMeat, allFish) expand to multiple keys.
  /// Profiles store enum `.name` (camelCase); this maps to the JSON form
  /// for filtering against recipes.
  final List<String> jsonKeys;
}
