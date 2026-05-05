// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget drawerRightBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 360,
    height: 220,
    surface: SnippetFrameSurface.liquidThemed,
    surfacePadding: EdgeInsets.zero,
    surfaceScrimOpacity: 0.4,
    child: Align(
      alignment: Alignment.centerRight,
      // {@highlight}
      child: LiqDrawer(
        side: LiqDrawerSide.right,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Filters', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Text('Unread'),
            SizedBox(height: 8),
            Text('Starred'),
            SizedBox(height: 8),
            Text('Archived'),
          ],
        ),
      ),
      // {@endhighlight}
    ),
  );
}
