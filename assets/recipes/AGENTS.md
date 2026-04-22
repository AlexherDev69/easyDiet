<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# recipes

## Purpose
Seed recipe data in JSON format: 96 recipes split by meal type (breakfast, lunch, dinner, snack), loaded at first app launch.

## Key Files
| File | Description |
|------|-------------|
| `breakfast.json` | Breakfast recipes (~24 recipes) |
| `lunch.json` | Lunch recipes (~24 recipes) |
| `dinner.json` | Dinner recipes (~24 recipes) |
| `snack.json` | Snack recipes (~24 recipes) |

## For AI Agents

### Working In This Directory
- Modify JSON files to add, remove, or update recipes.
- Each recipe JSON object has: name, category, caloriesPerServing, macros {protein, carbs, fat}, servings, prepTimeMinutes, cookTimeMinutes, isBatchFriendly, allergens (array), dietType, meatTypes (array), steps (array), ingredients (array).
- Example recipe:
  ```json
  {
    "name": "Omelette aux Champignons",
    "category": "eggs",
    "caloriesPerServing": 180,
    "macros": { "protein": 12, "carbs": 2, "fat": 14 },
    "servings": 1,
    "prepTimeMinutes": 5,
    "cookTimeMinutes": 10,
    "isBatchFriendly": false,
    "allergens": ["eggs"],
    "dietType": "OMNIVORE",
    "meatTypes": [],
    "steps": [
      { "stepNumber": 1, "instruction": "Beat eggs...", "timerSeconds": null }
    ],
    "ingredients": [
      { "name": "eggs", "quantity": 2, "unit": "pieces", "supermarketSection": "DAIRY" }
    ]
  }
  ```
- Supermarket sections: DAIRY, PROTEINS, VEGETABLES, FRUITS, GRAINS, OILS, CONDIMENTS, FROZEN, OTHER.
- Diet types: OMNIVORE, VEGETARIAN, VEGAN.
- Allergens: eggs, milk, peanuts, tree nuts, fish, shellfish, soy, wheat, sesame, etc.
- To reseed: delete SharedPreferences `isFirstRun` flag or clear app data.

## Dependencies

### Internal
- `lib/data/local/seeder/database_seeder.dart` — JSON loader

### External
- None (Dart json codec).

<!-- MANUAL: -->
