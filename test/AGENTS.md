<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# test

## Purpose
Unit and widget tests: test coverage for Cubits, use cases, repositories, and UI widgets.

## Key Files
| File | Description |
|------|-------------|
| `widget_test.dart` | Sample widget test (app startup, navigation verification) |

## For AI Agents

### Working In This Directory
- Add tests for new features: Cubit tests (mock repos), use case tests (mock DAOs), widget tests (integration).
- Test naming: `test('should [action] when [condition]', ...)`.
- Mock dependencies with `mockito` or `mocktail` for Cubit/repo tests.
- Use `WidgetTester` for UI tests (pump, pumpAndSettle, find).
- Run: `flutter test`.

### Test Patterns

**Cubit test**:
```dart
void main() {
  group('DashboardCubit', () {
    late DashboardCubit cubit;
    late MockMealPlanRepository mockRepo;
    
    setUp(() {
      mockRepo = MockMealPlanRepository();
      cubit = DashboardCubit(mockRepo);
    });
    
    test('emits [DashboardInitial, DashboardLoaded] when init', () async {
      expect(cubit.stream, emitsInOrder([
        isA<DashboardInitial>(),
        isA<DashboardLoaded>(),
      ]));
      cubit.init();
    });
  });
}
```

**Widget test**:
```dart
void main() {
  testWidgets('App loads onboarding or dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const EasyDietApp());
    await tester.pumpAndSettle();
    
    expect(find.byType(DashboardPage), findsOneWidget);
  });
}
```

## Dependencies

### Internal
- `lib/` — All app code
- Feature Cubits, repositories, use cases

### External
- **flutter_test** — WidgetTester, expect, testWidgets
- **mocktail** or **mockito** — Mocking dependencies
- **bloc_test** — BlocTester for Cubit testing (optional)

<!-- MANUAL: -->
