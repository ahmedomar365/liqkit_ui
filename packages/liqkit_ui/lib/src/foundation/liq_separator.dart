import 'package:flutter/widgets.dart';

/// Shared iOS separator and hairline colors.
///
/// Keep separator colors centralized so dark-mode previews, cards, lists,
/// pickers, and documentation examples do not drift into near-invisible
/// per-component values.
abstract final class LiqSeparator {
  /// Standard iOS hairline on light surfaces.
  static const Color light = Color(0x29000000);

  /// Standard iOS hairline on dark surfaces.
  ///
  /// Dark previews often sit on true black or near-black glass scenes, where
  /// the light-mode 16% optical weight disappears. Keep this shared token
  /// visibly hairline-thin while preserving enough contrast to read as a
  /// separator instead of a rendering artifact.
  static const Color dark = Color(0x52FFFFFF);

  /// Softer border on light grouped surfaces.
  static const Color lightBorder = Color(0x1F000000);

  /// Softer border on dark grouped surfaces.
  static const Color darkBorder = dark;
}
