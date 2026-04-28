// CLI tool — print is the intended output mechanism for this script.
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/// Extract a snippet record from raw Dart source.
///
/// Public surface: tested directly by snippet_generator_test.dart.
String extractSnippet({required String sourcePath, required String source}) {
  final lines = source.split('\n');
  final highlights = <Map<String, int>>[];
  int? openLine;
  for (var i = 0; i < lines.length; i++) {
    final t = lines[i].trim();
    if (t == '// {@highlight}') {
      openLine = i + 1; // first highlighted line is the next line
    } else if (t == '// {@endhighlight}') {
      if (openLine == null) {
        throw FormatException(
          '$sourcePath:${i + 1}: orphan {@endhighlight} marker',
        );
      }
      // The end-marker line itself is excluded from the highlight.
      highlights.add({'start': openLine + 1, 'end': i});
      openLine = null;
    }
  }
  if (openLine != null) {
    throw FormatException(
      '$sourcePath: unclosed {@highlight} marker'
      ' (started near line ${openLine + 1})',
    );
  }

  // Strip marker lines from the rendered source so consumers don't see
  // them, then renumber highlight ranges relative to the stripped output.
  final stripped = <String>[];
  final lineMap = <int, int>{}; // original 1-based -> stripped 1-based
  for (var i = 0; i < lines.length; i++) {
    final t = lines[i].trim();
    if (t == '// {@highlight}' || t == '// {@endhighlight}') continue;
    stripped.add(lines[i]);
    lineMap[i + 1] = stripped.length;
  }

  final renumbered =
      highlights
          .map(
            (h) => {
              'start': lineMap[h['start']!] ?? 0,
              'end': lineMap[h['end']!] ?? 0,
            },
          )
          .toList();

  return const JsonEncoder.withIndent('  ').convert({
    'file': sourcePath,
    'language': 'dart',
    'source': stripped.join('\n'),
    'highlights': renumbered,
  });
}

void main(List<String> args) {
  final repoRoot = Directory.current.path;
  final manifestPath = '$repoRoot/tooling/gen/snippet_manifest.json';
  final manifestJson = File(manifestPath).readAsStringSync();
  final manifest = jsonDecode(manifestJson) as Map<String, dynamic>;
  final components =
      (manifest['components'] as List).cast<Map<String, dynamic>>();

  final outputs = <String, String>{};
  for (final c in components) {
    final component = c['component'] as String;
    for (final v in (c['variants'] as List).cast<Map<String, dynamic>>()) {
      final variant = v['variant'] as String;
      final dartFile = v['dartFile'] as String;
      final fullPath = '$repoRoot/$dartFile';
      if (!File(fullPath).existsSync()) {
        stderr.writeln('snippet_manifest.json: $dartFile does not exist');
        exit(1);
      }
      final source = File(fullPath).readAsStringSync();
      final json = extractSnippet(sourcePath: dartFile, source: source);
      outputs['apps/docs/snippets/$component/$variant.json'] = json;
    }
  }

  if (args.contains('--check')) {
    var stale = false;
    for (final entry in outputs.entries) {
      final p = '$repoRoot/${entry.key}';
      if (!File(p).existsSync() || File(p).readAsStringSync() != entry.value) {
        stale = true;
        stderr.writeln('stale: ${entry.key}');
      }
    }
    if (stale) {
      stderr.writeln('Run: melos run docs:gen:snippets');
      exit(1);
    }
    print('snippet JSON up to date (${outputs.length} files)');
    return;
  }

  for (final entry in outputs.entries) {
    final p = '$repoRoot/${entry.key}';
    Directory(File(p).parent.path).createSync(recursive: true);
    File(p).writeAsStringSync(entry.value);
    print('wrote ${entry.key}');
  }
}
