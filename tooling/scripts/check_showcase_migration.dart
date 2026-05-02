import 'dart:io';

void main(List<String> args) {
  final showcasePath =
      args.isNotEmpty
          ? args.first
          : '/Users/ahmedomar/Documents/delta/liqkit/showcase_published_app_store/figma_design_ios_26/flutter_liquid_ui_kit';
  final showcase = Directory(showcasePath);
  if (!showcase.existsSync()) {
    stderr.writeln('Showcase directory does not exist: $showcasePath');
    exit(1);
  }

  final forbiddenDirs = <String>[
    'lib/components',
    'lib/core/effects',
    'lib/core/theme',
  ];

  final problems = <String>[];
  for (final relative in forbiddenDirs) {
    final dir = Directory('${showcase.path}/$relative');
    if (dir.existsSync()) {
      final dartFiles =
          dir
              .listSync(recursive: true)
              .whereType<File>()
              .where((file) => file.path.endsWith('.dart'))
              .toList();
      if (dartFiles.isNotEmpty) {
        problems.add(
          'Forbidden design-system directory still has Dart files: $relative',
        );
      }
    }
  }

  final dartFiles =
      showcase
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .where((file) => !file.path.contains('/.dart_tool/'))
          .where((file) => !file.path.contains('/build/'))
          .toList();

  for (final file in dartFiles) {
    final source = file.readAsStringSync();
    final relative = file.path.substring(showcase.path.length + 1);
    if (RegExp(r'class\s+Liquid[A-Za-z0-9_]+').hasMatch(source)) {
      problems.add('$relative declares a Liquid* class');
    }
    if (source.contains("import '../components/") ||
        source.contains("import '../../components/") ||
        source.contains("import '../../../components/") ||
        source.contains("import 'components/") ||
        source.contains("import '../core/theme/") ||
        source.contains("import '../../core/theme/") ||
        source.contains("import '../../../core/theme/") ||
        source.contains("import '../core/effects/") ||
        source.contains("import '../../core/effects/") ||
        source.contains("import '../../../core/effects/")) {
      problems.add('$relative imports old showcase design-system code');
    }
  }

  final pubspec = File('${showcase.path}/pubspec.yaml').readAsStringSync();
  if (!pubspec.contains('liqkit_ui:')) {
    problems.add('pubspec.yaml does not declare liqkit_ui dependency');
  }

  if (problems.isNotEmpty) {
    stderr.writeln('Showcase migration guard failed:');
    for (final problem in problems) {
      stderr.writeln('- $problem');
    }
    exit(1);
  }

  stdout.writeln('Showcase migration guard passed for $showcasePath');
}
