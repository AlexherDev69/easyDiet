// Re-fetch a single recipe image with a custom Pexels query.
//
// Usage:
//   dart run tool/refetch_recipe_image.dart <slug> "<custom query>"
//
// Example:
//   dart run tool/refetch_recipe_image.dart blanquette_de_veau_allegee "blanquette de veau"
//
// Overwrites assets/images/recipes/<slug>.jpg and updates the manifest.

import 'dart:convert';
import 'dart:io';

const _apiKey =
    '81FurvFe2wIND3LQ8vubuXiJTpkhGOH44STcNZ02StaPvjblFrg9mY0g';
const _searchEndpoint = 'https://api.pexels.com/v1/search';
const _outputDir = 'assets/images/recipes';
const _manifestPath = 'assets/images/recipes/_manifest.json';

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: dart run tool/refetch_recipe_image.dart <slug> "<query>" [photoIndex=0]');
    exit(1);
  }
  final slug = args[0];
  final query = args[1];
  final photoIndex = args.length >= 3 ? int.parse(args[2]) : 0;

  final client = HttpClient()..connectionTimeout = const Duration(seconds: 20);

  try {
    final uri = Uri.parse(
      '$_searchEndpoint?query=${Uri.encodeQueryComponent(query)}&per_page=5&locale=fr-FR',
    );
    final req = await client.getUrl(uri);
    req.headers.set(HttpHeaders.authorizationHeader, _apiKey);
    final resp = await req.close();

    if (resp.statusCode != 200) {
      stderr.writeln('http ${resp.statusCode}');
      exit(2);
    }

    final body = await resp.transform(utf8.decoder).join();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final photos = (data['photos'] as List?) ?? const [];
    if (photos.isEmpty) {
      stderr.writeln('no results for "$query"');
      exit(3);
    }

    stdout.writeln('Found ${photos.length} results for "$query":');
    for (var i = 0; i < photos.length; i++) {
      final p = photos[i] as Map<String, dynamic>;
      stdout.writeln('  [$i] id=${p['id']}  by ${p['photographer']}  ${p['url']}');
    }
    if (photoIndex >= photos.length) {
      stderr.writeln('photoIndex $photoIndex out of range');
      exit(4);
    }

    final photo = photos[photoIndex] as Map<String, dynamic>;
    final src = photo['src'] as Map<String, dynamic>;
    final mediumUrl = src['medium'] as String;

    final target = File('$_outputDir/$slug.jpg');
    final dlReq = await client.getUrl(Uri.parse(mediumUrl));
    final dlResp = await dlReq.close();
    if (dlResp.statusCode != 200) {
      stderr.writeln('download http ${dlResp.statusCode}');
      exit(5);
    }
    await dlResp.pipe(target.openWrite());
    stdout.writeln('\n✓ Wrote $_outputDir/$slug.jpg (index $photoIndex)');

    // Update manifest
    final manifestFile = File(_manifestPath);
    final entries = manifestFile.existsSync()
        ? (jsonDecode(manifestFile.readAsStringSync()) as List)
            .cast<Map<String, dynamic>>()
            .toList()
        : <Map<String, dynamic>>[];
    entries.removeWhere((e) => e['slug'] == slug);
    entries.add({
      'slug': slug,
      'name': slug,
      'photographer': photo['photographer'] as String? ?? 'Unknown',
      'photographerUrl': photo['photographer_url'] as String? ?? '',
      'pexelsUrl': photo['url'] as String,
      'pexelsId': photo['id'] as int,
    });
    entries.sort((a, b) => (a['slug'] as String).compareTo(b['slug'] as String));
    const encoder = JsonEncoder.withIndent('  ');
    manifestFile.writeAsStringSync('${encoder.convert(entries)}\n');
    stdout.writeln('✓ Manifest updated');
  } finally {
    client.close(force: true);
  }
}
