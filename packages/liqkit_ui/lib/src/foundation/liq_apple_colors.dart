// Apple HIG system color palette.
//
// These are the standard Apple Human Interface Guidelines system colors
// (https://developer.apple.com/design/human-interface-guidelines/color),
// the same surface that's been stable across iOS 13–18.
//
// liqkit_ui *also* ships [LiqCanonicalColors] — the iOS 26 Figma-extracted
// Liquid Glass palette. The two palettes overlap in name (`systemBlue`,
// `accentsBlue`) but use different hex values by design. Use:
//
//   * `LiqAppleColors` — when you want the canonical iOS HIG palette
//     (the values Apple ships in `UIColor.systemBlue`).
//   * `LiqCanonicalColors` — when you want the iOS 26 Liquid Glass values
//     captured directly from Apple's Figma kit.
//
// Each color exposes `light`, `dark`, `accessibleLight`, `accessibleDark`
// variants. Use `LiqAppleColors.blue(brightness)` for a brightness-aware
// resolve, or read the hex constants directly.

// Each member is a self-documenting Apple HIG token name; one-by-one
// docstrings would only restate the name and add noise.
// ignore_for_file: public_member_api_docs

import 'dart:ui' show Brightness, Color;

import 'package:flutter/widgets.dart' show BuildContext;

import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Static Apple HIG system color tokens.
class LiqAppleColors {
  const LiqAppleColors._();

  // ─── System Red ──────────────────────────────────────────────────────
  static const Color systemRed = Color(0xFFFF3B30);
  static const Color systemRedDark = Color(0xFFFF453A);
  static const Color systemRedAccessible = Color(0xFFD70015);
  static const Color systemRedAccessibleDark = Color(0xFFFF4747);

  // ─── System Orange ───────────────────────────────────────────────────
  static const Color systemOrange = Color(0xFFFF9500);
  static const Color systemOrangeDark = Color(0xFFFF9F0A);
  static const Color systemOrangeAccessible = Color(0xFFC55300);
  static const Color systemOrangeAccessibleDark = Color(0xFFFFB340);

  // ─── System Yellow ───────────────────────────────────────────────────
  static const Color systemYellow = Color(0xFFFFCC00);
  static const Color systemYellowDark = Color(0xFFFFD60A);
  static const Color systemYellowAccessible = Color(0xFFA16A00);
  static const Color systemYellowAccessibleDark = Color(0xFFFFD426);

  // ─── System Green ────────────────────────────────────────────────────
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemGreenDark = Color(0xFF30D158);
  static const Color systemGreenAccessible = Color(0xFF008932);
  static const Color systemGreenAccessibleDark = Color(0xFF4AE968);

  // ─── System Mint ─────────────────────────────────────────────────────
  static const Color systemMint = Color(0xFF00C8B3);
  static const Color systemMintDark = Color(0xFF63E6E2);
  static const Color systemMintAccessible = Color(0xFF008575);
  static const Color systemMintAccessibleDark = Color(0xFF54DFCB);

  // ─── System Teal ─────────────────────────────────────────────────────
  static const Color systemTeal = Color(0xFF30B0C7);
  static const Color systemTealDark = Color(0xFF40CBE0);
  static const Color systemTealAccessible = Color(0xFF007EAE);
  static const Color systemTealAccessibleDark = Color(0xFF3BDDEC);

  // ─── System Cyan ─────────────────────────────────────────────────────
  static const Color systemCyan = Color(0xFF32ADE6);
  static const Color systemCyanDark = Color(0xFF64D2FF);
  static const Color systemCyanAccessible = Color(0xFF008198);
  static const Color systemCyanAccessibleDark = Color(0xFF5CB8FF);

  // ─── System Blue ─────────────────────────────────────────────────────
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemBlueDark = Color(0xFF0A84FF);
  static const Color systemBlueAccessible = Color(0xFF0040DD);
  static const Color systemBlueAccessibleDark = Color(0xFF0091FF);

  // ─── System Indigo ───────────────────────────────────────────────────
  static const Color systemIndigo = Color(0xFF5856D6);
  static const Color systemIndigoDark = Color(0xFF5E5CE6);
  static const Color systemIndigoAccessible = Color(0xFF564ADE);
  static const Color systemIndigoAccessibleDark = Color(0xFF6B5DFF);

  // ─── System Purple ───────────────────────────────────────────────────
  static const Color systemPurple = Color(0xFFAF52DE);
  static const Color systemPurpleDark = Color(0xFFBF5AF2);
  static const Color systemPurpleAccessible = Color(0xFFB02FC2);
  static const Color systemPurpleAccessibleDark = Color(0xFFCB30E0);

  // ─── System Pink ─────────────────────────────────────────────────────
  static const Color systemPink = Color(0xFFFF2D55);
  static const Color systemPinkDark = Color(0xFFFF375F);
  static const Color systemPinkAccessible = Color(0xFFD30F45);
  static const Color systemPinkAccessibleDark = Color(0xFFFF4363);

  // ─── System Brown ────────────────────────────────────────────────────
  static const Color systemBrown = Color(0xFFA2845E);
  static const Color systemBrownDark = Color(0xFFAC8E68);
  static const Color systemBrownAccessible = Color(0xFF956D51);
  static const Color systemBrownAccessibleDark = Color(0xFFB78A66);

  // ─── System Grays (light) ────────────────────────────────────────────
  static const Color systemGray = Color(0xFF8E8E93);
  static const Color systemGray2 = Color(0xFFAEAEB2);
  static const Color systemGray3 = Color(0xFFC7C7CC);
  static const Color systemGray4 = Color(0xFFD1D1D6);
  static const Color systemGray5 = Color(0xFFE5E5EA);
  static const Color systemGray6 = Color(0xFFF2F2F7);

  // ─── System Grays (dark) ─────────────────────────────────────────────
  static const Color systemGrayDark = Color(0xFF8E8E93);
  static const Color systemGray2Dark = Color(0xFF636366);
  static const Color systemGray3Dark = Color(0xFF48484A);
  static const Color systemGray4Dark = Color(0xFF3A3A3C);
  static const Color systemGray5Dark = Color(0xFF2C2C2E);
  static const Color systemGray6Dark = Color(0xFF1C1C1E);

  // ─── Labels ──────────────────────────────────────────────────────────
  static const Color label = Color(0xFF000000);
  static const Color labelDark = Color(0xFFFFFFFF);
  static const Color secondaryLabel = Color(0x993C3C43);
  static const Color secondaryLabelDark = Color(0x99EBEBF5);
  static const Color tertiaryLabel = Color(0x4D3C3C43);
  static const Color tertiaryLabelDark = Color(0x4DEBEBF5);
  static const Color quaternaryLabel = Color(0x2E3C3C43);
  static const Color quaternaryLabelDark = Color(0x2EEBEBF5);

  // ─── Fills ───────────────────────────────────────────────────────────
  static const Color systemFill = Color(0x33787880);
  static const Color systemFillDark = Color(0x5C787880);
  static const Color secondarySystemFill = Color(0x29787880);
  static const Color secondarySystemFillDark = Color(0x52787880);
  static const Color tertiarySystemFill = Color(0x1F767680);
  static const Color tertiarySystemFillDark = Color(0x3D767680);
  static const Color quaternarySystemFill = Color(0x14747480);
  static const Color quaternarySystemFillDark = Color(0x2E767680);

  // ─── Backgrounds ─────────────────────────────────────────────────────
  static const Color systemBackground = Color(0xFFFFFFFF);
  static const Color systemBackgroundDark = Color(0xFF000000);
  static const Color secondarySystemBackground = Color(0xFFF2F2F7);
  static const Color secondarySystemBackgroundDark = Color(0xFF1C1C1E);
  static const Color tertiarySystemBackground = Color(0xFFFFFFFF);
  static const Color tertiarySystemBackgroundDark = Color(0xFF2C2C2E);

  // ─── Grouped Backgrounds ─────────────────────────────────────────────
  static const Color systemGroupedBackground = Color(0xFFF2F2F7);
  static const Color systemGroupedBackgroundDark = Color(0xFF000000);
  static const Color secondarySystemGroupedBackground = Color(0xFFFFFFFF);
  static const Color secondarySystemGroupedBackgroundDark = Color(0xFF1C1C1E);
  static const Color tertiarySystemGroupedBackground = Color(0xFFF2F2F7);
  static const Color tertiarySystemGroupedBackgroundDark = Color(0xFF2C2C2E);

  // ─── Separators ──────────────────────────────────────────────────────
  static const Color separator = Color(0x4A3C3C43);
  static const Color separatorDark = Color(0x99545458);
  static const Color opaqueSeparator = Color(0xFFC6C6C8);
  static const Color opaqueSeparatorDark = Color(0xFF38383A);

  // ─── Link ────────────────────────────────────────────────────────────
  static const Color link = Color(0xFF007AFF);
  static const Color linkDark = Color(0xFF0984FF);

  // ─── Custom UI palette extracted from iOS 26 reference frames ────────
  static const Color uiRed = Color(0xFFFF4245);
  static const Color uiRedDark = Color(0xFFFF383C);
  static const Color uiBackground = Color(0xFFF5F5F5);
  static const Color uiBlue = Color(0xFF0088FF);
  static const Color uiIndigo = Color(0xFF6155F5);
  static const Color uiPurple = Color(0xFFA7AAFF);
  static const Color uiCyan = Color(0xFF00C0E8);
  static const Color uiCyanLight = Color(0xFF3CD3FE);
  static const Color uiTeal = Color(0xFF00D2E0);
  static const Color uiMint = Color(0xFF00DAC3);
  static const Color uiGreen = Color(0xFF30D158);
  static const Color uiYellow = Color(0xFFFFDD00);
  static const Color uiOrange = Color(0xFFFF9500);
  static const Color uiBrown = Color(0xFFAC7F5E);

  // ─── Brightness-aware resolvers ──────────────────────────────────────
  /// Picks [light] in `Brightness.light`, [dark] otherwise.
  static Color resolve(Color light, Color dark, Brightness brightness) =>
      brightness == Brightness.light ? light : dark;

  static Color red(Brightness b) => resolve(systemRed, systemRedDark, b);
  static Color orange(Brightness b) =>
      resolve(systemOrange, systemOrangeDark, b);
  static Color yellow(Brightness b) =>
      resolve(systemYellow, systemYellowDark, b);
  static Color green(Brightness b) =>
      resolve(systemGreen, systemGreenDark, b);
  static Color mint(Brightness b) => resolve(systemMint, systemMintDark, b);
  static Color teal(Brightness b) => resolve(systemTeal, systemTealDark, b);
  static Color cyan(Brightness b) => resolve(systemCyan, systemCyanDark, b);
  static Color blue(Brightness b) => resolve(systemBlue, systemBlueDark, b);
  static Color indigo(Brightness b) =>
      resolve(systemIndigo, systemIndigoDark, b);
  static Color purple(Brightness b) =>
      resolve(systemPurple, systemPurpleDark, b);
  static Color pink(Brightness b) => resolve(systemPink, systemPinkDark, b);
  static Color brown(Brightness b) =>
      resolve(systemBrown, systemBrownDark, b);

  static Color gray(Brightness b) => resolve(systemGray, systemGrayDark, b);
  static Color gray2(Brightness b) => resolve(systemGray2, systemGray2Dark, b);
  static Color gray3(Brightness b) => resolve(systemGray3, systemGray3Dark, b);
  static Color gray4(Brightness b) => resolve(systemGray4, systemGray4Dark, b);
  static Color gray5(Brightness b) => resolve(systemGray5, systemGray5Dark, b);
  static Color gray6(Brightness b) => resolve(systemGray6, systemGray6Dark, b);
}

/// Brightness-bound color surface.
///
/// Lets consumers write `palette.blue` after pulling the brightness from
/// a `LiqTheme` (or wherever).
///
/// Example:
///
/// ```dart
/// final palette = LiqApplePalette(LiqTheme.of(context).brightness);
/// final color = palette.blue;
/// ```
class LiqApplePalette {
  /// Creates a brightness-bound view over [LiqAppleColors].
  const LiqApplePalette(this.brightness);

  /// The brightness this palette was created for.
  final Brightness brightness;

  Color get red => LiqAppleColors.red(brightness);
  Color get orange => LiqAppleColors.orange(brightness);
  Color get yellow => LiqAppleColors.yellow(brightness);
  Color get green => LiqAppleColors.green(brightness);
  Color get mint => LiqAppleColors.mint(brightness);
  Color get teal => LiqAppleColors.teal(brightness);
  Color get cyan => LiqAppleColors.cyan(brightness);
  Color get blue => LiqAppleColors.blue(brightness);
  Color get indigo => LiqAppleColors.indigo(brightness);
  Color get purple => LiqAppleColors.purple(brightness);
  Color get pink => LiqAppleColors.pink(brightness);
  Color get brown => LiqAppleColors.brown(brightness);

  Color get gray => LiqAppleColors.gray(brightness);
  Color get gray2 => LiqAppleColors.gray2(brightness);
  Color get gray3 => LiqAppleColors.gray3(brightness);
  Color get gray4 => LiqAppleColors.gray4(brightness);
  Color get gray5 => LiqAppleColors.gray5(brightness);
  Color get gray6 => LiqAppleColors.gray6(brightness);

  Color get label => brightness == Brightness.light
      ? LiqAppleColors.label
      : LiqAppleColors.labelDark;
  Color get secondaryLabel => brightness == Brightness.light
      ? LiqAppleColors.secondaryLabel
      : LiqAppleColors.secondaryLabelDark;
  Color get tertiaryLabel => brightness == Brightness.light
      ? LiqAppleColors.tertiaryLabel
      : LiqAppleColors.tertiaryLabelDark;
  Color get quaternaryLabel => brightness == Brightness.light
      ? LiqAppleColors.quaternaryLabel
      : LiqAppleColors.quaternaryLabelDark;

  Color get systemFill => brightness == Brightness.light
      ? LiqAppleColors.systemFill
      : LiqAppleColors.systemFillDark;
  Color get secondarySystemFill => brightness == Brightness.light
      ? LiqAppleColors.secondarySystemFill
      : LiqAppleColors.secondarySystemFillDark;
  Color get tertiarySystemFill => brightness == Brightness.light
      ? LiqAppleColors.tertiarySystemFill
      : LiqAppleColors.tertiarySystemFillDark;
  Color get quaternarySystemFill => brightness == Brightness.light
      ? LiqAppleColors.quaternarySystemFill
      : LiqAppleColors.quaternarySystemFillDark;

  Color get systemBackground => brightness == Brightness.light
      ? LiqAppleColors.systemBackground
      : LiqAppleColors.systemBackgroundDark;
  Color get secondarySystemBackground => brightness == Brightness.light
      ? LiqAppleColors.secondarySystemBackground
      : LiqAppleColors.secondarySystemBackgroundDark;
  Color get tertiarySystemBackground => brightness == Brightness.light
      ? LiqAppleColors.tertiarySystemBackground
      : LiqAppleColors.tertiarySystemBackgroundDark;

  Color get systemGroupedBackground => brightness == Brightness.light
      ? LiqAppleColors.systemGroupedBackground
      : LiqAppleColors.systemGroupedBackgroundDark;
  Color get secondarySystemGroupedBackground => brightness == Brightness.light
      ? LiqAppleColors.secondarySystemGroupedBackground
      : LiqAppleColors.secondarySystemGroupedBackgroundDark;
  Color get tertiarySystemGroupedBackground => brightness == Brightness.light
      ? LiqAppleColors.tertiarySystemGroupedBackground
      : LiqAppleColors.tertiarySystemGroupedBackgroundDark;

  Color get separator => brightness == Brightness.light
      ? LiqAppleColors.separator
      : LiqAppleColors.separatorDark;
  Color get opaqueSeparator => brightness == Brightness.light
      ? LiqAppleColors.opaqueSeparator
      : LiqAppleColors.opaqueSeparatorDark;

  Color get link => brightness == Brightness.light
      ? LiqAppleColors.link
      : LiqAppleColors.linkDark;
}

/// Convenience accessor: `context.appleColors.blue` returns a
/// brightness-bound palette resolved against the nearest `LiqTheme`.
extension LiqAppleColorsContext on BuildContext {
  /// Brightness-bound Apple HIG palette.
  LiqApplePalette get appleColors => LiqApplePalette(liqBrightness);
}
