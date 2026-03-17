/// Shared ingredient name normalization used by ShoppingListGenerator
/// and MealPlanGenerator.
/// Produces a stable key for grouping/comparing ingredients across recipes.
class IngredientNormalizer {
  IngredientNormalizer._();

  static final _articlePattern = RegExp(
    r"^(du |de la |de l['\u2019]|des |d['\u2019]|le |la |les |l['\u2019])",
    caseSensitive: false,
  );
  static final _parentheticalPattern = RegExp(r'\s*\(.*?\)');

  /// Maps variant ingredient keys to a canonical key so they merge
  /// in the shopping list. All keys must be accent-free and lowercase.
  static final Map<String, String> _synonyms = _buildSynonymMap({
    // Spices — "X moulu(e)" → "X"
    'cumin': ['cumin moulu'],
    'curcuma': ['curcuma moulu'],
    'cannelle': ['cannelle moulue'],
    'gingembre moulu': ['gingembre frai'],
    'muscade': ['noix de muscade'],
    // Herbs — fresh vs dried
    'persil': ['persil frai', 'persil plat'],
    'thym': ['thym frai'],
    'romarin': ['romarin frai'],
    'basilic': ['basilic frai', 'basilic thai'],
    'coriandre': ['coriandre fraiche'],
    'ciboulette': ['ciboulette fraiche'],
    'menthe': ['menthe fraiche'],
    'aneth': ['aneth frai'],
    // Vegetables — singular/plural
    'carotte': ['carotte (batonnet)'],
    'aubergine': ['aubergine'],
    'courgette': ['courgette'],
    'brocoli': ['brocoli'],
    'tomate': ['tomate'],
    'echalote': ['echalote'],
    'champignon': ['champignon de pari'],
    // Garlic
    'ail': ["gousse d'ail", "gousses d'ail", 'gousse d ail', 'gousses d ail'],
    // Eggs
    'oeuf': ["blanc d'oeuf"],
    // Oils — normalize apostrophe variants
    "huile d'olive": ['huile d olive'],
    // Edamame variants
    'edamame': ['edamame (decortique)', 'edamame (surgele)', 'edamame surgele'],
    // Cacao
    'cacao en poudre': ['cacao en poudre non sucre'],
    // Lait de coco
    'lait de coco': ['lait de coco allege', 'lait de coco light'],
    // Mozzarella
    'mozzarella': ['mozzarella allegee'],
    // Moutarde
    'moutarde de dijon': ["moutarde a l ancienne"],
    // Fromage rape
    'fromage rape': ['emmental rape', 'gruyere rape'],
    // Granola
    'granola': ['granola maison'],
    // Salade
    'salade verte': ['salade melangee', 'salade romaine'],
    // Farine
    'farine': ['farine complete', 'farine de ble'],
  });

  /// Canonical key → preferred display name (capitalized).
  static const _canonicalDisplayNames = <String, String>{
    'cumin': 'Cumin',
    'curcuma': 'Curcuma',
    'cannelle': 'Cannelle',
    'muscade': 'Muscade',
    'persil': 'Persil',
    'thym': 'Thym',
    'romarin': 'Romarin',
    'basilic': 'Basilic',
    'coriandre': 'Coriandre',
    'ciboulette': 'Ciboulette',
    'menthe': 'Menthe',
    'aneth': 'Aneth',
    'ail': 'Ail',
    'oeuf': 'Oeufs',
    "huile d'olive": "Huile d'olive",
    'edamame': 'Edamames',
    'cacao en poudre': 'Cacao en poudre',
    'lait de coco': 'Lait de coco',
    'mozzarella': 'Mozzarella',
    'moutarde de dijon': 'Moutarde',
    'fromage rape': 'Fromage rapé',
    'granola': 'Granola',
    'salade verte': 'Salade verte',
    'farine': 'Farine',
    'gingembre moulu': 'Gingembre',
    'champignon': 'Champignons',
  };

  /// Returns the preferred display name for a normalized key,
  /// or null if no canonical name is defined.
  static String? canonicalDisplayName(String normalizedKey) {
    return _canonicalDisplayNames[normalizedKey];
  }

  /// Returns a normalized key for ingredient comparison.
  /// Removes articles, accents, parenthetical qualifiers, and singularizes.
  static String normalizeKey(String name) {
    var key = name.trim().replaceFirst(_articlePattern, '').toLowerCase();
    key = removeAccents(key);

    // Singularize
    if (key.endsWith('eaux')) {
      key = '${key.substring(0, key.length - 4)}eau';
    } else if (key.endsWith('aux') && key.length > 4) {
      key = '${key.substring(0, key.length - 3)}al';
    } else if (key.endsWith('s') &&
        !key.endsWith('ss') &&
        !key.endsWith('us') &&
        !key.endsWith('is') &&
        key.length > 3) {
      key = key.substring(0, key.length - 1);
    }

    key = key.replaceAll(_parentheticalPattern, '').trim();

    // Merge synonyms/variants into a canonical name
    return _synonyms[key] ?? key;
  }

  /// Removes French accents and special characters.
  static String removeAccents(String s) {
    return s
        .replaceAll('\u2019', "'")
        .replaceAll('\u0153', 'oe')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('û', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('ô', 'o')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ç', 'c');
  }

  static Map<String, String> _buildSynonymMap(
    Map<String, List<String>> entries,
  ) {
    final map = <String, String>{};
    for (final entry in entries.entries) {
      for (final variant in entry.value) {
        map[variant] = entry.key;
      }
    }
    return map;
  }
}
