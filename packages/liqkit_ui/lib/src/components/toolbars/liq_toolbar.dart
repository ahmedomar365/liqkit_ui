import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
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

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final fg = context.liqLabelColor;
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 44),
              child: LiqGlassSurface(
                borderRadius: const BorderRadius.all(Radius.circular(296)),
                padding: symbolOnly
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 44,
                  width: symbolOnly ? 44 : null,
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontFamilyFallback: const <String>[
                          'SF Pro',
                          'sans-serif',
                        ],
                        fontSize: 17,
                        height: 22 / 17,
                        letterSpacing: -0.43,
                        fontWeight: FontWeight.w500,
                        color: fg,
                      ),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
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

  @override
  Widget build(BuildContext context) {
    final isDark = (brightness ?? context.liqBrightness) == Brightness.dark;
    final fg = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    return LiqPointerCursor(
      enabled: onPressed != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 30),
          child: LiqGlassSurface(
            tint: isDark ? LiqGlassTint.dark : LiqGlassTint.light,
            borderRadius: const BorderRadius.all(Radius.circular(9)),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: 11,
                height: 14 / 11,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
  }
}
