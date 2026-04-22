<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# features

## Purpose
10 feature modules following clean architecture (domain/data/presentation per feature): onboarding, dashboard, meal_plan, shopping, recipes, batch_cooking, weight_log, settings, plan_config, plan_preview.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `onboarding/` | 6-step wizard: profile, body metrics, goal, allergies, diet type, plan preview |
| `dashboard/` | Home screen: today's meals, water intake, weight summary, quick actions |
| `meal_plan/` | Weekly meal plan: view, swap meals, move meals, regenerate, date shift |
| `shopping/` | Shopping list: grouped by supermarket section, trip management, item check/uncheck |
| `recipes/` | Recipe list (filtered by category), detail page with macros, cooking mode with timers |
| `batch_cooking/` | Multi-recipe batch cooking: phase interleaving, step optimization, progress tracking |
| `weight_log/` | Weight tracking: input form, trend chart (fl_chart), projection calculator |
| `settings/` | Profile editor, app reset, about calorie formula, calculation details |
| `plan_config/` | Quick plan config: meal types toggle, free days, diet type, economic mode |
| `plan_preview/` | Preview generated plan before confirming to save |

## For AI Agents

### Working In This Directory
- Each feature is self-contained: domain (models, use cases, repo interfaces) → data (not here, in lib/data) → presentation (Cubits, pages, widgets).
- Add new feature: create `lib/features/{name}/domain/`, `presentation/cubit/`, `presentation/pages/`, `presentation/widgets/`.
- Register Cubit in `lib/core/di/injection.dart`.
- Add route in `lib/navigation/app_router.dart`.
- Import: `import 'package:easydiet/features/{name}/...';`

### Feature Structure (per feature)
```
{feature}/
├── domain/
│   ├── models/           # Freezed models, enums
│   ├── repositories/     # Interfaces
│   └── usecases/         # Business logic
└── presentation/
    ├── cubit/            # State management (Cubit)
    ├── pages/            # Full-screen pages
    └── widgets/          # Reusable components
```

### 10 Features at a Glance

**Onboarding** (6 steps): CalorieCalculator (Mifflin-St Jeor TDEE), profile save, plan generation preview.

**Dashboard** (home): DayScheduleItem, NextMealInfo, quick actions, water tracking, weight summary.

**Meal Plan** (weekly): MealPlanGenerator (~940 lines), recipe filtering/selection, macro validation, swap/move meals, daily macro display.

**Shopping** (list): ShoppingListGenerator, ingredient normalization, trip splitting, section grouping, item check/uncheck.

**Recipes** (catalog): RecipeListCubit (category filter), RecipeDetailCubit (servings adjust), cooking mode with timers.

**Batch Cooking**: BatchStepOptimizer (phase interleaving), multi-recipe step sequencing, timer management, progress UI.

**Weight Log** (tracking): WeightProjectionCalculator, trend chart (fl_chart), weekly average, projected goal date.

**Settings** (profile): Profile editor (all fields), app reset (clear DB), calorie formula explanation.

**Plan Config** (quick): Toggle meal types, set free days, select diet type, economic mode toggle.

**Plan Preview** (confirm): Generated plan overview, confirm/cancel, final save.

## Dependencies

### Internal (shared across features)
- `lib/core/` — Constants, theme, DI, utils
- `lib/data/` — Database, DAOs, repos
- `lib/shared/widgets/` — Reusable UI components
- `lib/navigation/` — Routing

### External (per feature as needed)
- **flutter_bloc** ^9.1.0 — Cubit
- **go_router** ^14.8.1 — Navigation
- **freezed_annotation** ^2.4.4 — Models
- **fl_chart** ^0.70.2 — Weight log charts
- **intl** ^0.20.2 — Date formatting

<!-- MANUAL: -->
