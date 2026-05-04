import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget otpDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 360,
    child: LiqDemo<String>(
      initial: '',
      builder:
          (v, set) =>
          // {@highlight}
          LiqOtpInput(value: v, onChanged: set),
      // {@endhighlight}
    ),
  );
}
