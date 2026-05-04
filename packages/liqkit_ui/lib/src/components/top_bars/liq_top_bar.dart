import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 navigation top bar.
///
/// Sourced from `native/components/top-bars.css`:
///   - row 44pt tall, 16pt horizontal padding
///   - centered title 590 17/22 SF Pro Text -0.43 tracking, color #1A1A1A
///   - large title 700 34/41 SF Pro Display +0.4 tracking
///   - action button 44x44 (symbol) or 36x36 accent pill (#0088FF)
final class LiqTopBar extends StatelessWidget {
  /// Creates a top bar.
  const LiqTopBar({
    required this.title,
    this.leading,
    this.trailing,
    this.largeTitle,
    this.brightness,
    super.key,
  });

  /// Centered nav title.
  final String title;

  /// Optional leading widget (e.g. a back button).
  final Widget? leading;

  /// Optional trailing widget (e.g. an accent action).
  final Widget? trailing;

  /// When non-null, renders the large-title row beneath the nav row.
  final String? largeTitle;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

  static const double _rowHeight = 44;
  static const double _hPad = 16;
  static const Color _titleLight = Color(0xFF1A1A1A);
  static const Color _titleDark = Color(0xFFF5F5F7);

  @override
  Widget build(BuildContext context) {
    final isDark = (brightness ?? context.liqBrightness) == Brightness.dark;
    final titleColor = isDark ? _titleDark : _titleLight;
    final titleStyle = TextStyle(
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
      fontSize: 17,
      height: 22 / 17,
      letterSpacing: -0.43,
      fontWeight: FontWeight.w600,
      color: titleColor,
    );
    final largeStyle = TextStyle(
      fontFamily: 'SF Pro Display',
      fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
      fontSize: 34,
      height: 41 / 34,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w700,
      color: titleColor,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: _rowHeight,
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  title,
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _hPad),
                child: Row(
                  children: <Widget>[
                    if (leading != null) leading!,
                    const Spacer(),
                    if (trailing != null) trailing!,
                  ],
                ),
              ),
            ],
          ),
        ),
        if (largeTitle != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(_hPad, 6, _hPad, 8),
            child: Text(
              largeTitle!,
              style: largeStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('largeTitle', largeTitle, defaultValue: null))
      ..add(EnumProperty<Brightness?>('brightness', brightness));
  }
}

/// 44x44 symbol-only nav button (iOS-style icon button).
final class LiqTopBarSymbolButton extends StatelessWidget {
  /// Creates a symbol button.
  const LiqTopBarSymbolButton({
    required this.glyph,
    required this.onPressed,
    this.brightness,
    super.key,
  });

  /// Glyph to render (e.g. '‹', '◍', single character or symbol).
  final String glyph;

  /// Tap callback. When null the button is rendered disabled.
  final VoidCallback? onPressed;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

  static const Color _accentLight = Color(0xFF0088FF);
  static const Color _accentDark = Color(0xFF0091FF);
  static const Color _disabled = Color(0x4D3C3C43);

  @override
  Widget build(BuildContext context) {
    final isDark = (brightness ?? context.liqBrightness) == Brightness.dark;
    final color =
        onPressed == null ? _disabled : (isDark ? _accentDark : _accentLight);
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: LiqPointerCursor(
        enabled: onPressed != null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Text(
                glyph,
                style: TextStyle(
                  fontFamily: LiqFontFamily.display,
                  fontSize: 22,
                  height: 1,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 36x36 accent pill action button used in iOS 26 top bars.
final class LiqTopBarAccentButton extends StatelessWidget {
  /// Creates an accent action button.
  const LiqTopBarAccentButton({
    required this.glyph,
    required this.onPressed,
    super.key,
  });

  /// Glyph to render.
  final String glyph;

  /// Tap callback.
  final VoidCallback? onPressed;

  static const Color _accent = Color(0xFF0088FF);
  static const double _tapTargetSize = 44;
  static const double _pillSize = 36;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: LiqPointerCursor(
        enabled: onPressed != null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: SizedBox(
            width: _tapTargetSize,
            height: _tapTargetSize,
            child: Center(
              child: Container(
                width: _pillSize,
                height: _pillSize,
                decoration: const BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0x1F000000),
                      offset: Offset(0, 1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  glyph,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 18,
                    height: 1,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
