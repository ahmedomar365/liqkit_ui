import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget chipSingleBuilder(BuildContext context) {
  return const SnippetFrame(
    // {@highlight}
    child: Wrap(
      spacing: 6,
      runSpacing: 8,
      children: <Widget>[
        LiqChip(label: 'flutter', onPressed: _noop),
        LiqChip(label: 'dart', selected: true, onPressed: _noop),
        LiqChip(label: 'ios', onPressed: _noop),
      ],
    ),
    // {@endhighlight}
  );
}

void _noop() {}
