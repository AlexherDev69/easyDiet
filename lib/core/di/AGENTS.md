<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# di

## Purpose
Dependency injection via GetIt: registers database, DAOs, repositories, use cases, and Cubits for app-wide access.

## Key Files
| File | Description |
|------|-------------|
| `injection.dart` | GetIt bootstrap: DB, 7 DAOs, 5 repos, 5 use cases, all Cubits |

## For AI Agents

### Working In This Directory
- **injection.dart** is the single source of truth for DI — register every new service here.
- Call `configureDependencies()` once at app startup (in `main.dart`).
- Pattern: Register DB → DAOs → Repos → UseCases → Cubits.
- Access any registered service with `getIt<ServiceType>()` anywhere in the app.

### Registration Pattern
```dart
// Database & DAOs
getIt.registerSingleton<AppDatabase>(AppDatabase());
getIt.registerSingleton<UserProfileDao>(UserProfileDao(getIt<AppDatabase>()));

// Repositories
getIt.registerSingleton<UserProfileRepository>(
  UserProfileRepositoryImpl(getIt<UserProfileDao>()),
);

// Use Cases
getIt.registerSingleton<CalorieCalculator>(CalorieCalculator());

// Cubits
getIt.registerSingleton<SettingsCubit>(
  SettingsCubit(getIt<UserProfileRepository>()),
);
```

### When Adding a Feature
1. Create domain/{models,usecases,repositories} folder.
2. Define interface in domain/repositories.
3. Implement in data/repository/{feature}_repository_impl.dart.
4. Register in injection.dart: repos first, then use cases, then Cubits.
5. Import in app and access via `getIt<MyRepo>()`.

## Dependencies

### Internal
- `lib/core/constants/` — Constants passed to repos
- `lib/data/local/daos/` — All 7 DAOs
- `lib/data/repository/` — All 5 repository implementations
- `lib/features/*/domain/` — All use cases & repository interfaces
- `lib/features/*/presentation/cubit/` — All Cubits

### External
- **get_it** ^8.0.3 — Service locator instance

<!-- MANUAL: -->
