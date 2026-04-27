// Tiny static preview server that mirrors liqkit's original preview/
// directory layout on top of our flattened design_data/ archive.
//
// Mounts:
//   /                          -> packages/liqkit_ui_design_data/rendered/
//   /source/...                -> packages/liqkit_ui_design_data/rendered/source/...
//   /snapshots/<slug>.png      -> packages/liqkit_ui_design_data/rendered/fidelity-snapshots/<slug>.png
//                                  (rendered/snapshots/ was deliberately skipped during import;
//                                   fidelity-snapshots are the per-component crops, which is
//                                   what the rendered HTML's "Open snapshot" link is meant to show)
//   /evidence/figma-artifacts/ -> packages/liqkit_ui_design_data/figma_artifacts/
//
// Usage:
//   dart run tooling/scripts/preview_server.dart [--port N]
//
// Default port: 4174.

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

const String _designDataRel = 'packages/liqkit_ui_design_data';

Future<void> main(List<String> args) async {
  var port = 4174;
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i] == '--port') {
      port = int.parse(args[i + 1]);
    }
  }

  final repoRoot = _findRepoRoot();
  final dataRoot = Directory('${repoRoot.path}/$_designDataRel');
  if (!dataRoot.existsSync()) {
    stderr.writeln('preview_server: $_designDataRel missing.');
    exit(2);
  }

  final mounts = <_Mount>[
    _Mount(
      prefix: '/evidence/figma-artifacts/',
      root: Directory('${dataRoot.path}/figma_artifacts'),
    ),
    _Mount(
      prefix: '/snapshots/',
      root: Directory('${dataRoot.path}/rendered/fidelity-snapshots'),
    ),
    _Mount(
      prefix: '/source/',
      root: Directory('${dataRoot.path}/rendered/source'),
    ),
    _Mount(prefix: '/', root: Directory('${dataRoot.path}/rendered')),
  ];

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('preview_server: serving on http://localhost:$port');
  print('  / -> ${mounts.last.root.path}');
  print('  /source/ -> ${mounts[2].root.path}');
  print('  /snapshots/ -> ${mounts[1].root.path}');
  print('  /evidence/figma-artifacts/ -> ${mounts[0].root.path}');

  await for (final request in server) {
    unawaited(_handle(request, mounts));
  }
}

class _Mount {
  _Mount({required this.prefix, required this.root});
  final String prefix;
  final Directory root;
}

Future<void> _handle(HttpRequest req, List<_Mount> mounts) async {
  final path = req.uri.path;
  for (final mount in mounts) {
    if (!path.startsWith(mount.prefix)) continue;
    var rel = path.substring(mount.prefix.length);
    if (rel.isEmpty || rel.endsWith('/')) rel = '${rel}index.html';
    if (rel.contains('..')) {
      req.response.statusCode = HttpStatus.forbidden;
      await req.response.close();
      return;
    }
    final file = File('${mount.root.path}/$rel');
    if (file.existsSync()) {
      req.response.headers.contentType = _contentType(rel);
      req.response.headers.set('Access-Control-Allow-Origin', '*');
      await file.openRead().pipe(req.response);
      return;
    }
    // Continue to next mount; the catch-all `/` mount is last.
  }
  req.response.statusCode = HttpStatus.notFound;
  req.response.write('not found: $path');
  await req.response.close();
}

ContentType _contentType(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.html')) return ContentType.html;
  if (lower.endsWith('.css')) return ContentType('text', 'css');
  if (lower.endsWith('.js') || lower.endsWith('.mjs')) {
    return ContentType('application', 'javascript');
  }
  if (lower.endsWith('.json')) return ContentType.json;
  if (lower.endsWith('.png')) return ContentType('image', 'png');
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
    return ContentType('image', 'jpeg');
  }
  if (lower.endsWith('.svg')) return ContentType('image', 'svg+xml');
  if (lower.endsWith('.txt') || lower.endsWith('.md')) {
    return ContentType.text;
  }
  return ContentType.binary;
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
