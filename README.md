# EasyDiet

Application mobile de planification de repas, liste de courses et suivi du poids. 100% offline, toutes les donnees restent sur l'appareil.

[![Release](https://img.shields.io/github/v/release/AlexherDev69/easyDiet)](https://github.com/AlexherDev69/easyDiet/releases)
[![Play Store](https://img.shields.io/badge/Play%20Store-EasyDiet-green)](https://play.google.com/store/apps/details?id=com.easydiet.easydiet)

## Fonctionnalites

- **Onboarding personnalise** - Profil complet (age, sexe, taille, poids), objectif de perte, regime alimentaire, allergies, viandes exclues. Sauvegarde a chaque etape.
- **Calcul calorique scientifique** - Formule Mifflin-St Jeor + niveau d'activite + deficit dynamique (350/500/750 kcal). Min 1200 kcal (femme) / 1500 kcal (homme).
- **Plan de repas hebdomadaire** - Generation automatique filtree par regime, allergies et viandes exclues. Validation des macros (lipides <35%, proteines >20%, 3+ groupes proteiques). Pas de recette repetee sur des jours consecutifs.
- **Liste de courses intelligente** - Generee depuis le plan, regroupee par rayon. Diff intelligent : changer une recette preserve les articles deja coches. Arrondi pratique des quantites.
- **Batch cooking** - Sessions de preparation groupee avec mode cuisson guide (minuteurs, etapes cochables, temps total parallele).
- **Suivi du poids** - Graphique avec animation draw-in, projection d'objectif ancree a la date de debut, detection d'ecarts anormaux, avertissement si perte >1 kg/semaine.
- **Dashboard bento grid** - Disposition asymetrique 2x2 avec cercle de calories anime, graphique macro radial (CustomPainter), hydratation, prochain repas.
- **Jours libres** - Jusqu'a 3 jours sans regime par semaine, correctement respectes dans le plan.
- **Decalage du plan** - Reporter les repas d'un jour en un clic.
- **Mode economique** - Favorise les ingredients communs entre recettes.
- **Portions ajustables** - Arrondi a la demi-portion, repas 0.5-3 portions, collation 0.5-2.
- **96 recettes** - Taguees par regime, allergenes et types de viande. Seeding incremental.

## Stack technique

| Composant | Technologie |
|---|---|
| Framework | Flutter 3.10+ / Dart 3+ |
| State management | Cubit (flutter_bloc) |
| Base de donnees | Drift (SQLite) |
| Injection de dependances | GetIt (lazy singletons) |
| Navigation | go_router (ShellRoute + 14 routes) |
| Graphiques | fl_chart + CustomPainter (MacroRadialChart, WeightLineChart) |
| Architecture | Clean Architecture (domain / data / presentation) |
| UI | Material 3, Nunito, emeraude #10B981 |

## Architecture

```
lib/
├── core/
│   ├── constants/      # AppConstants (calories, portions, eau)
│   ├── theme/          # AppTheme (M3 light/dark), AppColors, AppRadius
│   ├── utils/          # DateUtils, IngredientNormalizer, ProfileJsonParser
│   └── di/             # GetIt registration (lazy singletons)
├── data/
│   ├── local/
│   │   ├── database.dart    # Drift DB (9 tables, schema v1)
│   │   ├── tables/          # 9 table definitions
│   │   ├── daos/            # 7 DAOs
│   │   ├── models/          # Relations (RecipeWithDetails, WeekPlanWithDays...)
│   │   └── seeder/          # Incremental recipe seeder from JSON
│   └── repository/          # 5 repository implementations
├── features/
│   ├── batch_cooking/       # Batch prep + cooking mode
│   ├── dashboard/           # Bento grid, CaloriesHeroCard, MacroRadialChart
│   ├── meal_plan/           # Plan, MealPlanGenerator, RecipeFilter, ServingsCalculator
│   ├── onboarding/          # 6 steps + illustrations (CustomPainter)
│   ├── plan_config/         # Config avant regeneration (allergies, jours libres...)
│   ├── plan_preview/        # Apercu + swap/move repas
│   ├── recipes/             # Liste, detail, mode cuisson
│   ├── settings/            # Profil, methodes de calcul, reset
│   ├── shopping/            # Liste de courses (diff intelligent, micro-interactions)
│   └── weight_log/          # Suivi poids, projections, graphique anime
├── navigation/              # go_router config, ScaffoldWithNavBar
└── shared/widgets/          # GradientCard, SolidCard, FreeDaysSection...
```

## Base de donnees (Drift/SQLite)

9 tables, 100% offline :

- **UserProfiles** - Singleton (id=1), profil, calories, allergies, regime, jours libres
- **Recipes** -> **RecipeSteps** (1:N) + **Ingredients** (1:N)
- **WeekPlans** -> **DayPlans** (1:N) -> **Meals** (1:N, FK -> Recipe)
- **ShoppingItems** - Lie au WeekPlan, rayon, checkbox, sourceDetails JSON, trips
- **WeightLogs** - Une entree par jour (unique sur date)

## Logique metier cle

| Calcul | Methode |
|---|---|
| BMR | Mifflin-St Jeor (1990) |
| TDEE | BMR x facteur activite (1.2 / 1.375 / 1.55 / 1.725) |
| Deficit | Doux 350 / Modere 500 / Rapide 750 kcal/jour |
| kg/semaine | deficit x 7 / 7700 kcal/kg |
| Eau | TDEE x 1 mL/kcal, borne EFSA |
| Portions | calories cible / calories recette, arrondi 0.5, clamp 0.5-3 (snack 0.5-2) |
| Macros | Lipides <35%, Proteines >20%, 3+ groupes proteiques |
| Shopping diff | Compute-Diff-Apply : preserve coches, uncheck si quantite augmente |
| Projection | Ancree date debut, moyenne 7 dernieres pesees |

## Prerequis

- Flutter SDK >= 3.10.4
- Dart SDK >= 3.0
- Android SDK 24+ (min) / 36 (target)
- Java 17

## Installation

```bash
git clone https://github.com/AlexherDev69/easyDiet.git
cd easyDiet

flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Build

```bash
# APK release (GitHub)
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release
```

## Design

- **Material 3** avec couleur primaire emeraude (#10B981)
- **Police** Nunito (Google Fonts) avec echelle de poids w400-w800
- **Dark mode** fond verdatre (#0F1511) pour cohesion de marque
- **Light mode** fond menthe (#F0FDF4)
- **Animations** : cercle calories, macro radial donut, chart draw-in, checkbox elasticOut, nav bounce
- **Accessibilite** : touch targets 48dp, Semantics sur les graphiques, contraste WCAG AA
- **Radius scale** : sm=8, md=12, lg=16, xl=20
