# EasyDiet - Flutter App

> See also: [architecture.md](architecture.md) for detailed layer breakdown, [state.md](state.md) for current progress

## Quick Reference

- **Stack**: Flutter 3.10+ / Dart | Cubit (flutter_bloc) | Drift (SQLite) | GetIt | go_router
- **Architecture**: Clean Architecture (core + features with domain/data/presentation)
- **Min SDK**: Android default (flutter.minSdkVersion) | iOS default
- **UI**: Material 3, primary color #10B981 (emerald), all UI text in French, code in English
- **Database**: Drift (offline only, no network), seed data from `assets/recipes.json`
- **DI**: GetIt (manual registration in `core/di/injection.dart`)
- **Navigation**: go_router with ShellRoute + BottomNavBar (5 tabs)
- **Fonts**: Google Fonts Nunito
- **Package**: `com.easydiet.easydiet`
- **Port of**: MyDiet (Kotlin native Android app at `C:\Users\grimm\Desktop\Dev\my-diet`)

## Architecture

```
lib/
├── main.dart                    # Entry point, locale init, DI, runApp
├── app.dart                     # MaterialApp.router with theme + ExtendedColors
├── core/
│   ├── constants/app_constants.dart   # Min calories, kcalPerKgFat, water calc
│   ├── theme/
│   │   ├── app_colors.dart            # Emerald palette, dark theme, gradients, meal colors
│   │   └── app_theme.dart             # Material 3 light/dark, Nunito typography, ExtendedColors
│   ├── utils/
│   │   ├── date_utils.dart            # AppDateUtils (today, epoch, French formatting)
│   │   ├── quantity_formatter.dart     # roundForCooking()
│   │   ├── ingredient_normalizer.dart  # 500+ synonym rules, accent normalization
│   │   └── decimal_input_formatter.dart # Comma→dot, single decimal TextInputFormatter
│   └── di/injection.dart              # Manual GetIt registration (DB, DAOs, repos, usecases)
├── data/
│   ├── local/
│   │   ├── database.dart              # AppDatabase (Drift, 9 tables, v1)
│   │   ├── tables/                    # 9 Drift table definitions
│   │   ├── daos/                      # 7 DAOs
│   │   ├── seeder/database_seeder.dart # Loads recipes.json at first launch
│   │   └── models/                    # Relations (RecipeWithDetails, WeekPlanWithDays, etc.)
│   └── repository/                    # 5 Repository implementations
├── features/
│   ├── onboarding/                    # 6-step wizard
│   │   ├── domain/models/             # 8 enums (Sex, DietType, ActivityLevel, LossPace, MealType, Allergy, ExcludedMeat, SupermarketSection)
│   │   ├── domain/usecases/           # CalorieCalculator (Mifflin-St Jeor)
│   │   └── presentation/             # OnboardingCubit + 6 step widgets + page
│   ├── dashboard/                     # Home screen
│   │   ├── domain/models/             # DayScheduleItem, NextMealInfo, NextBatchCookingInfo
│   │   └── presentation/             # DashboardCubit + ~10 widgets
│   ├── meal_plan/                     # Weekly plan + generation
│   │   ├── domain/usecases/           # MealPlanGenerator (~940 lines, filtering + selection)
│   │   ├── domain/repositories/       # MealPlanRepository interface
│   │   └── presentation/             # MealPlanCubit + MealCard, SwapDialog, MoveDialog
│   ├── shopping/                      # Shopping list
│   │   ├── domain/usecases/           # ShoppingListGenerator (normalization, trips, dedup)
│   │   ├── domain/models/             # IngredientSource
│   │   └── presentation/             # ShoppingCubit + grouped list UI
│   ├── recipes/                       # List + Detail + Cooking mode
│   │   └── presentation/             # RecipeListCubit, RecipeDetailCubit + pages
│   ├── batch_cooking/                 # Batch cooking
│   │   ├── domain/usecases/           # BatchStepOptimizer (phase interleaving)
│   │   ├── domain/models/             # BatchPage, RecipeStepItem, etc.
│   │   └── presentation/             # BatchCookingCubit, BatchCookingModeCubit + pages
│   ├── weight_log/                    # Weight tracking
│   │   ├── domain/usecases/           # WeightProjectionCalculator
│   │   └── presentation/             # WeightLogCubit + chart (fl_chart)
│   ├── settings/                      # Profile editing + reset
│   │   ├── domain/repositories/       # UserProfileRepository interface
│   │   └── presentation/             # SettingsCubit + SettingsPage + AboutCalculationsPage
│   ├── plan_config/                   # Quick plan configuration
│   │   └── presentation/             # PlanConfigCubit + PlanConfigPage
│   └── plan_preview/                  # Plan preview before confirming
│       └── presentation/             # PlanPreviewCubit + PlanPreviewPage
├── shared/widgets/                    # GradientCard, SolidCard, FreeDaysSection, StepperCard
└── navigation/
    ├── app_router.dart                # GoRouter config (ShellRoute, 14 routes)
    └── scaffold_with_nav_bar.dart     # Bottom nav bar (5 tabs)
```

## Drift Database (9 tables)

| Table | Purpose | Key Fields |
|-------|---------|-----------|
| **UserProfiles** | Singleton (id=1) | name, age, sex, heightCm, weightKg, targetWeightKg, lossPace, activityLevel, dietType, dailyCalorieTarget, dailyWaterMl, allergies (JSON), excludedMeats (JSON), freeDays (JSON), enabledMealTypes (JSON), economicMode, onboardingCompleted |
| **Recipes** | Recipe base | name, category, caloriesPerServing, macros, servings, prepTime, cookTime, isBatchFriendly, allergens (JSON), dietType, meatTypes (JSON) |
| **RecipeSteps** | Instructions | recipeId (FK), stepNumber, instruction, timerSeconds |
| **Ingredients** | Recipe ingredients | recipeId (FK), name, quantity, unit, supermarketSection |
| **WeekPlans** | Week container | weekStartDate, createdAt |
| **DayPlans** | Day in week | weekPlanId (FK), date, dayOfWeek, isFreeDay, batchCookingSession |
| **Meals** | Meal assignment | dayPlanId (FK), mealType, recipeId (FK), servings, isConsumed |
| **ShoppingItems** | Shopping list | weekPlanId (FK), name, quantity, unit, supermarketSection, isChecked, isManuallyAdded, sourceDetails (JSON), tripNumber |
| **WeightLogs** | Weight tracking | date (unique), weightKg, createdAt |

Relations: `RecipeWithDetails`, `MealWithRecipe`, `DayPlanWithMeals`, `WeekPlanWithDays`

96 recipes seeded from `assets/recipes.json` tagged with `dietType`, `allergens`, `meatTypes`.

## 7 DAOs

- **UserProfileDao** — CRUD, watchProfile(), updateWeightAndCalories()
- **RecipeDao** — watch/get recipes with details, get by category, insert recipe+steps+ingredients
- **WeekPlanDao** — watchCurrentWeekPlan(), getCurrentWeekPlan(), create/delete
- **DayPlanDao** — watchDaysForWeek(), watchDayPlanByDate(), getDayPlansFromDate(), updateDayPlanDate/Status(), getMaxDate()
- **MealDao** — CRUD, getMealsForDay(), updateConsumed(), reassignMeals()
- **ShoppingItemDao** — watchItemsForWeek(), CRUD, uncheckAll(), deleteGeneratedItems()
- **WeightLogDao** — watchAllLogs/Since/Recent(), getLatest/First/ByDate(), insert (upsert), delete

## 5 Repositories

- **UserProfileRepository** — profile CRUD, updateWeightAndCalories()
- **RecipeRepository** — recipe list/detail queries
- **MealPlanRepository** — week plan management, swapMealsBetweenDays(), shiftProgramByOneDay(), toggleMealConsumed(), isCurrentPlanExpired()
- **ShoppingRepository** — shopping items CRUD, uncheckAll(), deleteGeneratedItems()
- **WeightLogRepository** — weight log CRUD, watch streams

## 5 Use Cases

- **CalorieCalculator** — Mifflin-St Jeor BMR → TDEE → daily target (clamped to min 1200F/1500H)
- **MealPlanGenerator** — Filter recipes (allergens, dietType, excludedMeats), select (random or economic mode), assign meals with calculated servings, macro validation
- **ShoppingListGenerator** — Aggregate ingredients, normalize names/units, dedup, split by trips
- **BatchStepOptimizer** — Interleave prep/cook/finish phases across recipes
- **WeightProjectionCalculator** — Estimated goal date, average weekly loss, projected date at current pace

## 12 Cubits

| Cubit | Feature | Key Methods |
|-------|---------|-------------|
| OnboardingCubit | 6-step onboarding | updateProfile fields, calculateCalories, generate plan |
| DashboardCubit | Home screen | selectDay, toggleMealConsumed, shiftByOneDay |
| MealPlanCubit | Weekly plan | selectDay, regenerateWeekPlan, swap/move meals, shiftByOneDay |
| ShoppingCubit | Shopping list | selectTrip, toggleItem, addManualItem, toggleSection |
| RecipeListCubit | Recipe list | selectTab, selectCategory |
| RecipeDetailCubit | Recipe detail | loadRecipe, increaseServings (+0.5), decreaseServings (-0.5) |
| WeightLogCubit | Weight tracking | addWeightLog, deleteLog, selectPeriod, date picker |
| SettingsCubit | Profile settings | updateProfile fields, saveDietProfile, appReset |
| BatchCookingCubit | Batch overview | loadBatchCooking |
| BatchCookingModeCubit | Batch cooking mode | loadOptimizedSteps, toggleStepComplete, nav pages |
| PlanConfigCubit | Plan config | updateDietType, enabledMealTypes, freeDays, save |
| PlanPreviewCubit | Plan preview | generateNewPlan, confirmPlan |

## 14 Routes

- `/onboarding` — full screen, no nav bar
- `/dashboard`, `/meal-plan`, `/shopping-list`, `/recipes`, `/weight-log` — ShellRoute with bottom nav
- `/recipes/:id?servings=X` — recipe detail
- `/recipes/:id/cooking?servings=X` — cooking mode
- `/batch-cooking/:dayPlanId` — batch overview
- `/batch-cooking/:dayPlanId/mode` — batch cooking mode
- `/settings` — profile editor
- `/settings/about-calculations` — calorie formula info
- `/plan-config` — plan configuration
- `/plan-preview` — preview before generation

## Key Business Logic

- **Calories**: Mifflin-St Jeor + activity factor - deficit. Min 1200 kcal (female) / 1500 kcal (male)
- **Recipe filtering**: OMNIVORE→all, VEGETARIAN→VEG+VEGAN, VEGAN→VEGAN only. Plus allergen + excluded meat filters
- **Plan generation**: Target ±10% daily calories, no repeats in week, random or economic mode (ingredient overlap)
- **Servings**: Meal share (breakfast 25%, lunch 35%, dinner 30%, snack 10%) × daily target / recipe calories, 0.5 increments
- **Shopping list**: Ingredient aggregation, unit normalization (kg→g, l→ml), synonym mapping, trip splitting
- **Plan shift**: Creates new day at end, cascades meals forward, marks today as free day
- **Weight outlier**: Warns if ±5 kg from last entry
- **Water calculation**: 1 ml per kcal, rounded to 100, clamped by sex-specific min/max

## Build

```bash
# Install dependencies
flutter pub get

# Generate code (Drift, Freezed, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Run debug
flutter run

# Build APK
flutter build apk --release

# Generate app icon (after placing icon file at root)
dart run flutter_launcher_icons
```

## Conventions

- Variable/function names in English, UI strings in French
- One Cubit per screen/feature, state via `emit()` + `copyWith()`
- No StatefulWidget except for isolated needs (timers, TextEditingControllers)
- Prefer `const` constructors everywhere
- No business logic in widgets, everything in Cubits/UseCases
- Max ~40 lines per function, max 1000 lines per file
- Clean architecture: data → domain → presentation per feature
- French labels: "Suivant", "Precedent", "Enregistrer", "Parametres"

## Dependencies

| Category | Package | Version |
|----------|---------|---------|
| State | flutter_bloc | ^9.1.0 |
| DB | drift | ^2.25.0 |
| DB (SQLite) | sqlite3_flutter_libs | ^0.5.28 |
| Navigation | go_router | ^14.8.1 |
| DI | get_it | ^8.0.3 |
| Models | freezed_annotation | ^2.4.4 |
| Charts | fl_chart | ^0.70.2 |
| Fonts | google_fonts | ^6.2.1 |
| Date | intl | ^0.20.2 |
| Wakelock | wakelock_plus | ^1.2.10 |
| Dev: codegen | build_runner, drift_dev, freezed, json_serializable |
| Dev: icons | flutter_launcher_icons | ^0.14.3 |
