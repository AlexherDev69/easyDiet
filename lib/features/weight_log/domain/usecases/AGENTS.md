<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# usecases

## Purpose

Business logic use case for weight projection and goal tracking.

## Key Files

| File | Description |
|------|-------------|
| `weight_projection_calculator.dart` | Calculates estimated goal date, average weekly loss, projected date at current pace |

## For AI Agents

### Working In This Directory

- **Projection algorithm**: Given user profile (current weight, target, activity level), calculate:
  - Average weekly weight loss (from historical logs)
  - Estimated weeks to goal
  - Projected goal date
  - Daily calorie deficit needed (via `CalorieCalculator`)
- **Robust calculation**: Handle edge cases (insufficient history, zero loss, etc.).
- **No DB access**: Pure calculation; caller passes profile and logs.

### Common Patterns

- **Weekly average**: Compute weight loss per week from oldest to newest log.
- **Projection**: If weekly loss is positive, `weeksToGoal = (currentWeight - targetWeight) / weeklyLoss`.
- **Date arithmetic**: Add weeks to today to get projected goal date.
- **Fallback**: If insufficient history, use profile-based estimates.

## Dependencies

### Internal

- `lib/data/local/database.dart` — `UserProfile`, `WeightLog`
- `lib/features/onboarding/domain/usecases/` — `CalorieCalculator` (optional, for daily deficit info)
- `lib/core/utils/` — `AppDateUtils`

### External

- None (pure Dart)
