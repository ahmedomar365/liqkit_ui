import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

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

void main() {
  group('LiqDatePickerField', () {
    testWidgets('renders the placeholder when value is null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqDatePickerField(
            value: null,
            onChanged: (_) {},
            placeholder: 'Pick a day',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Pick a day'), findsOneWidget);
    });

    testWidgets('renders the formatted date when value is set', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqDatePickerField(value: DateTime(2026, 4, 30), onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Apr 30, 2026'), findsOneWidget);
    });

    testWidgets('resolves trigger colors from dark LiqTheme', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            LiqDatePickerField(value: DateTime(2026, 4, 30), onChanged: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final label = tester.widget<Text>(find.text('Apr 30, 2026'));
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(LiqDatePickerField),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;

      expect(label.style?.color, const Color(0xFFFFFFFF));
      expect(decoration.color, const Color(0xFF000000));
    });

    testWidgets('custom format callback overrides the default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqDatePickerField(
            value: DateTime(2026, 4, 30),
            onChanged: (_) {},
            format:
                (d) =>
                    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
                    '${d.day.toString().padLeft(2, '0')}',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('2026-04-30'), findsOneWidget);
      expect(find.text('Apr 30, 2026'), findsNothing);
    });

    testWidgets('tapping the trigger opens the popover with a LiqCalendar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqDatePickerField(value: DateTime(2026, 4, 15), onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LiqCalendar), findsNothing);

      await tester.tap(find.byType(LiqDatePickerField));
      await tester.pumpAndSettle();

      expect(find.byType(LiqCalendar), findsOneWidget);
      // The month label should be visible inside the popover.
      expect(find.text('April 2026'), findsOneWidget);
    });

    testWidgets('calendar popover uses shared Liquid Glass material', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqDatePickerField(value: DateTime(2026, 4, 15), onChanged: (_) {}),
        ),
      );

      await tester.tap(find.byType(LiqDatePickerField));
      await tester.pumpAndSettle();

      final surface = tester.widget<LiqGlassSurface>(
        find.ancestor(
          of: find.byType(LiqCalendar),
          matching: find.byType(LiqGlassSurface),
        ),
      );
      expect(surface.tint, LiqGlassTint.light);
      expect(surface.elevation, LiqGlassElevation.floating);
    });

    testWidgets('trigger exposes a click cursor for pointer input', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqDatePickerField(value: DateTime(2026, 4, 15), onChanged: (_) {}),
        ),
      );

      final cursors = tester
          .widgetList<MouseRegion>(find.byType(MouseRegion))
          .map((region) => region.cursor);
      expect(cursors, contains(SystemMouseCursors.click));
    });

    testWidgets('open animations honor reduced motion', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(800, 600),
            disableAnimations: true,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder:
                      (_) => Center(
                        child: SizedBox(
                          width: 320,
                          child: LiqDatePickerField(
                            value: DateTime(2026, 4, 15),
                            onChanged: (_) {},
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).duration,
        Duration.zero,
      );

      await tester.tap(find.byType(LiqDatePickerField));
      await tester.pump();
      expect(find.byType(LiqCalendar), findsOneWidget);
    });

    testWidgets('tapping a day fires onChanged and closes the popover', (
      tester,
    ) async {
      DateTime? received;
      await tester.pumpWidget(
        _wrap(
          LiqDatePickerField(
            value: DateTime(2026, 4, 15),
            onChanged: (d) => received = d,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqDatePickerField));
      await tester.pumpAndSettle();
      expect(find.byType(LiqCalendar), findsOneWidget);

      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();

      expect(received, DateTime(2026, 4, 20));
      // Popover should be dismissed.
      expect(find.byType(LiqCalendar), findsNothing);
    });

    testWidgets(
      'when onChanged is null, tapping the trigger does not open the popover',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const LiqDatePickerField(
              value: null,
              onChanged: null,
              placeholder: 'Disabled',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(LiqDatePickerField), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.byType(LiqCalendar), findsNothing);
      },
    );

    testWidgets('firstDate and lastDate are forwarded to LiqCalendar', (
      tester,
    ) async {
      final first = DateTime(2026, 4, 10);
      final last = DateTime(2026, 4, 25);
      await tester.pumpWidget(
        _wrap(
          LiqDatePickerField(
            value: DateTime(2026, 4, 15),
            onChanged: (_) {},
            firstDate: first,
            lastDate: last,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LiqDatePickerField));
      await tester.pumpAndSettle();

      final calendar = tester.widget<LiqCalendar>(find.byType(LiqCalendar));
      expect(calendar.firstDate, first);
      expect(calendar.lastDate, last);
    });
  });
}
