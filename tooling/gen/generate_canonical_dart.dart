// Pure-Dart canonical token Dart generator.
//
// Reads packages/liqkit_ui_design_data/manifests/canonical_tokens.json
// and writes packages/liqkit_ui_tokens/lib/src/{foundation,semantic,component,canonical}.dart.
//
// Output:
//   - LiqColorMode (enum: default_, increasedContrast)
//   - LiqColorRef (final class with `Color valueIn(LiqColorMode mode)` resolver)
//   - LiqCanonicalColors (static const LiqColorRef per Figma path)
//   - LiqCanonicalTypography (static const LiqTextStyle per Figma path)
//
// Fully compile-safe: no dynamic, no string-keyed runtime lookups,
// every token is a typed `static const` reachable by named field.

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

const String _jsonRel =
    'packages/liqkit_ui_design_data/manifests/canonical_tokens.json';
const String _outDirRel = 'packages/liqkit_ui_tokens/lib/src';
const String _hashFileRel = 'tooling/gen/.canonical_tokens.json.sha256';

Future<void> main(List<String> args) async {
  final repoRoot = _findRepoRoot();
  final check = args.contains('--check');

  final jsonFile = File('${repoRoot.path}/$_jsonRel');
  if (!jsonFile.existsSync()) {
    stderr.writeln(
      'generate_canonical_dart: $_jsonRel not found. '
      'Run tooling/gen/capture_canonical_tokens.dart first.',
    );
    exit(2);
  }

  final bytes = await jsonFile.readAsBytes();
  final hash = sha256.convert(bytes).toString();
  final tokens = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;

  final modes = (tokens['modes'] as List?)
          ?.cast<String>()
          .toList(growable: false) ??
      const <String>['default'];

  final colors = (tokens['colors'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
  final typography = (tokens['typography'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};

  final canonicalDart = _emitCanonical(modes, colors, typography, hash);
  // Keep the schemaVersion-shaped placeholder files so the existing
  // tokens_smoke_test.dart and downstream imports still resolve.
  final foundationDart = _emitFoundationStub(hash);
  final semanticDart = _emitSemanticStub(hash);
  final componentDart = _emitComponentStub(hash);

  final outputs = <String, String>{
    'canonical.dart': canonicalDart,
    'foundation.dart': foundationDart,
    'semantic.dart': semanticDart,
    'component.dart': componentDart,
  };

  if (check) {
    var drift = false;
    outputs.forEach((name, body) {
      final committed = File('${repoRoot.path}/$_outDirRel/$name');
      if (!committed.existsSync() ||
          committed.readAsStringSync() != body) {
        drift = true;
        stderr.writeln('generate_canonical_dart --check: $name out of date.');
      }
    });
    final hashFile = File('${repoRoot.path}/$_hashFileRel');
    if (!hashFile.existsSync() ||
        hashFile.readAsStringSync().trim() != hash) {
      drift = true;
      stderr.writeln(
        'generate_canonical_dart --check: canonical_tokens.json sha256 sidecar is out of date.',
      );
    }
    if (drift) {
      stderr.writeln(
        'Run: dart run tooling/gen/generate_canonical_dart.dart',
      );
      exit(1);
    }
    print('generate_canonical_dart --check: ok');
    return;
  }

  outputs.forEach((name, body) {
    File('${repoRoot.path}/$_outDirRel/$name').writeAsStringSync(body);
  });
  File('${repoRoot.path}/$_hashFileRel').writeAsStringSync('$hash\n');
  print('generate_canonical_dart: wrote ${outputs.length} files; sha256=$hash');
}

const String _ignores =
    '// ignore_for_file: lines_longer_than_80_chars, '
    'public_member_api_docs, prefer_single_quotes, '
    'constant_identifier_names, prefer_int_literals, '
    'comment_references, eol_at_end_of_file';

String _header(String section, String hash) => '''
// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: $_jsonRel
// SHA-256: $hash
// Translator: tooling/gen/generate_canonical_dart.dart
// Section: $section
$_ignores

''';

String _emitCanonical(
  List<String> modes,
  Map<String, dynamic> colors,
  Map<String, dynamic> typography,
  String hash,
) {
  final buf = StringBuffer()
    ..write(_header('canonical', hash))
    ..writeln("import 'dart:ui' show Color, FontWeight;")
    ..writeln()
    ..writeln('/// Active iOS 26 token mode.')
    ..writeln('///')
    ..writeln('/// Captured from liqkit\'s Figma extraction. Values come from')
    ..writeln('/// `figma_artifacts/<category>/<node>.variable-defs.json` across')
    ..writeln('/// all 37 categories.')
    ..writeln('enum LiqColorMode {');
  for (final mode in modes) {
    buf
      ..writeln('  /// `${_dartIdent(mode)}` mode (Figma key: `$mode`).')
      ..writeln('  ${_dartIdent(mode)},');
  }
  buf
    ..writeln('}')
    ..writeln()
    ..writeln('/// A canonical iOS 26 color reference resolved per [LiqColorMode].')
    ..writeln('@pragma(\'vm:prefer-inline\')')
    ..writeln('final class LiqColorRef {')
    ..writeln('  /// Creates a color reference.')
    ..writeln('  const LiqColorRef({');
  for (final mode in modes) {
    buf.writeln('    required this.${_dartIdent(mode)},');
  }
  buf
    ..writeln('  });')
    ..writeln();
  for (final mode in modes) {
    buf
      ..writeln('  /// Value in `${_dartIdent(mode)}` mode.')
      ..writeln('  final Color ${_dartIdent(mode)};')
      ..writeln();
  }
  buf
    ..writeln('  /// Resolves the color value for [mode].')
    ..writeln('  Color valueIn(LiqColorMode mode) {')
    ..writeln('    switch (mode) {');
  for (final mode in modes) {
    buf
      ..writeln('      case LiqColorMode.${_dartIdent(mode)}:')
      ..writeln('        return ${_dartIdent(mode)};');
  }
  buf
    ..writeln('    }')
    ..writeln('  }')
    ..writeln('}')
    ..writeln();

  // Emit the LiqCanonicalColors class with one static const per token.
  buf
    ..writeln('/// Every iOS 26 color token captured from liqkit.')
    ..writeln('///')
    ..writeln('/// Field names are derived from the Figma path. For example,')
    ..writeln('/// Figma\'s `Backgrounds (Grouped)/Primary` becomes')
    ..writeln('/// [backgroundsGroupedPrimary].')
    ..writeln('class LiqCanonicalColors {')
    ..writeln('  const LiqCanonicalColors._();')
    ..writeln();
  final allColorEntries = <_ColorEntry>[];
  colors.forEach((path, modeMap) {
    if (modeMap is! Map) return;
    final fieldName = _dartFieldName(path);
    final perMode = <String, String>{};
    for (final mode in modes) {
      final raw = modeMap[mode]?.toString();
      if (raw == null) {
        // Fall back to the first available mode value to keep the field
        // typed as Color (no nulls). The default mode is always present
        // in our capture script's output.
        final any = modeMap.values.firstOrNull?.toString() ?? 'FF000000';
        perMode[mode] = any;
      } else {
        perMode[mode] = raw;
      }
    }
    allColorEntries.add(_ColorEntry(path: path, fieldName: fieldName, perMode: perMode));
  });
  for (final e in allColorEntries) {
    buf
      ..writeln('  /// `${e.path}` from liqkit Figma variable-defs.')
      ..writeln('  static const LiqColorRef ${e.fieldName} = LiqColorRef(');
    for (final mode in modes) {
      final hexVal = e.perMode[mode]!;
      buf.writeln('    ${_dartIdent(mode)}: Color(0x$hexVal),');
    }
    buf
      ..writeln('  );')
      ..writeln();
  }
  buf
    ..writeln('  /// Iterable view over every canonical color, paired with its')
    ..writeln('  /// dotted Figma path.')
    ..writeln('  static const List<MapEntry<String, LiqColorRef>> all =')
    ..writeln('      <MapEntry<String, LiqColorRef>>[');
  for (final e in allColorEntries) {
    buf.writeln("        MapEntry('${e.path}', ${e.fieldName}),");
  }
  buf
    ..writeln('      ];')
    ..writeln('}')
    ..writeln();

  // Typography.
  buf
    ..writeln('/// A canonical iOS 26 text-style reference per mode.')
    ..writeln('final class LiqTypographyRef {')
    ..writeln('  /// Creates a typography reference.')
    ..writeln('  const LiqTypographyRef({');
  for (final mode in modes) {
    buf.writeln('    required this.${_dartIdent(mode)},');
  }
  buf
    ..writeln('  });')
    ..writeln();
  for (final mode in modes) {
    buf
      ..writeln('  /// Spec in `${_dartIdent(mode)}` mode.')
      ..writeln('  final LiqTypographySpec ${_dartIdent(mode)};')
      ..writeln();
  }
  buf
    ..writeln('  /// Resolves the spec for [mode].')
    ..writeln('  LiqTypographySpec valueIn(LiqColorMode mode) {')
    ..writeln('    switch (mode) {');
  for (final mode in modes) {
    buf
      ..writeln('      case LiqColorMode.${_dartIdent(mode)}:')
      ..writeln('        return ${_dartIdent(mode)};');
  }
  buf
    ..writeln('    }')
    ..writeln('  }')
    ..writeln('}')
    ..writeln()
    ..writeln('/// One canonical typography record (family + size + weight + …).')
    ..writeln('final class LiqTypographySpec {')
    ..writeln('  /// Creates a typography spec.')
    ..writeln('  const LiqTypographySpec({')
    ..writeln('    required this.family,')
    ..writeln('    required this.style,')
    ..writeln('    required this.size,')
    ..writeln('    required this.weight,')
    ..writeln('    required this.lineHeight,')
    ..writeln('    required this.letterSpacing,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  /// Font family (e.g. "SF Pro").')
    ..writeln('  final String family;')
    ..writeln()
    ..writeln('  /// Style label as captured from Figma (e.g. "Regular", "Semibold").')
    ..writeln('  final String style;')
    ..writeln()
    ..writeln('  /// Font size in logical pixels.')
    ..writeln('  final double size;')
    ..writeln()
    ..writeln('  /// Font weight.')
    ..writeln('  final FontWeight weight;')
    ..writeln()
    ..writeln('  /// Line height in logical pixels.')
    ..writeln('  final double lineHeight;')
    ..writeln()
    ..writeln('  /// Tracking in logical pixels.')
    ..writeln('  final double letterSpacing;')
    ..writeln('}')
    ..writeln();

  buf
    ..writeln('/// Every iOS 26 typography token captured from liqkit.')
    ..writeln('class LiqCanonicalTypography {')
    ..writeln('  const LiqCanonicalTypography._();')
    ..writeln();
  final typoEntries = <_TypoEntry>[];
  typography.forEach((path, modeMap) {
    if (modeMap is! Map) return;
    final fieldName = _dartFieldName(path);
    final perMode = <String, _Spec>{};
    for (final mode in modes) {
      final body = modeMap[mode];
      if (body is! Map) {
        // Fall back to any available mode.
        final any = modeMap.values.firstWhere(
              (v) => v is Map,
              orElse: () => const <String, Object?>{},
            ) as Map;
        perMode[mode] = _Spec.from(any);
      } else {
        perMode[mode] = _Spec.from(body);
      }
    }
    typoEntries.add(_TypoEntry(path: path, fieldName: fieldName, perMode: perMode));
  });
  for (final e in typoEntries) {
    buf
      ..writeln('  /// `${e.path}` from liqkit Figma variable-defs.')
      ..writeln(
        '  static const LiqTypographyRef ${e.fieldName} = LiqTypographyRef(',
      );
    for (final mode in modes) {
      final s = e.perMode[mode]!;
      buf
        ..writeln('    ${_dartIdent(mode)}: LiqTypographySpec(')
        ..writeln("      family: '${s.family}',")
        ..writeln("      style: '${s.style}',")
        ..writeln('      size: ${s.size},')
        ..writeln('      weight: FontWeight.w${s.fontWeightRounded},')
        ..writeln('      lineHeight: ${s.lineHeight},')
        ..writeln('      letterSpacing: ${s.letterSpacing},')
        ..writeln('    ),');
    }
    buf
      ..writeln('  );')
      ..writeln();
  }
  buf
    ..writeln('  /// Iterable view over every canonical typography token.')
    ..writeln(
      '  static const List<MapEntry<String, LiqTypographyRef>> all =',
    )
    ..writeln('      <MapEntry<String, LiqTypographyRef>>[');
  for (final e in typoEntries) {
    buf.writeln("        MapEntry('${e.path}', ${e.fieldName}),");
  }
  buf
    ..writeln('      ];')
    ..writeln('}')
    ..writeln();

  return buf.toString();
}

String _emitFoundationStub(String hash) => '''
${_header('foundation', hash)}/// Foundation tokens placeholder.
///
/// Real iOS 26 token data lives in [LiqCanonicalColors] and
/// [LiqCanonicalTypography] under `package:liqkit_ui_tokens/liqkit_ui_tokens.dart`.
/// This class is preserved for backwards compatibility with the original
/// scaffold; new code should reference the canonical accessors directly.
class LiqFoundationTokens {
  /// Schema version of the foundation token set.
  static const int schemaVersion = 2;
}
''';

String _emitSemanticStub(String hash) => '''
${_header('semantic', hash)}/// Semantic tokens placeholder. See `LiqCanonicalColors` for real data.
class LiqSemanticTokens {
  /// Schema version of the semantic token set.
  static const int schemaVersion = 2;
}
''';

String _emitComponentStub(String hash) => '''
${_header('component', hash)}/// Component tokens placeholder. See `LiqCanonicalColors` for real data.
class LiqComponentTokens {
  /// Schema version of the component token set.
  static const int schemaVersion = 2;
}
''';

class _ColorEntry {
  _ColorEntry({
    required this.path,
    required this.fieldName,
    required this.perMode,
  });
  final String path;
  final String fieldName;
  final Map<String, String> perMode;
}

class _TypoEntry {
  _TypoEntry({
    required this.path,
    required this.fieldName,
    required this.perMode,
  });
  final String path;
  final String fieldName;
  final Map<String, _Spec> perMode;
}

class _Spec {
  _Spec({
    required this.family,
    required this.style,
    required this.size,
    required this.fontWeightRounded,
    required this.lineHeight,
    required this.letterSpacing,
  });

  factory _Spec.from(Map<dynamic, dynamic> body) {
    final family = (body['family'] as String?) ?? 'SF Pro';
    final style = (body['style'] as String?) ?? 'Regular';
    final size = (body['size'] as num?)?.toDouble() ?? 14.0;
    final weightRaw = (body['weight'] as num?)?.toDouble() ?? 400.0;
    final lineHeight = (body['lineHeight'] as num?)?.toDouble() ?? size * 1.2;
    final letterSpacing =
        (body['letterSpacing'] as num?)?.toDouble() ?? 0.0;
    return _Spec(
      family: family,
      style: style,
      size: size,
      fontWeightRounded: _roundFontWeight(weightRaw),
      lineHeight: lineHeight,
      letterSpacing: _roundDouble(letterSpacing, 4),
    );
  }

  final String family;
  final String style;
  final double size;
  final int fontWeightRounded;
  final double lineHeight;
  final double letterSpacing;
}

int _roundFontWeight(double weight) {
  // Snap to the nearest Flutter FontWeight bucket: 100, 200, 300,
  // 400, 500, 600, 700, 800, 900. Figma sometimes emits 590 for
  // SF Pro Semibold; round to 600.
  const buckets = <int>[100, 200, 300, 400, 500, 600, 700, 800, 900];
  var best = buckets.first;
  var bestDelta = (weight - best).abs();
  for (final b in buckets.skip(1)) {
    final d = (weight - b).abs();
    if (d < bestDelta) {
      best = b;
      bestDelta = d;
    }
  }
  return best;
}

double _roundDouble(double v, int decimals) {
  final factor = 1.0 *
      List<int>.filled(decimals, 10).fold<int>(1, (a, b) => a * b);
  return (v * factor).round() / factor;
}

extension on Iterable<dynamic> {
  Object? get firstOrNull => isEmpty ? null : first;
}

String _dartIdent(String s) {
  // Camel-case a single segment (e.g. "default" -> "default_" because
  // it's a reserved word; "increasedContrast" stays as-is).
  if (s == 'default') return 'default_';
  // Normalize: split on non-alpha, camel-case words.
  final cleaned =
      s.replaceAll(RegExp(r'[^A-Za-z0-9]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  if (cleaned.isEmpty) return 'value';
  final words = cleaned.split(' ');
  final first = words.first[0].toLowerCase() + words.first.substring(1);
  final rest = words.skip(1).map((w) {
    if (w.isEmpty) return '';
    return w[0].toUpperCase() + w.substring(1);
  });
  return [first, ...rest].join();
}

String _dartFieldName(String path) {
  // 'backgroundsGrouped/primary' -> 'backgroundsGroupedPrimary'
  // 'accents/blue' -> 'accentsBlue'
  final parts = path.split('/').where((s) => s.isNotEmpty).toList();
  if (parts.isEmpty) return 'value';
  final first = parts.first;
  final firstCamel = first[0].toLowerCase() + first.substring(1);
  final rest = parts.skip(1).map((p) {
    if (p.isEmpty) return '';
    return p[0].toUpperCase() + p.substring(1);
  });
  return [firstCamel, ...rest].join();
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
