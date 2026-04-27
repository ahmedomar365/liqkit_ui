import 'dart:convert';
import 'package:test/test.dart';
import '../main.dart' show extractSnippet;

void main() {
  test('extractSnippet collects highlight markers and source', () {
    const source = '''
import 'package:flutter/widgets.dart';

Widget sampleBuilder() {
  // {@highlight}
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text('hello'),
  );
  // {@endhighlight}
}
''';

    final json = extractSnippet(
      sourcePath: 'apps/docs_snippets/lib/snippets/button/regular.dart',
      source: source,
    );
    final decoded = jsonDecode(json) as Map<String, dynamic>;

    expect(decoded['language'], 'dart');
    expect(decoded['file'],
        'apps/docs_snippets/lib/snippets/button/regular.dart');
    expect(decoded['source'], contains("Text('hello')"));
    final highlights = (decoded['highlights'] as List)
        .cast<Map<String, dynamic>>();
    expect(highlights, hasLength(1));
    final start = highlights.single['start'] as int;
    final end = highlights.single['end'] as int;
    expect(start, greaterThan(0));
    expect(end, greaterThan(start));
  });
}
