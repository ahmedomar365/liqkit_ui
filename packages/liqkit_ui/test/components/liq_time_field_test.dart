import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Center(child: SizedBox(width: 320, child: child)),
  ),
);

void main() {
  group('LiqTimeField', () {
    testWidgets('renders the placeholder when value is null', (tester) async {
      await tester.pumpWidget(
        _wrap(LiqTimeField(value: null, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();
      expect(find.text('HH:MM AM'), findsOneWidget);
    });

    testWidgets('renders 14:32 in 24h mode', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqTimeField(
            value: const LiqTime(hour: 14, minute: 32),
            use24HourFormat: true,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      final ed = tester.widget<EditableText>(find.byType(EditableText));
      expect(ed.controller.text, '14:32');
    });

    testWidgets('renders 2:32 + PM segment active in 12h mode', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqTimeField(
            value: const LiqTime(hour: 14, minute: 32),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      final ed = tester.widget<EditableText>(find.byType(EditableText));
      expect(ed.controller.text, '2:32');

      // Both AM and PM render; the PM cell carries the active shadow.
      expect(find.text('AM'), findsOneWidget);
      expect(find.text('PM'), findsOneWidget);

      final pmContainer = tester.widget<Container>(
        find
            .ancestor(of: find.text('PM'), matching: find.byType(Container))
            .first,
      );
      final decoration = pmContainer.decoration! as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.isNotEmpty, isTrue);
    });

    testWidgets('AM/PM cells fill the bordered field interior', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqTimeField(
            value: const LiqTime(hour: 14, minute: 32),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final label in <String>['AM', 'PM']) {
        final cell = find.ancestor(
          of: find.text(label),
          matching: find.byType(GestureDetector),
        );
        expect(tester.getSize(cell.first).height, 42);
      }
    });

    testWidgets('typing 1432 auto-inserts colon and fires onChanged in 24h', (
      tester,
    ) async {
      LiqTime? received;
      await tester.pumpWidget(
        _wrap(
          LiqTimeField(
            value: null,
            use24HourFormat: true,
            onChanged: (v) => received = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), '1432');
      await tester.pumpAndSettle();

      expect(received, const LiqTime(hour: 14, minute: 32));
      final ed = tester.widget<EditableText>(find.byType(EditableText));
      expect(ed.controller.text, '14:32');
    });

    testWidgets('invalid input 25:99 does not fire onChanged', (tester) async {
      var validFires = 0;
      LiqTime? received;
      await tester.pumpWidget(
        _wrap(
          LiqTimeField(
            value: null,
            use24HourFormat: true,
            onChanged: (v) {
              if (v != null) {
                validFires += 1;
                received = v;
              }
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), '25:99');
      await tester.pumpAndSettle();

      expect(received, isNull);
      expect(validFires, 0);
    });

    testWidgets('empty input fires onChanged(null)', (tester) async {
      LiqTime? received = const LiqTime(hour: 1, minute: 1);
      var fired = 0;
      await tester.pumpWidget(
        _wrap(
          LiqTimeField(
            value: const LiqTime(hour: 14, minute: 32),
            use24HourFormat: true,
            onChanged: (v) {
              fired += 1;
              received = v;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), '');
      await tester.pumpAndSettle();

      expect(fired, greaterThanOrEqualTo(1));
      expect(received, isNull);
    });

    testWidgets('uses dark theme colors for field text and surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            LiqTimeField(
              value: const LiqTime(hour: 14, minute: 32),
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.style.color, const Color(0xFFFFFFFF));

      final decorations =
          tester
              .widgetList<Container>(
                find.descendant(
                  of: find.byType(LiqTimeField),
                  matching: find.byWidgetPredicate(
                    (widget) =>
                        widget is Container &&
                        widget.decoration is BoxDecoration,
                  ),
                ),
              )
              .map((container) => container.decoration)
              .whereType<BoxDecoration>();
      expect(
        decorations.any(
          (decoration) => decoration.color == const Color(0xFF000000),
        ),
        isTrue,
      );
    });

    testWidgets('selection gestures belong to EditableText', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqTimeField(
            value: const LiqTime(hour: 14, minute: 32),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

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

    test('throws AssertionError when hour out of range', () {
      expect(() => LiqTime(hour: 24, minute: 0), throwsAssertionError);
      expect(() => LiqTime(hour: -1, minute: 0), throwsAssertionError);
      expect(() => LiqTime(hour: 0, minute: 60), throwsAssertionError);
    });
  });
}
