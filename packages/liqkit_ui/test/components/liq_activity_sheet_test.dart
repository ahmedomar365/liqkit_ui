import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

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
  testWidgets('LiqActivityHeader renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqActivitySheet(
          header: LiqActivityHeader(title: 'Document.pdf', subtitle: '2.4 MB'),
        ),
      ),
    );
    expect(find.text('Document.pdf'), findsOneWidget);
    expect(find.text('2.4 MB'), findsOneWidget);
  });

  testWidgets('LiqActivityHeader close invokes onClose', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqActivitySheet(
          header: LiqActivityHeader(title: 'X', onClose: () => taps++),
        ),
      ),
    );
    await tester.tap(find.bySemanticsLabel('Close'));
    expect(taps, 1);
  });

  testWidgets('LiqActivityHeader close keeps a 44pt tap target', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        LiqActivitySheet(header: LiqActivityHeader(title: 'X', onClose: () {})),
      ),
    );

    expect(tester.getSize(find.bySemanticsLabel('Close')), const Size(44, 44));

    final closeCircle = tester.widget<Container>(
      find.descendant(
        of: find.bySemanticsLabel('Close'),
        matching: find.byType(Container),
      ),
    );
    expect(closeCircle.constraints?.maxWidth, 36);
    expect(closeCircle.constraints?.maxHeight, 36);
  });
}
