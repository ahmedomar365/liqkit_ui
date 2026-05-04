// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget scrollAreaHorizontalBuilder(BuildContext context) {
  return SnippetFrame(
    height: 80,
    // {@highlight}
    child: LiqScrollArea(
      axis: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List<Widget>.generate(
          24,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SnippetLabel('Item ${i + 1}', fontSize: 14),
          ),
        ),
      ),
    ),
    // {@endhighlight}
  );
}
