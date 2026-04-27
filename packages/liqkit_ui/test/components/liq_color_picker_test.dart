import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: SizedBox(width: 360, child: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('LiqColorPickerButton invokes onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LiqColorPickerButton(
          color: const Color(0xFFAF52DE),
          onPressed: () => taps++,
        ),
      ),
    );
    await tester.tap(find.byType(LiqColorPickerButton));
    expect(taps, 1);
  });

  testWidgets('LiqColorDot toggles selection ring', (tester) async {
    await tester.pumpWidget(
      _wrap(const LiqColorDot(color: Color(0xFFFF0000), selected: true)),
    );
    expect(find.byType(LiqColorDot), findsOneWidget);
  });

  testWidgets('LiqColorGrid invokes onSelected with index', (tester) async {
    var lastIndex = -1;
    await tester.pumpWidget(
      _wrap(
        LiqColorGrid(
          columns: 2,
          colors: const <Color>[
            Color(0xFFFF0000),
            Color(0xFF00FF00),
            Color(0xFF0000FF),
            Color(0xFFFFFF00),
          ],
          onSelected: (i) => lastIndex = i,
        ),
      ),
    );
    await tester.tapAt(tester.getCenter(find.byType(LiqColorGrid)));
    expect(lastIndex, anyOf(0, 1, 2, 3));
  });
}
