import 'dart:io';

Future<void> main() async {
  final temp = await Directory.systemTemp.createTemp('liqkit-real-previews-');
  try {
    await _writeWorkspace(
      temp,
      docsContent: '''
import { LiqPreview } from '@/components/liq-preview';

# Button

<LiqPreview component="button" variant="regular" />
''',
    );

    final pass = await _runAudit(temp);
    if (pass.exitCode != 0) {
      stderr
        ..writeln('Expected live LiqPreview docs content to pass.')
        ..write(pass.stdout)
        ..write(pass.stderr);
      exit(1);
    }

    await _writeWorkspace(
      temp,
      docsContent: '''
# Button

![Button](./button.png)
''',
    );

    final fail = await _runAudit(temp);
    if (fail.exitCode == 0) {
      stderr.writeln('Expected Markdown image docs preview to fail.');
      stdout.write(fail.stdout);
      stderr.write(fail.stderr);
      exit(1);
    }

    stdout.writeln('check_real_previews_self_test: ok');
  } finally {
    await temp.delete(recursive: true);
  }
}

Future<void> _writeWorkspace(
  Directory root, {
  required String docsContent,
}) async {
  await File('${root.path}/pubspec.yaml').writeAsString('''
name: liqkit_ui_workspace
publish_to: none
''');

  await _writeFile(
    root,
    'apps/docs/components/liq-preview.tsx',
    'export function LiqPreview() { return null; }\n',
  );
  await _writeFile(
    root,
    'apps/docs/content/docs/inputs/buttons.mdx',
    docsContent,
  );
  await _writeFile(
    root,
    'apps/docs_snippets/lib/main.dart',
    'void main() {}\n',
  );
  await _writeFile(root, 'packages/liqkit_ui/lib/liqkit_ui.dart', 'library;\n');
  await _writeFile(root, 'README.md', '# liqkit_ui\n');
  await _writeFile(
    root,
    'packages/liqkit_ui/README.md',
    '# liqkit_ui package\n',
  );
}

Future<void> _writeFile(Directory root, String path, String content) async {
  final file = File('${root.path}/$path');
  await file.parent.create(recursive: true);
  await file.writeAsString(content);
}

Future<ProcessResult> _runAudit(Directory root) {
  return Process.run(Platform.resolvedExecutable, [
    'run',
    'tooling/scripts/check_real_previews.dart',
    '--root',
    root.path,
  ]);
}
