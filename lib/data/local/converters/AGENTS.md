<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-20 -->

# converters

## Purpose
Custom Drift type converters: JSON → Dart (List<String>, JSON objects) for complex column types in the database.

## Key Files
| File | Description |
|------|-------------|
| `json_list_converter.dart` | Converts JSON string ↔ List<String> (used for allergies, excluded meats, free days in UserProfile) |

## For AI Agents

### Working In This Directory
- **json_list_converter.dart** converts database JSON strings to/from Dart lists — used for JSON columns in tables.
- Add new converter here for any custom type mapping (e.g., JSON object ↔ Freezed model).
- Reference converter in Drift table: `@UseRowClass` or apply to specific columns.

### Custom Type Pattern
```dart
class MyTypeConverter extends TypeConverter<MyType, String> {
  const MyTypeConverter();
  
  @override
  MyType fromSql(String? value) => MyType.fromJson(jsonDecode(value ?? '{}'));
  
  @override
  String toSql(MyType value) => jsonEncode(value.toJson());
}
```

## Dependencies

### Internal
None.

### External
- **drift** ^2.25.0 — TypeConverter base class
- **flutter** — JSON codec

<!-- MANUAL: -->
