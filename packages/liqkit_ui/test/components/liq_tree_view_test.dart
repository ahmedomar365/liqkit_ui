import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => LiqTheme(
    data: LiqThemeData.light,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  const sample = <LiqTreeNode<String>>[
    LiqTreeNode<String>(
      id: 'docs',
      label: 'docs',
      children: <LiqTreeNode<dynamic>>[
        LiqTreeNode<String>(id: 'docs/readme', label: 'readme.md'),
        LiqTreeNode<String>(
          id: 'docs/guides',
          label: 'guides',
          children: <LiqTreeNode<dynamic>>[
            LiqTreeNode<String>(
              id: 'docs/guides/intro',
              label: 'intro.md',
              value: 'intro-value',
            ),
          ],
        ),
      ],
    ),
    LiqTreeNode<String>(id: 'foo', label: 'foo', value: 'foo-value'),
  ];

  group('LiqTreeView', () {
    testWidgets('renders all top-level node labels', (tester) async {
      await tester.pumpWidget(wrap(const LiqTreeView<String>(nodes: sample)));

      expect(find.text('docs'), findsOneWidget);
      expect(find.text('foo'), findsOneWidget);
    });

    testWidgets('children of an unexpanded folder are not rendered', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const LiqTreeView<String>(nodes: sample)));

      expect(find.text('readme.md'), findsNothing);
      expect(find.text('guides'), findsNothing);
    });

    testWidgets(
      'children of a folder in initialExpanded are rendered on first build',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            const LiqTreeView<String>(
              nodes: sample,
              initialExpanded: <String>{'docs'},
            ),
          ),
        );

        expect(find.text('readme.md'), findsOneWidget);
        expect(find.text('guides'), findsOneWidget);
        // grand-children stay collapsed
        expect(find.text('intro.md'), findsNothing);
      },
    );

    testWidgets('tap on a folder row toggles its children visibility', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const LiqTreeView<String>(nodes: sample)));

      expect(find.text('readme.md'), findsNothing);

      await tester.tap(find.text('docs'));
      await tester.pumpAndSettle();
      expect(find.text('readme.md'), findsOneWidget);

      await tester.tap(find.text('docs'));
      await tester.pumpAndSettle();
      expect(find.text('readme.md'), findsNothing);
    });

    testWidgets('tap on a leaf row fires onSelected with id and value', (
      tester,
    ) async {
      String? lastId;
      String? lastValue;
      await tester.pumpWidget(
        wrap(
          LiqTreeView<String>(
            nodes: sample,
            onSelected: (id, value) {
              lastId = id;
              lastValue = value;
            },
          ),
        ),
      );

      await tester.tap(find.text('foo'));
      await tester.pumpAndSettle();

      expect(lastId, 'foo');
      expect(lastValue, 'foo-value');
    });

    testWidgets('tap on a folder row does not fire onSelected', (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        wrap(
          LiqTreeView<String>(
            nodes: sample,
            onSelected: (_, __) {
              calls += 1;
            },
          ),
        ),
      );

      await tester.tap(find.text('docs'));
      await tester.pumpAndSettle();

      expect(calls, 0);
    });

    testWidgets('selectedId paints the selected row with the selection color', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const LiqTreeView<String>(nodes: sample, selectedId: 'foo')),
      );

      // Find the Container nested under the row whose label is 'foo'.
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('foo'), matching: find.byType(Container))
            .first,
      );
      expect(container.color, LiqTreeView.selectedBackground);
    });

    testWidgets('depth-2 row pads left by indent * depth + 12 (= 44)', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const LiqTreeView<String>(
            nodes: sample,
            initialExpanded: <String>{'docs', 'docs/guides'},
          ),
        ),
      );

      // 'intro.md' is at depth 2 (docs > guides > intro.md).
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('intro.md'),
              matching: find.byType(Container),
            )
            .first,
      );
      final padding = container.padding! as EdgeInsets;
      expect(padding.left, 16 * 2 + 12);
    });

    testWidgets('uses dark theme colors for labels and selected row', (
      tester,
    ) async {
      await tester.pumpWidget(
        const LiqTheme(
          data: LiqThemeData.dark,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: LiqTreeView<String>(nodes: sample, selectedId: 'foo'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final label = tester.widget<Text>(find.text('foo'));
      expect(label.style?.color, const Color(0xFFFFFFFF));

      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('foo'), matching: find.byType(Container))
            .first,
      );
      expect(container.color, const Color(0xB2EBEBF5).withValues(alpha: 0.14));
    });
  });
}
