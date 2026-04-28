// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget windowInactiveControlsBuilder(BuildContext context) {
  // {@highlight}
  return const Align(
    heightFactor: 1,
    child: LiqWindow(
      size: Size(480, 300),
      toolbar: LiqWindowToolbar(
        leading: <Widget>[LiqWindowControls(active: false)],
        title: 'Document',
      ),
    ),
  );
  // {@endhighlight}
}
