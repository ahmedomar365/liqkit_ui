// Apple HIG type scale.
//
// The standard Apple iOS HIG typography surface
// (https://developer.apple.com/design/human-interface-guidelines/typography),
// stable across iOS 13+.
//
// liqkit_ui *also* ships [LiqCanonicalTypography] — the iOS 26 Figma-extracted
// values. Use:
//
//   * `LiqAppleTypography` — when you want the canonical iOS HIG type scale.
//   * `LiqCanonicalTypography` — when you want the iOS 26 Figma values.

// Each member is a canonical Apple HIG type-style name; one-by-one
// docstrings would only restate the name and add noise.
// ignore_for_file: public_member_api_docs

import 'dart:ui' show Brightness, Color, FontWeight;

import 'package:flutter/painting.dart' show TextStyle;
import 'package:flutter/widgets.dart' show BuildContext;

import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Static Apple HIG type style tokens.
///
/// Each `static TextStyle X(Brightness brightness)` returns a canonical
/// SF Pro text/display style with the right size, weight, line height,
/// letter spacing, and a brightness-resolved label color.
class LiqAppleTypography {
  const LiqAppleTypography._();

  // ─── Font families ───────────────────────────────────────────────────
  /// Body text family.
  static const String fontFamily = '.SF Pro Text';

  /// Display text family.
  static const String displayFontFamily = '.SF Pro Display';

  /// Monospaced family.
  static const String monospacedFontFamily = 'Menlo';

  // ─── Font weights ────────────────────────────────────────────────────
  static const FontWeight ultraLight = FontWeight.w100;
  static const FontWeight thin = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight heavy = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  static Color _label(Brightness b) =>
      b == Brightness.light ? LiqAppleColors.label : LiqAppleColors.labelDark;

  // ─── Display ─────────────────────────────────────────────────────────
  static TextStyle largeTitle(Brightness brightness) => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 34,
        fontWeight: regular,
        letterSpacing: 0.374,
        height: 1.21,
        color: _label(brightness),
      );

  static TextStyle title1(Brightness brightness) => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 28,
        fontWeight: regular,
        letterSpacing: 0.364,
        height: 1.21,
        color: _label(brightness),
      );

  static TextStyle title2(Brightness brightness) => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 22,
        fontWeight: regular,
        letterSpacing: 0.352,
        height: 1.27,
        color: _label(brightness),
      );

  static TextStyle title3(Brightness brightness) => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 20,
        fontWeight: regular,
        letterSpacing: 0.38,
        height: 1.25,
        color: _label(brightness),
      );

  // ─── Body ────────────────────────────────────────────────────────────
  static TextStyle headline(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: semibold,
        letterSpacing: -0.41,
        height: 1.29,
        color: _label(brightness),
      );

  static TextStyle body(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: regular,
        letterSpacing: -0.41,
        height: 1.29,
        color: _label(brightness),
      );

  static TextStyle callout(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: regular,
        letterSpacing: -0.32,
        height: 1.31,
        color: _label(brightness),
      );

  static TextStyle subheadline(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: regular,
        letterSpacing: -0.24,
        height: 1.33,
        color: _label(brightness),
      );

  static TextStyle footnote(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 13,
        fontWeight: regular,
        letterSpacing: -0.08,
        height: 1.38,
        color: _label(brightness),
      );

  static TextStyle caption1(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.33,
        color: _label(brightness),
      );

  static TextStyle caption2(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: regular,
        letterSpacing: 0.06,
        height: 1.45,
        color: _label(brightness),
      );

  // ─── Monospaced ──────────────────────────────────────────────────────
  static TextStyle monospacedBody(Brightness brightness) => TextStyle(
        fontFamily: monospacedFontFamily,
        fontSize: 13,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.38,
        color: _label(brightness),
      );

  static TextStyle monospacedHeadline(Brightness brightness) => TextStyle(
        fontFamily: monospacedFontFamily,
        fontSize: 13,
        fontWeight: bold,
        letterSpacing: 0,
        height: 1.38,
        color: _label(brightness),
      );
}

/// Brightness-bound type scale.
///
/// ```dart
/// final styles = LiqAppleTextStyles(LiqTheme.of(context).brightness);
/// Text('Hello', style: styles.body);
/// ```
class LiqAppleTextStyles {
  /// Creates a brightness-bound view over [LiqAppleTypography].
  const LiqAppleTextStyles(this.brightness);

  /// The brightness this surface was created for.
  final Brightness brightness;

  TextStyle get largeTitle => LiqAppleTypography.largeTitle(brightness);
  TextStyle get title1 => LiqAppleTypography.title1(brightness);
  TextStyle get title2 => LiqAppleTypography.title2(brightness);
  TextStyle get title3 => LiqAppleTypography.title3(brightness);
  TextStyle get headline => LiqAppleTypography.headline(brightness);
  TextStyle get body => LiqAppleTypography.body(brightness);
  TextStyle get callout => LiqAppleTypography.callout(brightness);
  TextStyle get subheadline => LiqAppleTypography.subheadline(brightness);
  TextStyle get footnote => LiqAppleTypography.footnote(brightness);
  TextStyle get caption1 => LiqAppleTypography.caption1(brightness);
  TextStyle get caption2 => LiqAppleTypography.caption2(brightness);
  TextStyle get monospacedBody => LiqAppleTypography.monospacedBody(brightness);
  TextStyle get monospacedHeadline =>
      LiqAppleTypography.monospacedHeadline(brightness);
}

/// Convenience weight + label-tier extensions on [TextStyle].
///
/// ```dart
/// Text('Title', style: styles.title2.bold);
/// Text('Hint', style: styles.body.semibold.secondary(context));
/// ```
/// Convenience accessor: `context.textStyles.body` returns a
/// brightness-bound type scale resolved against the nearest `LiqTheme`.
extension LiqAppleTypographyContext on BuildContext {
  /// Brightness-bound Apple HIG text styles.
  LiqAppleTextStyles get textStyles => LiqAppleTextStyles(liqBrightness);
}

extension LiqAppleTextStyleExtensions on TextStyle {
  TextStyle get ultraLight =>
      copyWith(fontWeight: LiqAppleTypography.ultraLight);
  TextStyle get thin => copyWith(fontWeight: LiqAppleTypography.thin);
  TextStyle get light => copyWith(fontWeight: LiqAppleTypography.light);
  TextStyle get regular => copyWith(fontWeight: LiqAppleTypography.regular);
  TextStyle get medium => copyWith(fontWeight: LiqAppleTypography.medium);
  TextStyle get semibold => copyWith(fontWeight: LiqAppleTypography.semibold);
  TextStyle get bold => copyWith(fontWeight: LiqAppleTypography.bold);
  TextStyle get heavy => copyWith(fontWeight: LiqAppleTypography.heavy);
  TextStyle get black => copyWith(fontWeight: LiqAppleTypography.black);

  /// Recolor to the iOS HIG secondary label tier. The brightness is
  /// inferred from the current color: light-mode (black-ish) text uses
  /// the light secondary color; dark-mode (white-ish) text uses the
  /// dark variant.
  TextStyle get secondary {
    final isDark = (color ?? const Color(0xFF000000)) ==
        LiqAppleColors.labelDark;
    return copyWith(
      color: isDark
          ? LiqAppleColors.secondaryLabelDark
          : LiqAppleColors.secondaryLabel,
    );
  }

  /// Recolor to the iOS HIG tertiary label tier.
  TextStyle get tertiary {
    final isDark = (color ?? const Color(0xFF000000)) ==
        LiqAppleColors.labelDark;
    return copyWith(
      color: isDark
          ? LiqAppleColors.tertiaryLabelDark
          : LiqAppleColors.tertiaryLabel,
    );
  }

  /// Recolor to the iOS HIG quaternary label tier.
  TextStyle get quaternary {
    final isDark = (color ?? const Color(0xFF000000)) ==
        LiqAppleColors.labelDark;
    return copyWith(
      color: isDark
          ? LiqAppleColors.quaternaryLabelDark
          : LiqAppleColors.quaternaryLabel,
    );
  }
}
