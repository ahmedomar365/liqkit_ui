// Walks every figma_artifacts/<category>/*.variable-defs.json and
// catalogs the *full* iOS 26 design surface (colors, typography, modes).
//
// Compares this canonical surface against what the TS foundationTokens
// + semanticTokens captured. Output:
//   - count of unique color tokens by mode
//   - count of unique typography tokens by mode
//   - list of modes encountered
//   - first N color samples
//   - first N typography samples
//   - delta vs. tokens.json
//
// Writes report to packages/liqkit_ui_design_data/TOKEN_INVENTORY.md.

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

const String _designDataRel = 'packages/liqkit_ui_design_data';

void main(List<String> args) {
  final repoRoot = _findRepoRoot();
  final root = Directory('${repoRoot.path}/$_designDataRel');
  final figmaArtifacts = Directory('${root.path}/figma_artifacts');
  if (!figmaArtifacts.existsSync()) {
    stderr.writeln('inventory: figma_artifacts/ missing');
    exit(2);
  }

  // For every variable-defs.json file, parse and collect the keys.
  // Schema (from inspection):
  //   { generatedAt, categoryNode, modes: { <modeName>: { <tokenKey>: <value> } } }
  // tokenKey is hierarchical, e.g. "Backgrounds (Grouped)/Primary".
  // Value is hex color, font spec, or rarely a number.

  // Per-mode dictionaries: mode -> tokenKey -> set of values seen.
  final byMode = <String, Map<String, Set<String>>>{};
  // Per-category presence: tokenKey -> categories that emit it.
  final keyCategories = <String, Set<String>>{};
  // Distinguish color tokens from font/other.
  final colorKeys = <String>{};
  final fontKeys = <String>{};
  final otherKeys = <String>{};

  final categoryDirs = figmaArtifacts
      .listSync()
      .whereType<Directory>()
      .where((d) {
        final n = d.uri.pathSegments.where((s) => s.isNotEmpty).last;
        return n != 'native' && n != 'assets' && n != 'history' && n != 'raw';
      })
      .toList();

  for (final cat in categoryDirs) {
    final catName =
        cat.uri.pathSegments.where((s) => s.isNotEmpty).last;
    for (final f in cat.listSync().whereType<File>()) {
      if (!f.path.endsWith('.variable-defs.json')) continue;
      final raw = f.readAsStringSync();
      Map<String, dynamic> json;
      try {
        json = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        continue;
      }
      final modes =
          (json['modes'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
      modes.forEach((modeName, modeBody) {
        if (modeBody is! Map) return;
        final perMode = byMode.putIfAbsent(
          modeName,
          () => <String, Set<String>>{},
        );
        modeBody.forEach((key, value) {
          if (key is! String) return;
          final v = value?.toString() ?? '';
          perMode.putIfAbsent(key, () => <String>{}).add(v);
          keyCategories.putIfAbsent(key, () => <String>{}).add(catName);
          if (_isHexColor(v) || _isHexAlphaColor(v)) {
            colorKeys.add(key);
          } else if (v.startsWith('Font(')) {
            fontKeys.add(key);
          } else {
            otherKeys.add(key);
          }
        });
      });
    }
  }

  // Compare to tokens.json captured from TS.
  final tokensFile =
      File('${root.path}/manifests/tokens.json');
  Map<String, dynamic>? capturedTs;
  if (tokensFile.existsSync()) {
    capturedTs =
        jsonDecode(tokensFile.readAsStringSync()) as Map<String, dynamic>;
  }
  final tsColorCount = _capturedColorCount(capturedTs);
  final tsRadiiCount = _capturedRadiiCount(capturedTs);
  final tsSpacingCount = _capturedSpacingCount(capturedTs);

  // Build report.
  final buf = StringBuffer()
    ..writeln('# liqkit token surface inventory')
    ..writeln()
    ..writeln(
      'Compares the *true* iOS 26 token surface (extracted from every '
      'Figma variable-defs.json across all 37 categories) against what '
      "the TS \\`foundationTokens\\` capture in \\`tokens.json\\` exposes.",
    )
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..writeln('- Categories scanned: ${categoryDirs.length}')
    ..writeln('- Modes encountered: ${byMode.keys.toList()..sort()}')
    ..writeln('- Unique color tokens (across all modes): ${colorKeys.length}')
    ..writeln('- Unique typography tokens: ${fontKeys.length}')
    ..writeln('- Unique other tokens: ${otherKeys.length}')
    ..writeln()
    ..writeln('## TS-captured vs. Figma-defined')
    ..writeln()
    ..writeln('| Surface | TS tokens.json | Figma variable-defs |')
    ..writeln('|---|---:|---:|')
    ..writeln('| Colors | $tsColorCount | ${colorKeys.length} |')
    ..writeln('| Radii | $tsRadiiCount | n/a (in component CSS only) |')
    ..writeln('| Spacing | $tsSpacingCount | n/a (in component CSS only) |')
    ..writeln('| Typography | 0 | ${fontKeys.length} |');

  for (final mode in byMode.keys.toList()..sort()) {
    final perMode = byMode[mode]!;
    buf
      ..writeln()
      ..writeln('## Mode: `$mode` (${perMode.length} tokens)')
      ..writeln();
    final colorEntries = perMode.entries
        .where((e) => colorKeys.contains(e.key))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final fontEntries = perMode.entries
        .where((e) => fontKeys.contains(e.key))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (colorEntries.isNotEmpty) {
      buf
        ..writeln('### Colors (${colorEntries.length})')
        ..writeln();
      for (final entry in colorEntries) {
        final values = entry.value.toList()..sort();
        buf.writeln('- `${entry.key}` = ${values.join(' / ')}');
      }
      buf.writeln();
    }
    if (fontEntries.isNotEmpty) {
      buf
        ..writeln('### Typography (${fontEntries.length})')
        ..writeln();
      for (final entry in fontEntries) {
        final values = entry.value.toList()..sort();
        buf.writeln('- `${entry.key}` = ${values.join(' / ')}');
      }
      buf.writeln();
    }
  }

  // Per-category coverage table for color keys: which categories define which
  // tokens. This is useful when reconciling cross-category overlaps.
  buf
    ..writeln('## Per-category color-token presence')
    ..writeln()
    ..writeln(
      'A `*` in a column means the category file declared that token at least once.',
    )
    ..writeln();

  final sortedColorKeys = colorKeys.toList()..sort();
  final sortedCats = categoryDirs
      .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last)
      .toList()
    ..sort();

  buf.writeln(
    '_Listed: top 30 most cross-category-shared tokens. Full data in `manifests/token_inventory.json`._',
  );
  buf.writeln();
  final ranked = sortedColorKeys
      .map((k) => MapEntry(k, keyCategories[k]?.length ?? 0))
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  for (final r in ranked.take(30)) {
    buf.writeln(
      '- `${r.key}` — present in ${r.value} categories',
    );
  }

  File('${root.path}/TOKEN_INVENTORY.md').writeAsStringSync(buf.toString());
  stdout.writeln('inventory: wrote ${root.path}/TOKEN_INVENTORY.md');
  stdout.writeln('inventory: ${categoryDirs.length} categories scanned');
  stdout.writeln('inventory: ${byMode.length} modes');
  stdout.writeln('inventory: ${colorKeys.length} unique color tokens');
  stdout.writeln('inventory: ${fontKeys.length} unique typography tokens');
  stdout.writeln('inventory: TS tokens.json had only $tsColorCount colors');
  stdout.writeln(
    'inventory: gap = ${colorKeys.length - tsColorCount} colors NOT in tokens.json',
  );

  // Persist machine-readable.
  final json = const JsonEncoder.withIndent('  ').convert(<String, Object>{
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'modes': byMode.map(
      (mode, perMode) => MapEntry(
        mode,
        perMode.map(
          (k, v) => MapEntry(k, v.toList()..sort()),
        ),
      ),
    ),
    'colorKeys': sortedColorKeys,
    'fontKeys': fontKeys.toList()..sort(),
    'otherKeys': otherKeys.toList()..sort(),
    'keyCategories':
        keyCategories.map((k, v) => MapEntry(k, v.toList()..sort())),
  });
  File('${root.path}/manifests/token_inventory.json').writeAsStringSync(json);
  stdout.writeln(
    'inventory: wrote ${root.path}/manifests/token_inventory.json',
  );
}

bool _isHexColor(String value) {
  return RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(value);
}

bool _isHexAlphaColor(String value) {
  return RegExp(r'^#[0-9a-fA-F]{8}$').hasMatch(value);
}

int _capturedColorCount(Map<String, dynamic>? tokens) {
  if (tokens == null) return 0;
  final foundation = (tokens['foundation'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
  final ft = (foundation['foundationTokens'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
  final color = (ft['color'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  return color.length;
}

int _capturedRadiiCount(Map<String, dynamic>? tokens) {
  if (tokens == null) return 0;
  final foundation = (tokens['foundation'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
  final ft = (foundation['foundationTokens'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
  final r = (ft['radius'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  return r.length;
}

int _capturedSpacingCount(Map<String, dynamic>? tokens) {
  if (tokens == null) return 0;
  final foundation = (tokens['foundation'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
  final ft = (foundation['foundationTokens'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
  final s = (ft['spacing'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  return s.length;
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
