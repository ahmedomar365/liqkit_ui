// Pure-Dart token translator.
//
// Reads packages/liqkit_ui_design_data/manifests/tokens.json and writes
// packages/liqkit_ui_tokens/lib/src/{foundation,semantic,component}.dart.
//
// Usage:
//   dart run tooling/gen/translate_tokens.dart
//   dart run tooling/gen/translate_tokens.dart --check

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
      if (!committed.existsSync() || committed.readAsStringSync() != body) {
        drift = true;
        stderr.writeln('translate_tokens --check: $name is out of date.');
      }
    });
    final hashFile = File('${repoRoot.path}/$_hashFileRel');
    if (!hashFile.existsSync() || hashFile.readAsStringSync().trim() != jsonHash) {
      drift = true;
      stderr.writeln('translate_tokens --check: tokens.json sha256 sidecar is out of date.');
    }
    if (drift) {
      stderr.writeln('Run: dart run tooling/gen/translate_tokens.dart');
      exit(1);
    }
    stdout.writeln('translate_tokens --check: ok');
    return;
  }

  outputs.forEach((name, body) {
    File('${repoRoot.path}/$_outDirRel/$name').writeAsStringSync(body);
  });
  File('${repoRoot.path}/$_hashFileRel').writeAsStringSync('$jsonHash\n');
  stdout.writeln('translate_tokens: wrote 3 files; sha256=$jsonHash');
}

Directory _findRepoRoot() {
  var dir = Directory.current;
  while (dir.parent.path != dir.path) {
    final pubspec = File('${dir.path}/pubspec.yaml');
    if (pubspec.existsSync() && pubspec.readAsStringSync().contains('liqkit_ui_workspace')) {
      return dir;
    }
    dir = dir.parent;
  }
  throw StateError('Could not find liqkit_ui_workspace pubspec.yaml');
}

String _header(String section, String jsonHash) => '''
// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: $_jsonRel
// SHA-256: $jsonHash
// Translator: tooling/gen/translate_tokens.dart
// Section: $section
''';

String _emitFoundation(Map<String, dynamic> tokens, String hash) {
  final foundation = (tokens['foundation'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  final colors = (foundation['colors'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  final radii = (foundation['radii'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  final spacings = (foundation['spacing'] as Map<String, dynamic>?) ?? const <String, dynamic>{};

  final buf = StringBuffer()
    ..writeln(_header('foundation', hash))
    ..writeln('import "dart:ui" show Color;')
    ..writeln()
    ..writeln('/// Foundation tokens generated from liqkit.')
    ..writeln('class LiqFoundationTokens {')
    ..writeln('  /// Schema version of the foundation token set.')
    ..writeln('  static const int schemaVersion = 1;')
    ..writeln()
    ..writeln('  /// Foundation colors keyed by liqkit name.')
    ..writeln('  static const Map<String, Color> colors = <String, Color>{');
  colors.forEach((name, value) {
    final argb = _parseColor(value);
    buf.writeln("    '$name': Color(0x${argb.toRadixString(16).padLeft(8, '0')}),");
  });
  buf
    ..writeln('  };')
    ..writeln()
    ..writeln('  /// Foundation corner radii (logical pixels).')
    ..writeln('  static const Map<String, double> radii = <String, double>{');
  radii.forEach((name, value) {
    buf.writeln("    '$name': ${(value as num).toDouble()},");
  });
  buf
    ..writeln('  };')
    ..writeln()
    ..writeln('  /// Foundation spacings (logical pixels).')
    ..writeln('  static const Map<String, double> spacing = <String, double>{');
  spacings.forEach((name, value) {
    buf.writeln("    '$name': ${(value as num).toDouble()},");
  });
  buf
    ..writeln('  };')
    ..writeln('}')
    ..writeln();
  return buf.toString();
}

String _emitSemantic(Map<String, dynamic> tokens, String hash) {
  final semantic = (tokens['semantic'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  final buf = StringBuffer()
    ..writeln(_header('semantic', hash))
    ..writeln('/// Semantic tokens generated from liqkit (role -> foundation key).')
    ..writeln('class LiqSemanticTokens {')
    ..writeln('  /// Schema version of the semantic token set.')
    ..writeln('  static const int schemaVersion = 1;')
    ..writeln()
    ..writeln('  /// Semantic role -> foundation key.')
    ..writeln('  static const Map<String, String> roles = <String, String>{');
  semantic.forEach((role, target) {
    buf.writeln("    '$role': '$target',");
  });
  buf
    ..writeln('  };')
    ..writeln('}')
    ..writeln();
  return buf.toString();
}

String _emitComponent(Map<String, dynamic> tokens, String hash) {
  final component = (tokens['component'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
  final buf = StringBuffer()
    ..writeln(_header('component', hash))
    ..writeln('/// Per-component token archive generated from liqkit.')
    ..writeln('class LiqComponentTokens {')
    ..writeln('  /// Schema version of the component token set.')
    ..writeln('  static const int schemaVersion = 1;')
    ..writeln()
    ..writeln('  /// Raw component-token map. Strongly-typed accessors live in')
    ..writeln('  /// `package:liqkit_ui/theme.dart`; this map is the lossless')
    ..writeln('  /// archive of the original liqkit values.')
    ..writeln('  static const Map<String, Map<String, Object?>> raw = <String, Map<String, Object?>>{');
  component.forEach((name, value) {
    if (value is Map) {
      buf.writeln("    '$name': <String, Object?>{");
      value.forEach((k, v) {
        buf.writeln("      '$k': ${_dartLiteral(v)},");
      });
      buf.writeln('    },');
    }
  });
  buf
    ..writeln('  };')
    ..writeln('}')
    ..writeln();
  return buf.toString();
}

int _parseColor(Object? value) {
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

String _dartLiteral(Object? value) {
  if (value == null) return 'null';
  if (value is num) return value.toString();
  if (value is bool) return value.toString();
  if (value is String) return "'${value.replaceAll("'", r"\'")}'";
  if (value is List) return '<Object?>[${value.map(_dartLiteral).join(', ')}]';
  if (value is Map) {
    final entries = value.entries
        .map((e) => "'${e.key}': ${_dartLiteral(e.value)}")
        .join(', ');
    return '<String, Object?>{$entries}';
  }
  return "'$value'";
}
