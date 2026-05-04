// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class _Person {
  const _Person(this.name, this.role, this.joined);
  final String name;
  final String role;
  final int joined;
}

const List<_Person> _people = <_Person>[
  _Person('Jane Doe', 'Engineer', 2024),
  _Person('Alex Kim', 'Design', 2023),
  _Person('Sam Park', 'PM', 2025),
];

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget dataTableSortableBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 480,
    child: LiqDemo<({int? col, LiqSortDirection dir})>(
      initial: (col: null, dir: LiqSortDirection.none),
      builder: (state, set) {
        // Reorder rows in response to the table's sort callback.
        final sorted = <_Person>[..._people];
        if (state.col == 2 && state.dir != LiqSortDirection.none) {
          sorted.sort((a, b) => a.joined.compareTo(b.joined));
          if (state.dir == LiqSortDirection.descending) {
            final reversed = sorted.reversed.toList();
            sorted
              ..clear()
              ..addAll(reversed);
          }
        }

        // {@highlight}
        return LiqDataTable(
          columns: const <LiqDataColumn>[
            LiqDataColumn(label: 'Name'),
            LiqDataColumn(label: 'Role'),
            LiqDataColumn(label: 'Joined', sortable: true, numeric: true),
          ],
          sortColumnIndex: state.col,
          sortDirection: state.dir,
          onSortChanged: (col, dir) => set((col: col, dir: dir)),
          rows: <LiqDataRow>[
            for (final p in sorted)
              LiqDataRow(
                cells: <Widget>[
                  Text(p.name),
                  Text(p.role),
                  Text('${p.joined}'),
                ],
              ),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
