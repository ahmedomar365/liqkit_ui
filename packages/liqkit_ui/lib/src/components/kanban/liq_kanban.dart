import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// A single card on a [LiqKanban] board.
///
/// The [id] is the value passed back through `onMove` when this card is
/// dragged. The [child] is rendered inside the card surface and may be
/// any widget — plain `Text`, a `Row` with avatar + label, etc.
@immutable
final class LiqKanbanCard with Diagnosticable {
  /// Creates a card with the given [id] and [child].
  const LiqKanbanCard({required this.id, required this.child});

  /// Stable identifier for this card. Passed to `onMove` when the card
  /// is dragged.
  final String id;

  /// The card body. Rendered inside the card surface with 12pt padding
  /// on all sides.
  final Widget child;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('id', id));
  }
}

/// One column on a [LiqKanban] board.
///
/// Owns the ordered list of [cardIds] for cards that live in this column;
/// the actual card data is looked up from [LiqKanban.cards].
@immutable
final class LiqKanbanColumn with Diagnosticable {
  /// Creates a column with the given [id], [title], and ordered [cardIds].
  const LiqKanbanColumn({
    required this.id,
    required this.title,
    required this.cardIds,
  });

  /// Stable identifier for this column. Passed to `onMove` as
  /// `fromColumnId` / `toColumnId`.
  final String id;

  /// Display title rendered above the cards in 13pt SF semibold uppercase.
  final String title;

  /// Ordered list of card ids that live in this column. Each id should
  /// resolve to an entry in [LiqKanban.cards]; ids that do not resolve
  /// are quietly omitted.
  final List<String> cardIds;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('id', id))
      ..add(StringProperty('title', title))
      ..add(IntProperty('cardCount', cardIds.length));
  }
}

/// Internal payload shuttled by the underlying [Draggable] between
/// columns. Captures the card's id and the column it came from so the
/// drop site can build a complete move event.
@immutable
class _LiqKanbanDragData {
  const _LiqKanbanDragData({required this.cardId, required this.fromColumnId});

  final String cardId;
  final String fromColumnId;
}

/// iOS 26 multi-column kanban (Trello-style) board.
///
/// `LiqKanban` lays out [columns] horizontally inside a horizontal
/// scroller; each column renders its title, its ordered list of cards
/// looked up from [cards], and a trailing drop target. Cards are
/// draggable to any other column or any other slot in the same column.
///
/// The widget is fully **stateless** — the parent owns column membership
/// and card order, and updates state in response to [onMove] callbacks.
///
/// Scope is deliberately narrow:
///
/// * Single-select drag (no multi-select).
/// * No inline edit / no card creation UI.
/// * No swimlanes, no WIP limits, no per-column color.
///
/// Wrap or compose for richer behaviour.
final class LiqKanban extends StatelessWidget {
  /// Creates an iOS 26 kanban board.
  const LiqKanban({
    required this.columns,
    required this.cards,
    required this.onMove,
    this.columnWidth = defaultColumnWidth,
    this.columnSpacing = defaultColumnSpacing,
    this.cardSpacing = defaultCardSpacing,
    super.key,
  });

  /// The columns to render, drawn left-to-right.
  final List<LiqKanbanColumn> columns;

  /// Map of card id -> card data. Card ids referenced by
  /// [LiqKanbanColumn.cardIds] but missing from this map are quietly
  /// skipped (no throw).
  final Map<String, LiqKanbanCard> cards;

  /// Called when the user drops a card. Receives:
  ///
  /// * `cardId` — id of the dragged card,
  /// * `fromColumnId` — id of the column the card came from,
  /// * `toColumnId` — id of the column the card was dropped into,
  /// * `toIndex` — target index inside `toColumnId`'s `cardIds`.
  ///
  /// The parent is responsible for actually mutating its state and
  /// rebuilding the board.
  final void Function(
    String cardId,
    String fromColumnId,
    String toColumnId,
    int toIndex,
  )
  onMove;

  /// Fixed width of each column in logical px.
  final double columnWidth;

  /// Horizontal gap between adjacent columns in logical px.
  final double columnSpacing;

  /// Vertical gap between adjacent cards inside a column in logical px.
  final double cardSpacing;

  /// Default fixed column width.
  static const double defaultColumnWidth = 240;

  /// Default horizontal gap between columns.
  static const double defaultColumnSpacing = 12;

  /// Default vertical gap between cards in a column.
  static const double defaultCardSpacing = 8;

  /// Column surface fill (light system gray).
  static const Color columnBackground = Color(0xFFF2F2F7);

  /// Column hairline border.
  static const Color columnBorder = Color(0x14000000);

  /// Column corner radius.
  static const double columnRadius = 12;

  /// Column padding on all sides.
  static const EdgeInsets columnPadding = EdgeInsets.all(12);

  /// Column-title color (SF iOS secondary label).
  static const Color titleColor = Color(0xFF8E8E93);

  /// Column-title text style (SF semibold 13pt uppercase).
  static const TextStyle titleStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: titleColor,
    letterSpacing: 0.5,
    height: 1.2,
  );

  /// Vertical gap between column title and the first card.
  static const double titleBottomGap = 12;

  /// Card surface fill.
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Card hairline border.
  static const Color cardBorder = Color(0x14000000);

  /// Card corner radius.
  static const double cardRadius = 10;

  /// Card padding on all sides.
  static const EdgeInsets cardPadding = EdgeInsets.all(12);

  /// Soft shadow used for static cards.
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x12000000),
    offset: Offset(0, 2),
    blurRadius: 6,
  );

  /// Elevated shadow used while a card is being dragged.
  static const BoxShadow dragShadow = BoxShadow(
    color: Color(0x33000000),
    offset: Offset(0, 6),
    blurRadius: 16,
  );

  /// iOS-blue accent used for the drop-zone hint line.
  static const Color dropHintColor = Color(0xFF007AFF);

  /// Drop-zone hint line thickness.
  static const double dropHintThickness = 2;

  /// Slight rotation angle (radians) applied to the drag feedback —
  /// roughly 2 degrees.
  static const double feedbackRotation = 0.0349;

  /// Opacity applied to the source card while it is being dragged.
  static const double dragSourceOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    final palette = _KanbanPalette.resolve(context);
    final children = <Widget>[];
    for (var i = 0; i < columns.length; i++) {
      children.add(_buildColumn(columns[i], palette));
      if (i != columns.length - 1) {
        children.add(SizedBox(width: columnSpacing));
      }
    }
    final body = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
    // Draggable requires an Overlay ancestor to host the drag feedback.
    // Keep the entry stable, but rebuild its child when the stateless
    // board receives new columns after a drop.
    return _KanbanOverlayHost(child: body);
  }

  Widget _buildColumn(LiqKanbanColumn column, _KanbanPalette palette) {
    final resolved = <LiqKanbanCard>[];
    for (final id in column.cardIds) {
      final card = cards[id];
      if (card != null) resolved.add(card);
    }

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: titleBottomGap),
        child: Text(
          column.title.toUpperCase(),
          style: titleStyle.copyWith(color: palette.title),
        ),
      ),
    ];
    for (var i = 0; i < resolved.length; i++) {
      children.add(
        _KanbanCardSlot(
          column: column,
          card: resolved[i],
          index: i,
          cardSpacing: cardSpacing,
          palette: palette,
          onMove: onMove,
        ),
      );
    }
    children.add(
      _KanbanColumnFooterTarget(
        column: column,
        index: resolved.length,
        cardSpacing: cardSpacing,
        hasCards: resolved.isNotEmpty,
        onMove: onMove,
      ),
    );

    return DragTarget<_LiqKanbanDragData>(
      onWillAcceptWithDetails:
          (details) => details.data.fromColumnId != column.id,
      onAcceptWithDetails: (details) {
        onMove(
          details.data.cardId,
          details.data.fromColumnId,
          column.id,
          resolved.length,
        );
      },
      builder: (context, candidate, rejected) {
        final dropping = candidate.isNotEmpty;
        return SizedBox(
          width: columnWidth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            padding: columnPadding,
            decoration: BoxDecoration(
              color:
                  dropping
                      ? palette.columnHoverBackground
                      : palette.columnBackground,
              borderRadius: BorderRadius.circular(columnRadius),
              border: Border.all(
                color:
                    dropping ? LiqKanban.dropHintColor : palette.columnBorder,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    var totalCards = 0;
    for (final c in columns) {
      totalCards += c.cardIds.length;
    }
    properties
      ..add(IntProperty('columnsCount', columns.length))
      ..add(IntProperty('totalCards', totalCards))
      ..add(DoubleProperty('columnWidth', columnWidth));
  }
}

class _KanbanOverlayHost extends StatefulWidget {
  const _KanbanOverlayHost({required this.child});

  final Widget child;

  @override
  State<_KanbanOverlayHost> createState() => _KanbanOverlayHostState();
}

class _KanbanOverlayHostState extends State<_KanbanOverlayHost> {
  late final OverlayEntry _entry = OverlayEntry(builder: (_) => widget.child);

  @override
  void didUpdateWidget(covariant _KanbanOverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _entry.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _entry
      ..remove()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(initialEntries: <OverlayEntry>[_entry]);
  }
}

/// One card row inside a column. Combines the drag source (the card
/// itself) with a drop target sized over the card's leading edge so a
/// drop snaps cards to slot `index` (i.e. above this card).
class _KanbanCardSlot extends StatelessWidget {
  const _KanbanCardSlot({
    required this.column,
    required this.card,
    required this.index,
    required this.cardSpacing,
    required this.palette,
    required this.onMove,
  });

  final LiqKanbanColumn column;
  final LiqKanbanCard card;
  final int index;
  final double cardSpacing;
  final _KanbanPalette palette;
  final void Function(
    String cardId,
    String fromColumnId,
    String toColumnId,
    int toIndex,
  )
  onMove;

  @override
  Widget build(BuildContext context) {
    return DragTarget<_LiqKanbanDragData>(
      onWillAcceptWithDetails: (details) => details.data.cardId != card.id,
      onAcceptWithDetails: (details) {
        onMove(
          details.data.cardId,
          details.data.fromColumnId,
          column.id,
          index,
        );
      },
      builder: (context, candidate, rejected) {
        final dropping = candidate.isNotEmpty;
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : cardSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (dropping)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _DropHintLine(),
                ),
              _KanbanCardDraggable(
                column: column,
                card: card,
                palette: palette,
                onMove: onMove,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The card itself — drag source. Shows the resting card normally, a
/// dimmed copy in the source position while dragging, and a slightly
/// rotated, more-elevated copy as drag feedback.
class _KanbanCardDraggable extends StatelessWidget {
  const _KanbanCardDraggable({
    required this.column,
    required this.card,
    required this.palette,
    required this.onMove,
  });

  final LiqKanbanColumn column;
  final LiqKanbanCard card;
  final _KanbanPalette palette;
  final void Function(
    String cardId,
    String fromColumnId,
    String toColumnId,
    int toIndex,
  )
  onMove;

  @override
  Widget build(BuildContext context) {
    final resting = _KanbanCardSurface(palette: palette, child: card.child);
    return Draggable<_LiqKanbanDragData>(
      data: _LiqKanbanDragData(cardId: card.id, fromColumnId: column.id),
      feedback: _KanbanCardFeedback(palette: palette, child: card.child),
      childWhenDragging: Opacity(
        opacity: LiqKanban.dragSourceOpacity,
        child: resting,
      ),
      child: resting,
    );
  }
}

/// Footer drop target — a thin sliver below the last card that accepts
/// drops at the end of the column.
class _KanbanColumnFooterTarget extends StatelessWidget {
  const _KanbanColumnFooterTarget({
    required this.column,
    required this.index,
    required this.cardSpacing,
    required this.hasCards,
    required this.onMove,
  });

  final LiqKanbanColumn column;
  final int index;
  final double cardSpacing;
  final bool hasCards;
  final void Function(
    String cardId,
    String fromColumnId,
    String toColumnId,
    int toIndex,
  )
  onMove;

  @override
  Widget build(BuildContext context) {
    return DragTarget<_LiqKanbanDragData>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        onMove(
          details.data.cardId,
          details.data.fromColumnId,
          column.id,
          index,
        );
      },
      builder: (context, candidate, rejected) {
        final dropping = candidate.isNotEmpty;
        final base = SizedBox(height: hasCards ? cardSpacing : 24);
        if (!dropping) return base;
        return Padding(
          padding: EdgeInsets.only(top: hasCards ? cardSpacing : 0),
          child: _DropHintLine(),
        );
      },
    );
  }
}

/// Dashed iOS-blue hint line shown between cards while the user is
/// hovering a drop slot.
class _DropHintLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: LiqKanban.dropHintThickness,
      child: CustomPaint(painter: _DashedLinePainter()),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = LiqKanban.dropHintColor
          ..strokeWidth = LiqKanban.dropHintThickness
          ..strokeCap = StrokeCap.round;
    const dash = 4.0;
    const gap = 3.0;
    final y = size.height / 2;
    var x = 0.0;
    while (x < size.width) {
      final next = (x + dash).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, y), Offset(next, y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}

/// Resting / source card surface (white, hairline border, soft shadow).
class _KanbanCardSurface extends StatelessWidget {
  const _KanbanCardSurface({required this.child, required this.palette});

  final Widget child;
  final _KanbanPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(LiqKanban.cardRadius),
        border: Border.all(color: palette.cardBorder, width: 0.5),
        boxShadow: const <BoxShadow>[LiqKanban.cardShadow],
      ),
      padding: LiqKanban.cardPadding,
      child: DefaultTextStyle.merge(
        style: TextStyle(fontSize: 13, color: palette.cardText),
        child: child,
      ),
    );
  }
}

/// Drag feedback — a slightly rotated, more-elevated copy of the card.
class _KanbanCardFeedback extends StatelessWidget {
  const _KanbanCardFeedback({required this.child, required this.palette});

  final Widget child;
  final _KanbanPalette palette;

  @override
  Widget build(BuildContext context) {
    final dir = Directionality.maybeOf(context) ?? TextDirection.ltr;
    return Directionality(
      textDirection: dir,
      child: SizedBox(
        width: LiqKanban.defaultColumnWidth - 24,
        child: Transform.rotate(
          angle: LiqKanban.feedbackRotation,
          child: Container(
            decoration: BoxDecoration(
              color: palette.cardBackground,
              borderRadius: BorderRadius.circular(LiqKanban.cardRadius),
              border: Border.all(color: palette.cardBorder, width: 0.5),
              boxShadow: const <BoxShadow>[LiqKanban.dragShadow],
            ),
            padding: LiqKanban.cardPadding,
            child: DefaultTextStyle.merge(
              style: TextStyle(fontSize: 13, color: palette.cardText),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

final class _KanbanPalette {
  const _KanbanPalette({
    required this.columnBackground,
    required this.columnHoverBackground,
    required this.columnBorder,
    required this.title,
    required this.cardBackground,
    required this.cardBorder,
    required this.cardText,
  });

  factory _KanbanPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _KanbanPalette(
        columnBackground: LiqKanban.columnBackground,
        columnHoverBackground: Color(0xFFEAF4FF),
        columnBorder: LiqKanban.columnBorder,
        title: LiqKanban.titleColor,
        cardBackground: LiqKanban.cardBackground,
        cardBorder: LiqKanban.cardBorder,
        cardText: Color(0xFF1C1C1E),
      );
    }

    final secondary = context.liqSecondaryLabelColor;
    return _KanbanPalette(
      columnBackground: secondary.withValues(alpha: 0.10),
      columnHoverBackground: const Color(0xFF007AFF).withValues(alpha: 0.18),
      columnBorder: secondary.withValues(alpha: 0.16),
      title: secondary,
      cardBackground: context.liqSurfaceColor,
      cardBorder: secondary.withValues(alpha: 0.18),
      cardText: context.liqLabelColor,
    );
  }

  final Color columnBackground;
  final Color columnHoverBackground;
  final Color columnBorder;
  final Color title;
  final Color cardBackground;
  final Color cardBorder;
  final Color cardText;
}
