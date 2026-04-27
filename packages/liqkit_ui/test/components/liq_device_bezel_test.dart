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
  testWidgets('LiqDeviceBezel renders with default island', (tester) async {
    await tester.pumpWidget(_wrap(const LiqDeviceBezel(size: Size(220, 480))));
    expect(find.byType(LiqDeviceBezel), findsOneWidget);
  });

  testWidgets('LiqDeviceBezel renders the screen child', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const LiqDeviceBezel(
          size: Size(220, 480),
          showIsland: false,
          child: Center(child: Text('Hello', textDirection: TextDirection.ltr)),
        ),
      ),
    );
    expect(find.text('Hello'), findsOneWidget);
  });
}
