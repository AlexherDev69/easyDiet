<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# usecases

## Purpose
Pure business logic — calorie calculations and nutritional math.

## Key Files
| File | Description |
|------|-------------|
| `calorie_calculator.dart` | Mifflin-St Jeor BMR, TDEE, daily target, water intake |

## For AI Agents

### Working In This Directory
- CalorieCalculator: pure stateless class
- calculateBMR(): formula per sex
- calculateTDEE(): BMR × activity factor
- calculateDailyTarget(): TDEE - deficit, clamped to min
- calculateDailyWater(): 1 ml per kcal, clamped by sex
- No side effects, no dependencies

### Common Patterns
- All methods static or const
- Return numeric values (int, double)
- Clamp to min/max per sex (1200F/1500M calories, 2000F/2500M water)
- Formulas from CLAUDE.md

## Dependencies

### Internal
- `lib/features/onboarding/domain/models/` — Sex, ActivityLevel, LossPace
- `lib/core/constants/app_constants.dart` — Min calorie constants

### External
- `dart:math` — For rounding, calculations

<!-- MANUAL: -->
