import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: SizedBox(width: 360, child: Center(child: child)),
      ),
    ),
  );
}

Widget _wrapDark(Widget child) {
  return LiqTheme(
    data: LiqThemeData.dark,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: SizedBox(width: 360, child: Center(child: child)),
      ),
    ),
  );
}

void main() {
  testWidgets('LiqEmptyState renders title + description', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqEmptyState(
          title: 'No Messages',
          description: 'Your inbox is empty.',
        ),
      ),
    );
    expect(find.text('No Messages'), findsOneWidget);
    expect(find.text('Your inbox is empty.'), findsOneWidget);
  });

  testWidgets('LiqEmptyStateCta invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqEmptyState(
          title: 'X',
          cta: LiqEmptyStateCta(label: 'Compose', onPressed: () => taps++),
        ),
      ),
    );
    await tester.tap(find.text('Compose'));
    expect(taps, 1);
  });

  testWidgets('LiqEmptyStateCta exposes a click cursor when tappable', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        LiqEmptyState(
          title: 'X',
          cta: LiqEmptyStateCta(label: 'Compose', onPressed: () {}),
        ),
      ),
    );

    final mouseRegion = tester.widget<MouseRegion>(find.byType(MouseRegion));
    expect(mouseRegion.cursor, SystemMouseCursors.click);
  });

  testWidgets('LiqEmptyState resolves text and CTA colors from dark theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrapDark(
        LiqEmptyState(
          title: 'No Messages',
          description: 'Your inbox is empty.',
          cta: LiqEmptyStateCta(label: 'Compose', onPressed: () {}),
        ),
      ),
    );

    final title = tester.widget<Text>(find.text('No Messages'));
    expect(title.style?.color, const Color(0xFFFFFFFF));

    final description = tester.widget<Text>(find.text('Your inbox is empty.'));
    expect(description.style?.color, const Color(0xB2EBEBF5));

    final ctaContainer = tester.widget<Container>(
      find
          .ancestor(of: find.text('Compose'), matching: find.byType(Container))
          .first,
    );
    final decoration = ctaContainer.decoration! as BoxDecoration;
    expect(decoration.color, const Color(0xFF0091FF));
  });
}
