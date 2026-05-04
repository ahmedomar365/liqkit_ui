import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqTopBar', () {
    testWidgets('renders title centered', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(width: 360, child: LiqTopBar(title: 'Settings')),
            ),
          ),
        ),
      );
      expect(find.text('Settings'), findsOneWidget);
      expect(tester.getSize(find.byType(LiqTopBar)).height, 44);
    });

    testWidgets('large title adds a second row', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 360,
                child: LiqTopBar(title: 'Inbox', largeTitle: 'Inbox'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Inbox'), findsNWidgets(2));
      expect(tester.getSize(find.byType(LiqTopBar)).height, greaterThan(44));
    });

    testWidgets('symbol button taps fire', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 360,
              child: LiqTopBar(
                title: 'Title',
                leading: LiqTopBarSymbolButton(
                  glyph: '‹',
                  onPressed: () => taps += 1,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(LiqTopBarSymbolButton));
      expect(taps, 1);
    });

    testWidgets('accent button keeps a 44pt tap target', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: LiqTopBarAccentButton(glyph: '+', onPressed: () {}),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(LiqTopBarAccentButton)),
        const Size(44, 44),
      );

      final pill = tester.widget<Container>(find.byType(Container));
      expect(pill.constraints?.maxWidth, 36);
      expect(pill.constraints?.maxHeight, 36);
    });
  });
}
