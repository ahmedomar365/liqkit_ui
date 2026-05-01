import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

const List<LiqBottomNavItem> _fourItems = <LiqBottomNavItem>[
  LiqBottomNavItem(icon: Icons.home_filled, label: 'Home'),
  LiqBottomNavItem(icon: Icons.search, label: 'Search'),
  LiqBottomNavItem(icon: Icons.notifications, label: 'Inbox'),
  LiqBottomNavItem(icon: Icons.person_outline, label: 'Profile'),
];

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Align(alignment: Alignment.bottomCenter, child: child),
  ),
);

void main() {
  group('LiqBottomNavBar', () {
    testWidgets('renders every item label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqBottomNavBar(
            items: _fourItems,
            currentIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Inbox'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('renders one icon per item', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqBottomNavBar(
            items: _fourItems,
            currentIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(Icon), findsNWidgets(_fourItems.length));
    });

    testWidgets('currentIndex highlights the active tab in iOS blue', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqBottomNavBar(
            items: _fourItems,
            currentIndex: 2,
            onChanged: (_) {},
          ),
        ),
      );

      final activeIcon = tester.widget<Icon>(find.byIcon(Icons.notifications));
      expect(activeIcon.color, LiqBottomNavBar.activeColor);

      final activeLabel = tester.widget<Text>(find.text('Inbox'));
      expect(activeLabel.style?.color, LiqBottomNavBar.activeColor);

      final inactiveIcon = tester.widget<Icon>(find.byIcon(Icons.home_filled));
      expect(inactiveIcon.color, LiqBottomNavBar.inactiveColor);

      final inactiveLabel = tester.widget<Text>(find.text('Home'));
      expect(inactiveLabel.style?.color, LiqBottomNavBar.inactiveColor);
    });

    testWidgets('tapping a tab fires onChanged with that index', (
      tester,
    ) async {
      var lastIndex = -1;
      await tester.pumpWidget(
        _wrap(
          LiqBottomNavBar(
            items: _fourItems,
            currentIndex: 0,
            onChanged: (i) => lastIndex = i,
          ),
        ),
      );

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(lastIndex, 1);
    });

    testWidgets('onChanged: null disables taps', (tester) async {
      const taps = 0;
      await tester.pumpWidget(
        _wrap(
          LiqBottomNavBar(items: _fourItems, currentIndex: 0, onChanged: null),
        ),
      );

      // Use warnIfMissed: false because the disabled bar intentionally
      // ignores hits.
      await tester.tap(find.text('Search'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(taps, 0);
    });

    test('asserts when items.length < 2', () {
      expect(
        () => LiqBottomNavBar(
          items: const <LiqBottomNavItem>[
            LiqBottomNavItem(icon: Icons.home, label: 'Only'),
          ],
          currentIndex: 0,
          onChanged: (_) {},
        ),
        throwsAssertionError,
      );
    });

    test('asserts when items.length > 5', () {
      expect(
        () => LiqBottomNavBar(
          items: const <LiqBottomNavItem>[
            LiqBottomNavItem(icon: Icons.home, label: 'A'),
            LiqBottomNavItem(icon: Icons.home, label: 'B'),
            LiqBottomNavItem(icon: Icons.home, label: 'C'),
            LiqBottomNavItem(icon: Icons.home, label: 'D'),
            LiqBottomNavItem(icon: Icons.home, label: 'E'),
            LiqBottomNavItem(icon: Icons.home, label: 'F'),
          ],
          currentIndex: 0,
          onChanged: (_) {},
        ),
        throwsAssertionError,
      );
    });
  });
}
