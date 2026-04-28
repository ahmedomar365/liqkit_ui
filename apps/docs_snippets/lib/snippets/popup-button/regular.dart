import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget popupButtonRegularBuilder(BuildContext context) {
  return Center(
    child: LiqDemo<int>(
      initial: 0,
      builder: (v, set) {
        // {@highlight}
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LiqPopupButton(label: 'Today', onPressed: () => set(v + 1)),
            if (v > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Tapped $v time${v == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ),
          ],
        );
        // {@endhighlight}
      },
    ),
  );
}
