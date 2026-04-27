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
  testWidgets('LiqSheet renders the configured title', (tester) async {
    await tester.pumpWidget(
      _wrap(const LiqSheet(title: 'Inspector')),
    );
    expect(find.text('Inspector'), findsOneWidget);
  });

  testWidgets('LiqSheet shows a grabber and default top buttons',
      (tester) async {
    await tester.pumpWidget(
      _wrap(const LiqSheet(title: 'Title')),
    );
    expect(find.byType(LiqSheetGrabber), findsOneWidget);
    expect(find.byType(LiqSheetTopButton), findsNWidgets(2));
  });

  testWidgets('LiqSheetTopButton invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqSheetTopButton(
          onPressed: () => taps++,
          child: const Text('×'),
        ),
      ),
    );
    await tester.tap(find.byType(LiqSheetTopButton));
    expect(taps, 1);
  });
}
