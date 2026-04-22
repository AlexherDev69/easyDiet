<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# lib

## Purpose
Application source code: entry point, app theming, DI bootstrap, core utilities, data layer (Drift DB), features (10 modules), shared widgets, and routing.

## Key Files
| File | Description |
|------|-------------|
| `main.dart` | Entry point: Flutter binding init, French locale setup, DI bootstrap, splash loader, app runner |
| `app.dart` | MaterialApp.router with theme (light/dark), ExtendedColors, GoRouter instance |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `core/` | Constants, theme, DI injection, utilities (date, ingredient normalization) |
| `data/` | Drift database, DAOs (7), repositories (5), JSON converters, seeding |
| `features/` | 10 feature modules (onboarding, dashboard, meal_plan, shopping, recipes, batch_cooking, weight_log, settings, plan_config, plan_preview) |
| `shared/` | Reusable widgets (GradientCard, SolidCard, FreeDaysSection, etc.) |
| `navigation/` | GoRouter config (14 routes, ShellRoute), BottomNavBar scaffold |

## For AI Agents

### Working In This Directory
- **main.dart** is the bootstrap — manages app init, DI, splash while DB seeds + profile loads.
- **app.dart** is the root MaterialApp — all routes, theming, and localization setup here.
- **core/** has DI and cross-cutting utilities; always register new services in `core/di/injection.dart`.
- **data/** owns database schema (Drift tables), DAOs, and repository impls — modify here for persistence changes.
- **features/** contains domain logic (models, use cases, repositories as interfaces) and presentation (Cubits, pages, widgets).
- **shared/widgets/** are reusable UI components used across multiple features.
- **navigation/** defines all routes — add new routes in `app_router.dart`.

### Common Patterns
- Import from features as: `import 'package:easydiet/features/{name}/...';`
- Use GetIt for DI: `getIt<SomeRepository>()` after bootstrap in `main.dart`.
- State management via Cubit: One Cubit per page/screen, emit state changes with copyWith().
- Database queries: Use DAOs from `data/local/daos/*.dart`; they return Drift queries or streams.
- Localizations: UI labels in French, code/comments/variable names in English.

## Dependencies

### Internal
- `core/` — DI, constants, theme
- `data/` — Database, DAOs, repos
- `features/` — Domain logic, Cubits, UI
- `shared/widgets/` — Reusable UI

### External
- **flutter_bloc** ^9.1.0 — Cubit state management
- **drift** ^2.25.0 — SQLite ORM
- **sqlite3_flutter_libs** ^0.5.28 — SQLite native bindings
- **go_router** ^14.8.1 — Declarative routing
- **get_it** ^8.0.3 — Dependency injection
- **freezed_annotation** ^2.4.4 — Immutable model generation
- **google_fonts** ^6.2.1 — Nunito font
- **intl** ^0.20.2 — Localization (French date formatting)
- **fl_chart** ^0.70.2 — Weight tracking chart
- **wakelock_plus** ^1.2.10 — Screen wake lock

<!-- MANUAL: -->
