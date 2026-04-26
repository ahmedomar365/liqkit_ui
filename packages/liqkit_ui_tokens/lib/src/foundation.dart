// GENERATED FILE - DO NOT EDIT BY HAND.
// Source: packages/liqkit_ui_design_data/manifests/tokens.json
// SHA-256: f0aac47ec577c298f075fcdf93c58da38ee14d0b9a02eb2e1b72c128a8d01f2b
// Translator: tooling/gen/translate_tokens.dart
// Section: foundation
// ignore_for_file: lines_longer_than_80_chars, public_member_api_docs, prefer_single_quotes

import 'dart:ui' show Color;

/// Foundation tokens generated from liqkit.
class LiqFoundationTokens {
  /// Schema version of the foundation token set.
  static const int schemaVersion = 1;

  /// Foundation colors keyed by liqkit name.
  static const Map<String, Color> colors = <String, Color>{
    'blue': Color(0xFF0A84FF),
    'green': Color(0xFF30D158),
    'red': Color(0xFFFF453A),
    'white': Color(0xFFFFFFFF),
    'black': Color(0xFF000000),
  };

  /// Foundation corner radii (logical pixels).
  static const Map<String, double> radii = <String, double>{
    'sm': 8.0,
    'md': 12.0,
    'lg': 16.0,
    'pill': 999.0,
  };

  /// Foundation spacings (logical pixels).
  static const Map<String, double> spacing = <String, double>{
    'xxs': 4.0,
    'xs': 8.0,
    'sm': 12.0,
    'md': 16.0,
    'lg': 20.0,
  };

  /// Foundation motion durations.
  static const Map<String, Duration> motion = <String, Duration>{
    'fast': Duration(milliseconds: 120),
    'normal': Duration(milliseconds: 200),
    'slow': Duration(milliseconds: 320),
  };
}
