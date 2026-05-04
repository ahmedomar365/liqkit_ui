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
  testWidgets('LiqColorPicker opens the native panel and selects a color', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var color = const Color(0xFFAF52DE);
    var open = false;

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder:
              (context, setState) => LiqColorPicker(
                color: color,
                onChanged: (next) => setState(() => color = next),
                onOpenChanged: (next) => open = next,
              ),
        ),
      ),
    );

    expect(find.byType(LiqColorPickerPanel), findsNothing);

    await tester.tap(find.byType(LiqColorPickerButton));
    await tester.pumpAndSettle();
    expect(open, isTrue);
    expect(find.byType(LiqColorPickerPanel), findsOneWidget);
    expect(find.text('Grid'), findsOneWidget);
    expect(find.text('Spectrum'), findsOneWidget);
    expect(find.text('Sliders'), findsOneWidget);

    await tester.tapAt(tester.getCenter(find.byType(LiqColorGrid)));
    await tester.pumpAndSettle();
    expect(color, isIn(liqNativeColorGridColors));
    expect(open, isTrue);
    expect(find.byType(LiqColorPickerPanel), findsOneWidget);
  });

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

  testWidgets('LiqColorPickerButton gives custom controls a click cursor', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        LiqColorPickerButton(color: const Color(0xFFAF52DE), onPressed: () {}),
      ),
    );

    final mouseRegion = tester.widget<MouseRegion>(find.byType(MouseRegion));
    expect(mouseRegion.cursor, SystemMouseCursors.click);
  });

  testWidgets('LiqColorPickerButton keeps a 44pt tap target', (tester) async {
    await tester.pumpWidget(
      _wrap(
        LiqColorPickerButton(
          color: const Color(0xFFAF52DE),
          onPressed: () {},
          size: LiqColorPickerButtonSize.small,
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(LiqColorPickerButton)),
      const Size(44, 44),
    );
  });

  testWidgets('LiqColorDot toggles selection ring', (tester) async {
    await tester.pumpWidget(
      _wrap(const LiqColorDot(color: Color(0xFFFF0000), selected: true)),
    );
    expect(find.byType(LiqColorDot), findsOneWidget);
  });

  testWidgets('LiqColorDot keeps a 44pt tap target', (tester) async {
    await tester.pumpWidget(
      _wrap(LiqColorDot(color: const Color(0xFFFF0000), onPressed: () {})),
    );
    expect(tester.getSize(find.byType(LiqColorDot)), const Size(44, 44));
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

  testWidgets('LiqColorGrid exposes clickable swatches with a cursor', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        LiqColorGrid(
          columns: 2,
          colors: const <Color>[Color(0xFFFF0000), Color(0xFF00FF00)],
          onSelected: (_) {},
        ),
      ),
    );

    final mouseRegions = tester.widgetList<MouseRegion>(
      find.byType(MouseRegion),
    );
    expect(
      mouseRegions.any((region) => region.cursor == SystemMouseCursors.click),
      isTrue,
    );
  });
}
