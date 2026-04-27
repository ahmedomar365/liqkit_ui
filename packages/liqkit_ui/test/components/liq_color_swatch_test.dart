import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqColorSwatch', () {
    testWidgets('renders label and hex caption', (tester) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: LiqColorSwatch(
              label: 'Accents/Blue',
              value: Color(0xFF0091FF),
            ),
          ),
        ),
      );
      expect(find.text('Accents/Blue'), findsOneWidget);
      expect(find.text('#0091FF'), findsOneWidget);
    });

    testWidgets('grid renders one card per canonical color', (tester) async {
      tester.view.physicalSize = const Size(1000, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(width: 1000, child: LiqColorSwatchGrid()),
          ),
        ),
      );
      expect(find.byType(LiqColorSwatch), findsNWidgets(40));
    });
  });
}
