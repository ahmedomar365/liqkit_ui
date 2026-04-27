// Uses print() for CLI progress output — not production code.
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Pure functions: input is a JSON string of the manifest, output is the
/// generated source. CLI wraps these for IO.

final RegExp _validIdent = RegExp(r'^[a-zA-Z0-9_-]+$');

void _checkIdent(String kind, String value, {String? component}) {
  if (!_validIdent.hasMatch(value)) {
    final ctx = component == null ? '' : ' (component: $component)';
    throw FormatException(
      'snippet_manifest.json: invalid $kind "$value"$ctx'
      ' — only [a-zA-Z0-9_-] allowed',
    );
  }
}

String _camel(String s) {
  final parts = s.split(RegExp('[-_]'));
  return parts.first +
      parts
          .skip(1)
          .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
          .join();
}

String _identifier(String component, String variant) {
  final v = _camel(variant);
  return '${_camel(component)}${v[0].toUpperCase()}${v.substring(1)}Builder';
}

/// Render the Dart `routes.g.dart` content for [apps/docs_snippets/].
String renderDartRoutes(String manifestJson) {
  final m = jsonDecode(manifestJson) as Map<String, dynamic>;
  final components = (m['components'] as List).cast<Map<String, dynamic>>();
  final imports = <String>[];
  final entries = <String>[];

  for (final c in components) {
    final component = c['component'] as String;
    _checkIdent('component', component);
    for (final v in (c['variants'] as List).cast<Map<String, dynamic>>()) {
      final variant = v['variant'] as String;
      _checkIdent('variant', variant, component: component);
      final ident = _identifier(component, variant);
      imports.add(
        "import 'package:docs_snippets/snippets/$component/$variant.dart' show $ident;",
      );
      entries.add("  '/$component/$variant': $ident,");
    }
  }

  imports.sort();
  entries.sort();

  return '''
// GENERATED FILE — DO NOT EDIT BY HAND.
// Source: tooling/gen/snippet_manifest.json
// Regenerate: melos run docs:gen:routes

import 'package:flutter/widgets.dart';
${imports.join('\n')}

const Map<String, WidgetBuilder> snippetRoutes = <String, WidgetBuilder>{
${entries.join('\n')}
};
''';
}

/// Render the typed TypeScript route lookup for [apps/docs/].
String renderTsRoutes(String manifestJson) {
  final m = jsonDecode(manifestJson) as Map<String, dynamic>;
  final components = (m['components'] as List).cast<Map<String, dynamic>>();
  final entries = <String>[];

  for (final c in components) {
    final component = c['component'] as String;
    _checkIdent('component', component);
    for (final v in (c['variants'] as List).cast<Map<String, dynamic>>()) {
      final variant = v['variant'] as String;
      _checkIdent('variant', variant, component: component);
      final display = v['displayName'] as String;
      entries.add(
        "  '$component/$variant': { component: '$component', variant: '$variant', displayName: ${jsonEncode(display)}, path: '/$component/$variant' },",
      );
    }
  }
  entries.sort();

  return '''
// GENERATED FILE — DO NOT EDIT BY HAND.
// Source: tooling/gen/snippet_manifest.json
// Regenerate: melos run docs:gen:routes

export interface SnippetRoute {
  readonly component: string;
  readonly variant: string;
  readonly displayName: string;
  readonly path: string;
}

export const SNIPPET_ROUTES = {
${entries.join('\n')}
} as const satisfies Record<string, SnippetRoute>;

export type SnippetRouteKey = keyof typeof SNIPPET_ROUTES;
''';
}

Future<void> main(List<String> args) async {
  final repoRoot = Directory.current.path;
  final manifestPath = '$repoRoot/tooling/gen/snippet_manifest.json';

  String manifestJson;
  try {
    manifestJson = await File(manifestPath).readAsString();
  } on FileSystemException catch (e) {
    stderr.writeln('snippet_manifest.json not found at $manifestPath: $e');
    exit(1);
  }

  late final String dartRoutes;
  late final String tsRoutes;
  try {
    dartRoutes = renderDartRoutes(manifestJson);
    tsRoutes = renderTsRoutes(manifestJson);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    exit(1);
  }

  final dartOutPath = '$repoRoot/apps/docs_snippets/lib/src/routes.g.dart';
  final tsOutPath = '$repoRoot/apps/docs/lib/snippet-routes.ts';

  if (args.contains('--check')) {
    final dartOnDisk = File(dartOutPath).existsSync()
        ? File(dartOutPath).readAsStringSync()
        : '';
    final tsOnDisk = File(tsOutPath).existsSync()
        ? File(tsOutPath).readAsStringSync()
        : '';
    if (dartOnDisk != dartRoutes || tsOnDisk != tsRoutes) {
      stderr.writeln(
        'snippet routes are stale. Run: melos run docs:gen:routes',
      );
      exit(1);
    }
    print('snippet routes are up to date');
    return;
  }

  await Directory('$repoRoot/apps/docs_snippets/lib/src').create(recursive: true);
  await Directory('$repoRoot/apps/docs/lib').create(recursive: true);
  await File(dartOutPath).writeAsString(dartRoutes);
  await File(tsOutPath).writeAsString(tsRoutes);

  print('wrote $dartOutPath');
  print('wrote $tsOutPath');
}
