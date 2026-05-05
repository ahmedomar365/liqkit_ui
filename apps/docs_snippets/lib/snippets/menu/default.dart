import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/material.dart' show Icon, Icons;
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget menuDefaultBuilder(BuildContext context) {
  // {@highlight}
  return SnippetFrame(
    maxWidth: 380,
    height: 560,
    surface: SnippetFrameSurface.liquidThemed,
    child: LiqMenu(
      quickActions: <LiqMenuQuickAction>[
        LiqMenuQuickAction(
          label: 'Copy',
          icon: const Icon(Icons.content_copy_rounded, size: 18),
          onPressed: () {},
        ),
        LiqMenuQuickAction(
          label: 'Share',
          icon: const Icon(Icons.ios_share_rounded, size: 18),
          onPressed: () {},
        ),
        LiqMenuQuickAction(
          label: 'Delete',
          icon: const Icon(Icons.delete_outline_rounded, size: 18),
          destructive: true,
          onPressed: () {},
        ),
      ],
      children: <Widget>[
        LiqMenuItem(
          label: 'Copy',
          icon: const Icon(Icons.content_copy_rounded),
          trailing: const Text('Cmd C'),
          onPressed: () {},
        ),
        LiqMenuItem(
          label: 'Paste',
          icon: const Icon(Icons.content_paste_rounded),
          trailing: const Text('Cmd V'),
          onPressed: () {},
        ),
        const LiqMenuItem(
          label: 'Disabled Action',
          icon: Icon(Icons.crop_square_rounded),
          trailing: Text('Cmd B'),
        ),
        const LiqMenuSeparator(),
        LiqMenuItem(
          label: 'Delete',
          icon: const Icon(Icons.delete_outline_rounded),
          trailing: const Text('Del'),
          style: LiqMenuItemStyle.destructive,
          onPressed: () {},
        ),
      ],
    ),
  );
  // {@endhighlight}
}
