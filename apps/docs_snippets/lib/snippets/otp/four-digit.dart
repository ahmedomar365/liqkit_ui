// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget otpFourDigitBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 360,
    child: LiqDemo<String>(
      initial: '',
      builder:
          (v, set) =>
          // {@highlight}
          LiqOtpInput(value: v, onChanged: set, length: 4),
      // {@endhighlight}
    ),
  );
}
