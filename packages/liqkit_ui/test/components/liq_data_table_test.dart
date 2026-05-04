import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

Widget _wrap(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(size: Size(800, 600)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: SizedBox(width: 480, child: child)),
    ),
  );
}

LiqDataTable _table({
  List<LiqDataColumn>? columns,
  List<LiqDataRow>? rows,
  int? sortColumnIndex,
  LiqSortDirection sortDirection = LiqSortDirection.none,
  void Function(int, LiqSortDirection)? onSortChanged,
}) {
  return LiqDataTable(
    columns:
        columns ??
        const <LiqDataColumn>[
          LiqDataColumn(label: 'Name'),
          LiqDataColumn(label: 'Role'),
          LiqDataColumn(label: 'Joined', sortable: true, numeric: true),
        ],
    rows:
        rows ??
        const <LiqDataRow>[
          LiqDataRow(
            cells: <Widget>[Text('Jane'), Text('Engineer'), Text('2024')],
          ),
          LiqDataRow(
            cells: <Widget>[Text('Alex'), Text('Design'), Text('2023')],
          ),
        ],
    sortColumnIndex: sortColumnIndex,
    sortDirection: sortDirection,
    onSortChanged: onSortChanged,
  );
}

void main() {
  group('LiqDataTable', () {
    testWidgets('renders all column labels', (tester) async {
      await tester.pumpWidget(_wrap(_table()));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Role'), findsOneWidget);
      expect(find.text('Joined'), findsOneWidget);
    });

    testWidgets('renders all cell contents', (tester) async {
      await tester.pumpWidget(_wrap(_table()));
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('Engineer'), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
      expect(find.text('Alex'), findsOneWidget);
      expect(find.text('Design'), findsOneWidget);
      expect(find.text('2023'), findsOneWidget);
    });

    testWidgets('tap on sortable header cycles none → ascending', (
      tester,
    ) async {
      int? receivedIndex;
      LiqSortDirection? receivedDir;
      await tester.pumpWidget(
        _wrap(
          _table(
            onSortChanged: (i, d) {
              receivedIndex = i;
              receivedDir = d;
            },
          ),
        ),
      );

      await tester.tap(find.text('Joined'));
      await tester.pump();

      expect(receivedIndex, 2);
      expect(receivedDir, LiqSortDirection.ascending);
    });

    testWidgets('tap cycles ascending → descending', (tester) async {
      int? receivedIndex;
      LiqSortDirection? receivedDir;
      await tester.pumpWidget(
        _wrap(
          _table(
            sortColumnIndex: 2,
            sortDirection: LiqSortDirection.ascending,
            onSortChanged: (i, d) {
              receivedIndex = i;
              receivedDir = d;
            },
          ),
        ),
      );

      await tester.tap(find.text('Joined'));
      await tester.pump();

      expect(receivedIndex, 2);
      expect(receivedDir, LiqSortDirection.descending);
    });

    testWidgets('tap cycles descending → none', (tester) async {
      int? receivedIndex;
      LiqSortDirection? receivedDir;
      await tester.pumpWidget(
        _wrap(
          _table(
            sortColumnIndex: 2,
            sortDirection: LiqSortDirection.descending,
            onSortChanged: (i, d) {
              receivedIndex = i;
              receivedDir = d;
            },
          ),
        ),
      );

      await tester.tap(find.text('Joined'));
      await tester.pump();

      expect(receivedIndex, 2);
      expect(receivedDir, LiqSortDirection.none);
    });

    testWidgets('tap on a non-sortable header does nothing', (tester) async {
      var fired = false;
      await tester.pumpWidget(
        _wrap(_table(onSortChanged: (_, __) => fired = true)),
      );

      await tester.tap(find.text('Name'));
      await tester.pump();
      await tester.tap(find.text('Role'));
      await tester.pump();

      expect(fired, isFalse);
    });

    testWidgets('tap on a body row with onTap fires it', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          _table(
            rows: <LiqDataRow>[
              LiqDataRow(
                cells: const <Widget>[
                  Text('Jane'),
                  Text('Engineer'),
                  Text('2024'),
                ],
                onTap: () => taps += 1,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Jane'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('body row with onTap=null is non-tappable', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            // Use only non-sortable columns so the only GestureDetectors
            // possible are the row taps.
            columns: const <LiqDataColumn>[
              LiqDataColumn(label: 'Name'),
              LiqDataColumn(label: 'Role'),
              LiqDataColumn(label: 'Joined', numeric: true),
            ],
            rows: const <LiqDataRow>[
              LiqDataRow(
                cells: <Widget>[Text('Jane'), Text('Engineer'), Text('2024')],
              ),
            ],
          ),
        ),
      );

      // No GestureDetector should wrap the row.
      expect(
        find.descendant(
          of: find.byType(LiqDataTable),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });

    testWidgets('uses dark theme colors for table text and surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        LiqTheme(data: LiqThemeData.dark, child: _wrap(_table())),
      );
      await tester.pumpAndSettle();

      final jane = tester.widget<Text>(find.text('Jane'));
      expect(jane.style?.color, isNull);

      final bodyDefault = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text('Jane'),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      expect(bodyDefault.style.color, const Color(0xFFFFFFFF));

      final tableDecorations =
          tester
              .widgetList<DecoratedBox>(
                find.descendant(
                  of: find.byType(LiqDataTable),
                  matching: find.byType(DecoratedBox),
                ),
              )
              .map((box) => box.decoration)
              .whereType<BoxDecoration>();
      expect(
        tableDecorations.any(
          (decoration) => decoration.color == const Color(0xFF000000),
        ),
        isTrue,
      );
    });

    testWidgets('asserts when row.cells.length != columns.length', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: const <LiqDataColumn>[
              LiqDataColumn(label: 'A'),
              LiqDataColumn(label: 'B'),
            ],
            rows: const <LiqDataRow>[
              LiqDataRow(cells: <Widget>[Text('only one')]),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isA<FlutterError>());
    });

    test('asserts when columns is empty', () {
      expect(
        () => LiqDataTable(
          columns: const <LiqDataColumn>[],
          rows: const <LiqDataRow>[],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
