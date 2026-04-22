<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# constants

## Purpose
App-wide constants: minimum calorie targets by sex, kcal-per-kg-fat for deficit/surplus calculations, water intake formula (1 ml per kcal).

## Key Files
| File | Description |
|------|-------------|
| `app_constants.dart` | Min calories (1200F/1500M), kcal per kg fat (7700), water calc formula |

## For AI Agents

### Working In This Directory
- **app_constants.dart** is the only file here — define app-wide numeric constants here (no magic numbers in code).
- Modify min calories, energy density, or water formula only in this file.
- Used by: `CalorieCalculator`, `DashboardCubit`, weight tracking logic.

### Common Patterns
- Reference constants: `import 'package:easydiet/core/constants/app_constants.dart';` → `AppConstants.minCaloriesFemale`.

## Dependencies

### Internal
None.

### External
- None (Dart stdlib only).

<!-- MANUAL: -->
