import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Visual style of a [LiqButton], ported from liqkit's iOS 26 button
/// catalog (`figma_artifacts/buttons/`).
enum LiqButtonStyle {
  /// `bordered-prominent` — solid accent fill, white label.
  borderedProminent,

  /// `bordered` — translucent secondary fill, accent label.
  bordered,

  /// `bordered-secondary` — translucent tertiary fill, primary label.
  borderedSecondary,

  /// `borderless` — no fill, accent label.
  borderless,

  /// `liquid` — iOS 26 liquid-glass button backed by [LiqGlassSurface].
  liquid,
}

/// Size axis from the iOS 26 button catalog.
enum LiqButtonSize {
  /// 28pt height; 15/20 SF Pro Text.
  small,

  /// 34pt height; 15/20 SF Pro Text (-0.24 tracking).
  medium,

  /// 50pt height; 17/22 SF Pro Text (-0.43 tracking).
  large,
}

/// iOS 26 button.
///
/// All visual values are sourced from liqkit's `buttons.css`:
///   --btn-accent-blue: #0088ff
///   --btn-accent-red:  #ff383c
///   --btn-fill-secondary:  #78788029
///   --btn-fill-tertiary:   #7676801f
///   --btn-prominent-disabled-bg: #0088ff33
///   --btn-destructive-bg: #ff383c24
///   --btn-destructive-bg-prominent: #ff383c33
///   border-radius: 999px (full pill)
final class LiqButton extends StatelessWidget {
  /// Creates a liqkit_ui button.
  const LiqButton({
    required this.label,
    required this.onPressed,
    this.style = LiqButtonStyle.borderedProminent,
    this.size = LiqButtonSize.medium,
    this.destructive = false,
    super.key,
  });

  /// Display text.
  final String label;

  /// Tap callback. When `null` the button is rendered disabled.
  final VoidCallback? onPressed;

  /// Visual style.
  final LiqButtonStyle style;

  /// Size axis.
  final LiqButtonSize size;

  /// When true, applies the iOS 26 destructive coloring.
  final bool destructive;

  // Canonical color values from liqkit's buttons.css.
  static const Color _accentBlue = Color(0xFF0088FF);
  static const Color _accentRed = Color(0xFFFF383C);
  static const Color _labelPrimary = Color(0xFF000000);
  static const Color _labelPrimaryDark = Color(0xFFFFFFFF);
  static const Color _labelTertiary = Color(0x4D3C3C43);
  static const Color _labelTertiaryDark = Color(0x52EBEBF5);
  static const Color _fillSecondary = Color(0x2978788A);
  static const Color _fillTertiary = Color(0x1F767680);
  static const Color _destructiveBg = Color(0x24FF383C);
  static const Color _destructiveBgProminent = Color(0x33FF383C);
  static const Color _destructiveDisabled = Color(0x80FF383C);
  static const Color _prominentDisabledBg = Color(0x330088FF);
  static const Color _prominentDisabledFg = Color(0x4DFFFFFF);
  static const Color _white = Color(0xFFFFFFFF);

  static double _height(LiqButtonSize size) => switch (size) {
    LiqButtonSize.small => 28,
    LiqButtonSize.medium => 34,
    LiqButtonSize.large => 50,
  };

  static EdgeInsets _padding(LiqButtonSize size) => switch (size) {
    LiqButtonSize.small => const EdgeInsets.symmetric(horizontal: 12),
    LiqButtonSize.medium => const EdgeInsets.symmetric(horizontal: 14),
    LiqButtonSize.large => const EdgeInsets.symmetric(horizontal: 18),
  };

  static TextStyle _textStyle(LiqButtonSize size) => switch (size) {
    LiqButtonSize.small || LiqButtonSize.medium => const TextStyle(
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
      fontSize: 15,
      height: 20 / 15,
      letterSpacing: -0.24,
      fontWeight: FontWeight.w400,
    ),
    LiqButtonSize.large => const TextStyle(
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
      fontSize: 17,
      height: 22 / 17,
      letterSpacing: -0.43,
      fontWeight: FontWeight.w400,
    ),
  };

  /// Resolved fill and label color for this style/state combo.
  ({Color fill, Color label, BoxDecoration? decoration}) _resolve({
    required bool isDark,
  }) {
    final disabled = onPressed == null;
    final labelPrimary = isDark ? _labelPrimaryDark : _labelPrimary;
    final labelTertiary = isDark ? _labelTertiaryDark : _labelTertiary;
    switch (style) {
      case LiqButtonStyle.borderedProminent:
        if (disabled) {
          return (
            fill: destructive ? _destructiveBgProminent : _prominentDisabledBg,
            label: _prominentDisabledFg,
            decoration: null,
          );
        }
        return (
          fill: destructive ? _accentRed : _accentBlue,
          label: _white,
          decoration: null,
        );
      case LiqButtonStyle.bordered:
        if (disabled) {
          return (
            fill: destructive ? _destructiveBg : _fillSecondary,
            label: destructive ? _destructiveDisabled : labelTertiary,
            decoration: null,
          );
        }
        return (
          fill: destructive ? _destructiveBg : _fillSecondary,
          label: destructive ? _accentRed : _accentBlue,
          decoration: null,
        );
      case LiqButtonStyle.borderedSecondary:
        if (disabled) {
          return (
            fill: destructive ? _destructiveBg : _fillTertiary,
            label: destructive ? _destructiveDisabled : labelTertiary,
            decoration: null,
          );
        }
        return (
          fill: destructive ? _destructiveBg : _fillTertiary,
          label: destructive ? _accentRed : labelPrimary,
          decoration: null,
        );
      case LiqButtonStyle.borderless:
        return (
          fill: const Color(0x00000000),
          label:
              disabled
                  ? labelTertiary
                  : (destructive ? _accentRed : _accentBlue),
          decoration: null,
        );
      case LiqButtonStyle.liquid:
        return (
          fill: const Color(0x00000000),
          label:
              disabled
                  ? labelTertiary
                  : (destructive ? _accentRed : labelPrimary),
          decoration: null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolve(isDark: context.liqIsDark);
    final textStyle = _textStyle(size).copyWith(color: resolved.label);
    final decoration =
        resolved.decoration ??
        BoxDecoration(
          color: resolved.fill,
          borderRadius: const BorderRadius.all(Radius.circular(999)),
        );
    final disabled = onPressed == null;
    const radius = BorderRadius.all(Radius.circular(999));

    final buttonBody = Container(
      height: _height(size),
      padding: _padding(size),
      decoration: style == LiqButtonStyle.liquid ? null : decoration,
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: textStyle,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
    );

    final visual =
        style == LiqButtonStyle.liquid
            ? LiqGlassSurface(
              borderRadius: radius,
              blurSigma: 18,
              elevation: LiqGlassElevation.flat,
              highlightStart: const Color(0x00FFFFFF),
              child: buttonBody,
            )
            : buttonBody;

    // Use IntrinsicWidth so the pill sizes to the label (plus padding)
    // instead of stretching to whatever bounded width its parent gives.
    // Matches iOS 26 spec widths captured from liqkit's Figma metadata
    // (text-only buttons: 49/57/73 logical px for Small/Medium/Large).
    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: LiqPointerCursor(
        enabled: !disabled,
        child: GestureDetector(
          onTap: onPressed,
          child: IntrinsicWidth(child: visual),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(EnumProperty<LiqButtonStyle>('style', style))
      ..add(EnumProperty<LiqButtonSize>('size', size))
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
