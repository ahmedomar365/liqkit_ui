import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  group('LiqTextField', () {
    testWidgets('renders placeholder when empty', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 240,
                child: LiqTextField(
                  controller: controller,
                  placeholder: 'Type here',
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Type here'), findsOneWidget);
    });

    testWidgets('placeholder hides once text is entered', (tester) async {
      final controller = TextEditingController(text: 'hi');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 240,
                child: LiqTextField(
                  controller: controller,
                  placeholder: 'Type here',
                ),
              ),
            ),
          ),
        ),
      );
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, 'hi');
    });

    testWidgets('canonical 52pt height', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 240,
                child: LiqTextField(controller: controller),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(LiqTextField)).height, 52);
    });

    testWidgets('uses centralized pointer selection around EditableText', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'hello world');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 240,
                child: LiqTextField(controller: controller),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Listener), findsAtLeastNWidgets(1));
      expect(find.byType(EditableText), findsOneWidget);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.rendererIgnoresPointer, isTrue);
      expect(editable.enableInteractiveSelection, isTrue);
      expect(editable.selectionControls, isNotNull);
    });

    testWidgets('double-click selects the word under the pointer', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'hello world');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 240,
                child: LiqTextField(controller: controller),
              ),
            ),
          ),
        ),
      );

      final fieldTopLeft = tester.getTopLeft(find.byType(LiqTextField));
      final wordPosition = fieldTopLeft + const Offset(44, 26);
      await tester.tapAt(wordPosition);
      await tester.pump(const Duration(milliseconds: 80));
      await tester.tapAt(wordPosition);
      await tester.pump();

      expect(
        controller.selection,
        const TextSelection(baseOffset: 0, extentOffset: 5),
      );
    });

    testWidgets('mouse drag selects a text range', (tester) async {
      final controller = TextEditingController(text: 'hello world');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 240,
                child: LiqTextField(controller: controller),
              ),
            ),
          ),
        ),
      );

      final fieldTopLeft = tester.getTopLeft(find.byType(LiqTextField));
      final gesture = await tester.startGesture(
        fieldTopLeft + const Offset(18, 26),
        kind: PointerDeviceKind.mouse,
      );
      await gesture.moveTo(fieldTopLeft + const Offset(96, 26));
      await tester.pump();
      await gesture.up();

      expect(controller.selection.isCollapsed, isFalse);
      expect(controller.selection.start, 0);
      expect(controller.selection.end, greaterThan(0));
    });

    testWidgets('placeholder remains visible before editing', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.light,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 240,
                child: LiqTextField(
                  controller: controller,
                  placeholder: 'Type here',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Type here'), findsOneWidget);
    });
  });
}
