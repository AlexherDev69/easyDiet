enum SupermarketSection {
  meat('Viandes et Poissons'),
  dairy('Produits laitiers'),
  pantry('Epicerie seche'),
  produce('Fruits et Legumes'),
  frozen('Surgeles'),
  spices('Condiments et Epices');

  const SupermarketSection(this.displayName);
  final String displayName;

  /// Maps section name from recipes.json to enum value
  static SupermarketSection fromJson(String name) {
    switch (name) {
      case 'MEAT':
      case 'MEAT_FISH':
      case 'SEAFOOD':
        return SupermarketSection.meat;
      case 'DAIRY':
        return SupermarketSection.dairy;
      case 'PANTRY':
        return SupermarketSection.pantry;
      case 'PRODUCE':
        return SupermarketSection.produce;
      case 'FROZEN':
        return SupermarketSection.frozen;
      case 'SPICES':
      case 'CONDIMENTS':
        return SupermarketSection.spices;
      default:
        return SupermarketSection.pantry;
    }
  }
}
