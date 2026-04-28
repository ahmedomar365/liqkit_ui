// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget activityViewDefaultBuilder(BuildContext context) {
  // {@highlight}
  return Center(
    child: LiqActivitySheet(
      header: LiqActivityHeader(
        title: 'Design System.sketch',
        subtitle: '4.2 MB',
        onClose: () {},
      ),
      child: const Text(
        'Share this file with your team.',
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF1A1A1A),
        ),
      ),
    ),
  );
  // {@endhighlight}
}
