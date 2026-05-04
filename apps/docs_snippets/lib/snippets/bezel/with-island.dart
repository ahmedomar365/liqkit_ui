// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget bezelWithIslandBuilder(BuildContext context) {
  // {@highlight}
  return const SnippetFrame(
    maxWidth: 260,
    child: LiqDeviceBezel(size: Size(220, 478)),
  );
  // {@endhighlight}
}
