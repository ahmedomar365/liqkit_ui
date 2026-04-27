// Pure-Dart canonical token capture.
//
// Reads every packages/liqkit_ui_design_data/figma_artifacts/<category>/<node>.variable-defs.json,
// merges them, normalizes hierarchical names ('Backgrounds (Grouped)/Primary'
// -> 'backgroundsGrouped/primary'), and writes
// packages/liqkit_ui_design_data/manifests/canonical_tokens.json.
//
// canonical_tokens.json schema:
// {
//   "capturedAt": "<iso8601>",
//   "schemaVersion": 1,
//   "modes": ["default", "increasedContrast"],
//   "colors": {
//     "<groupedName>": {
//       "<modeName>": "#RRGGBBAA"
//     }
//   },
//   "typography": {
//     "<groupedName>": {
//       "<modeName>": { "family": "...", "weight": 400, "size": 13.0, "lineHeight": 18.0, "letterSpacing": -0.08, "style": "regular" }
//     }
//   },
//   "categoriesContributing": ["buttons", "colors", ...]
// }

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

const String _designDataRel = 'packages/liqkit_ui_design_data';

void main(List<String> args) {
  final repoRoot = _findRepoRoot();
  final root = Directory('${repoRoot.path}/$_designDataRel');
  final figmaArtifacts = Directory('${root.path}/figma_artifacts');
  if (!figmaArtifacts.existsSync()) {
    stderr.writeln('capture: figma_artifacts/ missing');
    exit(2);
  }

  final categoryDirs =
      figmaArtifacts.listSync().whereType<Directory>().where((d) {
        final name = d.uri.pathSegments.where((s) => s.isNotEmpty).last;
        return !<String>{'native', 'assets', 'history', 'raw'}.contains(name);
      }).toList();

  final colors = <String, Map<String, String>>{};
  final typography = <String, Map<String, Map<String, Object?>>>{};
  final modesSeen = <String>{};
  final categoriesContributing = <String>[];

  for (final cat in categoryDirs) {
    final catName = cat.uri.pathSegments.where((s) => s.isNotEmpty).last;
    var contributed = false;
    for (final f in cat.listSync().whereType<File>()) {
      if (!f.path.endsWith('.variable-defs.json')) continue;
      Map<String, dynamic> j;
      try {
        j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      } catch (_) {
        continue;
      }
      final modes =
          (j['modes'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
      modes.forEach((modeName, modeBody) {
        if (modeBody is! Map) return;
        modesSeen.add(modeName);
        modeBody.forEach((rawKey, value) {
          if (rawKey is! String) return;
          final key = _normalizeKey(rawKey);
          final v = value?.toString() ?? '';
          if (_isHexColor(v)) {
            final argb = _hexToArgbString(v);
            colors.putIfAbsent(key, () => <String, String>{})[modeName] = argb;
            contributed = true;
          } else if (v.startsWith('Font(')) {
            final parsed = _parseFontSpec(v);
            if (parsed != null) {
              typography.putIfAbsent(
                    key,
                    () => <String, Map<String, Object?>>{},
                  )[modeName] =
                  parsed;
              contributed = true;
            }
          }
        });
      });
    }
    if (contributed) categoriesContributing.add(catName);
  }

  final out = <String, Object>{
    'capturedAt': DateTime.now().toUtc().toIso8601String(),
    'schemaVersion': 1,
    'modes': (modesSeen.toList()..sort()),
    'colors': _sortedNested(colors),
    'typography': _sortedNestedTypography(typography),
    'categoriesContributing': categoriesContributing..sort(),
  };

  final outFile = File('${root.path}/manifests/canonical_tokens.json');
  outFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(out));

  print('capture_canonical_tokens: wrote ${outFile.path}');
  print('  - ${colors.length} unique colors');
  print('  - ${typography.length} unique typography tokens');
  print('  - modes: ${modesSeen.toList()..sort()}');
  print('  - contributing categories: ${categoriesContributing.length}');
}

/// Converts 'Backgrounds (Grouped)/Primary - Elevated' into a stable
/// hierarchical key: 'backgroundsGrouped/primaryElevated'. Spaces and
/// punctuation are normalized; the slash is preserved as the path
/// separator so the Dart emitter can fan it out into nested classes.
String _normalizeKey(String raw) {
  return raw.split('/').map(_camel).where((s) => s.isNotEmpty).join('/');
}

String _camel(String segment) {
  // Replace ' - ' / ' & ' / ' (' / ')' / non-alpha with spaces.
  final cleaned =
      segment
          .replaceAll(RegExp(r'[^A-Za-z0-9 ]'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
  if (cleaned.isEmpty) return '';
  final words = cleaned.split(' ');
  final first = words.first.toLowerCase();
  final rest = words.skip(1).map((w) {
    if (w.isEmpty) return '';
    return w[0].toUpperCase() + w.substring(1).toLowerCase();
  });
  return [first, ...rest].join();
}

bool _isHexColor(String value) {
  return RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(value) ||
      RegExp(r'^#[0-9a-fA-F]{8}$').hasMatch(value);
}

/// Returns ARGB hex string '0xAARRGGBB' suitable for Color literals.
/// Input may be '#RRGGBB' (alpha=FF) or '#RRGGBBAA' (Figma's order).
/// Emits an uppercase 8-char hex without '0x' prefix.
String _hexToArgbString(String hex) {
  var s = hex.substring(1).toUpperCase();
  if (s.length == 6) {
    s = 'FF$s';
  } else if (s.length == 8) {
    // Figma emits #RRGGBBAA. Reorder to AARRGGBB for Dart Color.
    final rr = s.substring(0, 2);
    final gg = s.substring(2, 4);
    final bb = s.substring(4, 6);
    final aa = s.substring(6, 8);
    s = '$aa$rr$gg$bb';
  }
  return s;
}

/// Parses a Figma `Font(family: "SF Pro", style: Regular, size: 13,
/// weight: 400, lineHeight: 18, letterSpacing: -0.07999999...)` spec
/// into a structured map. Returns null if the spec doesn't parse.
Map<String, Object?>? _parseFontSpec(String spec) {
  final inner = RegExp(r'^Font\((.*)\)$').firstMatch(spec)?.group(1);
  if (inner == null) return null;
  // Tokenize the comma-separated key:value pairs while respecting
  // double-quoted strings (the family name).
  final pairs = <String>[];
  final buf = StringBuffer();
  var inString = false;
  for (var i = 0; i < inner.length; i++) {
    final ch = inner[i];
    if (ch == '"') inString = !inString;
    if (ch == ',' && !inString) {
      pairs.add(buf.toString().trim());
      buf.clear();
    } else {
      buf.write(ch);
    }
  }
  if (buf.isNotEmpty) pairs.add(buf.toString().trim());

  final result = <String, Object?>{};
  for (final p in pairs) {
    final colonAt = p.indexOf(':');
    if (colonAt < 0) continue;
    final key = p.substring(0, colonAt).trim();
    var value = p.substring(colonAt + 1).trim();
    if (value.startsWith('"') && value.endsWith('"')) {
      result[key] = value.substring(1, value.length - 1);
      continue;
    }
    final n = num.tryParse(value);
    if (n != null) {
      result[key] = n;
      continue;
    }
    result[key] = value;
  }
  return result;
}

Map<String, Map<String, String>> _sortedNested(
  Map<String, Map<String, String>> input,
) {
  final keys = input.keys.toList()..sort();
  return <String, Map<String, String>>{
    for (final k in keys)
      k: Map<String, String>.fromEntries(
        input[k]!.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
  };
}

Map<String, Map<String, Map<String, Object?>>> _sortedNestedTypography(
  Map<String, Map<String, Map<String, Object?>>> input,
) {
  final keys = input.keys.toList()..sort();
  return <String, Map<String, Map<String, Object?>>>{
    for (final k in keys)
      k: Map<String, Map<String, Object?>>.fromEntries(
        input[k]!.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
  };
}

Directory _findRepoRoot() {
  var dir = Directory.current;
  while (dir.parent.path != dir.path) {
    final pubspec = File('${dir.path}/pubspec.yaml');
    if (pubspec.existsSync() &&
        pubspec.readAsStringSync().contains('liqkit_ui_workspace')) {
      return dir;
    }
    dir = dir.parent;
  }
  throw StateError('Could not find liqkit_ui_workspace pubspec.yaml');
}
