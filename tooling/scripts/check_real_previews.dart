import 'dart:io';

const _scannedRoots = <String>[
  'apps/docs/components',
  'apps/docs/content',
  'apps/docs_snippets/lib',
  'packages/liqkit_ui/lib',
  'README.md',
  'packages/liqkit_ui/README.md',
];

const _ignoredSuffixes = <String>[
  '.g.dart',
  '.json',
  '.png',
  '.jpg',
  '.jpeg',
  '.webp',
  '.gif',
  '.lock',
];

final _blockedPatterns = <_BlockedPattern>[
  _BlockedPattern(
    RegExp('\\b${'fa'}${'ke'}\\b', caseSensitive: false),
    'Do not describe or implement staged preview/glass behavior.',
  ),
  _BlockedPattern(
    RegExp('\\b${'ba'}${'ked'}\\b', caseSensitive: false),
    'Do not bake visual effects into previews or components.',
  ),
  _BlockedPattern(
    RegExp('\\b${'screen'}${'shot'}\\b', caseSensitive: false),
    'Live docs/snippets must render widgets, not captured images.',
  ),
  _BlockedPattern(
    RegExp('\\b${'static'} ${'preview'}\\b', caseSensitive: false),
    'Live previews must not depend on captured preview images.',
  ),
  _BlockedPattern(
    RegExp('\\b${'pre'}${'tend'}\\b', caseSensitive: false),
    'Do not ship staged component behavior.',
  ),
  _BlockedPattern(
    RegExp(
      '\\b(?:${'top'}${'Band'}|${'lower'}${'Base'}|${'white'} ${'band'})\\b',
      caseSensitive: false,
    ),
    'Do not reintroduce staged banded backdrops.',
  ),
];

void main() {
  final repo = _findRepoRoot();
  final findings = <_Finding>[];

  for (final root in _scannedRoots) {
    final entity = FileSystemEntity.typeSync('${repo.path}/$root');
    if (entity == FileSystemEntityType.file) {
      _scanFile(File('${repo.path}/$root'), root, findings);
      continue;
    }
    if (entity == FileSystemEntityType.directory) {
      final directory = Directory('${repo.path}/$root');
      for (final child in directory.listSync(recursive: true)) {
        if (child is File) {
          final rel = child.path.substring(repo.path.length + 1);
          _scanFile(child, rel, findings);
        }
      }
    }
  }

  if (findings.isNotEmpty) {
    stderr.writeln('check_real_previews: blocked source patterns found.');
    for (final finding in findings) {
      stderr.writeln(
        '- ${finding.path}:${finding.line}: ${finding.reason}\n'
        '  ${finding.text.trim()}',
      );
    }
    exit(1);
  }

  stdout.writeln(
    'check_real_previews: ok (${_scannedRoots.length} roots scanned)',
  );
}

void _scanFile(File file, String rel, List<_Finding> findings) {
  if (_ignoredSuffixes.any(rel.endsWith)) return;
  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i += 1) {
    final line = lines[i];
    for (final blocked in _blockedPatterns) {
      if (blocked.regex.hasMatch(line)) {
        findings.add(
          _Finding(path: rel, line: i + 1, text: line, reason: blocked.reason),
        );
      }
    }
  }
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

final class _BlockedPattern {
  const _BlockedPattern(this.regex, this.reason);

  final RegExp regex;
  final String reason;
}

final class _Finding {
  const _Finding({
    required this.path,
    required this.line,
    required this.text,
    required this.reason,
  });

  final String path;
  final int line;
  final String text;
  final String reason;
}
