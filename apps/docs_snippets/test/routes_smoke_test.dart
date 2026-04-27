import 'package:docs_snippets/src/routes.g.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  for (final entry in snippetRoutes.entries) {
    testWidgets('snippet route ${entry.key} pumps', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: LiqTheme(
              data: LiqThemeData.light,
              child: Builder(builder: entry.value),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
