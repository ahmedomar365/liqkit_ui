import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: SizedBox(width: 360, child: child)),
    ),
  );
}

const _items = <LiqTabItem>[
  LiqTabItem(label: 'Overview'),
  LiqTabItem(label: 'Comments'),
  LiqTabItem(label: 'History'),
];

void main() {
  group('LiqTabs', () {
    testWidgets('tap on tab 1 fires onChanged(1)', (tester) async {
      var index = 0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder:
              (context, setState) => _wrap(
                LiqTabs(
                  items: _items,
                  selectedIndex: index,
                  onChanged: (i) => setState(() => index = i),
                ),
              ),
        ),
      );
      await tester.tap(find.text('Comments'));
      await tester.pumpAndSettle();
      expect(index, 1);
    });

    testWidgets('selectedIndex=2 then tap on tab 0 fires onChanged(0)', (
      tester,
    ) async {
      var index = 2;
      await tester.pumpWidget(
        StatefulBuilder(
          builder:
              (context, setState) => _wrap(
                LiqTabs(
                  items: _items,
                  selectedIndex: index,
                  onChanged: (i) => setState(() => index = i),
                ),
              ),
        ),
      );
      await tester.tap(find.text('Overview'));
      await tester.pumpAndSettle();
      expect(index, 0);
    });

    testWidgets('onChanged == null → tap does nothing', (tester) async {
      await tester.pumpWidget(
        _wrap(const LiqTabs(items: _items, selectedIndex: 0, onChanged: null)),
      );
      // Tapping should not throw, even with no callback.
      await tester.tap(find.text('Comments'));
      await tester.pumpAndSettle();
    });

    testWidgets('underline variant: an underline indicator widget exists', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(LiqTabs(items: _items, selectedIndex: 0, onChanged: (_) {})),
      );
      // The underline DecoratedBox uses LiqTabs.activeColor as a solid fill.
      final hasUnderline = find.byWidgetPredicate((w) {
        if (w is DecoratedBox) {
          final d = w.decoration;
          if (d is BoxDecoration && d.color == LiqTabs.activeColor) return true;
        }
        return false;
      });
      expect(hasUnderline, findsWidgets);
    });

    testWidgets('pill variant: an animated pill background exists', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqTabs(
            variant: LiqTabsVariant.pill,
            items: _items,
            selectedIndex: 1,
            onChanged: (_) {},
          ),
        ),
      );
      // The pill highlight is an AnimatedAlign moving the white pill.
      expect(find.byType(AnimatedAlign), findsWidgets);
      // And the highlight DecoratedBox uses pillHighlightColor.
      final hasPill = find.byWidgetPredicate((w) {
        if (w is DecoratedBox) {
          final d = w.decoration;
          if (d is BoxDecoration && d.color == LiqTabs.pillHighlightColor) {
            return true;
          }
        }
        return false;
      });
      expect(hasPill, findsWidgets);
    });

    testWidgets('renders 3 LiqTabItem labels', (tester) async {
      await tester.pumpWidget(
        _wrap(LiqTabs(items: _items, selectedIndex: 0, onChanged: (_) {})),
      );
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Comments'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
    });
  });
}
