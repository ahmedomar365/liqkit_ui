import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 Liquid Glass content surface for grouping arbitrary children.
///
/// Renders a rounded glass panel with optional [header] and [footer] slots
/// separated from the body by full-bleed hairline dividers. When [onTap]
/// is supplied, the surface becomes tappable and dims to 85% opacity while
/// pressed.
final class LiqCard extends StatelessWidget {
  /// Creates a generic content card.
  const LiqCard({
    required this.child,
    this.header,
    this.footer,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    super.key,
  });

  /// Body content rendered between the optional header and footer slots.
  final Widget child;

  /// Optional content rendered above the body, separated by a hairline
  /// divider.
  final Widget? header;

  /// Optional content rendered below the body, separated by a hairline
  /// divider.
  final Widget? footer;

  /// Padding applied around [child].
  final EdgeInsets padding;

  /// Tap callback. When non-null the card responds to taps and dims
  /// briefly while pressed.
  final VoidCallback? onTap;

  /// Outer surface corner radius in logical pixels.
  static const double cornerRadius = 16;

  /// Padding applied inside the [header] and [footer] slots.
  static const EdgeInsets slotPadding = EdgeInsets.all(16);

  /// Outer hairline border thickness in logical pixels.
  static const double borderThickness = 0.5;

  /// Header / footer divider thickness in logical pixels.
  static const double dividerThickness = 0.33;

  /// Surface background color.
  static const Color background = Color(0xFFFAFAFA);

  /// Outer hairline border color.
  static const Color borderColor = Color(0x14000000);

  /// Header / footer divider color.
  static const Color dividerColor = Color(0x29000000);

  /// Header / footer divider color in dark theme.
  static const Color darkDividerColor = Color(0x29FFFFFF);

  /// Soft drop shadow color.
  static const Color shadowColor = Color(0x12000000);

  /// Soft drop shadow used by every card regardless of [onTap] state.
  static const BoxShadow shadow = BoxShadow(
    color: shadowColor,
    offset: Offset(0, 6),
    blurRadius: 16,
  );

  @override
  Widget build(BuildContext context) {
    final columnChildren = <Widget>[];

    if (header != null) {
      columnChildren
        ..add(Padding(padding: slotPadding, child: header))
        ..add(_divider(context));
    }
    columnChildren.add(Padding(padding: padding, child: child));
    if (footer != null) {
      columnChildren
        ..add(_divider(context))
        ..add(Padding(padding: slotPadding, child: footer));
    }

    final brightness = context.liqBrightness;
    final Widget surface = LiqGlassSurface(
      tint:
          brightness == Brightness.dark
              ? LiqGlassTint.dark
              : LiqGlassTint.opaque,
      elevation: LiqGlassElevation.flat,
      borderRadius: BorderRadius.circular(cornerRadius),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: context.liqLabelColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: columnChildren,
        ),
      ),
    );

    if (onTap == null) {
      return surface;
    }

    return _PressableSurface(onTap: onTap!, child: surface);
  }

  static Widget _divider(BuildContext context) {
    final brightness = context.liqBrightness;
    return Container(
      height: dividerThickness,
      color: brightness == Brightness.dark ? darkDividerColor : dividerColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('hasHeader', header != null))
      ..add(DiagnosticsProperty<bool>('hasFooter', footer != null))
      ..add(DiagnosticsProperty<bool>('hasOnTap', onTap != null));
  }
}

class _PressableSurface extends StatefulWidget {
  const _PressableSurface({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_PressableSurface> createState() => _PressableSurfaceState();
}

class _PressableSurfaceState extends State<_PressableSurface> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (TapDownDetails _) => _setPressed(true),
      onTapUp: (TapUpDetails _) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        opacity: _pressed ? 0.85 : 1,
        duration: LiqMotion.fast,
        curve: LiqMotion.snappy,
        child: widget.child,
      ),
    );
  }
}
