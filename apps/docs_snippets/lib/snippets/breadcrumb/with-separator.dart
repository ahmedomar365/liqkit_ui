// ignore_for_file: file_names // hyphenated name required by snippet manifest convention

import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget breadcrumbWithSeparatorBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 520,
    height: 88,
    surface: SnippetFrameSurface.themed,
    surfacePadding: const EdgeInsets.symmetric(horizontal: 18),
    // {@highlight}
    child: LiqBreadcrumb(
      separator: const Icon(
        Icons.chevron_right,
        size: 14,
        color: Color(0xFFC7C7CC),
      ),
      items: <LiqBreadcrumbItem>[
        LiqBreadcrumbItem(label: 'Home', onPressed: () {}),
        LiqBreadcrumbItem(label: 'Library', onPressed: () {}),
        LiqBreadcrumbItem(label: 'Components', onPressed: () {}),
        const LiqBreadcrumbItem(label: 'Breadcrumb'),
      ],
    ),
    // {@endhighlight}
  );
}
