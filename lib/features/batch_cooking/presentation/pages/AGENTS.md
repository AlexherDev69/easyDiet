<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose
Full-screen pages for batch cooking workflow.

## Key Files
| File | Description |
|------|-------------|
| `batch_cooking_page.dart` | Overview — list of recipes to batch cook |
| `batch_cooking_mode_page.dart` | Execution — step-by-step with timers and progress |

## For AI Agents

### Working In This Directory
- StatelessWidget only — state in Cubit
- Use BlocBuilder<Cubit, State> to react to changes
- Build full screen layouts with proper spacing
- Extract complex widget trees to separate methods or widget classes
- No navigation logic — use context.go() or Router.of()

### Common Patterns
- BlocBuilder wraps main content, handles loading/error/data
- ListView/GridView for recipe lists
- Each step shown with timer, completion toggle, recipe name
- Material 3 design: Emerald (#10B981) primary color

## Dependencies

### Internal
- `lib/core/theme/app_colors.dart` — Color palette
- `lib/core/utils/` — Formatters
- `lib/shared/widgets/` — GradientCard, SolidCard
- Cubits from parent directory

### External
- `flutter_bloc` — BlocBuilder, BlocListener
- `go_router` — Navigation
- `google_fonts` — Nunito font

<!-- MANUAL: -->
