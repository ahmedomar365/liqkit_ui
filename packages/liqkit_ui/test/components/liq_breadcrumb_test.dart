import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Center(child: child),
);

Widget _wrapDark(Widget child) => LiqTheme(
  data: LiqThemeData.dark,
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: child),
  ),
);

void main() {
  group('LiqBreadcrumb', () {
    testWidgets('renders every item label as Text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqBreadcrumb(
            items: <LiqBreadcrumbItem>[
              LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
              LiqBreadcrumbItem(label: 'Library', onPressed: () {}),
              const LiqBreadcrumbItem(label: 'Components'),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Components'), findsOneWidget);
    });

    testWidgets('tap on a non-last crumb fires its onPressed', (tester) async {
      var libraryTapped = 0;
      await tester.pumpWidget(
        _wrap(
          LiqBreadcrumb(
            items: <LiqBreadcrumbItem>[
              LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
              LiqBreadcrumbItem(
                label: 'Library',
                onPressed: () => libraryTapped++,
              ),
              const LiqBreadcrumbItem(label: 'Components'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();
      expect(libraryTapped, 1);
    });

    testWidgets('tappable crumbs keep a 44pt tap target', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqBreadcrumb(
            items: <LiqBreadcrumbItem>[
              LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
              const LiqBreadcrumbItem(label: 'Current'),
            ],
          ),
        ),
      );

      final target = find.ancestor(
        of: find.text('Home'),
        matching: find.byType(GestureDetector),
      );
      expect(tester.getSize(target.first).height, 44);
    });

    testWidgets('crumbs stay on one line when width is available', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqBreadcrumb(
            items: <LiqBreadcrumbItem>[
              LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
              LiqBreadcrumbItem(label: 'Library', onPressed: () {}),
              LiqBreadcrumbItem(label: 'Components', onPressed: () {}),
              const LiqBreadcrumbItem(label: 'Breadcrumb'),
            ],
          ),
        ),
      );

      final y = tester.getTopLeft(find.text('Home')).dy;
      expect(tester.getTopLeft(find.text('Library')).dy, y);
      expect(tester.getTopLeft(find.text('Components')).dy, y);
      expect(tester.getTopLeft(find.text('Breadcrumb')).dy, y);
    });

    testWidgets("last crumb's text is rendered in semibold (w600)", (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqBreadcrumb(
            items: <LiqBreadcrumbItem>[
              LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
              const LiqBreadcrumbItem(label: 'Current'),
            ],
          ),
        ),
      );

      final lastText = tester.widget<Text>(find.text('Current'));
      expect(lastText.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('dark theme resolves active, inactive, and separator colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapDark(
          LiqBreadcrumb(
            items: <LiqBreadcrumbItem>[
              LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
              const LiqBreadcrumbItem(label: 'Current'),
            ],
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Home')).style?.color,
        LiqBreadcrumb.darkActiveColor,
      );
      expect(
        tester.widget<Text>(find.text('Current')).style?.color,
        LiqBreadcrumb.darkInactiveColor,
      );
      expect(
        tester.widget<Text>(find.text('/')).style?.color,
        LiqBreadcrumb.darkSeparatorColor,
      );
    });

    testWidgets('items with onPressed: null are non-tappable', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqBreadcrumb(
            items: <LiqBreadcrumbItem>[
              LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
              const LiqBreadcrumbItem(label: 'Static'),
              const LiqBreadcrumbItem(label: 'Current'),
            ],
          ),
        ),
      );

      // The static and current crumbs should not be wrapped in a
      // GestureDetector — the only GestureDetector should be the one
      // wrapping the Home crumb.
      final detectors = tester.widgetList<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(detectors.length, 1);

      // Confirm the GestureDetector wraps the 'Home' Text.
      final homeDetector = find.ancestor(
        of: find.text('Home'),
        matching: find.byType(GestureDetector),
      );
      expect(homeDetector, findsOneWidget);

      // 'Static' and 'Current' are not under any GestureDetector.
      expect(
        find.ancestor(
          of: find.text('Static'),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(
          of: find.text('Current'),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });

    testWidgets('custom separator renders items.length - 1 times', (
      tester,
    ) async {
      const separatorIcon = IconData(0xe5cc, fontFamily: 'MaterialIcons');
      await tester.pumpWidget(
        _wrap(
          LiqBreadcrumb(
            separator: const Icon(
              separatorIcon,
              size: 14,
              color: Color(0xFFC7C7CC),
            ),
            items: <LiqBreadcrumbItem>[
              LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
              LiqBreadcrumbItem(label: 'Library', onPressed: () {}),
              LiqBreadcrumbItem(label: 'Components', onPressed: () {}),
              const LiqBreadcrumbItem(label: 'Breadcrumb'),
            ],
          ),
        ),
      );

      // 4 items → 3 separators between them.
      expect(find.byIcon(separatorIcon), findsNWidgets(3));
    });
  });
}
