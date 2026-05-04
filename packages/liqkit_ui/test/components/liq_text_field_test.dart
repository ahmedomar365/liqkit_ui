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
      expect(find.text('Type here'), findsNothing);
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

    testWidgets('selection gestures belong to EditableText', (tester) async {
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

      expect(
        find.ancestor(
          of: find.byType(EditableText),
          matching: find.byWidgetPredicate(
            (widget) => widget is GestureDetector && widget.onTap != null,
          ),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(
          of: find.byType(EditableText),
          matching: find.byType(Listener),
        ),
        findsOneWidget,
      );
    });
  });
}
