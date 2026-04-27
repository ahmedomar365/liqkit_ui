import 'package:test/test.dart';
import '../gen_snippet_routes.dart';

void main() {
  group('renderDartRoutes', () {
    test('emits a Map<String, WidgetBuilder> for one component variant',
        () {
      const fixture = '''
{
  "components": [
    {
      "component": "button",
      "displayName": "Buttons",
      "group": "inputs",
      "variants": [
        {
          "variant": "regular",
          "displayName": "Regular",
          "dartFile": "apps/docs_snippets/lib/snippets/button/regular.dart"
        }
      ]
    }
  ]
}
''';
      final out = renderDartRoutes(fixture);
      expect(out, contains("import 'package:docs_snippets/snippets/button/regular.dart'"));
      expect(out, contains("'/button/regular':"));
      expect(out, contains('buttonRegularBuilder'));
    });
  });

  group('renderTsRoutes', () {
    test('emits a TS const map keyed by component-variant', () {
      const fixture = '''
{
  "components": [
    {
      "component": "button",
      "displayName": "Buttons",
      "group": "inputs",
      "variants": [
        {
          "variant": "regular",
          "displayName": "Regular",
          "dartFile": "apps/docs_snippets/lib/snippets/button/regular.dart"
        }
      ]
    }
  ]
}
''';
      final out = renderTsRoutes(fixture);
      expect(out, contains('export const SNIPPET_ROUTES'));
      expect(out, contains("'button/regular'"));
      expect(out, contains("path: '/button/regular'"));
    });
  });
}
