import 'dart:convert';

import 'package:drift/drift.dart';

/// Drift type converter that maps a JSON-encoded `List<String>` (stored as
/// TEXT in SQLite) to a Dart `List<String>`.
class JsonStringListConverter extends TypeConverter<List<String>, String> {
  const JsonStringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final decoded = json.decode(fromDb);
    if (decoded is List) return decoded.cast<String>();
    return [];
  }

  @override
  String toSql(List<String> value) => json.encode(value);
}

/// Drift type converter that maps a JSON-encoded `List<int>` (stored as
/// TEXT in SQLite) to a Dart `List<int>`.
class JsonIntListConverter extends TypeConverter<List<int>, String> {
  const JsonIntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final decoded = json.decode(fromDb);
    if (decoded is List) return decoded.cast<int>();
    return [];
  }

  @override
  String toSql(List<int> value) => json.encode(value);
}
