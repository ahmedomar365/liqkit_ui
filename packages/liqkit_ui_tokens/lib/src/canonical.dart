// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: packages/liqkit_ui_design_data/manifests/canonical_tokens.json
// SHA-256: 67dc45b65252e5824e5a696a45033987fd0f5aa6239af1ba014b7ce98f831218
// Translator: tooling/gen/generate_canonical_dart.dart
// Section: canonical
// ignore_for_file: lines_longer_than_80_chars, public_member_api_docs, prefer_single_quotes, constant_identifier_names, prefer_int_literals, comment_references, eol_at_end_of_file

import 'dart:ui' show Color, FontWeight;

/// Active iOS 26 token mode.
///
/// Captured from liqkit's Figma extraction. Values come from
/// `figma_artifacts/<category>/<node>.variable-defs.json` across
/// all 37 categories.
enum LiqColorMode {
  /// `default_` mode (Figma key: `default`).
  default_,

  /// `increasedContrast` mode (Figma key: `increasedContrast`).
  increasedContrast,
}

/// A canonical iOS 26 color reference resolved per [LiqColorMode].
@pragma('vm:prefer-inline')
final class LiqColorRef {
  /// Creates a color reference.
  const LiqColorRef({required this.default_, required this.increasedContrast});

  /// Value in `default_` mode.
  final Color default_;

  /// Value in `increasedContrast` mode.
  final Color increasedContrast;

  /// Resolves the color value for [mode].
  Color valueIn(LiqColorMode mode) {
    switch (mode) {
      case LiqColorMode.default_:
        return default_;
      case LiqColorMode.increasedContrast:
        return increasedContrast;
    }
  }
}

/// Every iOS 26 color token captured from liqkit.
///
/// Field names are derived from the Figma path. For example,
/// Figma's `Backgrounds (Grouped)/Primary` becomes
/// [backgroundsGroupedPrimary].
class LiqCanonicalColors {
  const LiqCanonicalColors._();

  /// `accents/blue` from liqkit Figma variable-defs.
  static const LiqColorRef accentsBlue = LiqColorRef(
    default_: Color(0xFF0091FF),
    increasedContrast: Color(0xFF5CB8FF),
  );

  /// `accents/brown` from liqkit Figma variable-defs.
  static const LiqColorRef accentsBrown = LiqColorRef(
    default_: Color(0xFFB78A66),
    increasedContrast: Color(0xFFDBA679),
  );

  /// `accents/cyan` from liqkit Figma variable-defs.
  static const LiqColorRef accentsCyan = LiqColorRef(
    default_: Color(0xFF3CD3FE),
    increasedContrast: Color(0xFF6DD9FF),
  );

  /// `accents/green` from liqkit Figma variable-defs.
  static const LiqColorRef accentsGreen = LiqColorRef(
    default_: Color(0xFF30D158),
    increasedContrast: Color(0xFF4AE968),
  );

  /// `accents/indigo` from liqkit Figma variable-defs.
  static const LiqColorRef accentsIndigo = LiqColorRef(
    default_: Color(0xFF6D7CFF),
    increasedContrast: Color(0xFFA7AAFF),
  );

  /// `accents/mint` from liqkit Figma variable-defs.
  static const LiqColorRef accentsMint = LiqColorRef(
    default_: Color(0xFF00DAC3),
    increasedContrast: Color(0xFF54DFCB),
  );

  /// `accents/orange` from liqkit Figma variable-defs.
  static const LiqColorRef accentsOrange = LiqColorRef(
    default_: Color(0xFFFF9230),
    increasedContrast: Color(0xFFFFA056),
  );

  /// `accents/pink` from liqkit Figma variable-defs.
  static const LiqColorRef accentsPink = LiqColorRef(
    default_: Color(0xFFFF375F),
    increasedContrast: Color(0xFFFF8AC4),
  );

  /// `accents/purple` from liqkit Figma variable-defs.
  static const LiqColorRef accentsPurple = LiqColorRef(
    default_: Color(0xFFDB34F2),
    increasedContrast: Color(0xFFEA8DFF),
  );

  /// `accents/red` from liqkit Figma variable-defs.
  static const LiqColorRef accentsRed = LiqColorRef(
    default_: Color(0xFFFF4245),
    increasedContrast: Color(0xFFFF6165),
  );

  /// `accents/teal` from liqkit Figma variable-defs.
  static const LiqColorRef accentsTeal = LiqColorRef(
    default_: Color(0xFF00D2E0),
    increasedContrast: Color(0xFF3BDDEC),
  );

  /// `accents/yellow` from liqkit Figma variable-defs.
  static const LiqColorRef accentsYellow = LiqColorRef(
    default_: Color(0xFFFFD600),
    increasedContrast: Color(0xFFFEDF43),
  );

  /// `backgrounds/primary` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsPrimary = LiqColorRef(
    default_: Color(0xFF000000),
    increasedContrast: Color(0xFF000000),
  );

  /// `backgrounds/primaryElevated` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsPrimaryElevated = LiqColorRef(
    default_: Color(0xFF1C1C1E),
    increasedContrast: Color(0xFF1C1C1E),
  );

  /// `backgrounds/secondary` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsSecondary = LiqColorRef(
    default_: Color(0xFF1C1C1E),
    increasedContrast: Color(0xFF1C1C1E),
  );

  /// `backgrounds/secondaryElevated` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsSecondaryElevated = LiqColorRef(
    default_: Color(0xFF2C2C2E),
    increasedContrast: Color(0xFF2C2C2E),
  );

  /// `backgrounds/tertiary` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsTertiary = LiqColorRef(
    default_: Color(0xFF2C2C2E),
    increasedContrast: Color(0xFF2C2C2E),
  );

  /// `backgrounds/tertiaryElevated` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsTertiaryElevated = LiqColorRef(
    default_: Color(0xFF3A3A3C),
    increasedContrast: Color(0xFF3A3A3C),
  );

  /// `backgroundsGrouped/primary` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsGroupedPrimary = LiqColorRef(
    default_: Color(0xFF000000),
    increasedContrast: Color(0xFF000000),
  );

  /// `backgroundsGrouped/primaryElevated` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsGroupedPrimaryElevated = LiqColorRef(
    default_: Color(0xFF1C1C1E),
    increasedContrast: Color(0xFF1C1C1E),
  );

  /// `backgroundsGrouped/secondary` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsGroupedSecondary = LiqColorRef(
    default_: Color(0xFF1C1C1E),
    increasedContrast: Color(0xFF1C1C1E),
  );

  /// `backgroundsGrouped/secondaryElevated` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsGroupedSecondaryElevated = LiqColorRef(
    default_: Color(0xFF2C2C2E),
    increasedContrast: Color(0xFF2C2C2E),
  );

  /// `backgroundsGrouped/tertiary` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsGroupedTertiary = LiqColorRef(
    default_: Color(0xFF2C2C2E),
    increasedContrast: Color(0xFF2C2C2E),
  );

  /// `backgroundsGrouped/tertiaryElevated` from liqkit Figma variable-defs.
  static const LiqColorRef backgroundsGroupedTertiaryElevated = LiqColorRef(
    default_: Color(0xFF3A3A3C),
    increasedContrast: Color(0xFF3A3A3C),
  );

  /// `grays/black` from liqkit Figma variable-defs.
  static const LiqColorRef graysBlack = LiqColorRef(
    default_: Color(0xFF000000),
    increasedContrast: Color(0xFF000000),
  );

  /// `grays/gray` from liqkit Figma variable-defs.
  static const LiqColorRef graysGray = LiqColorRef(
    default_: Color(0xFF8E8E93),
    increasedContrast: Color(0xFFAEAEB2),
  );

  /// `grays/gray2` from liqkit Figma variable-defs.
  static const LiqColorRef graysGray2 = LiqColorRef(
    default_: Color(0xFFAEAEB2),
    increasedContrast: Color(0xFFAEAEB2),
  );

  /// `grays/gray3` from liqkit Figma variable-defs.
  static const LiqColorRef graysGray3 = LiqColorRef(
    default_: Color(0xFF48484A),
    increasedContrast: Color(0xFF444446),
  );

  /// `grays/gray4` from liqkit Figma variable-defs.
  static const LiqColorRef graysGray4 = LiqColorRef(
    default_: Color(0xFF3A3A3C),
    increasedContrast: Color(0xFF363638),
  );

  /// `grays/gray5` from liqkit Figma variable-defs.
  static const LiqColorRef graysGray5 = LiqColorRef(
    default_: Color(0xFF2C2C2E),
    increasedContrast: Color(0xFF242426),
  );

  /// `grays/gray6` from liqkit Figma variable-defs.
  static const LiqColorRef graysGray6 = LiqColorRef(
    default_: Color(0xFF1C1C1E),
    increasedContrast: Color(0xFF000000),
  );

  /// `grays/white` from liqkit Figma variable-defs.
  static const LiqColorRef graysWhite = LiqColorRef(
    default_: Color(0xFFFFFFFF),
    increasedContrast: Color(0xFFFFFFFF),
  );

  /// `labels/primary` from liqkit Figma variable-defs.
  static const LiqColorRef labelsPrimary = LiqColorRef(
    default_: Color(0xFFFFFFFF),
    increasedContrast: Color(0xFFFFFFFF),
  );

  /// `labels/quaternary` from liqkit Figma variable-defs.
  static const LiqColorRef labelsQuaternary = LiqColorRef(
    default_: Color(0x29EBEBF5),
    increasedContrast: Color(0x66EBEBF5),
  );

  /// `labels/secondary` from liqkit Figma variable-defs.
  static const LiqColorRef labelsSecondary = LiqColorRef(
    default_: Color(0xB2EBEBF5),
    increasedContrast: Color(0xB2EBEBF5),
  );

  /// `labels/tertiary` from liqkit Figma variable-defs.
  static const LiqColorRef labelsTertiary = LiqColorRef(
    default_: Color(0x4DEBEBF5),
    increasedContrast: Color(0x8CEBEBF5),
  );

  /// `sectionFill` from liqkit Figma variable-defs.
  static const LiqColorRef sectionFill = LiqColorRef(
    default_: Color(0xFFF5F5F5),
    increasedContrast: Color(0xFFF5F5F5),
  );

  /// `sectionStroke` from liqkit Figma variable-defs.
  static const LiqColorRef sectionStroke = LiqColorRef(
    default_: Color(0x66000000),
    increasedContrast: Color(0x66000000),
  );

  /// `separators/nonOpaque` from liqkit Figma variable-defs.
  static const LiqColorRef separatorsNonOpaque = LiqColorRef(
    default_: Color(0x2BFFFFFF),
    increasedContrast: Color(0x2BFFFFFF),
  );

  /// `separators/opaque` from liqkit Figma variable-defs.
  static const LiqColorRef separatorsOpaque = LiqColorRef(
    default_: Color(0xFF38383A),
    increasedContrast: Color(0xFF38383A),
  );

  /// Iterable view over every canonical color, paired with its
  /// dotted Figma path.
  static const List<MapEntry<String, LiqColorRef>> all =
      <MapEntry<String, LiqColorRef>>[
        MapEntry('accents/blue', accentsBlue),
        MapEntry('accents/brown', accentsBrown),
        MapEntry('accents/cyan', accentsCyan),
        MapEntry('accents/green', accentsGreen),
        MapEntry('accents/indigo', accentsIndigo),
        MapEntry('accents/mint', accentsMint),
        MapEntry('accents/orange', accentsOrange),
        MapEntry('accents/pink', accentsPink),
        MapEntry('accents/purple', accentsPurple),
        MapEntry('accents/red', accentsRed),
        MapEntry('accents/teal', accentsTeal),
        MapEntry('accents/yellow', accentsYellow),
        MapEntry('backgrounds/primary', backgroundsPrimary),
        MapEntry('backgrounds/primaryElevated', backgroundsPrimaryElevated),
        MapEntry('backgrounds/secondary', backgroundsSecondary),
        MapEntry('backgrounds/secondaryElevated', backgroundsSecondaryElevated),
        MapEntry('backgrounds/tertiary', backgroundsTertiary),
        MapEntry('backgrounds/tertiaryElevated', backgroundsTertiaryElevated),
        MapEntry('backgroundsGrouped/primary', backgroundsGroupedPrimary),
        MapEntry(
          'backgroundsGrouped/primaryElevated',
          backgroundsGroupedPrimaryElevated,
        ),
        MapEntry('backgroundsGrouped/secondary', backgroundsGroupedSecondary),
        MapEntry(
          'backgroundsGrouped/secondaryElevated',
          backgroundsGroupedSecondaryElevated,
        ),
        MapEntry('backgroundsGrouped/tertiary', backgroundsGroupedTertiary),
        MapEntry(
          'backgroundsGrouped/tertiaryElevated',
          backgroundsGroupedTertiaryElevated,
        ),
        MapEntry('grays/black', graysBlack),
        MapEntry('grays/gray', graysGray),
        MapEntry('grays/gray2', graysGray2),
        MapEntry('grays/gray3', graysGray3),
        MapEntry('grays/gray4', graysGray4),
        MapEntry('grays/gray5', graysGray5),
        MapEntry('grays/gray6', graysGray6),
        MapEntry('grays/white', graysWhite),
        MapEntry('labels/primary', labelsPrimary),
        MapEntry('labels/quaternary', labelsQuaternary),
        MapEntry('labels/secondary', labelsSecondary),
        MapEntry('labels/tertiary', labelsTertiary),
        MapEntry('sectionFill', sectionFill),
        MapEntry('sectionStroke', sectionStroke),
        MapEntry('separators/nonOpaque', separatorsNonOpaque),
        MapEntry('separators/opaque', separatorsOpaque),
      ];
}

/// A canonical iOS 26 text-style reference per mode.
final class LiqTypographyRef {
  /// Creates a typography reference.
  const LiqTypographyRef({
    required this.default_,
    required this.increasedContrast,
  });

  /// Spec in `default_` mode.
  final LiqTypographySpec default_;

  /// Spec in `increasedContrast` mode.
  final LiqTypographySpec increasedContrast;

  /// Resolves the spec for [mode].
  LiqTypographySpec valueIn(LiqColorMode mode) {
    switch (mode) {
      case LiqColorMode.default_:
        return default_;
      case LiqColorMode.increasedContrast:
        return increasedContrast;
    }
  }
}

/// One canonical typography record (family + size + weight + …).
final class LiqTypographySpec {
  /// Creates a typography spec.
  const LiqTypographySpec({
    required this.family,
    required this.style,
    required this.size,
    required this.weight,
    required this.lineHeight,
    required this.letterSpacing,
  });

  /// Font family (e.g. "SF Pro").
  final String family;

  /// Style label as captured from Figma (e.g. "Regular", "Semibold").
  final String style;

  /// Font size in logical pixels.
  final double size;

  /// Font weight.
  final FontWeight weight;

  /// Line height in logical pixels.
  final double lineHeight;

  /// Tracking in logical pixels.
  final double letterSpacing;
}

/// Every iOS 26 typography token captured from liqkit.
class LiqCanonicalTypography {
  const LiqCanonicalTypography._();

  /// `footnote/emphasized` from liqkit Figma variable-defs.
  static const LiqTypographyRef footnoteEmphasized = LiqTypographyRef(
    default_: LiqTypographySpec(
      family: 'SF Pro',
      style: 'Semibold',
      size: 13.0,
      weight: FontWeight.w600,
      lineHeight: 18.0,
      letterSpacing: -0.08,
    ),
    increasedContrast: LiqTypographySpec(
      family: 'SF Pro',
      style: 'Semibold',
      size: 13.0,
      weight: FontWeight.w600,
      lineHeight: 18.0,
      letterSpacing: -0.08,
    ),
  );

  /// `footnote/regular` from liqkit Figma variable-defs.
  static const LiqTypographyRef footnoteRegular = LiqTypographyRef(
    default_: LiqTypographySpec(
      family: 'SF Pro',
      style: 'Regular',
      size: 13.0,
      weight: FontWeight.w400,
      lineHeight: 18.0,
      letterSpacing: -0.08,
    ),
    increasedContrast: LiqTypographySpec(
      family: 'SF Pro',
      style: 'Regular',
      size: 13.0,
      weight: FontWeight.w400,
      lineHeight: 18.0,
      letterSpacing: -0.08,
    ),
  );

  /// Iterable view over every canonical typography token.
  static const List<MapEntry<String, LiqTypographyRef>> all =
      <MapEntry<String, LiqTypographyRef>>[
        MapEntry('footnote/emphasized', footnoteEmphasized),
        MapEntry('footnote/regular', footnoteRegular),
      ];
}
