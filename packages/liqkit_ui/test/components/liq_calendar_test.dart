import 'package:flutter/material.dart' show Icons;
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

Widget _wrapAtWidth(double width, Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: MediaQuery(
    data: const MediaQueryData(),
    child: Center(child: SizedBox(width: width, child: child)),
  ),
);

void main() {
  group('LiqCalendar', () {
    testWidgets('renders 7 weekday headers (Sunday-first)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (_) {},
          ),
        ),
      );
      for (final label in <String>['SU', 'MO', 'TU', 'WE', 'TH', 'FR', 'SA']) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('renders the month label for selectedDate', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (_) {},
          ),
        ),
      );
      expect(find.text('April 2026'), findsOneWidget);
    });

    testWidgets('resolves title and day colors from dark LiqTheme', (
      tester,
    ) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: _wrap(
            LiqCalendar(
              selectedDate: DateTime(2026, 4, 15),
              onDateChanged: (_) {},
            ),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('April 2026'));
      final day = tester.widget<Text>(find.text('16'));

      expect(title.style?.color, const Color(0xFFFFFFFF));
      expect(day.style?.color, const Color(0xFFFFFFFF));
    });

    testWidgets('selected date cell has the filled blue background', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (_) {},
          ),
        ),
      );

      final dayFinder = find.text('15');
      expect(dayFinder, findsOneWidget);
      final container = tester.widget<Container>(
        find.ancestor(of: dayFinder, matching: find.byType(Container)).first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, LiqCalendar.accent);
    });

    testWidgets('day circles shrink inside narrow columns', (tester) async {
      await tester.pumpWidget(
        _wrapAtWidth(
          224,
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (_) {},
          ),
        ),
      );

      final selectedDay = find.text('15');
      final dayCircle = find.ancestor(
        of: selectedDay,
        matching: find.byType(Container),
      );

      expect(tester.getSize(dayCircle.first).width, lessThan(36));
    });

    testWidgets('tap on day "20" fires onDateChanged with that date', (
      tester,
    ) async {
      DateTime? received;
      await tester.pumpWidget(
        _wrap(
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (d) => received = d,
          ),
        ),
      );

      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();
      expect(received, DateTime(2026, 4, 20));
    });

    testWidgets('tap on leading-out-of-month day fires onDateChanged', (
      tester,
    ) async {
      // April 2026: April 1 is a Wednesday. Sunday-first leading days
      // are Mar 29 (Sun), Mar 30 (Mon), Mar 31 (Tue) — all rendered
      // before April 1.
      DateTime? received;
      await tester.pumpWidget(
        _wrap(
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (d) => received = d,
          ),
        ),
      );

      // "29" appears once (Mar 29) since April has no 29th leading
      // duplication issue — but to disambiguate, target the first
      // occurrence which is the Mar 29 leading cell.
      final twentyNines = find.text('29');
      expect(twentyNines, findsWidgets);
      await tester.tap(twentyNines.first);
      await tester.pumpAndSettle();
      expect(received, DateTime(2026, 3, 29));
    });

    testWidgets('prev chevron tap shifts the focused month back', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (_) {},
          ),
        ),
      );

      expect(find.text('April 2026'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text('March 2026'), findsOneWidget);
    });

    testWidgets('next chevron tap shifts the focused month forward', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (_) {},
          ),
        ),
      );

      expect(find.text('April 2026'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('May 2026'), findsOneWidget);
    });

    testWidgets('chevrons keep 44pt tap targets', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LiqCalendar(
            selectedDate: DateTime(2026, 4, 15),
            onDateChanged: (_) {},
          ),
        ),
      );

      final previous = find.ancestor(
        of: find.byIcon(Icons.chevron_left),
        matching: find.byType(GestureDetector),
      );
      final next = find.ancestor(
        of: find.byIcon(Icons.chevron_right),
        matching: find.byType(GestureDetector),
      );

      expect(tester.getSize(previous.first), const Size(44, 44));
      expect(tester.getSize(next.first), const Size(44, 44));
    });

    testWidgets(
      'firstDate / lastDate: out-of-bounds days are non-tappable and dim',
      (tester) async {
        DateTime? received;
        await tester.pumpWidget(
          _wrap(
            LiqCalendar(
              selectedDate: DateTime(2026, 4, 20),
              firstDate: DateTime(2026, 4, 15),
              lastDate: DateTime(2026, 4, 25),
              onDateChanged: (d) => received = d,
            ),
          ),
        );

        // April 10 is < April 15 → out of bounds.
        await tester.tap(find.text('10'));
        await tester.pumpAndSettle();
        expect(received, isNull);

        // The cell text color should be the out-of-bounds gray.
        final tenText = tester.widget<Text>(find.text('10'));
        expect(tenText.style?.color, LiqCalendar.outOfBoundsTextColor);

        // A day inside bounds should still fire.
        await tester.tap(find.text('22'));
        await tester.pumpAndSettle();
        expect(received, DateTime(2026, 4, 22));
      },
    );
  });
}
