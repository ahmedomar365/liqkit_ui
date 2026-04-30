import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Horizontal alignment for a [LiqDataColumn].
enum LiqColumnAlignment {
  /// Cells render left-aligned.
  left,

  /// Cells render center-aligned.
  center,

  /// Cells render right-aligned.
  right,
}

/// Sort state for a [LiqDataTable] header.
enum LiqSortDirection {
  /// No sort applied.
  none,

  /// Ascending order — smallest values first.
  ascending,

  /// Descending order — largest values first.
  descending,
}

/// Column descriptor for a [LiqDataTable].
final class LiqDataColumn with Diagnosticable {
  /// Creates a column descriptor.
  const LiqDataColumn({
    required this.label,
    this.alignment = LiqColumnAlignment.left,
    this.flex = 1,
    this.sortable = false,
    this.numeric = false,
  });

  /// Header label rendered in the title row.
  final String label;

  /// Horizontal alignment for the column's header and body cells.
  ///
  /// When [numeric] is true the effective alignment defaults to
  /// [LiqColumnAlignment.right] unless [alignment] was set explicitly to
  /// something other than [LiqColumnAlignment.left].
  final LiqColumnAlignment alignment;

  /// Relative width via [Flexible] — combined across all columns.
  final int flex;

  /// When true, taps on the header fire `onSortChanged` with the toggled
  /// direction.
  final bool sortable;

  /// When true the column is right-aligned by default and uses tabular
  /// numerals. Setting this implicitly sets `alignment=right` unless
  /// overridden.
  final bool numeric;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(EnumProperty<LiqColumnAlignment>('alignment', alignment))
      ..add(IntProperty('flex', flex))
      ..add(FlagProperty('sortable', value: sortable, ifTrue: 'sortable'))
      ..add(FlagProperty('numeric', value: numeric, ifTrue: 'numeric'));
  }
}

/// Row data for a [LiqDataTable].
final class LiqDataRow with Diagnosticable {
  /// Creates a row.
  ///
  /// [cells] must contain exactly `columns.length` entries — asserted at
  /// runtime by [LiqDataTable].
  const LiqDataRow({required this.cells, this.onTap});

  /// Cell widgets — one per column, in the same order as the table's
  /// `columns` list.
  final List<Widget> cells;

  /// Optional row tap callback. When non-null the entire row is
  /// tappable and reports `button: true` semantics.
  final VoidCallback? onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('cellCount', cells.length))
      ..add(
        FlagProperty(
          'tappable',
          value: onTap != null,
          ifTrue: 'tappable',
          ifFalse: 'static',
        ),
      );
  }
}

/// iOS 26 simple data table — header row + body rows + hairline
/// separators.
///
/// Width is provided by parent constraints. The table does **not** sort
/// the data itself; the consumer reorders [rows] in response to
/// [onSortChanged]. Sort cycle: `none → ascending → descending → none`.
final class LiqDataTable extends StatelessWidget {
  /// Creates a data table.
  const LiqDataTable({
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortDirection = LiqSortDirection.none,
    this.onSortChanged,
    super.key,
  }) : assert(columns.length > 0, 'columns must not be empty');

  /// Column descriptors. Order determines render order.
  final List<LiqDataColumn> columns;

  /// Body rows.
  final List<LiqDataRow> rows;

  /// 0-based index of the currently sorted column (the table doesn't
  /// sort the data itself — the consumer reorders [rows] in response to
  /// [onSortChanged]). When null no column is sorted.
  final int? sortColumnIndex;

  /// Current sort direction. Only meaningful when [sortColumnIndex] is
  /// non-null.
  final LiqSortDirection sortDirection;

  /// Called when a sortable header is tapped. Receives the column index
  /// and the next direction (cycles
  /// `none → ascending → descending → none`).
  final void Function(int columnIndex, LiqSortDirection nextDirection)?
  onSortChanged;

  /// Outer corner radius.
  static const double radius = 12;

  /// Outer hairline border color — 8% black.
  static const Color borderColor = Color(0x14000000);

  /// Outer hairline border thickness (logical pixels).
  static const double borderThickness = 0.5;

  /// Header row height.
  static const double headerHeight = 44;

  /// Body row min height.
  static const double rowMinHeight = 44;

  /// Horizontal cell padding.
  static const double cellPaddingHorizontal = 16;

  /// Header background — light system gray.
  static const Color headerBackground = Color(0xFFF2F2F7);

  /// Inter-row hairline color — ~16% black.
  static const Color rowDividerColor = Color(0x29000000);

  /// Inter-row hairline thickness (logical pixels).
  static const double rowDividerThickness = 0.33;

  /// Outer body background.
  static const Color bodyBackground = Color(0xFFFFFFFF);

  /// Header text color — system gray.
  static const Color headerTextColor = Color(0xFF8E8E93);

  /// Body text color.
  static const Color bodyTextColor = Color(0xFF1C1C1E);

  static const String _fontFamily = 'SF Pro Text';
  static const List<String> _fontFamilyFallback = <String>[
    'SF Pro',
    'sans-serif',
  ];

  /// The "next" sort direction the table will report when the given
  /// header is tapped. Cycles `none → ascending → descending → none`.
  ///
  /// Visible for testing.
  static LiqSortDirection nextDirectionFor({
    required int tappedIndex,
    required int? currentSortColumnIndex,
    required LiqSortDirection currentDirection,
  }) {
    if (currentSortColumnIndex != tappedIndex) {
      return LiqSortDirection.ascending;
    }
    switch (currentDirection) {
      case LiqSortDirection.none:
        return LiqSortDirection.ascending;
      case LiqSortDirection.ascending:
        return LiqSortDirection.descending;
      case LiqSortDirection.descending:
        return LiqSortDirection.none;
    }
  }

  LiqColumnAlignment _effectiveAlignment(LiqDataColumn column) {
    if (column.numeric && column.alignment == LiqColumnAlignment.left) {
      return LiqColumnAlignment.right;
    }
    return column.alignment;
  }

  Alignment _alignmentToWidgetAlignment(LiqColumnAlignment a) {
    switch (a) {
      case LiqColumnAlignment.left:
        return Alignment.centerLeft;
      case LiqColumnAlignment.center:
        return Alignment.center;
      case LiqColumnAlignment.right:
        return Alignment.centerRight;
    }
  }

  TextAlign _alignmentToTextAlign(LiqColumnAlignment a) {
    switch (a) {
      case LiqColumnAlignment.left:
        return TextAlign.left;
      case LiqColumnAlignment.center:
        return TextAlign.center;
      case LiqColumnAlignment.right:
        return TextAlign.right;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      for (var i = 0; i < rows.length; i++) {
        if (rows[i].cells.length != columns.length) {
          throw FlutterError(
            'LiqDataTable: row $i has ${rows[i].cells.length} cells but '
            'the table has ${columns.length} columns.',
          );
        }
      }
      return true;
    }(), 'every row must have exactly columns.length cells');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bodyBackground,
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
        border: Border.all(color: borderColor, width: borderThickness),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeader(),
            for (var i = 0; i < rows.length; i++) ...<Widget>[
              if (i > 0)
                const SizedBox(
                  height: rowDividerThickness,
                  child: ColoredBox(color: rowDividerColor),
                ),
              _buildBodyRow(rows[i]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: headerBackground,
        border: Border(
          bottom: BorderSide(
            color: rowDividerColor,
            width: rowDividerThickness,
          ),
        ),
      ),
      child: SizedBox(
        height: headerHeight,
        child: Row(
          children: <Widget>[
            for (var i = 0; i < columns.length; i++)
              Expanded(
                flex: columns[i].flex,
                child: _HeaderCell(
                  column: columns[i],
                  effectiveAlignment: _effectiveAlignment(columns[i]),
                  widgetAlignment: _alignmentToWidgetAlignment(
                    _effectiveAlignment(columns[i]),
                  ),
                  textAlign: _alignmentToTextAlign(
                    _effectiveAlignment(columns[i]),
                  ),
                  isSorted: sortColumnIndex == i,
                  sortDirection:
                      sortColumnIndex == i
                          ? sortDirection
                          : LiqSortDirection.none,
                  onTap:
                      columns[i].sortable
                          ? () {
                            final next = nextDirectionFor(
                              tappedIndex: i,
                              currentSortColumnIndex: sortColumnIndex,
                              currentDirection: sortDirection,
                            );
                            onSortChanged?.call(i, next);
                          }
                          : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyRow(LiqDataRow row) {
    final children = <Widget>[
      for (var i = 0; i < columns.length; i++)
        Expanded(
          flex: columns[i].flex,
          child: _BodyCell(
            column: columns[i],
            widgetAlignment: _alignmentToWidgetAlignment(
              _effectiveAlignment(columns[i]),
            ),
            textAlign: _alignmentToTextAlign(_effectiveAlignment(columns[i])),
            useTabularFigures: columns[i].numeric,
            child: row.cells[i],
          ),
        ),
    ];

    final body = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: rowMinHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: cellPaddingHorizontal),
        child: Row(children: children),
      ),
    );

    if (row.onTap == null) {
      return body;
    }
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: row.onTap,
        child: body,
      ),
    );
  }

  /// Header text style — exposed for tests.
  static const TextStyle headerTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: headerTextColor,
  );

  /// Body text style — exposed for tests.
  static const TextStyle bodyTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 15,
    height: 1.3,
    color: bodyTextColor,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('columnsCount', columns.length))
      ..add(IntProperty('rowsCount', rows.length))
      ..add(IntProperty('sortColumnIndex', sortColumnIndex, defaultValue: null))
      ..add(EnumProperty<LiqSortDirection>('sortDirection', sortDirection));
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.column,
    required this.effectiveAlignment,
    required this.widgetAlignment,
    required this.textAlign,
    required this.isSorted,
    required this.sortDirection,
    required this.onTap,
  });

  final LiqDataColumn column;
  final LiqColumnAlignment effectiveAlignment;
  final Alignment widgetAlignment;
  final TextAlign textAlign;
  final bool isSorted;
  final LiqSortDirection sortDirection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      column.label,
      style: LiqDataTable.headerTextStyle,
      textAlign: textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textDirection: TextDirection.ltr,
    );

    final content =
        column.sortable
            ? _withChevron(label)
            : Align(alignment: widgetAlignment, child: label);

    final padded = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LiqDataTable.cellPaddingHorizontal,
      ),
      child: content,
    );

    if (onTap == null) {
      return padded;
    }
    return Semantics(
      button: true,
      label: column.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: padded,
      ),
    );
  }

  Widget _withChevron(Widget label) {
    final chevron = _SortChevron(
      direction: isSorted ? sortDirection : LiqSortDirection.none,
    );
    final children =
        effectiveAlignment == LiqColumnAlignment.right
            ? <Widget>[
              chevron,
              const SizedBox(width: 4),
              Flexible(child: label),
            ]
            : <Widget>[
              Flexible(child: label),
              const SizedBox(width: 4),
              chevron,
            ];

    final mainAxisAlignment = () {
      switch (effectiveAlignment) {
        case LiqColumnAlignment.left:
          return MainAxisAlignment.start;
        case LiqColumnAlignment.center:
          return MainAxisAlignment.center;
        case LiqColumnAlignment.right:
          return MainAxisAlignment.end;
      }
    }();

    return Row(mainAxisAlignment: mainAxisAlignment, children: children);
  }
}

class _SortChevron extends StatelessWidget {
  const _SortChevron({required this.direction});

  final LiqSortDirection direction;

  @override
  Widget build(BuildContext context) {
    // Render an inactive chevron at low opacity when no sort is applied
    // so the tap target reads as sortable.
    final inactive = direction == LiqSortDirection.none;
    final glyph = direction == LiqSortDirection.descending ? '↓' : '↑';
    return Text(
      glyph,
      style: TextStyle(
        fontFamily: 'SF Pro Text',
        fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
        fontSize: 11,
        height: 1,
        fontWeight: FontWeight.w600,
        color:
            inactive ? const Color(0x808E8E93) : LiqDataTable.headerTextColor,
      ),
      textDirection: TextDirection.ltr,
    );
  }
}

class _BodyCell extends StatelessWidget {
  const _BodyCell({
    required this.column,
    required this.child,
    required this.widgetAlignment,
    required this.textAlign,
    required this.useTabularFigures,
  });

  final LiqDataColumn column;
  final Widget child;
  final Alignment widgetAlignment;
  final TextAlign textAlign;
  final bool useTabularFigures;

  @override
  Widget build(BuildContext context) {
    final style =
        useTabularFigures
            ? LiqDataTable.bodyTextStyle.copyWith(
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            )
            : LiqDataTable.bodyTextStyle;
    return Align(
      alignment: widgetAlignment,
      child: DefaultTextStyle.merge(
        style: style,
        textAlign: textAlign,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: child,
      ),
    );
  }
}
