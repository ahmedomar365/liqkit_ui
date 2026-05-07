import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (_) => Center(child: SizedBox(width: 480, child: child)),
        ),
      ],
    ),
  ),
);

void main() {
  group('LiqTextarea', () {
    testWidgets('renders the placeholder when value is empty', (tester) async {
      await tester.pumpWidget(
        _wrap(const LiqTextarea(placeholder: 'Tell us what you think')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tell us what you think'), findsOneWidget);
    });

    testWidgets('typing updates the controller and fires onChanged', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? received;
      await tester.pumpWidget(
        _wrap(
          LiqTextarea(controller: controller, onChanged: (v) => received = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'hello');
      await tester.pumpAndSettle();

      expect(controller.text, 'hello');
      expect(received, 'hello');
    });

    testWidgets('minLines: 5 results in a tall enough field', (tester) async {
      await tester.pumpWidget(_wrap(const LiqTextarea(minLines: 5)));
      await tester.pumpAndSettle();

      final size = tester.getSize(find.byType(LiqTextarea));
      // 5 lines * 17 * 1.4 = 119 + 24 padding + 2 border = ~145.
      // Use a conservative lower bound that scales with line count.
      expect(size.height, greaterThan(100));
    });

    testWidgets('maxLines: 3 + long content does not throw', (tester) async {
      final controller = TextEditingController(
        text: 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\nk',
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _wrap(LiqTextarea(controller: controller, minLines: 1, maxLines: 3)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LiqTextarea), findsOneWidget);
    });

    testWidgets('maxLength: 10 truncates input to 10 chars', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _wrap(LiqTextarea(controller: controller, maxLength: 10)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(EditableText),
        'abcdefghijklmnopqrstuvwxyz',
      );
      await tester.pumpAndSettle();

      expect(controller.text.length, 10);
      expect(controller.text, 'abcdefghij');
    });

    testWidgets('showCounter renders "0 / 10" then "5 / 10"', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _wrap(
          LiqTextarea(controller: controller, maxLength: 10, showCounter: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0 / 10'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'hello');
      await tester.pumpAndSettle();

      expect(find.text('5 / 10'), findsOneWidget);
    });

    testWidgets('counter color flips to red at maxLength', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _wrap(
          LiqTextarea(controller: controller, maxLength: 5, showCounter: true),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'hello');
      await tester.pumpAndSettle();

      final counter = tester.widget<Text>(find.text('5 / 5'));
      expect(counter.style?.color, LiqTextarea.counterOverColor);
    });

    testWidgets('uses dark theme colors for surface and text', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(const LiqTextarea(value: 'hello')),
        ),
      );
      await tester.pumpAndSettle();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.style.color, const Color(0xFFFFFFFF));

      final glass = tester.widget<LiqGlassSurface>(
        find.descendant(
          of: find.byType(LiqTextarea),
          matching: find.byType(LiqGlassSurface),
        ),
      );
      expect(glass.baseFill, const Color(0xFF000000));
    });

    testWidgets('uses Cupertino text selection gestures', (tester) async {
      await tester.pumpWidget(_wrap(const LiqTextarea(value: 'hello world')));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoTextField), findsOneWidget);
      expect(find.byType(EditableText), findsOneWidget);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.rendererIgnoresPointer, isTrue);
      expect(editable.enableInteractiveSelection, isTrue);
      expect(editable.selectionControls, isNotNull);
    });

    testWidgets('placeholder is rendered by the platform text field', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const LiqTextarea(placeholder: 'Tell us what you think')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoTextField), findsOneWidget);
      expect(find.text('Tell us what you think'), findsOneWidget);
    });

    test('throws AssertionError when minLines < 1', () {
      expect(() => LiqTextarea(minLines: 0, maxLines: 3), throwsAssertionError);
    });

    test('throws AssertionError when maxLines < minLines', () {
      expect(() => LiqTextarea(minLines: 5, maxLines: 3), throwsAssertionError);
    });
  });
}
