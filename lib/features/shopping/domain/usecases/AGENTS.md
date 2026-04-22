<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# usecases

## Purpose

Business logic use cases for shopping list generation. Complex aggregation, normalization, and splitting logic.

## Key Files

| File | Description |
|------|-------------|
| `shopping_list_generator.dart` | ~400 lines; main use case: `generateShoppingList(weekPlan, shoppingTripsPerWeek)` |

## For AI Agents

### Working In This Directory

- **Main algorithm**: Iterate meals → collect ingredients → normalize names/units → apply synonyms → dedup → split by trips.
- **Unit normalization**: Convert kg→g, l→ml, etc. to standard units; merge quantities.
- **Synonym mapping**: 500+ rules (e.g., "butter" = "beurre" = "margarine"). Apply via `IngredientNormalizer`.
- **Deduplication**: Combine same ingredient across recipes; sum quantities.
- **Trip splitting**: Assign items to trips (1..N) based on `shoppingTripsPerWeek` setting. Try to balance trips or follow predefined section→trip mapping.
- **Source tracking**: Record recipe ID, name, meal type for each ingredient in JSON.
- **Manual items**: Preserve user-added items; don't regenerate if already present.
- **DB persistence**: Call `ShoppingRepository.createItem()` for each generated item.

### Common Patterns

- **Aggregation loop**: For each meal → for each ingredient → add to normalized map, summing quantities by normalized name.
- **Normalization**: `IngredientNormalizer.normalize(name, supermarketSection)` returns normalized name and synonyms.
- **Unit conversion**: Map units to standard (g, ml, pieces), then convert quantities.
- **Dedup key**: Use `(normalizedName, supermarketSection)` as unique key.
- **Trip assignment**: Assign trips based on section affinity or round-robin distribution.
- **Idempotency**: If items already exist, update instead of duplicate (check by normalized name).

## Dependencies

### Internal

- `lib/features/shopping/domain/repositories/` — `ShoppingRepository`
- `lib/features/shopping/domain/models/` — `IngredientSource`
- `lib/core/utils/` — `IngredientNormalizer`, `QuantityFormatter`
- `lib/data/local/database.dart` — `ShoppingItem`, `WeekPlanWithDays`

### External

- `drift` — `Value()` for DB inserts
- `convert` (dart:convert) — JSON encoding
