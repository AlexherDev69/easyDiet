# EasyDiet

Application mobile de planification de repas, liste de courses et suivi du poids. 100% offline, toutes les donnees restent sur l'appareil.

## Fonctionnalites

- **Onboarding personnalise** — Profil (age, sexe, taille, poids), objectif de perte, regime alimentaire, allergies, viandes exclues
- **Calcul calorique automatique** — Formule Mifflin-St Jeor + niveau d'activite + deficit selon le rythme choisi
- **Plan de repas hebdomadaire** — Generation automatique filtree par regime, allergies et viandes exclues, avec respect du budget calorique (±10%)
- **Portions ajustables** — Par pas de 0.5 (0.5, 1, 1.5, 2...)
- **Batch cooking** — Sessions de preparation groupee avec mode cuisson guide (minuteurs, etapes cochables)
- **Liste de courses** — Generee automatiquement depuis le plan, ingredients regroupes par rayon, deduplication intelligente
- **Suivi du poids** — Historique avec graphique, projection de date d'objectif, detection d'ecarts anormaux
- **Dashboard** — Resume quotidien avec cercle de calories anime, macros, hydratation, prochain repas
- **Jours libres** — Jusqu'a 3 jours sans regime par semaine
- **Decalage du plan** — Reporter les repas d'un jour en un clic
- **Mode economique** — Favorise les ingredients communs entre recettes

## Stack technique

| Composant | Technologie |
|---|---|
| Framework | Flutter 3.10+ / Dart |
| State management | Cubit (flutter_bloc) |
| Base de donnees | Drift (SQLite) |
| Injection de dependances | GetIt + Injectable |
| Navigation | go_router |
| Graphiques | fl_chart |
| Architecture | Clean Architecture (domain / data / presentation) |

## Architecture

```
lib/
├── core/               # Constantes, theme, DI, utilitaires
├── data/
│   ├── local/          # Drift DB, DAOs, tables, seeder, models
│   └── repository/     # Implementations des repositories
├── features/
│   ├── batch_cooking/  # Preparation groupee
│   ├── dashboard/      # Ecran d'accueil
│   ├── meal_plan/      # Plan de repas hebdomadaire
│   ├── onboarding/     # Configuration initiale (6 etapes)
│   ├── plan_config/    # Parametrage du plan
│   ├── plan_preview/   # Apercu avant generation
│   ├── recipes/        # Liste, detail, mode cuisson
│   ├── settings/       # Parametres du profil
│   ├── shopping/       # Liste de courses
│   └── weight_log/     # Suivi du poids
├── navigation/         # Routes et configuration go_router
└── shared/widgets/     # Composants reutilisables (GradientCard, SolidCard...)
```

Chaque feature suit le pattern : `domain/` (models, usecases, repository interfaces) → `presentation/` (cubit, state, pages, widgets).

## Base de donnees (Drift/SQLite)

9 tables :

- **UserProfile** — Singleton (id=1), profil, calories, allergies, regime
- **Recipe** → **RecipeStep** (1:N) + **Ingredient** (1:N)
- **WeekPlan** → **DayPlan** (1:N) → **Meal** (1:N, FK→Recipe)
- **ShoppingItem** — Lie au WeekPlan, rayon supermarche, checkbox
- **WeightLog** — Une entree par jour

96 recettes seed dans `assets/recipes.json`, taguees par `dietType` (OMNIVORE/VEGETARIAN/VEGAN), allergenes et types de viande.

## Logique metier

- **Calories** : Mifflin-St Jeor + facteur d'activite - deficit. Min 1200 kcal (femme) / 1500 kcal (homme)
- **Filtrage recettes** : OMNIVORE → toutes, VEGETARIAN → VEG+VEGAN, VEGAN → VEGAN uniquement
- **Generation du plan** : Cible ±10% des calories journalieres, pas de repetition dans la semaine (selon config variete)
- **Liste de courses** : Aggregation des ingredients, fusion des doublons, regroupement par rayon

## Prerequis

- Flutter SDK >= 3.10.4
- Dart SDK >= 3.0
- Android SDK 24+ (min) / 36 (target)
- Java 17

## Installation

```bash
# Cloner le projet
git clone <repo-url>
cd easydiet-flutter

# Installer les dependances
flutter pub get

# Generer le code (Drift, Freezed, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Lancer en debug
flutter run
```

## Build

```bash
# APK debug
flutter build apk --debug

# APK release
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle
```

## UI

- **Material 3** avec couleur primaire emeraude (#2D6A4F)
- **Textes en francais** (interface utilisateur)
- **Code en anglais** (variables, fonctions, commentaires)
- Cards avec coins arrondis (20dp), gradients et ombres teintees
