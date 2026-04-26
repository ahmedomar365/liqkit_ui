// Pure-Dart token translator for liqkit_ui.
//
// Reads packages/liqkit_ui_design_data/manifests/tokens.json (captured
// once from liqkit's TypeScript sources by ts_to_json_oneshot.mjs) and
// writes packages/liqkit_ui_tokens/lib/src/{foundation,semantic,component}.dart.
//
// Schema of the JSON, derived from liqkit/packages/tokens/src/*.ts:
//
//   foundation.foundationTokens.color   : { name -> "#RRGGBB" }
//   foundation.foundationTokens.radius  : { name -> "<n>px" }
//   foundation.foundationTokens.spacing : { name -> "<n>px" }
//   foundation.foundationTokens.motion  : { name -> "<n>ms" }
//   semantic.semanticTokens             : { "--ui-*" -> "#RRGGBB" }   (pre-resolved)
//   component.componentTokens           : { component -> { "--xxx" -> string } }
//                                         The component values are CSS-style strings
//                                         that may be either px/ms literals or
//                                         var(--ui-*) references. They are kept verbatim
//                                         here; component themes resolve them at build
//                                         time using the foundation + semantic layers.
//
// Usage:
//   dart run tooling/gen/translate_tokens.dart
//   dart run tooling/gen/translate_tokens.dart --check

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

const String _jsonRel = 'packages/liqkit_ui_design_data/manifests/tokens.json';
const String _outDirRel = 'packages/liqkit_ui_tokens/lib/src';
const String _hashFileRel = 'tooling/gen/.tokens.json.sha256';

Future<void> main(List<String> args) async {
  final repoRoot = _findRepoRoot();
  final check = args.contains('--check');

  final jsonFile = File('${repoRoot.path}/$_jsonRel');
  if (!jsonFile.existsSync()) {
    stderr.writeln(
      'translate_tokens: $_jsonRel not found. '
      'Run tooling/gen/ts_to_json_oneshot.mjs first.',
    );
    exit(2);
  }

  final jsonBytes = await jsonFile.readAsBytes();
  final jsonHash = sha256.convert(jsonBytes).toString();
  final tokens = jsonDecode(utf8.decode(jsonBytes)) as Map<String, dynamic>;

  final foundation = _emitFoundation(tokens, jsonHash);
  final semantic = _emitSemantic(tokens, jsonHash);
  final component = _emitComponent(tokens, jsonHash);

  final outputs = <String, String>{
    'foundation.dart': foundation,
    'semantic.dart': semantic,
    'component.dart': component,
  };

  if (check) {
    var drift = false;
    outputs.forEach((name, body) {
      final committed = File('${repoRoot.path}/$_outDirRel/$name');
      if (!committed.existsSync() ||
          committed.readAsStringSync() != body) {
        drift = true;
        stderr.writeln('translate_tokens --check: $name out of date.');
      }
    });
    final hashFile = File('${repoRoot.path}/$_hashFileRel');
    if (!hashFile.existsSync() ||
        hashFile.readAsStringSync().trim() != jsonHash) {
      drift = true;
      stderr.writeln(
        'translate_tokens --check: tokens.json sha256 sidecar is out of date.',
      );
    }
    if (drift) {
      stderr.writeln('Run: dart run tooling/gen/translate_tokens.dart');
      exit(1);
    }
    print('translate_tokens --check: ok');
    return;
  }

  outputs.forEach((name, body) {
    File('${repoRoot.path}/$_outDirRel/$name').writeAsStringSync(body);
  });
  File('${repoRoot.path}/$_hashFileRel').writeAsStringSync('$jsonHash\n');
  print('translate_tokens: wrote 3 files; sha256=$jsonHash');
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

const String _ignoreLints =
    '// ignore_for_file: lines_longer_than_80_chars, '
    'public_member_api_docs, prefer_single_quotes';

String _header(String section, String hash) => '''
// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: $_jsonRel
// SHA-256: $hash
// Translator: tooling/gen/translate_tokens.dart
// Section: $section
$_ignoreLints

''';

Map<String, dynamic> _foundationTokens(Map<String, dynamic> tokens) {
  final foundation =
      (tokens['foundation'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  // ts_to_json_oneshot.mjs captures every named export from the
  // module. The TS module exports `foundationTokens`, so we drill into
  // that object.
  return (foundation['foundationTokens'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
}

Map<String, dynamic> _semanticTokens(Map<String, dynamic> tokens) {
  final semantic =
      (tokens['semantic'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  return (semantic['semanticTokens'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
}

Map<String, dynamic> _componentTokens(Map<String, dynamic> tokens) {
  final component =
      (tokens['component'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  return (component['componentTokens'] as Map<String, dynamic>?) ??
      const <String, dynamic>{};
}

String _emitFoundation(Map<String, dynamic> tokens, String hash) {
  final root = _foundationTokens(tokens);
  final color =
      (root['color'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  final radius =
      (root['radius'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  final spacing =
      (root['spacing'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  final motion =
      (root['motion'] as Map<String, dynamic>?) ?? const <String, dynamic>{};

  final buf = StringBuffer()
    ..write(_header('foundation', hash))
    ..writeln("import 'dart:ui' show Color;")
    ..writeln()
    ..writeln('/// Foundation tokens generated from liqkit.')
    ..writeln('class LiqFoundationTokens {')
    ..writeln('  /// Schema version of the foundation token set.')
    ..writeln('  static const int schemaVersion = 1;')
    ..writeln()
    ..writeln('  /// Foundation colors keyed by liqkit name.')
    ..writeln('  static const Map<String, Color> colors = <String, Color>{');
  color.forEach((name, value) {
    final argb = _parseHexColor(value);
    final hex = argb.toRadixString(16).padLeft(8, '0').toUpperCase();
    buf.writeln("    '$name': Color(0x$hex),");
  });
  buf
    ..writeln('  };')
    ..writeln()
    ..writeln('  /// Foundation corner radii (logical pixels).')
    ..writeln('  static const Map<String, double> radii = <String, double>{');
  radius.forEach((name, value) {
    buf.writeln("    '$name': ${_parsePx(value)},");
  });
  buf
    ..writeln('  };')
    ..writeln()
    ..writeln('  /// Foundation spacings (logical pixels).')
    ..writeln('  static const Map<String, double> spacing = <String, double>{');
  spacing.forEach((name, value) {
    buf.writeln("    '$name': ${_parsePx(value)},");
  });
  buf
    ..writeln('  };')
    ..writeln()
    ..writeln('  /// Foundation motion durations.')
    ..writeln(
      '  static const Map<String, Duration> motion = <String, Duration>{',
    );
  motion.forEach((name, value) {
    buf.writeln("    '$name': Duration(milliseconds: ${_parseMs(value)}),");
  });
  buf
    ..writeln('  };')
    ..writeln('}');
  return buf.toString();
}

String _emitSemantic(Map<String, dynamic> tokens, String hash) {
  final root = _semanticTokens(tokens);
  final buf = StringBuffer()
    ..write(_header('semantic', hash))
    ..writeln("import 'dart:ui' show Color;")
    ..writeln()
    ..writeln(
      '/// Semantic tokens generated from liqkit (CSS variable -> resolved color).',
    )
    ..writeln(
      "/// Keys are the CSS variable names exactly as authored in liqkit's TS,")
    ..writeln('/// e.g. `--ui-accent-primary`.')
    ..writeln('class LiqSemanticTokens {')
    ..writeln('  /// Schema version of the semantic token set.')
    ..writeln('  static const int schemaVersion = 1;')
    ..writeln()
    ..writeln(
      '  /// Pre-resolved semantic colors keyed by their `--ui-*` CSS variable name.',
    )
    ..writeln(
      '  static const Map<String, Color> colors = <String, Color>{',
    );
  root.forEach((cssVar, value) {
    final argb = _parseHexColor(value);
    final hex = argb.toRadixString(16).padLeft(8, '0').toUpperCase();
    buf.writeln("    '$cssVar': Color(0x$hex),");
  });
  buf
    ..writeln('  };')
    ..writeln('}');
  return buf.toString();
}

String _emitComponent(Map<String, dynamic> tokens, String hash) {
  final root = _componentTokens(tokens);
  final buf = StringBuffer()
    ..write(_header('component', hash))
    ..writeln('/// Per-component token archive generated from liqkit.')
    ..writeln('///')
    ..writeln(
      "/// Values are the raw CSS-variable strings from liqkit's TS source, e.g.",
    )
    ..writeln('/// `\'var(--ui-accent-primary)\'` or `\'12px\'`. Component themes')
    ..writeln('/// resolve these at build time against the foundation and semantic')
    ..writeln('/// layers in `package:liqkit_ui/theme.dart`.')
    ..writeln('class LiqComponentTokens {')
    ..writeln('  /// Schema version of the component token set.')
    ..writeln('  static const int schemaVersion = 1;')
    ..writeln()
    ..writeln(
      '  /// Per-component CSS-variable maps (kept verbatim).',
    )
    ..writeln(
      '  static const Map<String, Map<String, String>> raw =')
    ..writeln('      <String, Map<String, String>>{');
  root.forEach((component, value) {
    if (value is! Map) return;
    buf.writeln("    '$component': <String, String>{");
    value.forEach((k, v) {
      final escaped = (v?.toString() ?? '').replaceAll(r'\', r'\\').replaceAll("'", r"\'");
      buf.writeln("      '$k': '$escaped',");
    });
    buf.writeln('    },');
  });
  buf
    ..writeln('  };')
    ..writeln('}');
  return buf.toString();
}

int _parseHexColor(Object? value) {
  if (value is String) {
    var s = value.trim();
    if (s.startsWith('#')) s = s.substring(1);
    if (s.length == 6) s = 'ff$s';
    if (s.length == 8) {
      return int.parse(s, radix: 16);
    }
  }
  if (value is int) return value;
  return 0xFF000000;
}

double _parsePx(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) {
    final m = RegExp(r'^(-?\d+(?:\.\d+)?)\s*px$').firstMatch(value.trim());
    if (m != null) return double.parse(m.group(1)!);
    return double.tryParse(value.trim()) ?? 0;
  }
  return 0;
}

int _parseMs(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) {
    final m = RegExp(r'^(-?\d+(?:\.\d+)?)\s*ms$').firstMatch(value.trim());
    if (m != null) return double.parse(m.group(1)!).round();
    return int.tryParse(value.trim()) ?? 0;
  }
  return 0;
}
