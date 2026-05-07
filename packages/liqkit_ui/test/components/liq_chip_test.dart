import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/components.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(child: child),
    ),
  );
}

Color _backgroundOf(WidgetTester tester) {
  final container = tester.widget<AnimatedContainer>(
    find
        .descendant(
          of: find.byType(LiqChip),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
  final decoration = container.decoration! as BoxDecoration;
  return decoration.color!;
}

Color _labelColorOf(WidgetTester tester, String label) {
  final text = tester.widget<Text>(find.text(label));
  return text.style!.color!;
}

void main() {
  group('LiqChip', () {
    testWidgets('renders the supplied label', (tester) async {
      await tester.pumpWidget(_wrap(const LiqChip(label: 'flutter')));
      expect(find.text('flutter'), findsOneWidget);
    });

    testWidgets('selected: false uses the muted gray background', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const LiqChip(label: 'tag')));
      await tester.pump(LiqChip.animationDuration);
      expect(_backgroundOf(tester), equals(LiqChip.backgroundColor));
      expect(_labelColorOf(tester, 'tag'), equals(LiqChip.labelColor));
    });

    testWidgets(
      'selected: true uses the blue accent background and white label',
      (tester) async {
        await tester.pumpWidget(
          _wrap(const LiqChip(label: 'tag', selected: true)),
        );
        await tester.pump(LiqChip.animationDuration);
        expect(_backgroundOf(tester), equals(LiqChip.selectedBackgroundColor));
        expect(
          _labelColorOf(tester, 'tag'),
          equals(LiqChip.selectedLabelColor),
        );
      },
    );

    testWidgets('tap fires onPressed', (tester) async {
      var fired = 0;
      await tester.pumpWidget(
        _wrap(LiqChip(label: 'tap', onPressed: () => fired++)),
      );
      await tester.tap(find.byType(LiqChip));
      expect(fired, 1);
    });

    testWidgets('interactive chip keeps a 44pt-tall tap target', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(LiqChip(label: 'tap', onPressed: () {})));

      expect(tester.getSize(find.byType(LiqChip)).height, 44);

      final visual = tester.getSize(
        find
            .descendant(
              of: find.byType(LiqChip),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      expect(visual.height, LiqChip.minHeight);
    });

    testWidgets(
      'when both onPressed and onDeleted are null, the chip is non-tappable',
      (tester) async {
        await tester.pumpWidget(_wrap(const LiqChip(label: 'inert')));
        // No GestureDetector should be a descendant of the chip when
        // it's fully non-interactive.
        final detector = find.descendant(
          of: find.byType(LiqChip),
          matching: find.byType(GestureDetector),
        );
        expect(detector, findsNothing);
      },
    );

    testWidgets('renders the optional leading icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const LiqChip(label: 'starred', icon: LucideIcons.star)),
      );
      expect(find.byIcon(LucideIcons.star), findsOneWidget);
    });

    testWidgets('delete affordance only renders when onDeleted is non-null', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const LiqChip(label: 'no-x')));
      expect(find.byIcon(LucideIcons.x), findsNothing);

      await tester.pumpWidget(
        _wrap(LiqChip(label: 'with-x', onDeleted: () {})),
      );
      expect(find.byIcon(LucideIcons.x), findsOneWidget);
    });

    testWidgets(
      'tapping the delete affordance fires onDeleted, not onPressed',
      (tester) async {
        var pressed = 0;
        var deleted = 0;
        await tester.pumpWidget(
          _wrap(
            LiqChip(
              label: 'tag',
              onPressed: () => pressed++,
              onDeleted: () => deleted++,
            ),
          ),
        );
        await tester.tap(find.byIcon(LucideIcons.x));
        expect(deleted, 1);
        expect(pressed, 0);
      },
    );

    testWidgets('delete affordance is scoped to the close glyph', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(LiqChip(label: 'tag', onDeleted: () {})));

      final deleteTarget = find.ancestor(
        of: find.byIcon(LucideIcons.x),
        matching: find.byType(GestureDetector),
      );

      expect(
        tester.getSize(deleteTarget.first),
        const Size.square(LiqChip.deleteSize),
      );
    });
  });

  group('LiqChipGroup', () {
    testWidgets('lays out 3 chips inside a Wrap', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LiqChipGroup(
            chips: <LiqChip>[
              LiqChip(label: 'a'),
              LiqChip(label: 'b'),
              LiqChip(label: 'c'),
            ],
          ),
        ),
      );
      expect(find.byType(LiqChip), findsNWidgets(3));
      expect(
        find.descendant(
          of: find.byType(LiqChipGroup),
          matching: find.byType(Wrap),
        ),
        findsOneWidget,
      );
    });
  });
}
