import 'package:docs_snippets/src/routes.g.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  for (final entry in snippetRoutes.entries) {
    testWidgets('snippet route ${entry.key} pumps', (tester) async {
      await tester.pumpWidget(_SnippetSmokeShell(builder: entry.value));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('badge status snippet paints visible badges', (tester) async {
    await tester.pumpWidget(
      _SnippetSmokeShell(
        mediaQuery: const MediaQueryData(size: Size(480, 240)),
        builder: snippetRoutes['/badge/status']!,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Draft'), findsOneWidget);
    expect(tester.getSize(find.byType(LiqBadge).first).width, greaterThan(0));
  });
}

class _SnippetSmokeShell extends StatelessWidget {
  const _SnippetSmokeShell({
    required this.builder,
    this.mediaQuery = const MediaQueryData(size: Size(800, 600)),
  });

  final WidgetBuilder builder;
  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: mediaQuery,
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder:
                  (context) => LiqTheme(
                    data: LiqThemeData.light,
                    child: Builder(builder: builder),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
