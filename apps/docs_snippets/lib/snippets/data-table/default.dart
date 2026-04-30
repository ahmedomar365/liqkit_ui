// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

const List<LiqDataColumn> _columns = <LiqDataColumn>[
  LiqDataColumn(label: 'Name'),
  LiqDataColumn(label: 'Role'),
  LiqDataColumn(label: 'Joined', numeric: true),
];

const List<LiqDataRow> _rows = <LiqDataRow>[
  LiqDataRow(cells: <Widget>[Text('Jane Doe'), Text('Engineer'), Text('2024')]),
  LiqDataRow(cells: <Widget>[Text('Alex Kim'), Text('Design'), Text('2023')]),
  LiqDataRow(cells: <Widget>[Text('Sam Park'), Text('PM'), Text('2025')]),
];

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget dataTableDefaultBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 480,
        // {@highlight}
        child: LiqDataTable(columns: _columns, rows: _rows),
        // {@endhighlight}
      ),
    ),
  );
}
