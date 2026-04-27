import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 material thickness presets.
///
/// Each style controls the overlay alpha + core alpha + blur radius.
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
}

/// Brightness mode for [LiqMaterialChip].
enum LiqMaterialBrightness {
  /// Light variant — white-tinted overlay + light hairline border.
  light,

  /// Dark variant — black-tinted overlay + low-alpha white border.
  dark,
}

/// A 100×100 material swatch chip — used to preview iOS 26 material
/// thickness presets on top of arbitrary content.
///
/// Sourced from `native/components/materials.css`. The CSS uses
/// `backdrop-filter: blur(...)` to sample whatever sits behind the chip,
/// then overlays a light or dark tint to taste. In Flutter, we wrap the
/// chip in a [BackdropFilter] (clipped to the rounded shape) so the
/// blur applies to whatever paints behind it, then layer the tint and
/// the highlight on top. When [LiqMaterialChip] paints over an opaque
/// solid colour, the blur is a no-op and only the tint is visible — the
/// same as the CSS spec.
final class LiqMaterialChip extends StatelessWidget {
  /// Creates a material chip.
  const LiqMaterialChip({
    this.style = LiqMaterialStyle.regular,
    this.brightness = LiqMaterialBrightness.light,
    this.size = const Size(100, 100),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.increasedContrast = false,
    super.key,
  });

  /// The material thickness preset.
  final LiqMaterialStyle style;

  /// Light or dark variant.
  final LiqMaterialBrightness brightness;

  /// Outer dimensions.
  final Size size;

  /// Outer rounded shape.
  final BorderRadius borderRadius;

  /// When true, draws the border at 1.5pt instead of 1pt.
  final bool increasedContrast;

  static const Color _innerHighlightLight = Color(0xCCFFFFFF);
  static const Color _innerHighlightDark = Color(0x1FFFFFFF);
  static const Color _shadowLight = Color(0x1F131822);
  static const Color _shadowDark = Color(0x57000000);

  ({double overlay, double core, double blur}) get _styleValues {
    switch (style) {
      case LiqMaterialStyle.ultraThin:
        return (overlay: 0.28, core: 0.50, blur: 16);
      case LiqMaterialStyle.thin:
        return (overlay: 0.34, core: 0.58, blur: 28);
      case LiqMaterialStyle.regular:
        return (overlay: 0.42, core: 0.64, blur: 44);
      case LiqMaterialStyle.thick:
        return (overlay: 0.54, core: 0.74, blur: 60);
      case LiqMaterialStyle.chrome:
        return (overlay: 0.68, core: 0.82, blur: 76);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == LiqMaterialBrightness.dark;
    final v = _styleValues;
    final overlayBase =
        isDark
            ? const Color.fromARGB(255, 16, 17, 21)
            : const Color.fromARGB(255, 255, 255, 255);
    final coreBase =
        isDark
            ? const Color.fromARGB(255, 35, 37, 44)
            : const Color.fromARGB(255, 255, 255, 255);
    final overlayColor = overlayBase.withValues(
      alpha: isDark ? 0.58 : v.overlay,
    );
    final coreColor = coreBase.withValues(alpha: isDark ? 0.74 : v.core);
    final borderColor =
        isDark ? const Color(0x33FFFFFF) : const Color(0xC2FFFFFF);
    final innerHighlight = isDark ? _innerHighlightDark : _innerHighlightLight;
    final shadow = isDark ? _shadowDark : _shadowLight;

    final chip = SizedBox.fromSize(
      size: size,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: v.blur / 2, sigmaY: v.blur / 2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: const LinearGradient(
                begin: Alignment(0.55, -1),
                end: Alignment(-0.55, 1),
                colors: <Color>[Color(0x4DFFFFFF), Color(0x00FFFFFF)],
                stops: <double>[0, 0.68],
              ),
              color: Color.alphaBlend(overlayColor, coreColor),
              border: Border.all(
                color: borderColor,
                width: increasedContrast ? 1.5 : 1,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(color: innerHighlight),
              ),
            ),
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
      ..add(
        FlagProperty(
          'increasedContrast',
          value: increasedContrast,
          ifTrue: 'IC border',
        ),
      );
  }
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
