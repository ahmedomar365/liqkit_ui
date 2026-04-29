import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
/// regardless of its callback. Trails wrap onto multiple lines on
/// narrow screens.
final class LiqBreadcrumb extends StatelessWidget with Diagnosticable {
  /// Creates a breadcrumb trail.
  const LiqBreadcrumb({
    required this.items,
    this.separator = const Text(
      '/',
      style: TextStyle(color: Color(0xFFC7C7CC), fontSize: 14),
    ),
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

  /// Inactive (current page) text color.
  static const Color inactiveColor = Color(0xFF1C1C1E);

  /// Default font size for crumbs and the default separator.
  static const double fontSize = 14;

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
    final children = <Widget>[];
    final lastIndex = items.length - 1;
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == lastIndex;
      final tappable = !isLast && item.onPressed != null;
      final style = isLast ? inactiveTextStyle : activeTextStyle;
      final text = Text(
        item.label,
        style: style,
        textDirection: TextDirection.ltr,
      );
      if (tappable) {
        children.add(
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: item.onPressed,
            child: text,
          ),
        );
      } else {
        children.add(text);
      }
      if (!isLast) {
        children
          ..add(SizedBox(width: spacing))
          ..add(separator)
          ..add(SizedBox(width: spacing));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ),
      ],
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
