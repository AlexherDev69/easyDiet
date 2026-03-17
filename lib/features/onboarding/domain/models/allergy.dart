enum Allergy {
  gluten('Gluten'),
  lactose('Lactose'),
  treeNuts('Fruits a coque'),
  birchPollen('Pollen de bouleau (SBA)'),
  shellfish('Crustaces'),
  eggs('Oeufs'),
  soy('Soja');

  const Allergy(this.displayName);
  final String displayName;
}
