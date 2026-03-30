# EasyDiet - Audit complet v2 (2026-03-30)

Score de sante global : **7/10** (en progression depuis v1 a 6.5)

## Top 3 forces
1. **100% offline** - zero dependance reseau, Drift/SQLite solide, seeder incremental
2. **Animations soignees** - MacroRadialChart, AnimatedCheckbox, NavBar bounce, calorie counter
3. **Logique nutritionnelle correcte** - Mifflin-St Jeor exact, calorie shares coherentes, filtrage recettes solide

## Top 3 axes d'amelioration
1. **0% de couverture tests** - aucun test unitaire, aucun test de cubit, aucun test d'integration
2. **Accessibilite** - touch targets <48dp, pas de Semantics sur les charts, pas de labels screen reader
3. **Settings dialogs en Stack** - back button ne ferme pas les dialogs, pas de modal barrier

---

## Critiques (a corriger avant release)

### Navigation / Dialogs
- [x] `weight_log_page.dart` - Dialogs dans un `Stack`, bouton retour ne les ferme pas - utiliser `showDialog()`
- [x] `settings_page.dart:89` - Dialogs migres vers `showDialog()` avec `BlocProvider.value` + auto-pop + `.then()` safety
- [x] `meal_plan_page.dart:309` - `ScrollableTabBar` converti en StatefulWidget avec `TabController` explicite + `animateTo` dans `didUpdateWidget`

### Accessibilite
- [x] `meal_card.dart`, `day_meals_section.dart` - Touch targets <48x48dp, violation accessibilite Material
- [x] `shopping_item_row.dart:99` - `_AnimatedCheckbox` : `ConstrainedBox(min 48dp)` + `Semantics(checked, button, label)` ajoutes
- [x] `weight_line_chart.dart`, `mini_weight_chart.dart` - `Semantics` wrapper ajoute sur les CustomPaint
- [x] `batch_cooking_mode_page.dart:248` - `_TimerChip` dismiss : `GestureDetector` remplace par `IconButton(min 32dp, tooltip)`
- [x] `day_selector.dart:33` - `ConstrainedBox(minHeight: 48)` ajoute sur les cellules de jour

### Performance
- [x] `recipe_detail_page.dart:127` - sort fait une seule fois avant le map, plus de O(N^2)

### Data / Schema
- [x] `database.dart:56` - documentation ajoutee sur le schema v1 et les regles de migration futures

### Nutrition
- [x] `recipe_filter.dart:63` - `try-catch` ajoute sur `json.decode` dans `parseAllergies`

---

## Warnings (a corriger)

### Architecture
- [ ] Drift types (`Recipe`, `Meal`, `UserProfile`) exposes directement dans les interfaces domain - dette acceptee pour app offline-only, refactor massif differe
- [x] `plan_config`, `settings`, `onboarding` - parsing JSON duplique extrait dans `ProfileJsonParser` (core/utils)
- [x] `MealPlanRepositoryImpl` - `AppDatabase` retire, transactions via `MealDao.runInTransaction()`

### Nutrition / Logique
- [x] `loss_pace.dart` - `kgPerWeek` calcule dynamiquement depuis `deficitKcal * 7 / kcalPerKgFat` au lieu de valeurs hardcodees
- [x] `meal_plan_generator.dart:352` - `_fillDaysWithRecipes` shuffle + swap des doublons adjacents pour eviter repetitions consecutives
- [x] `shopping_list_generator.dart:167` - arrondi applique AVANT conversion d'unite (roundForCooking en g/ml puis toDisplayUnit)
- [x] `weight_log_cubit.dart` - `isAggressiveLoss` affiche en SnackBar rose "Perte rapide detectee, consultez un professionnel"
- [x] `weight_projection_calculator.dart:17` - `startDate` passe depuis `profile.dietStartDate` au lieu de `DateTime.now()`

### UI / Etats
- [x] `meal_plan_page.dart:44` - etat erreur avec icone + message + bouton "Reessayer"
- [x] `shopping_page.dart` - etat vide avec icone panier + message quand aucun article
- [x] `shopping_page.dart:292` - `_TripTabs` converti en StatefulWidget avec TabController explicite + animateTo
- [x] `app_router.dart:220,234` - route invalide affiche un Scaffold "Route invalide" au lieu de SizedBox.shrink

### Code quality
- [x] `ShoppingCubit._loadShoppingList` - `onError` ajoute sur les 2 `.listen()` (plan + items)
- [x] `RecipeListCubit._loadRecipes` - `onError` ajoute sur les 2 streams
- [x] `weight_log_page.dart` - tous les `TextStyle` hardcodes remplaces par `theme.textTheme` (stat cards + projected goal card)
- [x] `batch_cooking_mode_page.dart:228` - `fontSize: 10` releve a `12` (minimum lisible)
- [x] `accentAmber` assombri de #F59E0B (amber-500) a #D97706 (amber-600) - ratio WCAG AA sur blanc

### Fichiers >500 lignes (a splitter)
- [ ] `meal_plan_generator.dart` (833 lignes) - extraire selection, validation, helpers
- [ ] `batch_cooking_mode_page.dart` (711 lignes) - extraire timer et phase widgets
- [ ] `plan_preview_step.dart` (687 lignes) - extraire ReplaceRecipeDialog
- [ ] `weight_log_page.dart` (656 lignes) - extraire stats panel et history
- [ ] `cooking_mode_page.dart` (646 lignes) - extraire timer widget

---

## Suggestions (nice to have)

### Architecture
- [ ] Sealed classes pour les etats Cubit - differe (12 cubits a convertir + tous les BlocBuilder, risque/effort trop eleve vs benefice pour une app stable)
- [ ] `OnboardingState` god-state 39 champs - differe (restructuration lourde, fonctionne correctement en l'etat)
- [x] `MealPlanState.copyWith` + `PlanPreviewState.copyWith` : `clearWeekPlan` flag ajoute
- [x] DI : repositories et use cases en `registerLazySingleton` (DB + DAOs + Seeder restent eager)

### Nutrition
- [x] `maxServingsSnack` releve de 1.0 a 2.0 pour les snacks peu caloriques
- [x] `_parseEnabledMealTypes` utilise `firstOrNull` + `whereType` au lieu de fallback sur breakfast
- [x] `BatchStepOptimizer` - `estimatedTotalMinutes()` ajoute (parallel-aware) + `pageTimerSeconds` getter sur `BatchPage`
- [x] `_computeBatchDayIndices` distribue equitablement pour sessions > 2 au lieu de fallback silencieux
- [x] Outlier detection compare vs le log chronologiquement le plus proche de la date entree

### UI
- [x] `recipe_list_page.dart` - CTA "Generer un plan" ajoute quand tab "Cette semaine" est vide
- [x] `weight_log_page.dart` - historique expandable avec "Voir tout (N entrees)" / "Reduire"
- [x] `meal_card.dart:169` - P/C/L remplaces par `_MacroDot` colores (macroProtein/Carbs/Fat)
- [x] `recipe_list_page.dart:113` - filtrage/tri deplace dans `RecipeListState.filteredGroupedRecipes` getter
- [x] `_BentoGrid` - `IntrinsicHeight` remplace par `SizedBox(height: 320)`

### Design
- [x] `macroFat` change de amber (#F59E0B) a cyan (#06B6D4) - distinct visuellement de macroCarbs
- [x] `scaffoldBackgroundColor` light mode : `gray50` -> `emeraldBackground` (#F0FDF4)
- [x] `FontFeature.tabularFigures()` ajoute sur calorie counter, daily target, weight stat cards
- [x] `CaloriesHeroCard` TweenAnimationBuilder : `ValueKey(progress)` force re-animation a chaque changement
- [x] `MiniWeightChart` animation d'entree left-to-right draw-in 600ms easeOutCubic
- [x] `AnimatedSwitcher` 300ms avec `KeyedSubtree(ValueKey(path))` pour transitions entre tabs
- [x] `AppRadius` scale definie (sm=8, md=12, lg=16, xl=20) + adoptee dans CardTheme et ButtonThemes
- [x] Tooltip colors theme-aware via `colorScheme.inverseSurface/onInverseSurface` dans les 2 charts
- [x] Onboarding illustrations 120x120 -> 160x160
- [x] Dead ternaries corrigees dans `onboarding_illustration.dart`

---

## Design Opportunities - Quick wins

- [x] **Dashboard bento grid** - Layout 2x2 asymetrique (60/40) + MacroRadialChart (CustomPainter donut anime P/C/L avec ombres et gradients)
- [x] **NavigationBar icons animes** - AnimatedSwitcher + ScaleTransition elasticOut sur icones filled/outlined
- [x] **Shopping list micro-interactions** - AnimatedContainer (fond vert), AnimatedCheckbox (elasticOut), AnimatedItemLabel (fade), CelebrationBanner a 100%
- [x] **Macro colors cohesives** - `macroProtein/Carbs/Fat` branches sur macro_summary_card, calories_hero_card, recipe_detail_page, plan_preview_step
- [x] **Onboarding illustrations** - 6 CustomPainter minimalistes (avatar, regle, cible, couverts, bouclier, calendrier) avec animation d'entree easeOutBack
- [x] **Weight chart draw-in** - left-to-right draw-in animation 800ms easeOutCubic avec drawProgress
- [x] **Fix hardcoded TextStyle** - theme.textTheme + Nunito + tabular figures dans weight_log stat cards
- [x] **scaffoldBackgroundColor** `gray50` -> `emeraldBackground` en light mode
- [x] **AnimatedSwitcher** 300ms fade pour les tabs bottom nav
- [x] **Shopping progress bar** - CustomPainter avec gradient emerald->gold, quarter marks, glow a 100%

---

## Tests manquants (top 10 par priorite)

| # | Test | Cible | Impact |
|---|------|-------|--------|
| 1 | `CalorieCalculator` unit tests | BMR, TDEE, deficit, clamping min, water | Sante utilisateur |
| 2 | `RecipeFilter` unit tests | dietType cascading, allergens, excludedMeats, parseAllergies try-catch | Plan incorrect |
| 3 | `ServingsCalculator` unit tests | calorie share, floor 0.5, clamp, division par zero | Portions incorrectes |
| 4 | `ShoppingListGenerator` diff tests | keep checked, uncheck si qty augmente, delete ancien, insert nouveau | Regression UX critique |
| 5 | `WeightProjectionCalculator` unit tests | SMA, projection, aggressive loss, edge cases | Projections fausses |
| 6 | `MealPlanGenerator.validateMacros` tests | fat limit, protein min, protein groups, blacklisting | Plan desequilibre |
| 7 | `QuantityFormatter` unit tests | roundForCooking, formatServings, edge cases | Affichage incorrect |
| 8 | `MealPlanCubit` bloc tests | regenerate, swap, shift, error handling | Crashes utilisateur |
| 9 | `WeightLogCubit` bloc tests | addLog, outlier detection, deleteLog | Data integrity |
| 10 | `BatchStepOptimizer` unit tests | phase classification, interleaving, ingredient matching | Batch cooking UX |

---

## Precedemment corrige (historique)

- [x] `app_router.dart` - int.parse crash sur routes batch cooking
- [x] `app_theme.dart` - BottomNavigationBarThemeData remplace par NavigationBarThemeData
- [x] `database.dart` - onUpgrade dangereux avec m.createAll() supprime
- [x] `macro_validator.dart` - code mort supprime (180 lignes)
- [x] `ingredient_normalizer.dart` - synonyme oeuf/blanc d'oeuf corrige
- [x] `meal_plan_generator.dart` - decompose en RecipeFilter, ServingsCalculator, PlanEditUseCase
- [x] `shopping_list_generator.dart` - N+1 remplace par getAllRecipesWithDetails() + Map
- [x] `shopping_list_generator.dart` - diff intelligent preservant les items coches
- [x] `weight_log_page.dart` - dialogs Stack -> showDialog() avec BlocProvider.value
- [x] `meal_card.dart`, `day_meals_section.dart` - touch targets 36->48dp
- [x] **Partout (icon buttons)** - 18 tooltips ajoutes sur 14 fichiers
- [x] `app_colors.dart` - macroProtein/Carbs/Fat branches sur 4 widgets
- [x] `RecipeListPage` - etat vide explicite avec icone + bouton "Effacer le filtre"
- [x] `SettingsPage` - SnackBar confirmation apres appReset
- [x] Indicateur de progression pendant le seeding initial
- [x] Onboarding sauvegarde partielle a chaque etape + reprise au bon step
- [x] Splash loader check profil avant routing (plus de flash etape 0)
- [x] `plan_preview_step.dart`, `plan_preview_page.dart` - dialog replace recipe overflow corrige
- [x] `plan_preview_step.dart` - tabs overflow corrige (espacement + taille titre)
- [x] Weight chart tooltip clamp aux bords + flip en bas si haut deborde
- [x] FAB poids : foregroundColor + protection crash double-tap + pop securise
- [x] `recipe_detail_page.dart` - macros Row Expanded au lieu de spaceEvenly
- [x] Constantes servings extraites dans AppConstants
- [x] `meal_type.dart` - calorieShare reference AppConstants
