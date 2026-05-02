import 'dart:io';

void main() {
  final repo = Directory.current;
  final exportsFile = File(
    '${repo.path}/packages/liqkit_ui/lib/components.dart',
  );
  final checklistFile = File(
    '${repo.path}/docs/audits/ios26_component_checklist.md',
  );

  if (!exportsFile.existsSync()) {
    stderr.writeln('Missing ${exportsFile.path}');
    exit(1);
  }
  if (!checklistFile.existsSync()) {
    stderr.writeln('Missing ${checklistFile.path}');
    exit(1);
  }

  final exportLines =
      exportsFile
          .readAsLinesSync()
          .where((line) => line.trim().startsWith('export '))
          .toList();

  final exportedFiles = <String>[];
  for (final line in exportLines) {
    final match = RegExp("'([^']+)'").firstMatch(line);
    if (match != null) {
      exportedFiles.add(match.group(1)!);
    }
  }

  final classes = <String>{};
  for (final exported in exportedFiles) {
    final path = '${repo.path}/packages/liqkit_ui/lib/$exported';
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('Export points to missing file: $exported');
      exit(1);
    }
    final source = file.readAsStringSync();
    for (final match in RegExp(
      r'(?:final\s+)?class\s+(Liq[A-Za-z0-9]+)',
    ).allMatches(source)) {
      classes.add(match.group(1)!);
    }
  }

  final checklist = checklistFile.readAsStringSync();
  final missing =
      classes.where((name) => !checklist.contains('| $name |')).toList()
        ..sort();
  final invalidStatuses = <String>[];
  final rows =
      checklist.split('\n').where((line) => line.startsWith('| Liq')).toList();

  for (final row in rows) {
    final cells = row.split('|').map((cell) => cell.trim()).toList();
    if (cells.length < 14) {
      invalidStatuses.add('Malformed row: $row');
      continue;
    }
    final statuses = <String>[
      cells[5],
      cells[6],
      cells[7],
      cells[8],
      cells[9],
      cells[10],
      cells[11],
      cells[12],
    ];
    for (final status in statuses) {
      if (!status.startsWith('Pass') &&
          !status.startsWith('Fix') &&
          !status.startsWith('Extension') &&
          !status.startsWith('Defer') &&
          !status.startsWith('Pending')) {
        invalidStatuses.add('Invalid status "$status" in row: ${cells[1]}');
      }
    }
  }

  if (missing.isNotEmpty || invalidStatuses.isNotEmpty) {
    if (missing.isNotEmpty) {
      stderr.writeln('Checklist missing exported classes:');
      for (final name in missing) {
        stderr.writeln('- $name');
      }
    }
    if (invalidStatuses.isNotEmpty) {
      stderr.writeln('Checklist status problems:');
      for (final problem in invalidStatuses) {
        stderr.writeln('- $problem');
      }
    }
    exit(1);
  }

  stdout.writeln(
    'Component audit covers ${classes.length} exported Liq classes.',
  );
}
