import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child, {MediaQueryData media = const MediaQueryData()}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: media,
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

  testWidgets('color picker animations honor reduced motion', (tester) async {
    await tester.pumpWidget(
      _wrap(
        LiqColorPicker(color: const Color(0xFFAF52DE), onChanged: (_) {}),
        media: const MediaQueryData(disableAnimations: true),
      ),
    );

    expect(find.byType(AnimatedSize), findsNothing);
    expect(
      tester
          .widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher).first)
          .duration,
      Duration.zero,
    );

    await tester.tap(find.byType(LiqColorPickerButton));
    await tester.pump();

    expect(
      tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .map((container) => container.duration),
      everyElement(Duration.zero),
    );
  });

  testWidgets('open color picker scrolls instead of overflowing when bounded', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 420);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          height: 360,
          child: LiqColorPicker(color: Color(0xFFAF52DE), onChanged: _noop),
        ),
      ),
    );

    await tester.tap(find.byType(LiqColorPickerButton));
    await tester.pumpAndSettle();

    expect(find.byType(LiqColorPickerPanel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('color picker mode segments remain legible in dark theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      LiqTheme(
        data: LiqThemeData.dark,
        child: _wrap(
          LiqColorPicker(color: const Color(0xFFAF52DE), onChanged: (_) {}),
        ),
      ),
    );

    await tester.tap(find.byType(LiqColorPickerButton));
    await tester.pumpAndSettle();

    final selected = tester.widget<Text>(find.text('Grid'));
    expect(selected.style?.color, const Color(0xFFFFFFFF));
    final inactive = tester.widget<Text>(find.text('Spectrum'));
    expect(inactive.style?.color, const Color(0xB2EBEBF5));
  });

  testWidgets(
    'spectrum taps move the selected color instead of staying centered',
    (tester) async {
      _useLargeViewport(tester);
      var color = const Color(0xFFAF52DE);

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder:
                (context, setState) => LiqColorPickerPanel(
                  color: color,
                  onChanged: (next) => setState(() => color = next),
                ),
          ),
        ),
      );

      await tester.tap(find.text('Spectrum'));
      await tester.pumpAndSettle();

      final spectrum = find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint &&
            widget.painter.runtimeType.toString() == '_SpectrumPainter',
      );
      expect(spectrum, findsOneWidget);

      final rect = tester.getRect(spectrum);
      await tester.tapAt(rect.topLeft + const Offset(20, 40));
      await tester.pump();

      final hsl = HSLColor.fromColor(color);
      expect(hsl.hue, lessThan(30));
      expect(hsl.lightness, greaterThan(0.7));
    },
  );

  testWidgets('RGB sliders commit the tapped position', (tester) async {
    _useLargeViewport(tester);
    var color = const Color(0xFFFF0000);

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder:
              (context, setState) => LiqColorPickerPanel(
                color: color,
                onChanged: (next) => setState(() => color = next),
              ),
        ),
      ),
    );

    await tester.tap(find.text('Sliders'));
    await tester.pumpAndSettle();

    final blueLabel = tester.getCenter(find.text('Blue'));
    final panel = tester.getRect(find.byType(LiqColorPickerPanel));
    await tester.tapAt(Offset(panel.right - 42, blueLabel.dy));
    await tester.pump();

    expect(color.b, greaterThan(0.85));
  });

  testWidgets('opacity slider and percentage field update alpha', (
    tester,
  ) async {
    _useLargeViewport(tester);
    var color = const Color(0xFFFF0000);

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder:
              (context, setState) => LiqColorPickerPanel(
                color: color,
                onChanged: (next) => setState(() => color = next),
              ),
        ),
      ),
    );

    final opacitySlider = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_OpacitySliderPainter',
    );
    expect(opacitySlider, findsOneWidget);

    final rect = tester.getRect(opacitySlider);
    await tester.tapAt(Offset(rect.left + rect.width * 0.25, rect.center.dy));
    await tester.pump();

    expect(color.a, closeTo(0.25, 0.08));

    await tester.tap(find.byType(EditableText));
    await tester.enterText(find.byType(EditableText), '42');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(color.a, closeTo(0.42, 0.01));
  });

  testWidgets('saved swatch plus adds current color to the second page', (
    tester,
  ) async {
    _useLargeViewport(tester);
    var color = const Color(0xFF123456);

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder:
              (context, setState) => LiqColorPickerPanel(
                color: color,
                onChanged: (next) => setState(() => color = next),
              ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is LiqColorDot && widget.color == const Color(0xFF123456),
      ),
      findsNothing,
    );

    final plus = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_PlusPainter',
    );
    expect(plus, findsOneWidget);

    await tester.tap(plus);
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is LiqColorDot && widget.color == const Color(0xFF123456),
      ),
      findsOneWidget,
    );
  });

  testWidgets('saved swatch page dots switch pages', (tester) async {
    _useLargeViewport(tester);
    var color = const Color(0xFF000000);
    const secondPageColor = Color(0xFF123456);

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder:
              (context, setState) => LiqColorPickerPanel(
                color: color,
                savedColors: const <Color>[
                  ...liqDefaultColorPickerColors,
                  secondPageColor,
                ],
                onChanged: (next) => setState(() => color = next),
              ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) => widget is LiqColorDot && widget.color == secondPageColor,
      ),
      findsNothing,
    );

    final dots = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_PageDots',
    );
    expect(dots, findsOneWidget);

    final dotsRect = tester.getRect(dots);
    await tester.tapAt(Offset(dotsRect.center.dx + 11, dotsRect.center.dy));
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is LiqColorDot && widget.color == secondPageColor,
      ),
      findsOneWidget,
    );
  });
}

void _noop(Color color) {}

void _useLargeViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
