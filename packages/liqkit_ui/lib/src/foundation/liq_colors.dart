// Color names speak for themselves; redundant per-member docs add noise.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';

/// Drop-in palette for callsites that previously imported Material's
/// [Colors] class. Each entry maps to the closest LiqAppleColors value
/// or a const Color literal, so the showcase can write
/// `LiqColors.red` instead of pulling in `package:flutter/material.dart`
/// just for the standard color names.
///
/// The named tones (`red`, `blue`, etc.) intentionally pick the iOS 26
/// system color rather than Material's 500 tone — the visual is closer
/// to what an iOS design system should look like.
class LiqColors {
  const LiqColors._();

  // ─── Greyscale ──────────────────────────────────────────────────────
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Material-style alpha fades on white.
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white54 = Color(0x8AFFFFFF);
  static const Color white38 = Color(0x61FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);

  // Material-style alpha fades on black.
  static const Color black87 = Color(0xDE000000);
  static const Color black54 = Color(0x8A000000);
  static const Color black45 = Color(0x73000000);
  static const Color black38 = Color(0x61000000);
  static const Color black26 = Color(0x42000000);
  static const Color black12 = Color(0x1F000000);

  // ─── Apple system tones (iOS 26 light) ──────────────────────────────
  static const Color red = LiqAppleColors.systemRed;
  static const Color orange = LiqAppleColors.systemOrange;
  static const Color yellow = LiqAppleColors.systemYellow;
  static const Color green = LiqAppleColors.systemGreen;
  static const Color mint = LiqAppleColors.systemMint;
  static const Color teal = LiqAppleColors.systemTeal;
  static const Color cyan = LiqAppleColors.systemCyan;
  static const Color blue = LiqAppleColors.systemBlue;
  static const Color indigo = LiqAppleColors.systemIndigo;
  static const Color purple = LiqAppleColors.systemPurple;
  static const Color pink = LiqAppleColors.systemPink;
  static const Color brown = LiqAppleColors.systemBrown;
  static const Color gray = LiqAppleColors.systemGray;
  static const Color grey = LiqAppleColors.systemGray;

  // Common Material aliases.
  static const Color amber = Color(0xFFFFC107);
  static const Color lime = Color(0xFFCDDC39);
  static const Color lightBlue = Color(0xFF03A9F4);
  static const Color lightGreen = Color(0xFF8BC34A);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color blueGrey = Color(0xFF607D8B);

  // ─── Material grey ramp (50–900) ────────────────────────────────────
  // Provided for adapters that previously called Colors.grey.shade100/etc.
  static const LiqColorRamp greyRamp = LiqColorRamp(
    p50: Color(0xFFFAFAFA),
    p100: Color(0xFFF5F5F5),
    p200: Color(0xFFEEEEEE),
    p300: Color(0xFFE0E0E0),
    p400: Color(0xFFBDBDBD),
    p500: Color(0xFF9E9E9E),
    p600: Color(0xFF757575),
    p700: Color(0xFF616161),
    p800: Color(0xFF424242),
    p900: Color(0xFF212121),
  );
}

/// A simple Material-style color ramp accessor.
///
/// Use as `LiqColors.greyRamp.shade(700)` to fetch a tone, mirroring
/// `Colors.grey.shade700` from Material.
class LiqColorRamp {
  const LiqColorRamp({
    required this.p50,
    required this.p100,
    required this.p200,
    required this.p300,
    required this.p400,
    required this.p500,
    required this.p600,
    required this.p700,
    required this.p800,
    required this.p900,
  });

  final Color p50;
  final Color p100;
  final Color p200;
  final Color p300;
  final Color p400;
  final Color p500;
  final Color p600;
  final Color p700;
  final Color p800;
  final Color p900;

  Color shade(int tone) => switch (tone) {
        50 => p50,
        100 => p100,
        200 => p200,
        300 => p300,
        400 => p400,
        500 => p500,
        600 => p600,
        700 => p700,
        800 => p800,
        900 => p900,
        _ => p500,
      };
}
