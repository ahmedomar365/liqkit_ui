import 'dart:convert';
import 'dart:io';

void main() {
  final repo = _findRepoRoot();
  final manifestFile = File(
    '${repo.path}/apps/docs/public/showcase/manifest.json',
  );
  final readmeFile = File('${repo.path}/README.md');
  final snippetManifestFile = File(
    '${repo.path}/tooling/gen/snippet_manifest.json',
  );

  final entries = _readShowcaseManifest(manifestFile);
  final readmePaths = _readReadmeShowcasePaths(readmeFile);
  final snippetRoutes = _readSnippetRoutes(snippetManifestFile);
  final problems = <String>[];

  for (final path in readmePaths) {
    final entry = entries[path];
    if (entry == null) {
      problems.add(
        '$path is used in README.md but missing from showcase manifest.',
      );
      continue;
    }
    final image = File('${repo.path}/$path');
    if (!image.existsSync()) {
      problems.add('$path is declared but the file does not exist.');
    } else {
      final dimensions = _readPngDimensions(image);
      if (dimensions == null) {
        problems.add('$path is not a readable PNG image.');
      } else if (dimensions.width != entry.width ||
          dimensions.height != entry.height) {
        problems.add(
          '$path is ${dimensions.width}x${dimensions.height}; '
          'expected ${entry.width}x${entry.height}.',
        );
      }
    }
    final route = '${entry.component}/${entry.variant}';
    if (!snippetRoutes.contains(route)) {
      problems.add('$path points to missing snippet route $route.');
    }
    final expectedRoute = '/${entry.component}/${entry.variant}';
    if (entry.route != expectedRoute) {
      problems.add('$path has route ${entry.route}; expected $expectedRoute.');
    }
  }

  for (final path in entries.keys) {
    if (!readmePaths.contains(path)) {
      problems.add(
        '$path is declared in showcase manifest but not used in README.md.',
      );
    }
  }

  if (problems.isNotEmpty) {
    stderr.writeln('check_showcase_preview_provenance: problems found.');
    for (final problem in problems) {
      stderr.writeln('- $problem');
    }
    exit(1);
  }

  stdout.writeln(
    'check_showcase_preview_provenance: ok (${entries.length} previews)',
  );
}

Map<String, _ShowcasePreview> _readShowcaseManifest(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! List<Object?>) {
    throw const FormatException('Showcase manifest must be a list.');
  }
  return {
    for (final item in decoded)
      if (item is Map<String, Object?>)
        _requiredString(item, 'path'): _ShowcasePreview(
          path: _requiredString(item, 'path'),
          component: _requiredString(item, 'component'),
          variant: _requiredString(item, 'variant'),
          route: _requiredString(item, 'route'),
          width: _requiredInt(item, 'width'),
          height: _requiredInt(item, 'height'),
        ),
  };
}

Set<String> _readReadmeShowcasePaths(File file) {
  final paths = <String>{};
  final pattern = RegExp(r'\[[^\]]+\]\((apps/docs/public/showcase/[^)]+)\)');
  for (final match in pattern.allMatches(file.readAsStringSync())) {
    paths.add(match.group(1)!);
  }
  return paths;
}

Set<String> _readSnippetRoutes(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  final components =
      decoded is Map<String, Object?> ? decoded['components'] : decoded;
  if (components is! List<Object?>) {
    throw const FormatException('Snippet manifest must include components.');
  }
  final routes = <String>{};
  for (final item in components) {
    if (item case {
      'component': final String component,
      'variants': final List<Object?> variants,
    }) {
      for (final variantItem in variants) {
        if (variantItem case {'variant': final String variant}) {
          routes.add('$component/$variant');
        }
      }
    }
  }
  return routes;
}

String _requiredString(Map<String, Object?> item, String key) {
  final value = item[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw FormatException('Showcase manifest entry is missing "$key".');
}

int _requiredInt(Map<String, Object?> item, String key) {
  final value = item[key];
  if (value is int && value > 0) {
    return value;
  }
  throw FormatException('Showcase manifest entry is missing "$key".');
}

_PngDimensions? _readPngDimensions(File file) {
  final bytes = file.readAsBytesSync();
  if (bytes.length < 24) {
    return null;
  }
  const signature = <int>[137, 80, 78, 71, 13, 10, 26, 10];
  for (var i = 0; i < signature.length; i++) {
    if (bytes[i] != signature[i]) {
      return null;
    }
  }

  int uint32(int offset) =>
      (bytes[offset] << 24) |
      (bytes[offset + 1] << 16) |
      (bytes[offset + 2] << 8) |
      bytes[offset + 3];

  return _PngDimensions(width: uint32(16), height: uint32(20));
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

final class _ShowcasePreview {
  const _ShowcasePreview({
    required this.path,
    required this.component,
    required this.variant,
    required this.route,
    required this.width,
    required this.height,
  });

  final String path;
  final String component;
  final String variant;
  final String route;
  final int width;
  final int height;
}

final class _PngDimensions {
  const _PngDimensions({required this.width, required this.height});

  final int width;
  final int height;
}
