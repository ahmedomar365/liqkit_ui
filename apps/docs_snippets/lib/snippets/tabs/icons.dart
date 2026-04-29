import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget tabsIconsBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: LiqDemo<int>(
      initial: 0,
      builder: (i, set) {
        // {@highlight}
        return SizedBox(
          width: 280,
          child: LiqTabs(
            variant: LiqTabsVariant.pill,
            items: const <LiqTabItem>[
              LiqTabItem(icon: Icons.home_filled),
              LiqTabItem(icon: Icons.search),
              LiqTabItem(icon: Icons.person_outline),
            ],
            selectedIndex: i,
            onChanged: set,
          ),
        );
        // {@endhighlight}
      },
    ),
  );
}
