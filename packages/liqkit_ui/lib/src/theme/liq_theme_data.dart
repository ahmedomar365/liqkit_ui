import 'dart:ui' show Brightness, Color, FontWeight;

import 'package:flutter/foundation.dart';
import 'package:liqkit_ui/src/theme/liq_bezel.dart';
import 'package:liqkit_ui/src/theme/liq_color.dart';
import 'package:liqkit_ui/src/theme/liq_material.dart';
import 'package:liqkit_ui/src/theme/liq_quality.dart';
import 'package:liqkit_ui/src/theme/liq_semantics.dart';
import 'package:liqkit_ui/src/theme/liq_text_style.dart';
import 'package:liqkit_ui_tokens/liqkit_ui_tokens.dart';

/// The single immutable theme data carried via `LiqTheme`.
///
/// Color values come from the canonical iOS 26 token surface in
/// [LiqCanonicalColors] (generated from liqkit's Figma `variable-defs`).
@immutable
final class LiqThemeData with Diagnosticable {
  /// Creates a theme data.
  const LiqThemeData({
    required this.brightness,
    required this.primaryColor,
    required this.surfaceColor,
    required this.labelColor,
    required this.secondaryLabelColor,
    required this.material,
    required this.bezel,
    required this.bodyText,
    required this.titleText,
    required this.semantics,
    required this.quality,
  });

  /// Active brightness.
  final Brightness brightness;

  /// System primary tint (Accents/Blue).
  final LiqColor primaryColor;

  /// Default surface background.
  final LiqColor surfaceColor;

  /// Primary label color.
  final LiqColor labelColor;

  /// Secondary label color.
  final LiqColor secondaryLabelColor;

  /// Default glass material.
  final LiqMaterial material;

  /// Default bezel.
  final LiqBezel bezel;

  /// Body text style.
  final LiqTextStyle bodyText;

  /// Title text style.
  final LiqTextStyle titleText;

  /// Semantic flags.
  final LiqSemantics semantics;

  /// Glass-rendering quality tier.
  final LiqQuality quality;

  // Light/dark are paired with what liqkit's Figma capture exposed:
  // `default_` mode is the iOS 26 dark base; `increasedContrast` is the
  // accessibility variant. Light values for system tokens are taken
  // from Apple's published iOS 26 system palette where they are not in
  // the Figma capture, then validated against the rendered HTML
  // baselines via the Playwright fidelity loop.

  /// Light-mode default theme.
  static const LiqThemeData light = LiqThemeData(
    brightness: Brightness.light,
    primaryColor: LiqColor(
      light: Color(0xFF007AFF),
      dark: Color(0xFF0091FF), // = LiqCanonicalColors.accentsBlue.default_
    ),
    surfaceColor: LiqColor(
      light: Color(0xFFFFFFFF),
      dark: Color(0xFF000000), // = backgroundsPrimary.default_
    ),
    labelColor: LiqColor(
      light: Color(0xFF000000),
      dark: Color(0xFFFFFFFF), // = labelsPrimary.default_
    ),
    secondaryLabelColor: LiqColor(
      light: Color(0x993C3C43),
      dark: Color(0xB2EBEBF5), // labelsSecondary.default_ = #ebebf5b2
    ),
    material: LiqMaterial.regular,
    bezel: LiqBezel(
      cornerRadius: 18,
      innerHighlight: 0.08,
      outerShadowOpacity: 0.18,
    ),
    bodyText: LiqTextStyle(
      family: 'SF Pro Text',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.4,
      heightMultiplier: 1.29,
    ),
    titleText: LiqTextStyle(
      family: 'SF Pro Display',
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.36,
      heightMultiplier: 1.21,
    ),
    semantics: LiqSemantics(),
    quality: LiqQuality.standard,
  );

  /// Dark-mode default theme.
  static const LiqThemeData dark = LiqThemeData(
    brightness: Brightness.dark,
    primaryColor: LiqColor(light: Color(0xFF007AFF), dark: Color(0xFF0091FF)),
    surfaceColor: LiqColor(light: Color(0xFFFFFFFF), dark: Color(0xFF000000)),
    labelColor: LiqColor(light: Color(0xFF000000), dark: Color(0xFFFFFFFF)),
    secondaryLabelColor: LiqColor(
      light: Color(0x993C3C43),
      dark: Color(0xB2EBEBF5),
    ),
    material: LiqMaterial.regular,
    bezel: LiqBezel(
      cornerRadius: 18,
      innerHighlight: 0.10,
      outerShadowOpacity: 0.30,
    ),
    bodyText: LiqTextStyle(
      family: 'SF Pro Text',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.4,
      heightMultiplier: 1.29,
    ),
    titleText: LiqTextStyle(
      family: 'SF Pro Display',
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.36,
      heightMultiplier: 1.21,
    ),
    semantics: LiqSemantics(),
    quality: LiqQuality.standard,
  );

  /// Returns a copy with selected fields replaced.
  LiqThemeData copyWith({
    Brightness? brightness,
    LiqColor? primaryColor,
    LiqColor? surfaceColor,
    LiqColor? labelColor,
    LiqColor? secondaryLabelColor,
    LiqMaterial? material,
    LiqBezel? bezel,
    LiqTextStyle? bodyText,
    LiqTextStyle? titleText,
    LiqSemantics? semantics,
    LiqQuality? quality,
  }) => LiqThemeData(
    brightness: brightness ?? this.brightness,
    primaryColor: primaryColor ?? this.primaryColor,
    surfaceColor: surfaceColor ?? this.surfaceColor,
    labelColor: labelColor ?? this.labelColor,
    secondaryLabelColor: secondaryLabelColor ?? this.secondaryLabelColor,
    material: material ?? this.material,
    bezel: bezel ?? this.bezel,
    bodyText: bodyText ?? this.bodyText,
    titleText: titleText ?? this.titleText,
    semantics: semantics ?? this.semantics,
    quality: quality ?? this.quality,
  );

  /// Linearly interpolates between two themes.
  // ignore: prefer_constructors_over_static_methods
  static LiqThemeData lerp(LiqThemeData a, LiqThemeData b, double t) =>
      LiqThemeData(
        brightness: t < 0.5 ? a.brightness : b.brightness,
        primaryColor: LiqColor.lerp(a.primaryColor, b.primaryColor, t),
        surfaceColor: LiqColor.lerp(a.surfaceColor, b.surfaceColor, t),
        labelColor: LiqColor.lerp(a.labelColor, b.labelColor, t),
        secondaryLabelColor: LiqColor.lerp(
          a.secondaryLabelColor,
          b.secondaryLabelColor,
          t,
        ),
        material: LiqMaterial.lerp(a.material, b.material, t),
        bezel: t < 0.5 ? a.bezel : b.bezel,
        bodyText: t < 0.5 ? a.bodyText : b.bodyText,
        titleText: t < 0.5 ? a.titleText : b.titleText,
        semantics: t < 0.5 ? a.semantics : b.semantics,
        quality: t < 0.5 ? a.quality : b.quality,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiqThemeData &&
          other.brightness == brightness &&
          other.primaryColor == primaryColor &&
          other.surfaceColor == surfaceColor &&
          other.labelColor == labelColor &&
          other.secondaryLabelColor == secondaryLabelColor &&
          other.material == material &&
          other.bezel == bezel &&
          other.bodyText == bodyText &&
          other.titleText == titleText &&
          other.semantics == semantics &&
          other.quality == quality;

  @override
  int get hashCode => Object.hash(
    brightness,
    primaryColor,
    surfaceColor,
    labelColor,
    secondaryLabelColor,
    material,
    bezel,
    bodyText,
    titleText,
    semantics,
    quality,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Brightness>('brightness', brightness))
      ..add(DiagnosticsProperty<LiqColor>('primaryColor', primaryColor))
      ..add(DiagnosticsProperty<LiqColor>('surfaceColor', surfaceColor))
      ..add(DiagnosticsProperty<LiqColor>('labelColor', labelColor))
      ..add(
        DiagnosticsProperty<LiqColor>(
          'secondaryLabelColor',
          secondaryLabelColor,
        ),
      )
      ..add(DiagnosticsProperty<LiqMaterial>('material', material))
      ..add(DiagnosticsProperty<LiqBezel>('bezel', bezel))
      ..add(DiagnosticsProperty<LiqTextStyle>('bodyText', bodyText))
      ..add(DiagnosticsProperty<LiqTextStyle>('titleText', titleText))
      ..add(DiagnosticsProperty<LiqSemantics>('semantics', semantics))
      ..add(EnumProperty<LiqQuality>('quality', quality));
  }
}
