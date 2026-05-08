import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (_) => Center(child: SizedBox(width: 320, child: child)),
        ),
      ],
    ),
  ),
);

void main() {
  group('LiqNumberField', () {
    testWidgets('renders the value as text', (tester) async {
      await tester.pumpWidget(
        _wrap(LiqNumberField(value: 42, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('tapping + button fires onChanged(value + step)', (
      tester,
    ) async {
      num? received;
      await tester.pumpWidget(
        _wrap(
          LiqNumberField(value: 5, step: 2, onChanged: (v) => received = v),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(LucideIcons.plus));
      await tester.pumpAndSettle();
      expect(received, 7);
    });

    testWidgets('enabled stepper buttons expose click cursors', (tester) async {
      await tester.pumpWidget(
        _wrap(LiqNumberField(value: 5, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      final mouseRegions = tester.widgetList<MouseRegion>(
        find.byType(MouseRegion),
      );
      expect(
        mouseRegions.where(
          (region) => region.cursor == SystemMouseCursors.click,
        ),
        hasLength(2),
      );
    });

    testWidgets('tapping - button fires onChanged(value - step)', (
      tester,
    ) async {
      num? received;
      await tester.pumpWidget(
        _wrap(
          LiqNumberField(value: 5, step: 2, onChanged: (v) => received = v),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(LucideIcons.minus));
      await tester.pumpAndSettle();
      expect(received, 3);
    });

    testWidgets('+ is disabled at max (no callback, opacity 0.4)', (
      tester,
    ) async {
      var fired = 0;
      await tester.pumpWidget(
        _wrap(LiqNumberField(value: 10, max: 10, onChanged: (_) => fired += 1)),
      );
      await tester.pumpAndSettle();

      // The + button is wrapped in an Opacity with opacity 0.4 when disabled.
      final addOpacity = tester.widget<Opacity>(
        find.ancestor(
          of: find.byIcon(LucideIcons.plus),
          matching: find.byType(Opacity),
        ),
      );
      expect(addOpacity.opacity, 0.4);

      await tester.tap(find.byIcon(LucideIcons.plus));
      await tester.pumpAndSettle();
      expect(fired, 0);
    });

    testWidgets('- is disabled at min (no callback, opacity 0.4)', (
      tester,
    ) async {
      var fired = 0;
      await tester.pumpWidget(
        _wrap(LiqNumberField(value: 0, onChanged: (_) => fired += 1)),
      );
      await tester.pumpAndSettle();

      final removeOpacity = tester.widget<Opacity>(
        find.ancestor(
          of: find.byIcon(LucideIcons.minus),
          matching: find.byType(Opacity),
        ),
      );
      expect(removeOpacity.opacity, 0.4);

      await tester.tap(find.byIcon(LucideIcons.minus));
      await tester.pumpAndSettle();
      expect(fired, 0);
    });

    testWidgets(
      'typing "5" replaces controller content and fires onChanged(5)',
      (tester) async {
        num? received;
        await tester.pumpWidget(
          _wrap(LiqNumberField(value: 0, onChanged: (v) => received = v)),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(EditableText), '5');
        await tester.pumpAndSettle();

        expect(received, 5);
      },
    );

    testWidgets('typing non-numeric text does not fire onChanged', (
      tester,
    ) async {
      num? received;
      await tester.pumpWidget(
        _wrap(LiqNumberField(value: 0, onChanged: (v) => received = v)),
      );
      await tester.pumpAndSettle();

      // Force-set an unparseable value into the controller (the input
      // formatter normally blocks non-digits, but we want to verify the
      // listener-side guard).
      final ed = tester.widget<EditableText>(find.byType(EditableText));
      ed.controller.value = const TextEditingValue(text: 'abc');
      await tester.pumpAndSettle();

      expect(received, isNull);
    });

    testWidgets('showButtons: false hides the +/- buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(LiqNumberField(value: 1, showButtons: false, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.plus), findsNothing);
      expect(find.byIcon(LucideIcons.minus), findsNothing);
    });

    testWidgets('uses dark theme colors for field and steppers', (
      tester,
    ) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(LiqNumberField(value: 42, onChanged: (_) {})),
        ),
      );
      await tester.pumpAndSettle();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.style.color, const Color(0xFFFFFFFF));

      final glassFills = tester
          .widgetList<LiqGlassSurface>(
            find.descendant(
              of: find.byType(LiqNumberField),
              matching: find.byType(LiqGlassSurface),
            ),
          )
          .map((s) => s.baseFill);
      expect(
        glassFills.any((fill) => fill == const Color(0xFF000000)),
        isTrue,
      );

      final addIcon = tester.widget<Icon>(find.byIcon(LucideIcons.plus));
      expect(addIcon.color, const Color(0xFFFFFFFF));
    });

    testWidgets('has no Cupertino selection controls (iOS-26 native)', (tester) async {
      await tester.pumpWidget(
        _wrap(LiqNumberField(value: 42, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EditableText), findsOneWidget);
      expect(find.byType(EditableText), findsOneWidget);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      
      expect(editable.enableInteractiveSelection, isTrue);
      expect(editable.selectionControls, isNull);
    });

    test('throws AssertionError when min > max', () {
      expect(
        () => LiqNumberField(value: 0, min: 10, max: 5, onChanged: (_) {}),
        throwsAssertionError,
      );
    });

    test('throws AssertionError when step is not positive', () {
      expect(
        () => LiqNumberField(value: 0, step: 0, onChanged: (_) {}),
        throwsAssertionError,
      );
    });
  });
}
