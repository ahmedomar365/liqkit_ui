import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget stepperDefaultBuilder(BuildContext context) {
  return SnippetFrame(
    child: LiqDemo<int>(
      initial: 3,
      builder: (v, set) {
        // {@highlight}
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$v',
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 34,
                height: 41 / 34,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 10),
            LiqStepper(value: v, onChanged: set),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
