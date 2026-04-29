import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Center(child: SizedBox(width: 320, child: child)),
  ),
);

void main() {
  group('LiqTimePicker', () {
    testWidgets('seeds the hour and minute wheels from value (12-hour)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqTimePicker(
            value: DateTime(2026, 4, 29, 14, 30),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 14:30 = 2:30 PM. Three wheels rendered.
      final wheels = tester.widgetList<ListWheelScrollView>(
        find.byType(ListWheelScrollView),
      );
      expect(wheels.length, 3);

      // Hour wheel: 12-hour index 2 = "2".
      final hourWheel = wheels.elementAt(0);
      final hourController =
          hourWheel.controller! as FixedExtentScrollController;
      expect(hourController.selectedItem, 2);

      // Minute wheel: minute 30 with interval 1 → index 30.
      final minuteWheel = wheels.elementAt(1);
      final minuteController =
          minuteWheel.controller! as FixedExtentScrollController;
      expect(minuteController.selectedItem, 30);

      // AM/PM wheel: PM = index 1.
      final amPmWheel = wheels.elementAt(2);
      final amPmController =
          amPmWheel.controller! as FixedExtentScrollController;
      expect(amPmController.selectedItem, 1);
    });

    testWidgets('24-hour mode renders only two wheels and seeds raw hour', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqTimePicker(
            value: DateTime(2026, 4, 29, 14, 30),
            use24HourFormat: true,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final wheels = tester.widgetList<ListWheelScrollView>(
        find.byType(ListWheelScrollView),
      );
      expect(wheels.length, 2);

      final hourWheel = wheels.elementAt(0);
      final hourController =
          hourWheel.controller! as FixedExtentScrollController;
      expect(hourController.selectedItem, 14);
    });

    testWidgets('12-hour mode in the morning seeds AM', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqTimePicker(value: DateTime(2026, 4, 29, 8), onChanged: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      final wheels =
          tester
              .widgetList<ListWheelScrollView>(find.byType(ListWheelScrollView))
              .toList();
      expect(wheels.length, 3);
      final amPm = wheels[2].controller! as FixedExtentScrollController;
      expect(amPm.selectedItem, 0);
    });

    testWidgets('minuteInterval=15 produces a 4-tick minute wheel', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqTimePicker(
            value: DateTime(2026, 4, 29, 9, 30),
            minuteInterval: 15,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final wheels =
          tester
              .widgetList<ListWheelScrollView>(find.byType(ListWheelScrollView))
              .toList();
      // Minute wheel should have looping delegate with 4 children
      // (0, 15, 30, 45). Snap minute=30 → index 2.
      final minuteController =
          wheels[1].controller! as FixedExtentScrollController;
      expect(minuteController.selectedItem, 2);

      // Render the 4 minute labels somewhere in the tree.
      expect(find.text('00'), findsWidgets);
      expect(find.text('15'), findsWidgets);
      expect(find.text('30'), findsWidgets);
      expect(find.text('45'), findsWidgets);
    });

    test('throws AssertionError when minuteInterval does not divide 60', () {
      expect(
        () => LiqTimePicker(
          value: DateTime(2026, 4, 29, 9),
          minuteInterval: 7,
          onChanged: (_) {},
        ),
        throwsAssertionError,
      );
    });

    testWidgets('drag on the minute wheel fires onChanged with new minute', (
      tester,
    ) async {
      DateTime? received;
      await tester.pumpWidget(
        _wrap(
          LiqTimePicker(
            value: DateTime(2026, 4, 29, 9),
            onChanged: (t) => received = t,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final wheels =
          tester
              .widgetList<ListWheelScrollView>(find.byType(ListWheelScrollView))
              .toList();
      final minuteController =
          wheels[1].controller! as FixedExtentScrollController;

      // Programmatically advance one tick on the minute wheel and let
      // it settle. This is the same effect as a fling/drag that snaps
      // to the next item.
      minuteController.jumpToItem(minuteController.selectedItem + 1);
      await tester.pumpAndSettle();

      expect(received, isNotNull);
      expect(received!.minute, 1);
    });
  });
}
