import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );

  group('LiqToggleGroup', () {
    testWidgets('renders all item labels', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqToggleGroup<String>(
            selected: const <String>{},
            onChanged: (_) {},
            items: const <LiqToggleGroupItem<String>>[
              LiqToggleGroupItem(value: 'a', label: 'Alpha'),
              LiqToggleGroupItem(value: 'b', label: 'Beta'),
              LiqToggleGroupItem(value: 'c', label: 'Gamma'),
            ],
          ),
        ),
      );

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);
    });

    testWidgets('tap on an unselected item adds it to the new set', (
      tester,
    ) async {
      Set<String>? captured;
      await tester.pumpWidget(
        wrap(
          LiqToggleGroup<String>(
            selected: const <String>{'a'},
            onChanged: (next) => captured = next,
            items: const <LiqToggleGroupItem<String>>[
              LiqToggleGroupItem(value: 'a', label: 'Alpha'),
              LiqToggleGroupItem(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(captured, equals(<String>{'a', 'b'}));
    });

    testWidgets('tap on a selected item removes it from the new set', (
      tester,
    ) async {
      Set<String>? captured;
      await tester.pumpWidget(
        wrap(
          LiqToggleGroup<String>(
            selected: const <String>{'a', 'b'},
            onChanged: (next) => captured = next,
            items: const <LiqToggleGroupItem<String>>[
              LiqToggleGroupItem(value: 'a', label: 'Alpha'),
              LiqToggleGroupItem(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(captured, equals(<String>{'a'}));
    });

    testWidgets('multiple values can be selected simultaneously', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqToggleGroup<String>(
            selected: const <String>{'a', 'c'},
            onChanged: (_) {},
            items: const <LiqToggleGroupItem<String>>[
              LiqToggleGroupItem(value: 'a', label: 'Alpha'),
              LiqToggleGroupItem(value: 'b', label: 'Beta'),
              LiqToggleGroupItem(value: 'c', label: 'Gamma'),
            ],
          ),
        ),
      );
      await tester.pump(LiqToggleGroup.animationDuration);

      Color labelColorOf(String label) =>
          tester.widget<Text>(find.text(label)).style!.color!;

      expect(
        labelColorOf('Alpha'),
        equals(LiqToggleGroup.activeForegroundColor),
      );
      expect(
        labelColorOf('Beta'),
        equals(LiqToggleGroup.inactiveForegroundColor),
      );
      expect(
        labelColorOf('Gamma'),
        equals(LiqToggleGroup.activeForegroundColor),
      );
    });

    testWidgets('onChanged: null → tap does nothing', (tester) async {
      await tester.pumpWidget(
        wrap(
          const LiqToggleGroup<String>(
            selected: <String>{'a'},
            onChanged: null,
            items: <LiqToggleGroupItem<String>>[
              LiqToggleGroupItem(value: 'a', label: 'Alpha'),
              LiqToggleGroupItem(value: 'b', label: 'Beta'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      // No callback wired → no error.
      expect(tester.takeException(), isNull);
    });

    testWidgets('item with icon and no label renders the icon', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqToggleGroup<String>(
            selected: const <String>{},
            onChanged: (_) {},
            items: const <LiqToggleGroupItem<String>>[
              LiqToggleGroupItem(value: 'b', icon: Icons.format_bold),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.format_bold), findsOneWidget);
    });

    test('asserts when an item has both label AND icon null', () {
      expect(
        () => LiqToggleGroupItem<String>(value: 'x'),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
