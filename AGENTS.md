# EasyDiet Flutter App — Agents Guide

## Purpose
Offline diet and nutrition planning app for Flutter. Clean architecture with Cubit state management, Drift SQLite database, and Material 3 UI. Users complete onboarding (calories, allergies, preferences), receive AI-generated weekly meal plans, track weight, and access smart shopping lists.

## Project Structure

```
easydiet-flutter/
├── lib/                       # Application source
│   ├── main.dart              # Entry point, locale init, DI bootstrap
│   ├── app.dart               # MaterialApp.router, theme setup
│   ├── core/                  # Cross-cutting concerns (see lib/AGENTS.md)
│   ├── data/                  # Data layer: Drift DB, DAOs, repos
│   ├── features/              # Feature modules (10 features)
│   ├── shared/                # Reusable widgets & utilities
│   └── navigation/            # GoRouter config, bottom nav
├── assets/                    # Seed data (recipes JSON)
├── design-claude/             # Design system docs + UI handoff
├── test/                      # Unit & widget tests
├── pubspec.yaml              # Dependencies
├── CLAUDE.md                 # Project documentation
└── AGENTS.md                 # This file
```

## Key Concepts

**Architecture**: Clean Architecture (domain → data → presentation) per feature.  
**State Management**: Cubit/BLoC (flutter_bloc).  
**Database**: Drift with Freezed models, 9 tables, 7 DAOs.  
**Dependency Injection**: GetIt (manual registration in `core/di/injection.dart`).  
**Navigation**: GoRouter with ShellRoute + BottomNavBar (5 tabs).  
**UI**: Material 3, Emerald (#10B981), French labels, code in English.  
**Localization**: French (fr_FR) date formatting via intl.

## 10 Features

| Feature | Purpose | Key Entry |
|---------|---------|-----------|
| **onboarding** | 6-step wizard (profile, calories, allergies, preferences) | `/onboarding` |
| **dashboard** | Home screen: today's meals, water intake, weight | `/dashboard` |
| **meal_plan** | Weekly meal plan view, swap/move meals, plan regeneration | `/meal-plan` |
| **shopping** | Normalized shopping list by supermarket section | `/shopping-list` |
| **recipes** | Recipe list (by category) + detail + cooking mode | `/recipes`, `/recipes/:id/cooking` |
| **batch_cooking** | Multi-recipe cooking with phase interleaving | `/batch-cooking/:dayPlanId/mode` |
| **weight_log** | Weight tracking with trend chart (fl_chart) | `/weight-log` |
| **settings** | Profile editor, app reset, calorie formula info | `/settings` |
| **plan_config** | Quick plan config (meal types, free days, diet type) | `/plan-config` |
| **plan_preview** | Preview generated plan before confirming | `/plan-preview` |

## Core Layers

**Core** (`lib/core/`): Constants, theme, DI, utilities (date, ingredient normalization, quantity formatting).  
**Data** (`lib/data/`): Drift database + 7 DAOs, 5 repository implementations, JSON converters.  
**Shared** (`lib/shared/`): Reusable UI widgets (GradientCard, SolidCard, FreeDaysSection, StepperCard).

## Database (Drift)

9 tables: UserProfiles, Recipes, RecipeSteps, Ingredients, WeekPlans, DayPlans, Meals, ShoppingItems, WeightLogs.  
96 recipes seeded from `assets/recipes/*.json` (by meal type).  
Full relations support (RecipeWithDetails, WeekPlanWithDays, etc.).

## For AI Agents

### Common Tasks
1. **Add a feature**: Create `lib/features/{name}/` with domain/{models,usecases,repositories}, data layers, and presentation/{cubit,pages,widgets}.
2. **Modify recipes/cooking logic**: Touch `lib/features/recipes/`, `lib/features/batch_cooking/`, meal plan generator.
3. **Change UI styling**: See `lib/core/theme/app_colors.dart` for palette, `app_theme.dart` for Material 3 theme.
4. **Update database schema**: Modify `lib/data/local/tables/*.dart`, then run `dart run build_runner build`.
5. **Add a new repository**: Implement interface in feature domain, impl in `lib/data/repository/`, register in `lib/core/di/injection.dart`.
6. **Test changes**: Run `flutter test` (see `test/` for widget tests).

### Code Navigation
- **Calories logic**: `lib/features/onboarding/domain/usecases/calorie_calculator.dart` (Mifflin-St Jeor).
- **Meal plan generation**: `lib/features/meal_plan/domain/usecases/meal_plan_generator.dart` (~940 lines, filtering + selection).
- **Shopping list**: `lib/features/shopping/domain/usecases/shopping_list_generator.dart` (normalization, dedup, trip splitting).
- **Batch cooking**: `lib/features/batch_cooking/domain/usecases/batch_step_optimizer.dart` (phase interleaving).
- **Weight projection**: `lib/features/weight_log/domain/usecases/weight_projection_calculator.dart`.
- **Routes**: `lib/navigation/app_router.dart` (14 routes, ShellRoute with 5 tabs).

### Debugging
- Enable print logs: Set breakpoints in Cubits (emit() calls).
- Database: Inspect via `AppDatabase` in `lib/data/local/database.dart` (Drift).
- DI: Check registration in `lib/core/di/injection.dart`.
- State: Use Flutter DevTools (BloC Observer or inspect state snapshots).

### Code Standards
- Variable names in English, UI strings in French.
- One Cubit per screen, one responsibility per function (~40 lines max).
- Use `const` constructors, no StatefulWidget unless isolated.
- Models use Freezed + JSON serializable.
- No business logic in widgets — all in Cubits/UseCases.
- Max 1000 lines per file.

### Dependencies
State: flutter_bloc ^9.1.0 | DB: drift ^2.25.0, sqlite3_flutter_libs ^0.5.28 | Navigation: go_router ^14.8.1 | DI: get_it ^8.0.3 | Models: freezed_annotation ^2.4.4 | Charts: fl_chart ^0.70.2 | Dev: build_runner, drift_dev, freezed.

## Subdirectories

| Directory | See |
|-----------|-----|
| `lib/` | lib/AGENTS.md |
| `lib/core/` | lib/core/AGENTS.md |
| `lib/data/` | lib/data/AGENTS.md |
| `lib/features/` | lib/features/AGENTS.md (index + feature guides) |
| `lib/shared/` | lib/shared/AGENTS.md |
| `lib/navigation/` | lib/navigation/AGENTS.md |
| `assets/` | assets/AGENTS.md |
| `design-claude/` | design-claude/AGENTS.md |
| `test/` | test/AGENTS.md |

## Related Documentation

- **CLAUDE.md**: Full architecture, conventions, dependencies, DI structure, database schema.
- **architecture.md**: Detailed layer breakdown (if exists).
- **state.md**: Current progress tracking (if exists).

<!-- MANUAL: -->
