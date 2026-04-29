import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget dividerHorizontalBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      // {@highlight}
      child: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Section A'),
            SizedBox(height: 12),
            LiqDivider(),
            SizedBox(height: 12),
            Text('Section B'),
          ],
        ),
      ),
      // {@endhighlight}
    ),
  );
}
