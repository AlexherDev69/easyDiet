<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# navigation

## Purpose
GoRouter routing configuration: 14 routes, ShellRoute with bottom navigation bar (5 tabs), nested routes, and declarative routing.

## Key Files
| File | Description |
|------|-------------|
| `app_router.dart` | GoRouter config: 14 routes, ShellRoute, 5 tab routes, nested recipe routes, modals |
| `scaffold_with_nav_bar.dart` | Bottom navigation bar scaffold: 5 tabs (dashboard, meal-plan, shopping-list, recipes, weight-log) |

## For AI Agents

### Working In This Directory
- **app_router.dart** defines all 14 routes — add new routes here.
  - Root `/` redirects to `/dashboard` or `/onboarding` based on profile completion.
  - 5 tab routes use ShellRoute: `/dashboard`, `/meal-plan`, `/shopping-list`, `/recipes`, `/weight-log`.
  - Nested detail routes: `/recipes/:id?servings=X`, `/recipes/:id/cooking?servings=X`.
  - Modal routes: `/settings`, `/settings/about-calculations`, `/plan-config`, `/plan-preview`, `/batch-cooking/:dayPlanId`, `/batch-cooking/:dayPlanId/mode`.
- **scaffold_with_nav_bar.dart** renders the bottom nav bar — modify icons, labels, colors here.

### Route Pattern
```dart
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) => DetailPage(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);
```

### 14 Routes
1. `/onboarding` — full screen, no nav
2. `/dashboard` — tab, home
3. `/meal-plan` — tab
4. `/shopping-list` — tab
5. `/recipes` — tab, list with category filter
6. `/recipes/:id?servings=X` — nested, detail page
7. `/recipes/:id/cooking?servings=X` — nested, cooking mode
8. `/weight-log` — tab
9. `/batch-cooking/:dayPlanId` — modal, overview
10. `/batch-cooking/:dayPlanId/mode` — modal, cooking mode
11. `/settings` — modal, profile editor
12. `/settings/about-calculations` — modal, calorie formula
13. `/plan-config` — modal, quick config
14. `/plan-preview` — modal, plan confirmation

## Dependencies

### Internal
- `lib/features/*/presentation/pages/` — Page widgets
- `lib/features/*/presentation/cubit/` — State managers (read route params)

### External
- **go_router** ^14.8.1 — Router, GoRoute, path params, query params
- **flutter** — BuildContext, Navigator

<!-- MANUAL: -->
