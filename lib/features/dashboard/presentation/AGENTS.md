<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# presentation

## Purpose
Presentation layer — dashboard Cubit, page, and widgets.

## Key Files
| File | Description |
|------|-------------|
| `cubit/dashboard_cubit.dart` | Manages dashboard state, streams |
| `pages/dashboard_page.dart` | Main home screen layout |
| `widgets/*.dart` | 10+ reusable dashboard widgets |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `cubit/` | State management (see `cubit/AGENTS.md`) |
| `pages/` | Dashboard page (see `pages/AGENTS.md`) |
| `widgets/` | Dashboard widget library (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- One Cubit per page — DashboardCubit
- StatelessWidget + BlocBuilder pattern
- Extract large widget trees to separate widgets
- Use const constructors
- No business logic in widgets
- Text in French

### Common Patterns
- BlocBuilder refreshes on state change
- BlocListener handles side effects (snackbars, nav)
- Use GetIt to inject Cubit and Repositories
- Cards for metrics (calories, macros, hydration)

## Dependencies

### Internal
- `lib/core/theme/` — Colors, typography
- `lib/core/utils/` — Formatters
- `lib/data/local/` — Models
- `lib/shared/widgets/` — Card base components
- `lib/features/meal_plan/`, `lib/features/weight_log/`, etc.

### External
- `flutter_bloc` — Cubit, BlocBuilder
- `go_router` — Navigation
- `fl_chart` — Charts
- `google_fonts` — Nunito

<!-- MANUAL: -->
