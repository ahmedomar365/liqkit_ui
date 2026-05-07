// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/material.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget drawerCollapsedBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 620,
    height: 260,
    surface: SnippetFrameSurface.liquidThemed,
    surfacePadding: EdgeInsets.zero,
    surfaceScrimOpacity: 0.32,
    child: Stack(
      children: <Widget>[
        Positioned.fill(
          left: 72,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Color(0x332C7DFF)),
            child: Center(
              child: Text(
                'Content',
                style: TextStyle(
                  color: Color(0x99FFFFFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          // {@highlight}
          child: LiqDrawer(
            collapsed: true,
            collapsedWidth: 72,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.inbox, size: 22),
                SizedBox(height: 18),
                Icon(Icons.send_outlined, size: 22),
                SizedBox(height: 18),
                Icon(Icons.drafts_outlined, size: 22),
              ],
            ),
          ),
          // {@endhighlight}
        ),
      ],
    ),
  );
}
