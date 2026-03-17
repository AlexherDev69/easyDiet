# EasyDiet - Current State

> Last updated: 2026-03-17

## Project Status: Feature Complete (Dev Phase)

All features from the Kotlin MyDiet app have been ported to Flutter. The app is functional on Android.

## Completed Features

### Core Infrastructure
- [x] Flutter project setup with all dependencies
- [x] Drift database with 9 tables + auto-seeder (96 recipes)
- [x] GetIt DI (manual registration)
- [x] Material 3 theme (light + dark, emerald palette, Nunito font)
- [x] go_router navigation with ShellRoute + 5-tab bottom nav
- [x] App icon (flutter_launcher_icons configured)

### Features
- [x] **Onboarding** — 6-step wizard (personal info, body metrics, goals, lifestyle, allergies, plan preview)
- [x] **Dashboard** — Day selector, calories hero card, hydration, progress, mini weight chart, next meal/batch cooking, day meals section
- [x] **Meal Plan** — Day tabs, meal cards with macros, swap meal dialog, move meal dialog, regenerate with confirmation modal, plan shift (decalage)
- [x] **Shopping List** — Grouped by supermarket section, trip selector, manual item add, check/uncheck, cart weight estimate
- [x] **Recipes** — List with 4 meal type tabs, category filter, week recipe highlighting, detail page with macro summary, servings adjustment (0.5 increments)
- [x] **Cooking Mode** — Step-by-step with timers, wakelock, step checkboxes
- [x] **Batch Cooking** — Overview with merged ingredients, guided cooking mode with interleaved phases
- [x] **Weight Log** — Chart (4 weeks / 3 months / all), add entry with date picker, outlier warning (±5kg), duplicate detection, profile weight sync + calorie recalc
- [x] **Settings** — All profile fields editable, diet change detection with plan regeneration, app reset
- [x] **Plan Config** — Quick plan parameter editing before regeneration
- [x] **Plan Preview** — Day-by-day preview with confirm button

### Business Logic
- [x] Calorie calculator (Mifflin-St Jeor + activity + deficit)
- [x] Meal plan generator (filtering, random/economic selection, macro validation)
- [x] Shopping list generator (normalization, dedup, trip splitting)
- [x] Batch step optimizer (phase interleaving)
- [x] Weight projection calculator (goal date, avg loss, projected date)

### UX Improvements (Post-Port)
- [x] Decimal weight input with French comma support (onboarding, weight log, settings)
- [x] Portion sizes in 0.5 increments (0.5 to 12.0)
- [x] Date picker on weight log entry (default today)
- [x] Regenerate confirmation modal on meal plan page
- [x] Day shift algorithm (creates new day, cascades meals, marks today as free)
- [x] README documentation

## Known Limitations

- Database: `fallbackToDestructiveMigration()` enabled (dev phase — schema changes destroy data)
- No tests written yet
- No automated CI/CD
- Release signing not configured (Android uses debug keys)
- injectable_generator declared but not used (manual DI instead)

## iOS Status

The app is **ready for iOS build** with these considerations:
- All dependencies are cross-platform compatible (drift, flutter_bloc, go_router, fl_chart, etc.)
- `sqlite3_flutter_libs` supports iOS natively
- `wakelock_plus` supports iOS
- `google_fonts` works on iOS (downloads fonts at runtime)
- Info.plist is standard Flutter template
- `flutter_launcher_icons` configured for both Android and iOS
- **Requires a Mac with Xcode** to build and test
- No iOS-specific permissions needed (100% offline app, no camera/location/etc.)
- May want to restrict orientation to portrait only in Info.plist for phone UX
- Bundle identifier: default Flutter template (should set to `com.easydiet.app` before release)

## File Statistics

- ~139 Dart files (excluding generated `.g.dart` files)
- 14 pages/screens
- 12 Cubits + 12 States
- 7 DAOs
- 5 Repositories (interface + impl)
- 5 Use Cases
- 8 Domain enums
- 4 Shared widgets
- ~30 feature-specific widgets
- 96 seed recipes in `assets/recipes.json`

## Build Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run                    # Debug
flutter build apk --release    # Android APK
dart run flutter_launcher_icons # Generate icons
```

## Next Steps (Potential)

- [ ] Write unit tests for use cases (CalorieCalculator, MealPlanGenerator, ShoppingListGenerator)
- [ ] Write widget tests for key flows (onboarding, meal plan generation)
- [ ] Set up proper database migrations (replace destructive migration)
- [ ] Configure release signing (Android keystore + iOS certificates)
- [ ] Set bundle identifier to `com.easydiet.app` for iOS
- [ ] Test on iOS device via Mac
- [ ] Performance profiling on older devices
- [ ] Add error handling states in cubits (currently mostly loading/success)
- [ ] Consider adding food/recipe search functionality
- [ ] Localization support (currently hardcoded French)
