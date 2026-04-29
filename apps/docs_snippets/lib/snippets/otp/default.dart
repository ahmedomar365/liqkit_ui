import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget otpDefaultBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<String>(
        initial: '',
        builder:
            (v, set) => SizedBox(
              width: 360,
              // {@highlight}
              child: LiqOtpInput(value: v, onChanged: set),
              // {@endhighlight}
            ),
      ),
    ),
  );
}
