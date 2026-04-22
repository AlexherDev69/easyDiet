enum Allergy {
  gluten('Gluten', 'GLUTEN'),
  lactose('Lactose', 'LACTOSE'),
  treeNuts('Fruits a coque', 'TREE_NUTS'),
  birchPollen('Pollen de bouleau (SBA)', 'BIRCH_POLLEN'),
  shellfish('Crustaces', 'SHELLFISH'),
  eggs('Oeufs', 'EGGS'),
  soy('Soja', 'SOY');

  const Allergy(this.displayName, this.jsonKey);
  final String displayName;

  /// Canonical uppercase key used in recipe JSON `allergens` lists.
  /// Profiles store enum `.name` (camelCase); this maps to the JSON form
  /// for filtering against recipes.
  final String jsonKey;
}
