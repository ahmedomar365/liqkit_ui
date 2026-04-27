import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Brightness mode shared across system primitives.
enum LiqSystemBrightness {
  /// Light variant.
  light,

  /// Dark variant.
  dark,
}

/// Layout / orientation enum for [LiqHomeIndicator].
enum LiqHomeIndicatorLayout {
  /// 34pt-tall iPhone portrait slot.
  iphonePortrait,

  /// 21pt-tall iPhone landscape slot.
  iphoneLandscape,

  /// 19.5pt-tall iPad slot.
  ipadPortrait,

  /// 19.5pt-tall iPad slot.
  ipadLandscape,
}

/// 144×5 black home indicator pill, bottom-aligned inside a device-tinted
/// 11pt rounded slot.
///
/// Sourced from `native/components/system.css`.
final class LiqHomeIndicator extends StatelessWidget {
  /// Creates a home indicator.
  const LiqHomeIndicator({
    this.layout = LiqHomeIndicatorLayout.iphonePortrait,
    super.key,
  });

  /// Slot layout / orientation.
  final LiqHomeIndicatorLayout layout;

  static const Color _slotBg = Color(0xFFF4F5F8);
  static const Color _slotBorder = Color(0xFFD8DBE3);
  static const Color _bar = Color(0xFF000000);

  ({double height, double bottomPad}) get _slotSize {
    switch (layout) {
      case LiqHomeIndicatorLayout.iphonePortrait:
        return (height: 34, bottomPad: 8);
      case LiqHomeIndicatorLayout.iphoneLandscape:
        return (height: 21, bottomPad: 4);
      case LiqHomeIndicatorLayout.ipadPortrait:
      case LiqHomeIndicatorLayout.ipadLandscape:
        return (height: 19.5, bottomPad: 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _slotSize;
    return Container(
      height: s.height,
      decoration: const BoxDecoration(
        color: _slotBg,
        borderRadius: BorderRadius.all(Radius.circular(11)),
        border: Border.fromBorderSide(BorderSide(color: _slotBorder)),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: s.bottomPad),
          child: Container(
            width: 144,
            height: 5,
            decoration: const BoxDecoration(
              color: _bar,
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<LiqHomeIndicatorLayout>('layout', layout));
  }
}

/// Action pill style for [LiqSystemActionPill].
enum LiqSystemActionPillStyle {
  /// Default — system-coloured 14pt label.
  regular,

  /// Destructive — #FF3B30 (light) / #FF5F57 (dark) label.
  destructive,
}

/// 42pt rounded gradient pill — used inside Home-Screen Quick Actions
/// rows (HSQA) for action labels.
final class LiqSystemActionPill extends StatelessWidget {
  /// Creates an action pill.
  const LiqSystemActionPill({
    required this.label,
    this.style = LiqSystemActionPillStyle.regular,
    this.brightness = LiqSystemBrightness.light,
    this.onPressed,
    super.key,
  });

  /// Pill label text rendered in 500 14/20.
  final String label;

  /// Regular or destructive variant.
  final LiqSystemActionPillStyle style;

  /// Light or dark variant.
  final LiqSystemBrightness brightness;

  /// Optional tap handler.
  final VoidCallback? onPressed;

  static const Color _lightBorder = Color(0x14000000);
  static const Color _darkBorder = Color(0x29FFFFFF);
  static const Color _lightLabel = Color(0xFF181A1F);
  static const Color _darkLabel = Color(0xFFF1F3F7);
  static const Color _lightDestructive = Color(0xFFFF3B30);
  static const Color _darkDestructive = Color(0xFFFF5F57);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == LiqSystemBrightness.dark;
    final isDestructive = style == LiqSystemActionPillStyle.destructive;
    final color = isDestructive
        ? (isDark ? _darkDestructive : _lightDestructive)
        : (isDark ? _darkLabel : _lightLabel);
    final borderColor = isDark ? _darkBorder : _lightBorder;
    final gradient = isDark
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xB8565C6B), Color(0xE6323744)],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xB8FFFFFF), Color(0xE6E6E9EE)],
          );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontFamily: 'SF Pro Text',
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.w500,
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
      ..add(EnumProperty<LiqSystemActionPillStyle>('style', style))
      ..add(EnumProperty<LiqSystemBrightness>('brightness', brightness));
  }
}

/// 38×38 round toggle dot — used as a single-cell radio inside HSQA
/// rows. Selected state fills with system blue + 2pt halo.
final class LiqSystemToggleDot extends StatelessWidget {
  /// Creates a toggle dot.
  const LiqSystemToggleDot({
    this.selected = false,
    this.onPressed,
    super.key,
  });

  /// When true, dot fills with #0A84FF + halo.
  final bool selected;

  /// Optional tap handler.
  final VoidCallback? onPressed;

  static const Color _bg = Color(0xFFF0F2F6);
  static const Color _border = Color(0x1F000000);
  static const Color _selected = Color(0xFF0A84FF);
  static const Color _halo = Color(0x3D0A84FF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: selected ? _selected : _bg,
          shape: BoxShape.circle,
          border: Border.all(color: _border),
          boxShadow: selected
              ? const <BoxShadow>[
                  BoxShadow(color: _halo, spreadRadius: 2),
                ]
              : null,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('selected', value: selected, ifTrue: 'on'));
  }
}
