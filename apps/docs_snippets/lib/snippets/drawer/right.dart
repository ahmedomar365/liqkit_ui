// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget drawerRightBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 360,
        height: 220,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: const ColoredBox(
            color: Color(0xFFEFEFF4),
            child: Stack(
              children: <Widget>[
                Positioned.fill(child: ColoredBox(color: Color(0x66000000))),
                Align(
                  alignment: Alignment.centerRight,
                  // {@highlight}
                  child: LiqDrawer(
                    side: LiqDrawerSide.right,
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Filters',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 12),
                        Text('Unread'),
                        SizedBox(height: 8),
                        Text('Starred'),
                        SizedBox(height: 8),
                        Text('Archived'),
                      ],
                    ),
                  ),
                  // {@endhighlight}
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
