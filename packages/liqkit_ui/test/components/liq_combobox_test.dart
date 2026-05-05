import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

const List<LiqComboboxOption<String>> _fruits = <LiqComboboxOption<String>>[
  LiqComboboxOption<String>(value: 'apple', label: 'Apple'),
  LiqComboboxOption<String>(value: 'apricot', label: 'Apricot'),
  LiqComboboxOption<String>(value: 'banana', label: 'Banana'),
  LiqComboboxOption<String>(value: 'cherry', label: 'Cherry'),
];

Widget _wrap(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (_) => Center(child: SizedBox(width: 320, child: child)),
          ),
        ],
      ),
    ),
  );
}

Widget _wrapWithMedia(Widget child, MediaQueryData media) {
  return MediaQuery(
    data: media,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(
            builder: (_) => Center(child: SizedBox(width: 320, child: child)),
          ),
        ],
      ),
    ),
  );
}

void main() {
  group('LiqCombobox', () {
    testWidgets('renders the placeholder when value is null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(
            options: _fruits,
            value: null,
            onChanged: (_) {},
            placeholder: 'Pick a fruit',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Pick a fruit'), findsOneWidget);
    });

    testWidgets('shows the matching option label when value is set', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(
            options: _fruits,
            value: 'banana',
            onChanged: (_) {},
            placeholder: 'Pick a fruit',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsOneWidget);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, 'Banana');
    });

    testWidgets('tapping the field opens the dropdown', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(options: _fruits, value: null, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      // Apple isn't in the field yet because nothing is selected.
      expect(find.text('Apple'), findsNothing);

      await tester.tap(find.byType(LiqCombobox<String>));
      await tester.pumpAndSettle();

      // All four labels should now be findable in the dropdown.
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Apricot'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
    });

    testWidgets('typing "ap" filters to options containing "ap"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(options: _fruits, value: null, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqCombobox<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'ap');
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Apricot'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
      expect(find.text('Cherry'), findsNothing);
    });

    testWidgets('tapping a row fires onChanged with that option value', (
      tester,
    ) async {
      String? received;
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(
            options: _fruits,
            value: null,
            onChanged: (v) => received = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqCombobox<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cherry'));
      await tester.pumpAndSettle();

      expect(received, 'cherry');
    });

    testWidgets('reports dropdown open and close state', (tester) async {
      final states = <bool>[];
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(
            options: _fruits,
            value: null,
            onChanged: (_) {},
            onOpenChanged: states.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqCombobox<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cherry'));
      await tester.pumpAndSettle();

      expect(states, <bool>[true, false]);
    });

    testWidgets('"No matches" row appears when filter returns empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(options: _fruits, value: null, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqCombobox<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('No matches'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('selected option row has a checkmark icon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(
            options: _fruits,
            value: 'banana',
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqCombobox<String>));
      await tester.pumpAndSettle();

      // The check icon appears exactly once — next to the selected
      // "Banana" row.
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('opening dropdown uses a glass popover surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(options: _fruits, value: null, onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqCombobox<String>));
      await tester.pumpAndSettle();

      expect(find.byType(LiqGlassSurface), findsOneWidget);
    });

    testWidgets('reduced motion shows dropdown without waiting for animation', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithMedia(
          LiqCombobox<String>(options: _fruits, value: null, onChanged: (_) {}),
          const MediaQueryData(size: Size(800, 600), disableAnimations: true),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqCombobox<String>));
      await tester.pump();

      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets(
      'when onChanged is null, tapping the field does NOT open the dropdown',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const LiqCombobox<String>(
              options: _fruits,
              value: null,
              onChanged: null,
              placeholder: 'Disabled',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(LiqCombobox<String>));
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.byType(LiqGlassSurface),
            matching: find.text('Apple'),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.byType(LiqGlassSurface),
            matching: find.text('Banana'),
          ),
          findsNothing,
        );
      },
    );

    testWidgets('uses dark theme colors for field text and surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            LiqCombobox<String>(
              options: _fruits,
              value: 'apple',
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
                  of: find.byType(LiqCombobox<String>),
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

    testWidgets('uses Cupertino text selection gestures', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqCombobox<String>(
            options: _fruits,
            value: 'apple',
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoTextField), findsOneWidget);
      expect(find.byType(EditableText), findsOneWidget);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.rendererIgnoresPointer, isTrue);
      expect(editable.enableInteractiveSelection, isTrue);
      expect(editable.selectionControls, isNotNull);
    });
  });
}
