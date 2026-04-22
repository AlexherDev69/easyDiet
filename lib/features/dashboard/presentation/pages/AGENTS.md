<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# pages

## Purpose
Dashboard page — full screen home layout.

## Key Files
| File | Description |
|------|-------------|
| `dashboard_page.dart` | StatelessWidget, BlocBuilder, main layout |

## For AI Agents

### Working In This Directory
- StatelessWidget only
- Use BlocBuilder to render DashboardState
- Call Cubit methods via context.read<DashboardCubit>()
- Extract widget trees to separate methods or widget classes
- Use Column/Row with proper constraints
- Add SingleChildScrollView for content overflow

### Common Patterns
- Header with day selector
- Hero card (calories burned/remaining)
- Meal cards with meal type icons
- Mini charts (weight trend, macro breakdown)
- Quick action buttons (add meal, shift plan)

## Dependencies

### Internal
- `lib/core/theme/` — Colors, spacing
- `lib/core/utils/` — Formatters
- `lib/shared/widgets/` — Card bases
- Cubit from parent directory
- Widgets from sibling `widgets/` directory

### External
- `flutter_bloc` — BlocBuilder
- `go_router` — Navigation
- `google_fonts` — Typography

<!-- MANUAL: -->
