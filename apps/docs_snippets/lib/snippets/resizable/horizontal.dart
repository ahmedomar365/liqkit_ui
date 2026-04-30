import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

const TextStyle _label = TextStyle(
  fontFamily: 'SF Pro Text',
  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Color(0xFF1C1C1E),
);

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget resizableHorizontalBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 480,
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: ColoredBox(
            color: Color(0xFFEFEFF4),
            // {@highlight}
            child: LiqResizable(
              first: ColoredBox(
                color: Color(0xFFFAFAFA),
                child: Center(
                  child: Text(
                    'Left',
                    textDirection: TextDirection.ltr,
                    style: _label,
                  ),
                ),
              ),
              second: ColoredBox(
                color: Color(0xFFFFFFFF),
                child: Center(
                  child: Text(
                    'Right',
                    textDirection: TextDirection.ltr,
                    style: _label,
                  ),
                ),
              ),
            ),
            // {@endhighlight}
          ),
        ),
      ),
    ),
  );
}
