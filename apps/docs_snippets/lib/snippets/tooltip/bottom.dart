import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget tooltipBottomBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 340,
    height: 260,
    child: Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          top: 58,
          child:
          // {@highlight}
          LiqTooltip(
            message: 'Add a new project',
            placement: LiqTooltipPlacement.bottom,
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
