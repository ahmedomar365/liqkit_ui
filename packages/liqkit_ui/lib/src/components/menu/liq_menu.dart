import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 menu surface — translucent rounded panel of action rows.
///
/// Sourced from `native/kit.css` (`.ios26-menu-panel`):
/// 238pt wide, 34pt corner radius, 10pt top/bottom padding, translucent
/// `rgba(245,245,245,0.84)` fill, 1pt #d8dce3 border, drop shadow + inset
/// white highlight.
final class LiqMenu extends StatelessWidget {
  /// Creates a menu panel.
  const LiqMenu({
    required this.children,
    this.width = 238,
    this.brightness = Brightness.light,
    super.key,
  });

  /// Children — typically [LiqMenuItem], [LiqMenuSeparator], or
  /// [LiqMenuSectionTitle].
  final List<Widget> children;

  /// Panel width. Defaults to 238pt.
  final double width;

  /// Surface brightness.
  final Brightness brightness;

  static const Color _bgLight = Color(0xD6F5F5F5);
  static const Color _bgDark = Color(0xCC0F0F0F);
  static const Color _borderLight = Color(0xFFD8DCE3);
  static const Color _borderDark = Color(0x70E4E9EF);
  static const Color _shadowLight = Color(0x33000000);
  static const Color _shadowDark = Color(0x6B000000);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(34)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isDark ? _bgDark : _bgLight,
            borderRadius: const BorderRadius.all(Radius.circular(34)),
            border: Border.fromBorderSide(
              BorderSide(color: isDark ? _borderDark : _borderLight),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: isDark ? _shadowDark : _shadowLight,
                offset: const Offset(0, 16),
                blurRadius: 40,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(mainAxisSize: MainAxisSize.min, children: children),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('childrenCount', children.length))
      ..add(EnumProperty<Brightness>('brightness', brightness))
      ..add(DoubleProperty('width', width));
  }
}

/// Style for a single [LiqMenuItem].
enum LiqMenuItemStyle {
  /// Default action: dark label.
  regular,

  /// Destructive action: red label and trailing color.
  destructive,
}

/// Single row inside a [LiqMenu].
final class LiqMenuItem extends StatelessWidget {
  /// Creates a menu row.
  const LiqMenuItem({
    required this.label,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onPressed,
    this.style = LiqMenuItemStyle.regular,
    this.brightness = Brightness.light,
    super.key,
  });

  /// Row label.
  final String label;

  /// Optional small subtitle rendered below [label].
  final String? subtitle;

  /// Optional leading 28×22 icon slot.
  final Widget? icon;

  /// Optional trailing widget (typically a shortcut or chevron).
  final Widget? trailing;

  /// Tap callback. When null the row is rendered disabled.
  final VoidCallback? onPressed;

  /// Visual style.
  final LiqMenuItemStyle style;

  /// Surface brightness (controls disabled / regular tints).
  final Brightness brightness;

  static const Color _labelLight = Color(0xFF1A1A1A);
  static const Color _labelDark = Color(0xFFF5F5F5);
  static const Color _disabledLight = Color(0xFFBFBFBF);
  static const Color _disabledDark = Color(0xFF404040);
  static const Color _destructiveLight = Color(0xFFFF383C);
  static const Color _destructiveDark = Color(0xFFFF4245);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final disabled = onPressed == null;
    Color resolveLabel() {
      if (style == LiqMenuItemStyle.destructive) {
        return isDark ? _destructiveDark : _destructiveLight;
      }
      if (disabled) return isDark ? _disabledDark : _disabledLight;
      return isDark ? _labelDark : _labelLight;
    }

    final labelColor = resolveLabel();

    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 8, 0),
              child: Row(
                children: <Widget>[
                  if (icon != null)
                    SizedBox(width: 28, height: 22, child: Center(child: icon)),
                  if (icon != null) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontFamilyFallback: const <String>[
                              'SF Pro',
                              'sans-serif',
                            ],
                            fontSize: 17,
                            height: 20 / 17,
                            letterSpacing: -0.43,
                            fontWeight: FontWeight.w400,
                            color: labelColor,
                          ),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: 11,
                                height: 13 / 11,
                                letterSpacing: -0.08,
                                fontWeight: FontWeight.w400,
                                color:
                                    isDark
                                        ? const Color(0xFF8A8A8A)
                                        : const Color(0xFF727272),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...<Widget>[
                    const SizedBox(width: 8),
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? _disabledDark : const Color(0xFF727272),
                      ),
                      child: trailing!,
                    ),
                  ],
                ],
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
      ..add(EnumProperty<LiqMenuItemStyle>('style', style))
      ..add(EnumProperty<Brightness>('brightness', brightness))
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

/// 1pt horizontal divider between [LiqMenuItem]s.
final class LiqMenuSeparator extends StatelessWidget {
  /// Creates a separator.
  const LiqMenuSeparator({this.brightness = Brightness.light, super.key});

  /// Surface brightness.
  final Brightness brightness;

  static const Color _light = Color(0xFFE6E6E6);
  static const Color _dark = Color(0xD1F5F5F5);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ColoredBox(
        color: isDark ? _dark : _light,
        child: const SizedBox(height: 1, width: double.infinity),
      ),
    );
  }
}

/// Small section title rendered above a group of menu items.
final class LiqMenuSectionTitle extends StatelessWidget {
  /// Creates a section title.
  const LiqMenuSectionTitle({
    required this.title,
    this.brightness = Brightness.light,
    super.key,
  });

  /// Title text.
  final String title;

  /// Surface brightness.
  final Brightness brightness;

  static const Color _fgLight = Color(0xFF727272);
  static const Color _fgDark = Color(0xDBF5F5F5);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 10),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'SF Pro Text',
          fontSize: 13,
          height: 15 / 13,
          letterSpacing: -0.08,
          fontWeight: FontWeight.w500,
          color: isDark ? _fgDark : _fgLight,
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
