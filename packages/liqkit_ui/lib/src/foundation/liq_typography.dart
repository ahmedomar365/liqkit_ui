/// iOS 26 automatic font-family selection.
///
/// Apple's San Francisco family ships in two optical sizes:
///
///   - **SF Pro Text** — body / caption sizes, < 20pt. Looser
///     letter-spacing, sturdier strokes for legibility at small
///     sizes.
///   - **SF Pro Display** — headline / title sizes, >= 20pt. Tighter
///     spacing, more refined glyphs.
///
/// iOS swaps the family automatically per size. liqkit_ui follows
/// the same rule via [LiqFontFamily.forSize] — call it from any
/// component that builds a `TextStyle` from a size.
final class LiqFontFamily {
  LiqFontFamily._();

  /// SF Pro Text — under 20pt.
  static const String text = 'SF Pro Text';

  /// SF Pro Display — 20pt and up.
  static const String display = 'SF Pro Display';

  /// Fallback chain that lets the platform pick a serviceable
  /// system font when SF isn't installed (Android, web).
  static const List<String> fallback = <String>[
    'SF Pro',
    'system-ui',
    '-apple-system',
    'sans-serif',
  ];

  /// The Apple-rule font family for a given size. Use this instead
  /// of hard-coding `'SF Pro Text'`.
  static String forSize(double fontSize) => fontSize >= 20 ? display : text;
}
