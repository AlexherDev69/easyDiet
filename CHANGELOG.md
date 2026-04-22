# Changelog

Tous les changements notables de ce projet sont documentés dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.0] - 2026-04-22

### Ajouté

- **Photos de recettes** — 96 images Pexels intégrées, une par recette pour un visuel enrichi
- **Onboarding refondu** — Wizard 6 étapes (infos perso, métriques, objectifs, style de vie, allergies, prévisualisation)
- **Page Configuration du plan** — Changement rapide du type de régime, repas actifs, jours libres, avant régénération
- **Page Prévisualisation du plan** — Jour par jour avant confirmation, avec bouton "Valider"
- **Dashboard bento grid** — Carte héros calories animée, macro donut chart, hydration, prochaine recette, batch cooking
- **Suivi du poids refondu** — Charts 4 semaines / 3 mois / tout, historique expandable, projections
- **Liste de courses v2** — Tri par plat, agrégation ingrédients communs, détail modale, reset avec confirmation
- **Animations UI** — NavBar icônes animées, transitions fade entre onglets, draw-in charts, micro-interactions
- **Illustrations onboarding** — 6 CustomPaint minimalistes (avatar, règle, cible, couverts, bouclier, calendrier)

### Modifié

- **Thème couleurs** — Fond clair émeraude (#F0FDF4), gras distinctif cyan pour les lipides
- **Cartes recettes** — Symboles P/C/L remplacés par dots macro colorés
- **Typographie** — Tabular figures sur compteurs caloriques, cartes poids, target journalier
- **Dialog navigation** — Dialogs migré vers `showDialog()` au lieu de Stack (fermeture bouton retour stable)
- **TabBar meals** — TabController explicite + `animateTo()` pour scroll-to-tab robuste
- **Touch targets** — Min 48×48 dp sur checkbox shopping, boutons jour, icônes
- **Radius design** — Échelle unifiée (sm=8, md=12, lg=16, xl=20) dans tous les CardTheme

### Corrigé

- **DatePicker crash** — Crash sélection date picker résolu
- **Codegen Drift** — Warnings codegen résolus
- **Localisation FR** — Labels français complets, dialogs, snackbars
- **Agrégation poivron** — Normalisation unités (g, kg, ml) stable dans shopping list
- **Texte bouton retour** — Dialogs settings et weight log ferment correctement
- **Arrondi portions** — Quantités arrondies avant conversion unité pour cohérence affichage
- **Textstyle hardcodés** — Remplacés par `theme.textTheme` (weight stats, projected goal card)

### Supprimé

- Code mort (macro_validator.dart 180 lignes)
- Ternaires mortes (onboarding_illustration.dart)

---

[2.0.0]: https://github.com/Alexher/easydiet-flutter/releases/tag/v2.0.0
