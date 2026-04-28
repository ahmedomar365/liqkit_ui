// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget appIconWithCaptionBuilder(BuildContext context) {
  // {@highlight}
  return const Center(
    child: LiqAppIcon(
      color: Color(0xFFFF9500),
      label: 'Messages',
    ),
  );
  // {@endhighlight}
}
