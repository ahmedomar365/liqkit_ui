// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget kanbanDefaultBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: _KanbanDemo(),
      // {@endhighlight}
    ),
  );
}

class _KanbanDemo extends StatefulWidget {
  const _KanbanDemo();
  @override
  State<_KanbanDemo> createState() => _KanbanDemoState();
}

class _KanbanDemoState extends State<_KanbanDemo> {
  final Map<String, LiqKanbanCard> _cards = <String, LiqKanbanCard>{
    'a': const LiqKanbanCard(id: 'a', child: Text('Design system audit')),
    'b': const LiqKanbanCard(id: 'b', child: Text('Add Phase 5 components')),
    'c': const LiqKanbanCard(id: 'c', child: Text('Cloudflare Pages deploy')),
    'd': const LiqKanbanCard(id: 'd', child: Text('Wire ⌘K search')),
    'e': const LiqKanbanCard(id: 'e', child: Text('Pixel goldens')),
  };

  List<LiqKanbanColumn> _columns = const <LiqKanbanColumn>[
    LiqKanbanColumn(id: 'todo', title: 'TO DO', cardIds: <String>['a', 'c']),
    LiqKanbanColumn(id: 'doing', title: 'DOING', cardIds: <String>['b']),
    LiqKanbanColumn(id: 'done', title: 'DONE', cardIds: <String>['d', 'e']),
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
      child: LiqKanban(columns: _columns, cards: _cards, onMove: _onMove),
    );
  }
}
