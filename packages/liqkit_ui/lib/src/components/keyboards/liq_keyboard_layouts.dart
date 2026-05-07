import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/keyboards/liq_keyboard.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Predefined keyboard layouts for [LiqKeyboard]. Selects which set
/// of [List<List<String>>] to render via the `keyRows` parameter.
enum LiqKeyboardLayout {
  /// QWERTY alphabetic layout (lowercase).
  alphabetic,

  /// Numeric pad (0-9 plus arithmetic).
  numeric,

  /// Decimal numeric pad (0-9 + period).
  decimal,

  /// Phone keypad (0-9 plus *#+).
  phone,

  /// Email layout — alphabetic with @ shortcut row.
  email,

  /// URL layout — alphabetic with .com shortcut row.
  url,

  /// Emoji palette (sample 24 emojis).
  emoji,
}

/// Visual brightness preset for [LiqKeyboard]. Currently informational
/// — pass through to LiqTheme to drive the surface coloring.
enum LiqKeyboardAppearance {
  /// Force light keyboard.
  light,

  /// Force dark keyboard.
  dark,

  /// Inherit from ambient LiqTheme.
  auto,
}

/// Predefined key rows for [LiqKeyboardLayout.numeric].
const List<List<String>> liqKeyboardNumericRows = <List<String>>[
  <String>['1', '2', '3'],
  <String>['4', '5', '6'],
  <String>['7', '8', '9'],
  <String>['+', '0', '-'],
];

/// Predefined key rows for [LiqKeyboardLayout.decimal].
const List<List<String>> liqKeyboardDecimalRows = <List<String>>[
  <String>['1', '2', '3'],
  <String>['4', '5', '6'],
  <String>['7', '8', '9'],
  <String>['.', '0', '⌫'],
];

/// Predefined key rows for [LiqKeyboardLayout.phone].
const List<List<String>> liqKeyboardPhoneRows = <List<String>>[
  <String>['1', '2', '3'],
  <String>['4', '5', '6'],
  <String>['7', '8', '9'],
  <String>['*', '0', '#'],
  <String>['+', ' ', '⌫'],
];

/// Predefined key rows for [LiqKeyboardLayout.email].
const List<List<String>> liqKeyboardEmailRows = <List<String>>[
  <String>['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
  <String>['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
  <String>['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  <String>['@', '.', '_', '-'],
];

/// Predefined key rows for [LiqKeyboardLayout.url].
const List<List<String>> liqKeyboardUrlRows = <List<String>>[
  <String>['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
  <String>['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
  <String>['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  <String>['.com', '.', '/', '?'],
];

/// Predefined key rows for [LiqKeyboardLayout.emoji].
const List<List<String>> liqKeyboardEmojiRows = <List<String>>[
  <String>['😀', '😂', '🥰', '😎', '🤔', '😴', '🙃', '😇'],
  <String>['👍', '👎', '🙏', '👏', '✌️', '🤞', '👌', '🤝'],
  <String>['❤️', '💔', '🔥', '⭐', '🎉', '✨', '💯', '🏆'],
];

/// Returns the canonical key rows for [layout].
List<List<String>> liqKeyboardRowsFor(LiqKeyboardLayout layout) =>
    switch (layout) {
      LiqKeyboardLayout.alphabetic => liqKeyboardQwertyRows,
      LiqKeyboardLayout.numeric => liqKeyboardNumericRows,
      LiqKeyboardLayout.decimal => liqKeyboardDecimalRows,
      LiqKeyboardLayout.phone => liqKeyboardPhoneRows,
      LiqKeyboardLayout.email => liqKeyboardEmailRows,
      LiqKeyboardLayout.url => liqKeyboardUrlRows,
      LiqKeyboardLayout.emoji => liqKeyboardEmojiRows,
    };

/// Layout-aware wrapper around [LiqKeyboard] that picks key rows for
/// the given [layout] and forwards [suggestions] / [width] /
/// [minHeight].
final class LiqLayoutKeyboard extends StatelessWidget with Diagnosticable {
  /// Creates a layout-aware keyboard.
  const LiqLayoutKeyboard({
    this.layout = LiqKeyboardLayout.alphabetic,
    this.appearance = LiqKeyboardAppearance.auto,
    this.suggestions = const <String>['"The"', 'the', 'to'],
    this.width = 402,
    this.minHeight = 320,
    super.key,
  });

  final LiqKeyboardLayout layout;
  final LiqKeyboardAppearance appearance;
  final List<String> suggestions;
  final double width;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final isDark = switch (appearance) {
      LiqKeyboardAppearance.light => false,
      LiqKeyboardAppearance.dark => true,
      LiqKeyboardAppearance.auto => context.liqIsDark,
    };
    return _AppearanceTheme(
      isDark: isDark,
      child: LiqKeyboard(
        keyRows: liqKeyboardRowsFor(layout),
        suggestions: suggestions,
        width: width,
        minHeight: minHeight,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqKeyboardLayout>('layout', layout))
      ..add(EnumProperty<LiqKeyboardAppearance>('appearance', appearance));
  }
}

/// Caption strip with three predicted next-word chips. Use above any
/// text input that doesn't already render the keyboard suggestion bar.
final class LiqKeyboardSuggestionBar extends StatelessWidget
    with Diagnosticable {
  /// Creates a suggestion bar.
  const LiqKeyboardSuggestionBar({
    required this.suggestions,
    this.onSelect,
    super.key,
  });

  final List<String> suggestions;
  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final textStyle = LiqAppleTypography.body(brightness).copyWith(
      fontWeight: LiqAppleTypography.semibold,
    );
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1C1E)
            : const Color(0xFFE5E5EA),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0x1AEBEBF5)
                : const Color(0x1A3C3C43),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          for (var i = 0; i < suggestions.length; i++) ...<Widget>[
            if (i > 0)
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? const Color(0x33EBEBF5)
                    : const Color(0x1A3C3C43),
              ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSelect == null
                    ? null
                    : () => onSelect!(suggestions[i]),
                child: Center(
                  child: Text(suggestions[i], style: textStyle),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('suggestionCount', suggestions.length));
  }
}

class _AppearanceTheme extends StatelessWidget {
  const _AppearanceTheme({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Force the brightness via MediaQuery so LiqKeyboard's palette
    // resolver picks the desired surface.
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        platformBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: child,
    );
  }
}
