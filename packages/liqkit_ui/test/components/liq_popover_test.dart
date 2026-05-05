import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';
import 'package:liqkit_ui/liqkit_ui.dart'
    show LiqGlassSurface, LiqTheme, LiqThemeData;

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(child: child),
    ),
  );
}

void main() {
  testWidgets('LiqPopover renders its child', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqPopover(
          child: Text('Hello', textDirection: TextDirection.ltr),
        ),
      ),
    );
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('LiqPopover supports all four sides', (tester) async {
    for (final side in LiqPopoverSide.values) {
      await tester.pumpWidget(
        _wrap(
          LiqPopover(
            side: side,
            child: const Text('x', textDirection: TextDirection.ltr),
          ),
        ),
      );
      expect(find.text('x'), findsOneWidget);
    }
  });

  testWidgets('LiqPopover renders bubble through LiqGlassSurface', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const LiqPopover(
          child: Text('Glass', textDirection: TextDirection.ltr),
        ),
      ),
    );

    expect(find.byType(LiqGlassSurface), findsOneWidget);
  });

  testWidgets('dark popover gives child a light default text color', (
    tester,
  ) async {
    await tester.pumpWidget(
      LiqTheme(
        data: LiqThemeData.dark,
        child: _wrap(
          const LiqPopover(
            child: Text('Dark popover', textDirection: TextDirection.ltr),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Dark popover'));
    expect(text.style?.color, isNull);
    final defaultStyle = tester.widget<DefaultTextStyle>(
      find
          .ancestor(
            of: find.text('Dark popover'),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(defaultStyle.style.color, const Color(0xFFFFFFFF));
  });
}
