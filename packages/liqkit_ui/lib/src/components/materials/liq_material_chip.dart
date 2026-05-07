import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 material thickness presets.
///
/// Each style controls the translucent material opacity and blur radius.
enum LiqMaterialStyle {
  /// Sheerest material — minimal overlay + small blur.
  ultraThin,

  /// Thin material — light overlay + small blur.
  thin,

  /// Default material — balanced overlay + medium blur.
  regular,

  /// Thicker material — heavy overlay + large blur.
  thick,

  /// Chrome — heaviest overlay + largest blur.
  chrome,

  /// macOS-style sidebar surface (thick + slight desaturation).
  sidebar,

  /// Header / toolbar blur (chrome-equivalent + tighter shadow).
  headerBlur,

  /// Full-screen overlay (thick base, deep blur).
  fullScreenUI,

  /// HUD-style modal (chrome base, very strong blur).
  hudWindow,

  /// Tooltip (regular base, smaller chip default).
  tooltip,

  /// Menu (thick base, sharper hairline).
  menu,

  /// Popover (regular base, lighter hairline).
  popover,

  /// Modal sheet surface.
  sheet,

  /// Window background (subtler than chrome).
  windowBackground,

  /// Content area background (lightest).
  contentBackground,
}

/// Brightness mode for [LiqMaterialChip].
enum LiqMaterialBrightness {
  /// Light variant — white-tinted overlay + light hairline border.
  light,

  /// Dark variant — black-tinted overlay + low-alpha white border.
  dark,
}

/// Caller-tunable visual config for [LiqMaterialChip]. When passed,
/// it overrides the values derived from the chosen [LiqMaterialStyle].
@immutable
class LiqMaterialConfig {
  /// Creates a material config.
  const LiqMaterialConfig({
    this.blurRadius = 50,
    this.opacity = 1.0,
    this.tintOpacity = 0.28,
    this.brightnessAdjust = 0,
    this.saturation = 1.0,
    this.vibrancy = true,
  });

  /// BackdropFilter sigma in logical pixels.
  final double blurRadius;

  /// Outer surface opacity (multiplier on top of resolved tint).
  final double opacity;

  /// Tint overlay alpha in [0, 1].
  final double tintOpacity;

  /// Brightness adjustment in [-1, 1] applied to the core fill.
  final double brightnessAdjust;

  /// Saturation multiplier (1.0 = neutral). Currently informational —
  /// preserved on the public surface so consumers can introspect.
  final double saturation;

  /// Whether to render the inner highlight rim.
  final bool vibrancy;
}

/// A 100x100 material swatch chip — used to preview iOS 26 material
/// thickness presets on top of arbitrary content.
///
/// The Figma material node is a uniform translucent layer with backdrop blur,
/// not a directional gloss painted over the top. In Flutter, this samples the
/// live pixels behind the chip through [BackdropFilter], then applies a single
/// brightness-appropriate tint, rim, and shadow. The component is rendered from
/// live Flutter layers, with no static image or staged reflection asset.
final class LiqMaterialChip extends StatelessWidget {
  /// Creates a material chip.
  const LiqMaterialChip({
    this.style = LiqMaterialStyle.regular,
    this.brightness,
    this.size = const Size(100, 100),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.increasedContrast = false,
    this.padding = EdgeInsets.zero,
    this.child,
    this.config,
    super.key,
  });

  /// The material thickness preset.
  final LiqMaterialStyle style;

  /// Light or dark variant. Defaults to the nearest liq theme brightness.
  final LiqMaterialBrightness? brightness;

  /// Outer dimensions.
  final Size size;

  /// Outer rounded shape.
  final BorderRadius borderRadius;

  /// When true, draws the border at 1.5pt instead of 1pt.
  final bool increasedContrast;

  /// Insets applied around [child].
  final EdgeInsetsGeometry padding;

  /// Optional foreground content rendered inside the material.
  final Widget? child;

  /// Optional override config that supersedes the values derived from
  /// [style] (blur, tint, opacity, vibrancy).
  final LiqMaterialConfig? config;

  static const Color _innerHighlightLight = Color(0xB8FFFFFF);
  static const Color _innerHighlightDark = Color(0x21FFFFFF);
  static const Color _shadowLight = Color(0x24131822);
  static const Color _shadowDark = Color(0x64000000);

  ({double overlay, double core, double blur}) get _styleValues {
    switch (style) {
      case LiqMaterialStyle.ultraThin:
        return (overlay: 0.18, core: 0.46, blur: 24);
      case LiqMaterialStyle.thin:
        return (overlay: 0.23, core: 0.54, blur: 34);
      case LiqMaterialStyle.regular:
        return (overlay: 0.28, core: 0.60, blur: 50);
      case LiqMaterialStyle.thick:
        return (overlay: 0.34, core: 0.68, blur: 66);
      case LiqMaterialStyle.chrome:
        return (overlay: 0.40, core: 0.76, blur: 82);
      case LiqMaterialStyle.sidebar:
        return (overlay: 0.32, core: 0.65, blur: 60);
      case LiqMaterialStyle.headerBlur:
        return (overlay: 0.42, core: 0.78, blur: 90);
      case LiqMaterialStyle.fullScreenUI:
        return (overlay: 0.36, core: 0.70, blur: 75);
      case LiqMaterialStyle.hudWindow:
        return (overlay: 0.45, core: 0.82, blur: 100);
      case LiqMaterialStyle.tooltip:
        return (overlay: 0.30, core: 0.62, blur: 45);
      case LiqMaterialStyle.menu:
        return (overlay: 0.36, core: 0.72, blur: 70);
      case LiqMaterialStyle.popover:
        return (overlay: 0.30, core: 0.62, blur: 55);
      case LiqMaterialStyle.sheet:
        return (overlay: 0.34, core: 0.70, blur: 65);
      case LiqMaterialStyle.windowBackground:
        return (overlay: 0.26, core: 0.58, blur: 40);
      case LiqMaterialStyle.contentBackground:
        return (overlay: 0.22, core: 0.52, blur: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedBrightness =
        brightness ??
        switch (context.liqBrightness) {
          Brightness.dark => LiqMaterialBrightness.dark,
          Brightness.light => LiqMaterialBrightness.light,
        };
    final isDark = resolvedBrightness == LiqMaterialBrightness.dark;
    final v = _styleValues;
    final cfg = config;
    final blurSigma = cfg?.blurRadius ?? v.blur;
    final tintAlpha = cfg?.tintOpacity ?? (isDark ? v.overlay : 0.25);
    final coreAlpha = cfg?.opacity != null
        ? (cfg!.opacity * v.core).clamp(0.0, 1.0)
        : v.core;
    final brightnessShift = cfg?.brightnessAdjust ?? 0;
    final showInnerHighlight = cfg?.vibrancy ?? true;
    final overlayBase =
        isDark ? const Color(0xFF050507) : const Color(0xFFFFFFFF);
    final coreBase = isDark ? const Color(0xFF1E2025) : const Color(0xFFFFFFFF);
    final overlayColor = overlayBase.withValues(alpha: tintAlpha);
    final coreColor = coreBase.withValues(alpha: coreAlpha);
    final borderColor =
        isDark ? const Color(0x30FFFFFF) : const Color(0xD6FFFFFF);
    final innerHighlight = isDark ? _innerHighlightDark : _innerHighlightLight;
    final shadow = isDark ? _shadowDark : _shadowLight;
    final blendedFill = Color.alphaBlend(overlayColor, coreColor);
    final fillColor = brightnessShift == 0
        ? blendedFill
        : _shiftBrightness(blendedFill, brightnessShift);

    final chip = SizedBox.fromSize(
      size: size,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: fillColor,
                  border: Border.all(
                    color: borderColor,
                    width: increasedContrast ? 1.5 : 1,
                  ),
                ),
              ),
              if (showInnerHighlight)
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(color: innerHighlight),
                  ),
                ),
              if (child case final foreground?)
                Padding(padding: padding, child: foreground),
            ],
          ),
        ),
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(color: shadow, offset: const Offset(0, 16), blurRadius: 30),
        ],
      ),
      child: chip,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqMaterialStyle>('style', style))
      ..add(EnumProperty<LiqMaterialBrightness>('brightness', brightness))
      ..add(DiagnosticsProperty<Size>('size', size))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding))
      ..add(
        FlagProperty(
          'increasedContrast',
          value: increasedContrast,
          ifTrue: 'IC border',
        ),
      );
  }
}

Color _shiftBrightness(Color color, double amount) {
  if (amount == 0) return color;
  final clamped = amount.clamp(-1.0, 1.0);
  if (clamped > 0) {
    return Color.lerp(color, const Color(0xFFFFFFFF), clamped) ?? color;
  }
  return Color.lerp(color, const Color(0xFF000000), -clamped) ?? color;
}

/// Captioned material chip — places a 12pt caption 24pt below the chip.
final class LiqMaterialChipCell extends StatelessWidget {
  /// Creates a captioned chip.
  const LiqMaterialChipCell({
    required this.caption,
    required this.chip,
    super.key,
  });

  /// Caption text rendered below the chip in SF Pro Text 500 12/16.
  final String caption;

  /// The chip widget rendered above the caption.
  final Widget chip;

  static const Color _captionColor = Color(0xFF5D6069);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        chip,
        const SizedBox(height: 24),
        Text(
          caption,
          style: const TextStyle(
            color: _captionColor,
            fontFamily: 'SF Pro Text',
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
