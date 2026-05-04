// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget kanbanDenseBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 760,
    // {@highlight}
    child: _KanbanDenseDemo(),
    // {@endhighlight}
  );
}

class _KanbanDenseDemo extends StatefulWidget {
  const _KanbanDenseDemo();
  @override
  State<_KanbanDenseDemo> createState() => _KanbanDenseDemoState();
}

class _KanbanDenseDemoState extends State<_KanbanDenseDemo> {
  final Map<String, LiqKanbanCard> _cards = <String, LiqKanbanCard>{
    '1': const LiqKanbanCard(id: '1', child: Text('Triage inbox')),
    '2': const LiqKanbanCard(id: '2', child: Text('Audit color tokens')),
    '3': const LiqKanbanCard(id: '3', child: Text('Spec kanban v1')),
    '4': const LiqKanbanCard(id: '4', child: Text('Implement DragTarget gaps')),
    '5': const LiqKanbanCard(id: '5', child: Text('Snippet manifests')),
    '6': const LiqKanbanCard(id: '6', child: Text('Generate routes.g.dart')),
    '7': const LiqKanbanCard(id: '7', child: Text('Pixel-perfect golden')),
    '8': const LiqKanbanCard(id: '8', child: Text('Ship to docs site')),
  };

  List<LiqKanbanColumn> _columns = const <LiqKanbanColumn>[
    LiqKanbanColumn(
      id: 'backlog',
      title: 'BACKLOG',
      cardIds: <String>['1', '2'],
    ),
    LiqKanbanColumn(id: 'todo', title: 'TO DO', cardIds: <String>['3', '4']),
    LiqKanbanColumn(id: 'doing', title: 'DOING', cardIds: <String>['5', '6']),
    LiqKanbanColumn(id: 'done', title: 'DONE', cardIds: <String>['7', '8']),
  ];

  void _onMove(
    String cardId,
    String fromColumnId,
    String toColumnId,
    int toIndex,
  ) {
    setState(() {
      _columns =
          _columns.map((col) {
            if (col.id == fromColumnId && col.id == toColumnId) {
              final next = List<String>.from(col.cardIds)..remove(cardId);
              next.insert(toIndex.clamp(0, next.length), cardId);
              return LiqKanbanColumn(
                id: col.id,
                title: col.title,
                cardIds: next,
              );
            }
            if (col.id == fromColumnId) {
              return LiqKanbanColumn(
                id: col.id,
                title: col.title,
                cardIds: List<String>.from(col.cardIds)..remove(cardId),
              );
            }
            if (col.id == toColumnId) {
              final next = List<String>.from(col.cardIds);
              next.insert(toIndex.clamp(0, next.length), cardId);
              return LiqKanbanColumn(
                id: col.id,
                title: col.title,
                cardIds: next,
              );
            }
            return col;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: LiqKanban(
        columns: _columns,
        cards: _cards,
        onMove: _onMove,
        columnWidth: 180,
      ),
    );
  }
}
