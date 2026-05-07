import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const List<LiqBottomNavItem> _fourItems = <LiqBottomNavItem>[
  LiqBottomNavItem(icon: LucideIcons.house, label: 'Home'),
  LiqBottomNavItem(icon: LucideIcons.search, label: 'Search'),
  LiqBottomNavItem(icon: LucideIcons.bell, label: 'Inbox'),
  LiqBottomNavItem(icon: LucideIcons.user, label: 'Profile'),
];

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Align(alignment: Alignment.bottomCenter, child: child),
  ),
);

Widget _wrapDark(Widget child) =>
    LiqTheme(data: LiqThemeData.dark, child: _wrap(child));

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

      final activeIcon = tester.widget<Icon>(find.byIcon(LucideIcons.bell));
      expect(activeIcon.color, LiqBottomNavBar.activeColor);

      final activeLabel = tester.widget<Text>(find.text('Inbox'));
      expect(activeLabel.style?.color, LiqBottomNavBar.activeColor);

      final inactiveIcon = tester.widget<Icon>(find.byIcon(LucideIcons.house));
      expect(inactiveIcon.color, const Color(0xFF1A1A1A));

      final inactiveLabel = tester.widget<Text>(find.text('Home'));
      expect(inactiveLabel.style?.color, const Color(0xFF1A1A1A));
    });

    testWidgets('dark theme uses iOS 26 dark active and secondary tints', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapDark(
          LiqBottomNavBar(
            items: _fourItems,
            currentIndex: 2,
            onChanged: (_) {},
          ),
        ),
      );

      const darkActive = Color(0xFF0091FF);
      const darkInactive = Color(0xE6F5F5F5);

      final activeIcon = tester.widget<Icon>(find.byIcon(LucideIcons.bell));
      expect(activeIcon.color, darkActive);

      final activeLabel = tester.widget<Text>(find.text('Inbox'));
      expect(activeLabel.style?.color, darkActive);

      final inactiveIcon = tester.widget<Icon>(find.byIcon(LucideIcons.house));
      expect(inactiveIcon.color, darkInactive);

      final inactiveLabel = tester.widget<Text>(find.text('Home'));
      expect(inactiveLabel.style?.color, darkInactive);
    });

    testWidgets('uses an inset rounded Liquid Glass capsule', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqBottomNavBar(
            items: _fourItems,
            currentIndex: 0,
            onChanged: (_) {},
          ),
        ),
      );

      final glass = tester.widget<LiqGlassSurface>(
        find.byType(LiqGlassSurface),
      );
      expect(glass.borderRadius, const BorderRadius.all(Radius.circular(999)));
      expect(glass.blurSigma, 20);
      expect(glass.baseFill, isNull);
      expect(glass.highlightStart, isNull);
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

    testWidgets('dragging across tabs previews and commits the released tab', (
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

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Home')),
      );
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.text('Inbox')));
      await tester.pump();

      expect(lastIndex, -1);
      final previewIcon = tester.widget<Icon>(find.byIcon(LucideIcons.bell));
      expect(previewIcon.color, LiqBottomNavBar.activeColor);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(lastIndex, 2);
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
            LiqBottomNavItem(icon: LucideIcons.house, label: 'Only'),
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
            LiqBottomNavItem(icon: LucideIcons.house, label: 'A'),
            LiqBottomNavItem(icon: LucideIcons.house, label: 'B'),
            LiqBottomNavItem(icon: LucideIcons.house, label: 'C'),
            LiqBottomNavItem(icon: LucideIcons.house, label: 'D'),
            LiqBottomNavItem(icon: LucideIcons.house, label: 'E'),
            LiqBottomNavItem(icon: LucideIcons.house, label: 'F'),
          ],
          currentIndex: 0,
          onChanged: (_) {},
        ),
        throwsAssertionError,
      );
    });
  });
}
