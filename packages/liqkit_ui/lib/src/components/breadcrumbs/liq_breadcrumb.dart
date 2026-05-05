import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// One crumb in a [LiqBreadcrumb] trail.
///
/// The last crumb in a trail is typically the current page and has
/// [onPressed] set to `null` — it renders as plain semibold text rather
/// than a tappable link.
final class LiqBreadcrumbItem with Diagnosticable {
  /// Creates a breadcrumb entry.
  const LiqBreadcrumbItem({required this.label, this.onPressed});

  /// Text shown for this crumb.
  final String label;

  /// Tap callback. Set to `null` to render the crumb as static text
  /// (the last crumb in a trail is typically non-tappable).
  final VoidCallback? onPressed;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(
        FlagProperty(
          'onPressed',
          value: onPressed != null,
          ifTrue: 'tappable',
          ifFalse: 'static',
        ),
      );
  }
}

/// iOS 26 navigation trail — a horizontal list of crumbs separated by
/// a divider widget showing the current page hierarchy.
///
/// Each crumb in [items] renders as a tappable link in iOS system blue
/// when its [LiqBreadcrumbItem.onPressed] is non-null. The final crumb
/// is rendered in semibold iOS primary-label color and is never a link
/// regardless of its callback. Trails stay on one horizontal line and
/// scroll when space is tight so the hierarchy remains visually intact.
final class LiqBreadcrumb extends StatelessWidget with Diagnosticable {
  /// Creates a breadcrumb trail.
  const LiqBreadcrumb({
    required this.items,
    this.separator = _defaultSeparator,
    this.spacing = 8,
    super.key,
  });

  /// Ordered crumbs from root to current page.
  final List<LiqBreadcrumbItem> items;

  /// Widget rendered between adjacent crumbs.
  final Widget separator;

  /// Horizontal gap on each side of [separator].
  final double spacing;

  /// Active link color (iOS 26 system blue).
  static const Color activeColor = Color(0xFF007AFF);

  /// Active link color in dark theme.
  static const Color darkActiveColor = Color(0xFF0091FF);

  /// Inactive (current page) text color.
  static const Color inactiveColor = Color(0xFF1C1C1E);

  /// Inactive (current page) text color in dark theme.
  static const Color darkInactiveColor = Color(0xFFFFFFFF);

  /// Default separator color.
  static const Color separatorColor = Color(0xFFC7C7CC);

  /// Default separator color in dark theme.
  static const Color darkSeparatorColor = Color(0x66EBEBF5);

  /// Default font size for crumbs and the default separator.
  static const double fontSize = 14;

  /// Minimum tap target height for tappable crumbs.
  static const double tapTargetHeight = 44;

  /// Style applied to tappable crumbs.
  static const TextStyle activeTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    color: activeColor,
  );

  /// Style applied to the final, non-tappable crumb.
  static const TextStyle inactiveTextStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    color: inactiveColor,
  );

  @override
  Widget build(BuildContext context) {
    final brightness = context.liqBrightness;
    final isDark = brightness == Brightness.dark;
    final activeStyle = activeTextStyle.copyWith(
      color: isDark ? darkActiveColor : activeColor,
    );
    final inactiveStyle = inactiveTextStyle.copyWith(
      color: isDark ? darkInactiveColor : inactiveColor,
    );
    final effectiveSeparator =
        identical(separator, _defaultSeparator)
            ? Text(
              '/',
              style: TextStyle(
                color: isDark ? darkSeparatorColor : separatorColor,
                fontSize: fontSize,
              ),
            )
            : separator;
    final children = <Widget>[];
    final lastIndex = items.length - 1;
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == lastIndex;
      final tappable = !isLast && item.onPressed != null;
      final style = isLast ? inactiveStyle : activeStyle;
      final text = Text(
        item.label,
        style: style,
        textDirection: TextDirection.ltr,
      );
      if (tappable) {
        children.add(
          LiqPointerCursor(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: item.onPressed,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: tapTargetHeight),
                child: Center(widthFactor: 1, heightFactor: 1, child: text),
              ),
            ),
          ),
        );
      } else {
        children.add(text);
      }
      if (!isLast) {
        children
          ..add(SizedBox(width: spacing))
          ..add(effectiveSeparator)
          ..add(SizedBox(width: spacing));
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('count', items.length))
      ..add(
        StringProperty('firstLabel', items.isEmpty ? null : items.first.label),
      )
      ..add(
        StringProperty('lastLabel', items.isEmpty ? null : items.last.label),
      );
  }
}

const Widget _defaultSeparator = Text(
  '/',
  style: TextStyle(color: LiqBreadcrumb.separatorColor, fontSize: 14),
);
