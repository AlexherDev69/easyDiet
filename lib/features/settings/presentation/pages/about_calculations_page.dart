import 'package:flutter/material.dart';

import '../../../../shared/widgets/solid_card.dart';

/// Displays the methodology behind calorie/water/portion calculations.
/// Port of AboutCalculationsScreen.kt.
class AboutCalculationsPage extends StatelessWidget {
  const AboutCalculationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Methodes de calcul'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionCard(
            title: 'Objectif calorique',
            content: [
              'Le calcul se fait en 3 etapes :',
              '',
              '1. Metabolisme de base (BMR) - Formule de Mifflin-St Jeor :',
              '  Homme : 10 x poids(kg) + 6.25 x taille(cm) - 5 x age + 5',
              '  Femme : 10 x poids(kg) + 6.25 x taille(cm) - 5 x age - 161',
              '',
              '2. Depense energetique totale (TDEE) :',
              '  TDEE = BMR x facteur d\'activite',
              '  Sedentaire : x 1.2',
              '  Legerement actif : x 1.375',
              '  Moderement actif : x 1.55',
              '  Tres actif : x 1.725',
              '',
              '3. Objectif = TDEE - deficit selon rythme de perte :',
              '  Doux (~0.3 kg/sem) : - 350 kcal/jour',
              '  Modere (~0.5 kg/sem) : - 500 kcal/jour',
              '  Rapide (~0.7 kg/sem) : - 750 kcal/jour',
              '',
              'Le rythme exact est calcule via :',
              '  kg/semaine = (deficit x 7) / 7700 kcal/kg',
              '',
              'Minimum garanti : 1500 kcal (homme), 1200 kcal (femme)',
            ],
            source: 'Mifflin MD, St Jeor ST et al. (1990). '
                'American Journal of Clinical Nutrition, 51(2), 241-247',
          ),
          SizedBox(height: 16),
          _SectionCard(
            title: 'Hydratation quotidienne',
            content: [
              'Methode basee sur la depense energetique (EFSA/IOM) :',
              '',
              'Eau (mL) = TDEE (kcal) x 1 mL/kcal',
              'Arrondi aux 100 mL les plus proches.',
              '',
              'Le resultat est borne selon les recommandations EFSA :',
              '  Homme : entre 2.5 L et 3.3 L par jour',
              '  Femme : entre 2.0 L et 2.8 L par jour',
              '',
              'Cette methode est plus fiable qu\'un simple ratio par kg de '
                  'poids car le TDEE prend deja en compte la taille, l\'age, '
                  'le sexe et l\'activite physique.',
            ],
            source: 'EFSA Panel on Dietetic Products, Nutrition and '
                'Allergies (2010). EFSA Journal, 8(3), 1459',
          ),
          SizedBox(height: 16),
          _SectionCard(
            title: 'Ajustement des portions',
            content: [
              'Les portions de chaque recette sont ajustees selon '
                  'votre objectif calorique :',
              '',
              'Repartition par repas :',
              '  Petit-dejeuner : 25% des calories',
              '  Dejeuner : 35% des calories',
              '  Diner : 30% des calories',
              '  Collation : 10% des calories',
              '',
              'Calcul : portions = (calories du repas cible) / '
                  '(calories par portion de la recette)',
              '',
              'Arrondi a la demi-portion inferieure (ex: 1.8 -> 1.5).',
              'Bornes : repas entre 0.5 et 3 portions, '
                  'collation entre 0.5 et 2 portions.',
            ],
            source: 'Repartition recommandee par l\'ANSES '
                '(Agence nationale de securite sanitaire)',
          ),
          SizedBox(height: 16),
          _SectionCard(
            title: 'Projection de poids',
            content: [
              'La date estimee d\'objectif est calculee a partir de :',
              '',
              '  Poids restant / perte hebdomadaire estimee',
              '',
              'La perte hebdomadaire depend du deficit calorique :',
              '  1 kg de graisse = 7700 kcal',
              '',
              'La projection initiale est ancree a la date de debut du regime.',
              'La projection "rythme actuel" utilise la moyenne des 7 ',
              'dernieres pesees pour estimer le rythme reel.',
              '',
              'Seuls les jours de regime sont comptes '
                  '(pas les jours libres).',
              '',
              'Un avertissement est affiche si la perte depasse '
                  '1 kg/semaine (perte rapide).',
            ],
            source: 'Hall KD et al. (2011). '
                'The Lancet, 378(9793), 826-837',
          ),
          SizedBox(height: 16),
          _SectionCard(
            title: 'Validation des macros',
            content: [
              'Lors de la generation du plan, les macronutriments sont '
                  'verifies :',
              '',
              '  Lipides : max 35% des calories totales',
              '  (relaxe a 38% si les recettes disponibles sont grasses)',
              '',
              '  Proteines : min 20% des calories totales',
              '  Au moins 3 groupes proteiques differents par semaine',
              '',
              'Si les seuils ne sont pas respectes, la recette la plus '
                  'desequilibree est remplacee automatiquement.',
            ],
            source: 'ANSES - Recommandations nutritionnelles (2021)',
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.content,
    required this.source,
  });

  final String title;
  final List<String> content;
  final String source;

  @override
  Widget build(BuildContext context) {
    return SolidCard(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...content.map((line) {
            if (line.isEmpty) return const SizedBox(height: 4);
            return Text(line, style: const TextStyle(fontSize: 13));
          }),
          const SizedBox(height: 12),
          Text(
            'Source : $source',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
