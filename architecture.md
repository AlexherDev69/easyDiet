# EasyDiet - Architecture

## Overview

Clean Architecture with feature-based organization. Each feature contains up to 3 layers: `domain/` (models, usecases, repository interfaces), `data/` (rarely used, most data logic is in `lib/data/`), `presentation/` (cubit, state, pages, widgets).

```
lib/
├── main.dart           → Init locale, DI, runApp
├── app.dart            → MaterialApp.router + theme
├── core/               → Shared utilities, theme, DI, constants
├── data/               → Database, DAOs, repositories
├── features/           → 10 features (domain + presentation)
├── shared/widgets/     → Reusable UI components
└── navigation/         → GoRouter + bottom nav bar
```

## Data Flow

```
Widget (BlocBuilder)
    ↕ events / state
Cubit (business orchestration)
    ↕ calls
UseCase (pure business logic) + Repository (data access)
    ↕ calls
DAO (Drift queries)
    ↕ SQL
AppDatabase (SQLite via Drift)
```

## Core Layer

### DI (`core/di/injection.dart`)

Manual GetIt registration (injectable_generator declared but not used). Order:

1. `AppDatabase` (singleton)
2. 7 DAOs (from db instance)
3. `DatabaseSeeder` (auto-seeds recipes if empty)
4. 5 Repositories (interfaces → implementations)
5. 5 UseCases (stateless, const constructors)

### Theme (`core/theme/`)

**AppColors:**
- Primary: Emerald `#10B981` (main), `#059669` (dark), `#6EE7B7` (light)
- Secondary: Teal `#14B8A6`
- Accents: Amber, Orange, Blue (water), Purple, Rose
- Meal colors: breakfast=amber, lunch=green, dinner=purple, snack=rose
- Gradients: calories (amber→orange), water (blue→cyan), primary (emerald→teal)
- Dark theme: `#6EE7B7` primary, `#0F1511` bg, `#1A2420` surface

**AppTheme:**
- Material 3 with `ColorScheme.fromSeed`
- Typography: Google Fonts Nunito (display 32px → label 10px)
- `ExtendedColors` InheritedWidget for gradients/accents not in Material spec
- Light + Dark mode (follows system)
- Button: 12px border radius, 24h/12v padding
- Card: 20dp rounded corners

### Utils (`core/utils/`)

**AppDateUtils:**
- `today()`, `todayMillis()`, `toEpochMillis()`, `fromEpochMillis()`
- French formatting: `formatFrenchDate()` → "15 mars 2026", `formatDayName()` → "Lundi 15"
- `getWeekStartDate()` → Monday of current week
- `getDayOfWeekFrench(weekday)` → "Lundi", "Mardi", etc.

**IngredientNormalizer:**
- `normalizeKey(name)` → accent-stripped, lowercase, singular form
- `canonicalDisplayName(key)` → display-friendly version
- 500+ synonym rules for French ingredients (spices, herbs, vegetables)

**QuantityFormatter:**
- `roundForCooking(quantity)` → practical cooking values

**DecimalInputFormatter:**
- `TextInputFormatter` that replaces comma with dot (French keyboard)
- Allows only one decimal point, max 1 decimal place

### Constants (`core/constants/app_constants.dart`)

- `minCaloriesMale = 1500`, `minCaloriesFemale = 1200`
- `kcalPerKgFat = 7700.0`
- `calorieTolerance = 0.15` (±15% for plan generation)
- Water: 1 ml per kcal, min/max ranges by sex

## Data Layer

### Database (`data/local/database.dart`)

- Drift `AppDatabase` with 9 tables
- File: `easydiet.sqlite` in app documents directory
- Version: 1, `fallbackToDestructiveMigration()` (dev phase)
- Cascade delete on foreign keys

### Tables (`data/local/tables/`)

9 tables mirroring the Kotlin Room entities:

| Table | Notable columns | Type converters |
|-------|----------------|-----------------|
| UserProfiles | allergies, customAllergies, freeDays, enabledMealTypes, excludedMeats | JSON string lists via `TypeConverter` |
| Recipes | allergens, meatTypes | JSON string lists |
| RecipeSteps | timerSeconds (nullable) | — |
| Ingredients | quantity (real), unit, supermarketSection | — |
| WeekPlans | weekStartDate (int, epoch ms) | — |
| DayPlans | date (int, epoch ms), isFreeDay, batchCookingSession (nullable int) | — |
| Meals | mealType (text), servings (real), isConsumed (bool) | — |
| ShoppingItems | sourceDetails (text, JSON), tripNumber (nullable int) | — |
| WeightLogs | date (int, unique), weightKg (real) | — |

### DAOs (`data/local/daos/`)

7 DAOs, each annotated with `@DriftAccessor(tables: [...])`:

**UserProfileDao** — Singleton profile CRUD + weight/calorie sync
**RecipeDao** — Full recipe queries with joins (steps + ingredients)
**WeekPlanDao** — Week plan with nested days → meals → recipes (3-level join)
**DayPlanDao** — Day CRUD, date queries, status updates, nested meal queries
**MealDao** — Meal CRUD, consumed toggle, reassignMeals (for plan shift)
**ShoppingItemDao** — Item CRUD, check/uncheck, trip filtering, section ordering
**WeightLogDao** — Log CRUD, date range queries, latest/first queries

### Models (`data/local/models/`)

Relation classes (plain Dart, not Drift-generated):

- `RecipeWithDetails` — recipe + steps + ingredients
- `MealWithRecipe` — meal + recipe
- `DayPlanWithMeals` — dayPlan + List<MealWithRecipe>
- `WeekPlanWithDays` — weekPlan + List<DayPlanWithMeals>

### Repositories (`data/repository/`)

5 implementations, all thin wrappers around DAOs:

- `UserProfileRepositoryImpl` → UserProfileDao
- `RecipeRepositoryImpl` → RecipeDao
- `MealPlanRepositoryImpl` → WeekPlanDao, DayPlanDao, MealDao (+ shift/swap logic)
- `ShoppingRepositoryImpl` → ShoppingItemDao
- `WeightLogRepositoryImpl` → WeightLogDao

**MealPlanRepositoryImpl** contains significant logic:
- `swapMealsBetweenDays()` — exchange recipeId + servings between meals, or move to empty slot
- `shiftProgramByOneDay()` — create new day at end, cascade-move all meals forward, mark today as free
- `isCurrentPlanExpired()` — check if last day plan date < today

### Seeder (`data/local/seeder/database_seeder.dart`)

- Loads `assets/recipes.json` via `rootBundle`
- Parses JSON, inserts recipes with steps and ingredients
- Called once at startup if recipe count is 0

## Feature Layer

### Onboarding (`features/onboarding/`)

**Domain:**
- 8 enums: Sex, DietType, ActivityLevel, LossPace, MealType, Allergy, ExcludedMeat, SupermarketSection
- CalorieCalculator: Mifflin-St Jeor BMR → TDEE → daily target with deficit

**Presentation:**
- OnboardingCubit (6 steps): personal info → body metrics → goals → lifestyle → allergies → plan preview
- OnboardingState: all profile fields + calculated calories + generated week plan
- 6 step widgets + OnboardingPage orchestrator
- On completion: saves profile, generates meal plan + shopping list, navigates to dashboard

### Dashboard (`features/dashboard/`)

**Domain:**
- DayScheduleItem, NextMealInfo, NextBatchCookingInfo models

**Presentation:**
- DashboardCubit: subscribes to profile + week plan + weight logs streams
- DashboardState: today's meals/macros, progress stats, week schedule, plan expiration
- Widgets: CaloriesHeroCard (animated circle), HydrationCard, ProgressCard, MiniWeightChart, NextMealCard, NextBatchCookingCard, DaySelector, DayMealsSection

### Meal Plan (`features/meal_plan/`)

**Domain:**
- MealPlanGenerator (~940 lines): multi-stage filtering pipeline → recipe selection (random or economic) → meal assignment with serving calculation → macro validation
- MealPlanRepository interface

**Presentation:**
- MealPlanCubit: day selection, plan regeneration, meal swap/move, day shift
- Widgets: MealCard (type icon, recipe info, macros), SwapMealDialog, MoveMealDialog

### Shopping (`features/shopping/`)

**Domain:**
- ShoppingListGenerator (~280 lines): ingredient aggregation, name/unit normalization, dedup, trip splitting
- IngredientSource model (recipe name, day, quantity, unit)

**Presentation:**
- ShoppingCubit: trip selection, section collapsing, item check/uncheck/delete, manual add, cart weight estimation
- Widgets: SectionHeader, AddItemDialog, ItemDetailDialog

### Recipes (`features/recipes/`)

**Presentation:**
- RecipeListCubit: tab selection (4 meal types), category filter, week recipe highlighting
- RecipeDetailCubit: recipe loading, servings adjustment (0.5 increments, range 0.5-12.0)
- Pages: RecipeListPage, RecipeDetailPage, CookingModePage (timers, step checkboxes, wakelock)

### Batch Cooking (`features/batch_cooking/`)

**Domain:**
- BatchStepOptimizer: phase classification (prep/cook/finish) + page construction
- Models: BatchPage, RecipeStepItem, BatchRecipeInfo, IngredientInfo, StepPhase

**Presentation:**
- BatchCookingCubit: load batch data, merge common ingredients
- BatchCookingModeCubit: optimized step navigation, step completion tracking

### Weight Log (`features/weight_log/`)

**Domain:**
- WeightProjectionCalculator: goal date estimation, average weekly loss, projected date at current pace

**Presentation:**
- WeightLogCubit: log CRUD, period selection (4w/3m/all), outlier detection (±5kg), duplicate handling, date picker, profile weight sync + calorie recalc
- WeightLineChart: fl_chart line graph with period filtering

### Settings (`features/settings/`)

**Presentation:**
- SettingsCubit: all profile fields editing, diet change detection (triggers plan regeneration), app reset (delete all data)
- SettingsPage: form with all onboarding fields
- AboutCalculationsPage: read-only calorie formula explanation

### Plan Config (`features/plan_config/`)

**Presentation:**
- PlanConfigCubit: quick plan parameter editing (meal types, free days, batch sessions, shopping trips, distinct counts)
- PlanConfigPage: configuration form before plan generation

### Plan Preview (`features/plan_preview/`)

**Presentation:**
- PlanPreviewCubit: auto-generates plan on init, confirmPlan() saves + generates shopping list
- PlanPreviewPage: day-by-day meal preview with confirm button

## Shared Widgets (`shared/widgets/`)

- `GradientCard` — Card with LinearGradient background, rounded corners, shadow
- `SolidCard` — Plain colored card with rounded corners
- `FreeDaysSection` — 7-day week grid for selecting free days (max 3)
- `StepperCard` — Increment/decrement control with label

## Navigation (`navigation/`)

**AppRouter (go_router):**
- `_rootNavigatorKey` for full-screen routes (onboarding, recipe detail, settings)
- `_shellNavigatorKey` for tabbed routes
- `ShellRoute` wraps 5 main tabs with `ScaffoldWithNavBar`
- `NoTransitionPage` for tab switches (no animation)
- Cubits injected via `BlocProvider` at route level

**ScaffoldWithNavBar:**
- 5 tabs: Accueil (dashboard), Repas (meal plan), Courses (shopping), Recettes (recipes), Poids (weight)
- Selected/unselected icons for each tab

## Key Algorithms

### Meal Plan Generation
1. Filter recipes by allergies → dietType → excludedMeats
2. Group by category (BREAKFAST, LUNCH, DINNER, SNACK)
3. Select recipes: random shuffle or economic mode (greedy ingredient overlap)
4. Validate macros: fat <40%, protein >20%, ≥3 protein groups
5. Assign to days with calculated servings
6. Handle batch cooking days and free days

### Plan Shift (Decalage)
1. Get future days from today
2. Create new DayPlan at lastDay.date + 1 day
3. Move last day's meals to new day via `reassignMeals()`
4. Cascade: for each day from end to start, move meals from previous day
5. Mark today as free day (its meals moved to tomorrow)

### Shopping List Generation
1. Iterate all meals in week plan
2. Multiply ingredient quantities by servings
3. Normalize names (accent removal, synonym mapping)
4. Normalize units (kg→g, l→ml, c.à.s→ml/g)
5. Aggregate by normalized name
6. Deduplicate, assign supermarket sections
7. Split into trips if shoppingTripsPerWeek > 1
