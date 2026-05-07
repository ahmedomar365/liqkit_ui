import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Visual style for [LiqIconButton]. Mirrors `LiqButton`'s style axis
/// but with semantics that make sense for an icon-only circular button.
enum LiqIconButtonStyle {
  /// Solid translucent fill — the iOS top-bar / toolbar idiom.
  filled,

  /// No fill — bare icon, accent color label.
  borderless,

  /// iOS 26 liquid-glass surface.
  liquid,
}

/// Circular icon-only button.
///
/// iOS-26-aligned counterpart to a Material `IconButton`. Sized as a
/// 44×44 hit-target by default (matches Apple HIG minimum tap area).
final class LiqIconButton extends StatelessWidget {
  /// Creates a liqkit_ui icon button.
  const LiqIconButton({
    required this.icon,
    required this.onPressed,
    this.style = LiqIconButtonStyle.filled,
    this.size = 44,
    this.iconSize,
    this.color,
    this.semanticLabel,
    this.destructive = false,
    super.key,
  });

  /// The icon glyph (typically `LiqIcons.X` from `liqkit_ui_icons`).
  final IconData icon;

  /// Tap callback. When `null`, the button renders disabled.
  final VoidCallback? onPressed;

  /// Visual style.
  final LiqIconButtonStyle style;

  /// Outer button diameter in logical pixels (default 44 — Apple HIG).
  final double size;

  /// Optional icon size override. Defaults to `size * 0.5`.
  final double? iconSize;

  /// Optional explicit icon color override.
  final Color? color;

  /// Accessibility label.
  final String? semanticLabel;

  /// When true, applies the iOS 26 destructive (red) coloring.
  final bool destructive;

  static const Color _accentBlue = Color(0xFF0088FF);
  static const Color _accentRed = Color(0xFFFF383C);
  static const Color _labelPrimary = Color(0xFF000000);
  static const Color _labelPrimaryDark = Color(0xFFFFFFFF);
  static const Color _labelTertiary = Color(0x4D3C3C43);
  static const Color _labelTertiaryDark = Color(0x52EBEBF5);
  static const Color _fillSecondary = Color(0x2978788A);

  ({Color fill, Color label}) _resolve({required bool isDark}) {
    final disabled = onPressed == null;
    final labelTertiary = isDark ? _labelTertiaryDark : _labelTertiary;
    final labelPrimary = isDark ? _labelPrimaryDark : _labelPrimary;
    final activeColor = destructive ? _accentRed : _accentBlue;

    switch (style) {
      case LiqIconButtonStyle.filled:
        return (
          fill: _fillSecondary,
          label: disabled
              ? labelTertiary
              : (destructive ? _accentRed : labelPrimary),
        );
      case LiqIconButtonStyle.borderless:
        return (
          fill: const Color(0x00000000),
          label: disabled ? labelTertiary : activeColor,
        );
      case LiqIconButtonStyle.liquid:
        return (
          fill: const Color(0x00000000),
          label: disabled
              ? labelTertiary
              : (destructive ? _accentRed : labelPrimary),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolve(isDark: context.liqIsDark);
    final disabled = onPressed == null;
    final radius = BorderRadius.circular(size / 2);
    final iconColor = color ?? resolved.label;
    final iconPx = iconSize ?? size * 0.5;

    final body = Container(
      width: size,
      height: size,
      decoration: style == LiqIconButtonStyle.liquid
          ? null
          : BoxDecoration(color: resolved.fill, borderRadius: radius),
      alignment: Alignment.center,
      child: Icon(icon, size: iconPx, color: iconColor),
    );

    final visual = style == LiqIconButtonStyle.liquid
        ? LiqGlassSurface(
            borderRadius: radius,
            blurSigma: 18,
            elevation: LiqGlassElevation.flat,
            highlightStart: const Color(0x00FFFFFF),
            child: body,
          )
        : body;

    return Semantics(
      button: true,
      enabled: !disabled,
      label: semanticLabel,
      child: LiqPointerCursor(
        enabled: !disabled,
        child: GestureDetector(onTap: onPressed, child: visual),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(EnumProperty<LiqIconButtonStyle>('style', style))
      ..add(DoubleProperty('size', size))
      ..add(DoubleProperty('iconSize', iconSize, defaultValue: null))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(StringProperty('semanticLabel', semanticLabel, defaultValue: null))
      ..add(
        FlagProperty('destructive', value: destructive, ifTrue: 'destructive'),
      )
      ..add(
        FlagProperty(
          'enabled',
          value: onPressed != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}
