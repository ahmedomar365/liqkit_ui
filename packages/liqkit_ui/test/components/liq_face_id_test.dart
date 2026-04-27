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
  testWidgets('LiqFaceIdBezel renders for all states', (tester) async {
    for (final state in LiqFaceIdState.values) {
      await tester.pumpWidget(_wrap(LiqFaceIdBezel(state: state, size: 100)));
      expect(find.byType(LiqFaceIdBezel), findsOneWidget);
    }
  });
}
