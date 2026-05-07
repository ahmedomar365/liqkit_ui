// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/material.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget drawerLeftBuilder(BuildContext context) {
  return const SnippetFrame(
    maxWidth: 620,
    height: 260,
    surface: SnippetFrameSurface.liquidThemed,
    surfacePadding: EdgeInsets.zero,
    surfaceScrimOpacity: 0.4,
    child: Stack(
      children: <Widget>[
        Positioned.fill(
          left: 240,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Color(0x3300A887)),
            child: Center(
              child: Icon(Icons.mail_outline, color: Color(0x66FFFFFF)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          // {@highlight}
          child: LiqDrawer(
            width: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Navigation',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 16),
                Text('Inbox'),
                SizedBox(height: 10),
                Text('Sent'),
                SizedBox(height: 10),
                Text('Drafts'),
              ],
            ),
          ),
          // {@endhighlight}
        ),
      ],
    ),
  );
}
