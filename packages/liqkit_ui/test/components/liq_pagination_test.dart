import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Center(child: child),
);

Widget _wrapAtWidth(double width, Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Center(child: SizedBox(width: width, child: child)),
);

void main() {
  group('LiqPagination.visiblePages', () {
    final cases = <({int currentPage, int totalPages, List<dynamic> expected})>[
      (currentPage: 1, totalPages: 1, expected: <dynamic>[1]),
      (currentPage: 3, totalPages: 5, expected: <dynamic>[1, 2, 3, 4, 5]),
      (currentPage: 1, totalPages: 12, expected: <dynamic>[1, 2, 3, '…', 12]),
      (currentPage: 2, totalPages: 12, expected: <dynamic>[1, 2, 3, '…', 12]),
      (
        currentPage: 6,
        totalPages: 12,
        expected: <dynamic>[1, '…', 5, 6, 7, '…', 12],
      ),
      (
        currentPage: 11,
        totalPages: 12,
        expected: <dynamic>[1, '…', 10, 11, 12],
      ),
      (
        currentPage: 12,
        totalPages: 12,
        expected: <dynamic>[1, '…', 10, 11, 12],
      ),
    ];

    for (final c in cases) {
      test('currentPage=${c.currentPage}, totalPages=${c.totalPages}', () {
        expect(
          LiqPagination.visiblePages(c.currentPage, c.totalPages),
          c.expected,
        );
      });
    }
  });

  group('LiqPagination', () {
    testWidgets('renders 5 page-number buttons for totalPages=5', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqPagination(currentPage: 3, totalPages: 5, onPageChanged: (_) {}),
        ),
      );

      for (var i = 1; i <= 5; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
      expect(find.text('…'), findsNothing);
    });

    testWidgets(
      'renders [1, …, 5, 6, 7, …, 12] for currentPage=6, totalPages=12',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            LiqPagination(
              currentPage: 6,
              totalPages: 12,
              onPageChanged: (_) {},
            ),
          ),
        );

        for (final p in <int>[1, 5, 6, 7, 12]) {
          expect(find.text('$p'), findsOneWidget);
        }
        for (final p in <int>[2, 3, 4, 8, 9, 10, 11]) {
          expect(find.text('$p'), findsNothing);
        }
        expect(find.text('…'), findsNWidgets(2));
      },
    );

    testWidgets('tap on a page-number button fires onPageChanged', (
      tester,
    ) async {
      var received = -1;
      await tester.pumpWidget(
        _wrap(
          LiqPagination(
            currentPage: 3,
            totalPages: 5,
            onPageChanged: (p) => received = p,
          ),
        ),
      );

      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();
      expect(received, 4);
    });

    testWidgets('page and chevron buttons keep 44pt tap targets', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapAtWidth(
          400,
          LiqPagination(currentPage: 3, totalPages: 5, onPageChanged: (_) {}),
        ),
      );

      final page = find.ancestor(
        of: find.text('3'),
        matching: find.byType(GestureDetector),
      );
      final previous = find.ancestor(
        of: find.byIcon(LucideIcons.chevronLeft),
        matching: find.byType(GestureDetector),
      );
      final next = find.ancestor(
        of: find.byIcon(LucideIcons.chevronRight),
        matching: find.byType(GestureDetector),
      );

      expect(tester.getSize(page.first), const Size(44, 44));
      expect(tester.getSize(previous.first), const Size(44, 44));
      expect(tester.getSize(next.first), const Size(44, 44));
    });

    testWidgets('expanded mode auto-compacts when width is constrained', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapAtWidth(
          320,
          LiqPagination(currentPage: 6, totalPages: 12, onPageChanged: (_) {}),
        ),
      );

      expect(find.text('6 / 12'), findsOneWidget);
      expect(find.text('…'), findsNothing);
    });

    testWidgets('tap on prev when currentPage=2 fires onPageChanged(1)', (
      tester,
    ) async {
      var received = -1;
      await tester.pumpWidget(
        _wrap(
          LiqPagination(
            currentPage: 2,
            totalPages: 5,
            onPageChanged: (p) => received = p,
          ),
        ),
      );

      await tester.tap(find.byIcon(LucideIcons.chevronLeft));
      await tester.pumpAndSettle();
      expect(received, 1);
    });

    testWidgets(
      'tap on next when currentPage=2, totalPages=5 fires onPageChanged(3)',
      (tester) async {
        var received = -1;
        await tester.pumpWidget(
          _wrap(
            LiqPagination(
              currentPage: 2,
              totalPages: 5,
              onPageChanged: (p) => received = p,
            ),
          ),
        );

        await tester.tap(find.byIcon(LucideIcons.chevronRight));
        await tester.pumpAndSettle();
        expect(received, 3);
      },
    );

    testWidgets('compact mode renders "X / Y"', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqPagination(
            currentPage: 3,
            totalPages: 12,
            compact: true,
            onPageChanged: (_) {},
          ),
        ),
      );

      expect(find.text('3 / 12'), findsOneWidget);
      // Individual page numbers should not appear.
      expect(find.text('1'), findsNothing);
      expect(find.text('12'), findsNothing);
    });

    testWidgets('onPageChanged: null → tap on a page does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const LiqPagination(
            currentPage: 3,
            totalPages: 5,
            onPageChanged: null,
          ),
        ),
      );

      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();
      // No assertion needed — we just expect no exception.
    });

    test('AssertionError: currentPage=0 throws', () {
      expect(
        () =>
            LiqPagination(currentPage: 0, totalPages: 5, onPageChanged: (_) {}),
        throwsAssertionError,
      );
    });

    test('AssertionError: currentPage=6 with totalPages=5 throws', () {
      expect(
        () =>
            LiqPagination(currentPage: 6, totalPages: 5, onPageChanged: (_) {}),
        throwsAssertionError,
      );
    });

    test('AssertionError: totalPages=0 throws', () {
      expect(
        () =>
            LiqPagination(currentPage: 1, totalPages: 0, onPageChanged: (_) {}),
        throwsAssertionError,
      );
    });
  });
}
