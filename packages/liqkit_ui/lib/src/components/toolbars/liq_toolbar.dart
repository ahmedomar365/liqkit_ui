import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 toolbar action button (glass-style 44pt pill).
///
/// Sourced from `native/components/toolbars.css`:
///   - 44pt tall, min 44pt wide, radius 296 (full pill)
///   - background #F7F7F7, color #1A1A1A
///   - inset 0 0 0 1px rgba(255,255,255,0.85) (top highlight)
final class LiqToolbarGlassButton extends StatelessWidget {
  /// Creates a glass toolbar button.
  const LiqToolbarGlassButton({
    required this.label,
    required this.onPressed,
    this.symbolOnly = false,
    super.key,
  });

  /// Glyph or label to render.
  final String label;

  /// Tap callback. When null the button is rendered disabled.
  final VoidCallback? onPressed;

  /// When true, button is exactly 44x44 (no horizontal padding).
  final bool symbolOnly;

  static const Color _bg = Color(0xFFF7F7F7);
  static const Color _fg = Color(0xFF1A1A1A);
  static const Color _highlight = Color(0xD9FFFFFF);

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: LiqPointerCursor(
        enabled: !disabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Opacity(
            opacity: disabled ? 0.5 : 1,
            child: Container(
              height: 44,
              constraints: const BoxConstraints(minWidth: 44),
              padding:
                  symbolOnly
                      ? null
                      : const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: const BorderRadius.all(Radius.circular(296)),
                border: Border.all(color: _highlight),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                  fontSize: 17,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  fontWeight: FontWeight.w500,
                  color: _fg,
                ),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(
        FlagProperty('symbolOnly', value: symbolOnly, ifTrue: 'symbol-only'),
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

/// iOS 26 toolbar — horizontal row of [LiqToolbarGlassButton]s.
///
/// Layout: leading + trailing groups separated by a Spacer.
final class LiqToolbar extends StatelessWidget {
  /// Creates a toolbar.
  const LiqToolbar({
    this.leading = const <Widget>[],
    this.trailing = const <Widget>[],
    super.key,
  });

  /// Items pinned to the start.
  final List<Widget> leading;

  /// Items pinned to the end.
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: <Widget>[
          for (var i = 0; i < leading.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 8),
            leading[i],
          ],
          const Spacer(),
          for (var i = 0; i < trailing.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 8),
            trailing[i],
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('leadingCount', leading.length))
      ..add(IntProperty('trailingCount', trailing.length));
  }
}

/// 30pt chip used as a small toolbar tag/filter.
final class LiqToolbarChip extends StatelessWidget {
  /// Creates a chip.
  const LiqToolbarChip({
    required this.label,
    this.onPressed,
    this.brightness,
    super.key,
  });

  /// Display label.
  final String label;

  /// Optional tap callback.
  final VoidCallback? onPressed;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _bgDark = Color(0xFF1F2937);
  static const Color _borderLight = Color(0xFFDBE1EA);
  static const Color _borderDark = Color(0xFF334155);
  static const Color _fgLight = Color(0xFF334155);
  static const Color _fgDark = Color(0xFFCBD5E1);

  @override
  Widget build(BuildContext context) {
    final isDark = (brightness ?? context.liqBrightness) == Brightness.dark;
    return LiqPointerCursor(
      enabled: onPressed != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: 30),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
            color: isDark ? _bgDark : _bgLight,
            borderRadius: const BorderRadius.all(Radius.circular(9)),
            border: Border.all(color: isDark ? _borderDark : _borderLight),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 11,
              height: 14 / 11,
              fontWeight: FontWeight.w500,
              color: isDark ? _fgDark : _fgLight,
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}
