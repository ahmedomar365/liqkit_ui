import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 home-screen app icon — squircle tile with optional badge.
///
/// Sourced from `native/components/app-icons.css` (`.ios26-app-icons-image`):
/// 66pt square, 14pt corner radius. Icon background can be a single [color]
/// or a vertical [gradient]. Optional [glyph] is rendered centered, and an
/// [badge] (e.g. unread count) appears at the top-right.
final class LiqAppIcon extends StatelessWidget {
  /// Creates an app icon.
  const LiqAppIcon({
    this.size = 66,
    this.color,
    this.gradient,
    this.glyph,
    this.badge,
    this.label,
    this.onPressed,
    super.key,
  }) : assert(
         color != null || gradient != null,
         'LiqAppIcon needs either color or gradient.',
       );

  /// Tile dimension (square).
  final double size;

  /// Solid background color (used when [gradient] is null).
  final Color? color;

  /// Optional vertical gradient for the tile.
  final Gradient? gradient;

  /// Optional centered glyph (typically a small SVG or icon widget).
  final Widget? glyph;

  /// Optional badge (e.g. [LiqAppIconBadge]) — top-right.
  final Widget? badge;

  /// Optional caption rendered below the tile.
  final String? label;

  /// Tap callback.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = size * (14 / 66);
    final labelColor =
        context.liqIsDark ? const Color(0xFFFFFFFF) : const Color(0xFF12161F);
    final tile = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: glyph,
    );

    final stack = SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          tile,
          if (badge != null) Positioned(top: -4, right: -4, child: badge!),
        ],
      ),
    );

    Widget content = Semantics(
      button: onPressed != null,
      label: label,
      child: LiqPointerCursor(
        enabled: onPressed != null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: stack,
        ),
      ),
    );

    if (label != null) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          content,
          const SizedBox(height: 6),
          SizedBox(
            width: size + 24,
            child: Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                fontFamily: 'SF Pro Text',
                fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                fontSize: 11,
                height: 14 / 11,
                fontWeight: FontWeight.w400,
              ).copyWith(color: labelColor),
            ),
          ),
        ],
      );
    }

    return content;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('size', size))
      ..add(StringProperty('label', label))
      ..add(ColorProperty('color', color));
  }
}

/// Small red badge rendered at the top-right of a [LiqAppIcon].
final class LiqAppIconBadge extends StatelessWidget {
  /// Creates a badge.
  const LiqAppIconBadge({required this.count, super.key});

  /// Number to display.
  final int count;

  static const Color _bg = Color(0xFFFF3B30);
  static const Color _fg = Color(0xFFFFFFFF);
  static const Color _ring = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        border: Border.all(color: _ring, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          fontFamily: 'SF Pro Text',
          fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
          fontSize: 12,
          height: 14 / 12,
          fontWeight: FontWeight.w600,
          color: _fg,
        ),
      ),
    );
  }
}
