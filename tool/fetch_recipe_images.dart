// One-shot CLI that downloads a photo per recipe from Pexels, bundles it
// under assets/images/recipes/, and enriches assets/recipes/*.json with an
// `imagePath` field.
//
// Usage:
//   dart run tool/fetch_recipe_images.dart
//
// Idempotent: existing files are skipped. Re-run to fill gaps or after
// manually deleting photos you want to replace.

import 'dart:convert';
import 'dart:io';

const _apiKey =
    '81FurvFe2wIND3LQ8vubuXiJTpkhGOH44STcNZ02StaPvjblFrg9mY0g';
const _searchEndpoint = 'https://api.pexels.com/v1/search';

const _jsonFiles = [
  'assets/recipes/breakfast.json',
  'assets/recipes/lunch.json',
  'assets/recipes/dinner.json',
  'assets/recipes/snack.json',
];

const _outputDir = 'assets/images/recipes';
const _manifestPath = 'assets/images/recipes/_manifest.json';

Future<void> main() async {
  final outDir = Directory(_outputDir);
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  final manifest = <Map<String, dynamic>>[];
  var downloaded = 0;
  var skipped = 0;
  var failed = 0;

  final client = HttpClient()..connectionTimeout = const Duration(seconds: 20);

  try {
    for (final jsonPath in _jsonFiles) {
      stdout.writeln('\n=== Processing $jsonPath ===');
      final file = File(jsonPath);
      final raw = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final recipes = (raw['recipes'] as List).cast<Map<String, dynamic>>();

      for (final recipe in recipes) {
        final name = recipe['name'] as String;
        final slug = _slugify(name);
        final imageFile = File('$_outputDir/$slug.jpg');
        final relPath = '$_outputDir/$slug.jpg';

        if (imageFile.existsSync()) {
          recipe['imagePath'] = relPath;
          skipped++;
          stdout.writeln('  [skip] $name');
          continue;
        }

        final result = await _fetchOne(client, name);
        if (result == null) {
          failed++;
          stderr.writeln('  [FAIL] $name (no result)');
          continue;
        }

        try {
          await _downloadTo(client, result.mediumUrl, imageFile);
          recipe['imagePath'] = relPath;
          manifest.add({
            'slug': slug,
            'name': name,
            'photographer': result.photographer,
            'photographerUrl': result.photographerUrl,
            'pexelsUrl': result.pageUrl,
            'pexelsId': result.id,
          });
          downloaded++;
          stdout.writeln('  [ok]   $name  (by ${result.photographer})');
        } catch (e) {
          failed++;
          stderr.writeln('  [FAIL] $name  download error: $e');
        }

        // Gentle pacing for API rate-limit (200/h free tier).
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }

      // Rewrite JSON with imagePath fields injected.
      const jsonEncoder = JsonEncoder.withIndent('  ');
      file.writeAsStringSync('${jsonEncoder.convert(raw)}\n');
    }

    // Append to manifest (preserve previous attributions from earlier runs).
    final manifestFile = File(_manifestPath);
    List<dynamic> existing = [];
    if (manifestFile.existsSync()) {
      try {
        existing =
            jsonDecode(manifestFile.readAsStringSync()) as List<dynamic>;
      } catch (_) {}
    }
    // Dedup by slug, new entries win.
    final bySlug = <String, Map<String, dynamic>>{};
    for (final e in existing.cast<Map<String, dynamic>>()) {
      bySlug[e['slug'] as String] = e;
    }
    for (final e in manifest) {
      bySlug[e['slug'] as String] = e;
    }
    const encoder = JsonEncoder.withIndent('  ');
    manifestFile.writeAsStringSync(
      '${encoder.convert(bySlug.values.toList()..sort((a, b) => (a['slug'] as String).compareTo(b['slug'] as String)))}\n',
    );

    stdout.writeln('\n=== Summary ===');
    stdout.writeln('  downloaded: $downloaded');
    stdout.writeln('  skipped:    $skipped');
    stdout.writeln('  failed:     $failed');
    stdout.writeln('  manifest:   $_manifestPath');
  } finally {
    client.close(force: true);
  }
}

// ── Pexels API ─────────────────────────────────────────────────────────────

class _PexelsResult {
  _PexelsResult({
    required this.id,
    required this.mediumUrl,
    required this.pageUrl,
    required this.photographer,
    required this.photographerUrl,
  });

  final int id;
  final String mediumUrl;
  final String pageUrl;
  final String photographer;
  final String photographerUrl;
}

Future<_PexelsResult?> _fetchOne(HttpClient client, String recipeName) async {
  // Strategy: recipe name + "food" to bias towards plated-food shots.
  final query = Uri.encodeQueryComponent('$recipeName food');
  final uri = Uri.parse(
    '$_searchEndpoint?query=$query&per_page=1&locale=fr-FR',
  );

  try {
    final req = await client.getUrl(uri);
    req.headers.set(HttpHeaders.authorizationHeader, _apiKey);
    final resp = await req.close();

    if (resp.statusCode != 200) {
      stderr.writeln('    http ${resp.statusCode} for "$recipeName"');
      await resp.drain<void>();
      return null;
    }

    final body = await resp.transform(utf8.decoder).join();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final photos = (data['photos'] as List?) ?? const [];

    if (photos.isEmpty) return null;
    final photo = photos.first as Map<String, dynamic>;
    final src = photo['src'] as Map<String, dynamic>;

    return _PexelsResult(
      id: photo['id'] as int,
      mediumUrl: src['medium'] as String,
      pageUrl: photo['url'] as String,
      photographer: photo['photographer'] as String? ?? 'Unknown',
      photographerUrl: photo['photographer_url'] as String? ?? '',
    );
  } catch (e) {
    stderr.writeln('    query error for "$recipeName": $e');
    return null;
  }
}

Future<void> _downloadTo(
  HttpClient client,
  String url,
  File target,
) async {
  final req = await client.getUrl(Uri.parse(url));
  final resp = await req.close();
  if (resp.statusCode != 200) {
    throw Exception('http ${resp.statusCode}');
  }
  await resp.pipe(target.openWrite());
}

// ── Slug ────────────────────────────────────────────────────────────────────

/// Convert a French recipe name into a lowercase ASCII snake_case slug.
String _slugify(String input) {
  const accents = {
    'à': 'a', 'â': 'a', 'ä': 'a', 'á': 'a', 'ã': 'a',
    'ç': 'c',
    'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
    'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
    'ý': 'y', 'ÿ': 'y',
    'ñ': 'n',
    "'": ' ',
  };
  final buf = StringBuffer();
  for (final ch in input.toLowerCase().split('')) {
    buf.write(accents[ch] ?? ch);
  }
  return buf
      .toString()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
}
