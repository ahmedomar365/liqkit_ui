import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget tooltipBottomBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // {@highlight}
          LiqTooltip(
            message: 'Add a new project',
            placement: LiqTooltipPlacement.bottom,
            child: LiqButton(label: 'New', onPressed: () {}),
          ),
          // {@endhighlight}
          const SizedBox(height: 12),
          const Text(
            'Long-press or hover to reveal the tooltip.',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
              color: Color(0xFF8E8E93),
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );
}
