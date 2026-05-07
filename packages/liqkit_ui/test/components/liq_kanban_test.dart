import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() {
  Widget wrap(Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(child: SizedBox(width: 900, height: 600, child: child)),
    ),
  );

  Map<String, LiqKanbanCard> threeCards() => <String, LiqKanbanCard>{
    'a': const LiqKanbanCard(id: 'a', child: Text('Card A')),
    'b': const LiqKanbanCard(id: 'b', child: Text('Card B')),
    'c': const LiqKanbanCard(id: 'c', child: Text('Card C')),
  };

  group('LiqKanban', () {
    testWidgets('renders all column titles', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqKanban(
            columns: const <LiqKanbanColumn>[
              LiqKanbanColumn(id: 'todo', title: 'TO DO', cardIds: <String>[]),
              LiqKanbanColumn(id: 'doing', title: 'DOING', cardIds: <String>[]),
              LiqKanbanColumn(id: 'done', title: 'DONE', cardIds: <String>[]),
            ],
            cards: const <String, LiqKanbanCard>{},
            onMove: (_, __, ___, ____) {},
          ),
        ),
      );

      expect(find.text('TO DO'), findsOneWidget);
      expect(find.text('DOING'), findsOneWidget);
      expect(find.text('DONE'), findsOneWidget);
    });

    testWidgets('renders card content for cards present in cards map', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqKanban(
            columns: const <LiqKanbanColumn>[
              LiqKanbanColumn(
                id: 'todo',
                title: 'TO DO',
                cardIds: <String>['a', 'b'],
              ),
              LiqKanbanColumn(
                id: 'done',
                title: 'DONE',
                cardIds: <String>['c'],
              ),
            ],
            cards: threeCards(),
            onMove: (_, __, ___, ____) {},
          ),
        ),
      );

      expect(find.text('Card A'), findsOneWidget);
      expect(find.text('Card B'), findsOneWidget);
      expect(find.text('Card C'), findsOneWidget);
    });

    testWidgets('cards referencing unknown ids are quietly omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          LiqKanban(
            columns: const <LiqKanbanColumn>[
              LiqKanbanColumn(
                id: 'todo',
                title: 'TO DO',
                cardIds: <String>['a', 'missing', 'b'],
              ),
            ],
            cards: const <String, LiqKanbanCard>{
              'a': LiqKanbanCard(id: 'a', child: Text('Card A')),
              'b': LiqKanbanCard(id: 'b', child: Text('Card B')),
            },
            onMove: (_, __, ___, ____) {},
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Card A'), findsOneWidget);
      expect(find.text('Card B'), findsOneWidget);
      expect(find.text('missing'), findsNothing);
    });

    testWidgets('drag from column 1 to column 2 fires onMove with right args', (
      tester,
    ) async {
      final events = <List<Object>>[];
      await tester.pumpWidget(
        wrap(
          LiqKanban(
            columns: const <LiqKanbanColumn>[
              LiqKanbanColumn(
                id: 'todo',
                title: 'TO DO',
                cardIds: <String>['a'],
              ),
              LiqKanbanColumn(
                id: 'done',
                title: 'DONE',
                cardIds: <String>['c'],
              ),
            ],
            cards: threeCards(),
            onMove: (cardId, fromId, toId, idx) {
              events.add(<Object>[cardId, fromId, toId, idx]);
            },
          ),
        ),
      );

      await tester.drag(find.text('Card A'), const Offset(310, 0));
      await tester.pumpAndSettle();

      expect(events, isNotEmpty);
      expect(events.first[0], 'a');
      expect(events.first[1], 'todo');
      expect(events.first[2], 'done');
    });

    testWidgets('overlay host reflects updated columns after parent rebuild', (
      tester,
    ) async {
      var columns = const <LiqKanbanColumn>[
        LiqKanbanColumn(id: 'todo', title: 'TO DO', cardIds: <String>['a']),
        LiqKanbanColumn(id: 'done', title: 'DONE', cardIds: <String>[]),
      ];

      Widget board() => wrap(
        LiqKanban(
          columns: columns,
          cards: threeCards(),
          onMove: (_, __, ___, ____) {},
        ),
      );

      await tester.pumpWidget(board());
      await tester.pumpAndSettle();
      final before = tester.getCenter(find.text('Card A')).dx;

      columns = const <LiqKanbanColumn>[
        LiqKanbanColumn(id: 'todo', title: 'TO DO', cardIds: <String>[]),
        LiqKanbanColumn(id: 'done', title: 'DONE', cardIds: <String>['a']),
      ];
      await tester.pumpWidget(board());
      await tester.pumpAndSettle();
      final after = tester.getCenter(find.text('Card A')).dx;

      expect(after, greaterThan(before + 100));
    });

    testWidgets('drag within same column fires onMove with same column ids', (
      tester,
    ) async {
      final events = <List<Object>>[];
      await tester.pumpWidget(
        wrap(
          LiqKanban(
            columns: const <LiqKanbanColumn>[
              LiqKanbanColumn(
                id: 'todo',
                title: 'TO DO',
                cardIds: <String>['a', 'b', 'c'],
              ),
            ],
            cards: threeCards(),
            onMove: (cardId, fromId, toId, idx) {
              events.add(<Object>[cardId, fromId, toId, idx]);
            },
          ),
        ),
      );

      // Drag Card A downward onto Card B's slot to reorder within column.
      await tester.drag(find.text('Card A'), const Offset(0, 60));
      await tester.pumpAndSettle();

      expect(events, isNotEmpty);
      expect(events.first[0], 'a');
      expect(events.first[1], 'todo');
      expect(events.first[2], 'todo');
    });

    testWidgets('the whole column body accepts a drop at the end', (
      tester,
    ) async {
      final events = <List<Object>>[];
      await tester.pumpWidget(
        wrap(
          LiqKanban(
            columns: const <LiqKanbanColumn>[
              LiqKanbanColumn(
                id: 'todo',
                title: 'TO DO',
                cardIds: <String>['a'],
              ),
              LiqKanbanColumn(
                id: 'done',
                title: 'DONE',
                cardIds: <String>['c'],
              ),
            ],
            cards: threeCards(),
            onMove: (cardId, fromId, toId, idx) {
              events.add(<Object>[cardId, fromId, toId, idx]);
            },
          ),
        ),
      );

      final dragStart = tester.getCenter(find.text('Card A'));
      final columnTarget =
          tester.getCenter(find.text('DONE')) + const Offset(0, 140);
      await tester.dragFrom(dragStart, columnTarget - dragStart);
      await tester.pumpAndSettle();

      expect(events, isNotEmpty);
      expect(events.last, <Object>['a', 'todo', 'done', 1]);
    });

    testWidgets('card drag surfaces use a grab cursor', (tester) async {
      await tester.pumpWidget(
        wrap(
          LiqKanban(
            columns: const <LiqKanbanColumn>[
              LiqKanbanColumn(
                id: 'todo',
                title: 'TO DO',
                cardIds: <String>['a'],
              ),
            ],
            cards: threeCards(),
            onMove: (_, __, ___, ____) {},
          ),
        ),
      );

      final mouseRegion = tester.widget<MouseRegion>(
        find
            .ancestor(
              of: find.text('Card A'),
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(mouseRegion.cursor, SystemMouseCursors.grab);
    });

    testWidgets('drop outside any DragTarget does not call onMove', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        wrap(
          LiqKanban(
            columns: const <LiqKanbanColumn>[
              LiqKanbanColumn(
                id: 'todo',
                title: 'TO DO',
                cardIds: <String>['a'],
              ),
            ],
            cards: threeCards(),
            onMove: (_, __, ___, ____) {
              calls += 1;
            },
          ),
        ),
      );

      // Drag far off-screen so we miss every DragTarget.
      await tester.drag(find.text('Card A'), const Offset(2000, 2000));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(calls, 0);
    });

    testWidgets('uses dark theme colors for columns and cards', (tester) async {
      await tester.pumpWidget(
        LiqTheme(
          data: LiqThemeData.dark,
          child: wrap(
            LiqKanban(
              columns: const <LiqKanbanColumn>[
                LiqKanbanColumn(
                  id: 'todo',
                  title: 'TO DO',
                  cardIds: <String>['a'],
                ),
              ],
              cards: threeCards(),
              onMove: (_, __, ___, ____) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final cardDefault = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text('Card A'),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      expect(cardDefault.style.color, const Color(0xFFFFFFFF));

      final fills = tester
          .widgetList<LiqGlassSurface>(
            find.descendant(
              of: find.byType(LiqKanban),
              matching: find.byType(LiqGlassSurface),
            ),
          )
          .map((s) => s.baseFill);
      expect(
        fills.any((fill) => fill == const Color(0xFF000000)),
        isTrue,
      );
    });
  });
}
