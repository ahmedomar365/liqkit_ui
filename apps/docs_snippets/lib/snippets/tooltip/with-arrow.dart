// ignore_for_file: file_names // hyphenated name required by snippet manifest convention

import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget tooltipWithArrowBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 360,
    height: 260,
    child: Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          top: 124,
          child:
          // {@highlight}
          LiqTooltip(
            message:
                'Create a brand new project. Tooltips wrap to multiple lines '
                'when the message is longer than 240pt.',
            child: LiqButton(label: 'New', onPressed: () {}),
          ),
          // {@endhighlight}
        ),
        const Positioned(
          bottom: 24,
          child: SnippetLabel(
            'Long-press or hover to reveal the tooltip.',
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}
