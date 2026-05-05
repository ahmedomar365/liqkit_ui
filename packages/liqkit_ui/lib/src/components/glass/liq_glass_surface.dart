import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Tint preset for [LiqGlassSurface].
enum LiqGlassTint {
  /// iOS 26 chrome / popover glass — light translucent.
  light,

  /// iOS 26 dark surfaces (action sheet on dark, status bar dark
  /// mode, etc.).
  dark,

  /// For controls layered over arbitrary content where backdrop blur
  /// would muddy text. Falls back to a near-opaque surface with no
  /// [BackdropFilter].
  opaque,
}

/// Elevation preset for [LiqGlassSurface]. Drives the outer shadow.
enum LiqGlassElevation {
  /// Sits flat on its parent (sidebars, inline panels).
  flat,

  /// Floats above content (dialogs, popovers, hover cards, drawers).
  floating,

  /// Modal overlay with a heavier shadow (sheets at full screen).
  modal,
}

/// iOS 26 Liquid Glass material primitive.
///
/// Renders a translucent surface with proper backdrop blur, a uniform
/// material tint, and a hairline rim. Use this
/// everywhere a component needs an iOS-26 glass panel — instead of
/// hand-rolling the colors and shadows.
///
/// The widget paints, in order:
/// 1. A [BackdropFilter] that samples whatever sits behind the surface
///    (skipped for [LiqGlassTint.opaque]).
/// 2. A tint-specific base fill.
/// 3. An optional, very subtle optical highlight.
/// 4. A 0.5pt hairline rim.
/// 5. The [child] wrapped in [padding].
///
/// An outer drop shadow is layered behind the clipped surface. The
/// shadow weight is driven by [elevation].
final class LiqGlassSurface extends StatelessWidget with Diagnosticable {
  /// Creates a Liquid Glass surface.
  const LiqGlassSurface({
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.padding = EdgeInsets.zero,
    this.tint = LiqGlassTint.light,
    this.elevation = LiqGlassElevation.floating,
    this.baseFill,
    this.rimColor,
    this.highlightStart,
    this.blurSigma = defaultBlurSigma,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
    super.key,
  });

  /// Content rendered inside the glass surface.
  final Widget child;

  /// Outer corner radius. Drives both the [ClipRRect] and the rim
  /// hairline. Defaults to a 14pt rounded rectangle, the iOS 26 default
  /// for popover glass.
  final BorderRadius borderRadius;

  /// Padding applied around [child] inside the glass surface.
  final EdgeInsetsGeometry padding;

  /// Tint preset. Drives the base fill and rim colors.
  final LiqGlassTint tint;

  /// Elevation preset. Drives the outer drop shadow.
  final LiqGlassElevation elevation;

  /// Optional base fill override for components with an artifact-specific
  /// material recipe.
  final Color? baseFill;

  /// Optional hairline rim override.
  final Color? rimColor;

  /// Optional optical highlight override. Keep this subtle; the material
  /// should read as sampled glass, not as a separate painted overlay.
  final Color? highlightStart;

  /// Backdrop blur sigma.
  final double blurSigma;

  /// Optional shadow override for components with an artifact-specific
  /// elevation recipe.
  final List<BoxShadow>? shadows;

  /// Clip behavior for the inner [ClipRRect]. Defaults to
  /// [Clip.antiAlias] for crisp rounded corners.
  final Clip clipBehavior;

  // -- iOS 26 spec values ----------------------------------------------------

  /// Light tint base fill. Mostly uniform so content beneath reads through
  /// the blur without creating a separate painted band.
  static const Color lightTintBase = Color(0xE6F5F5F7);

  /// Dark tint base fill. Opaque enough to keep dark chrome visually
  /// continuous over mixed imagery while still sampling the backdrop.
  static const Color darkTintBase = Color(0xE61C1C1E);

  /// Opaque light fallback: no transparency, no blur.
  static const Color opaqueLightTintBase = Color(0xFFFAFAFA);

  /// Opaque dark fallback: no transparency, no blur.
  static const Color opaqueDarkTintBase = Color(0xFF1C1C1E);

  /// Light-tint inner border (rim) hairline color: 8% black.
  static const Color lightRimColor = Color(0x14000000);

  /// Dark-tint inner border (rim) hairline color: 8% white.
  static const Color darkRimColor = Color(0x14FFFFFF);

  /// Optional optical highlight start color for light tint.
  static const Color lightHighlightStart = Color(0x06FFFFFF);

  /// Optional optical highlight start color for dark tint.
  static const Color darkHighlightStart = Color(0x04FFFFFF);

  /// Vibrancy highlight end color (transparent white).
  static const Color highlightEnd = Color(0x00FFFFFF);

  /// Backdrop blur sigma. Matches `UIBlurEffect.systemMaterial`.
  static const double defaultBlurSigma = 30;

  /// Floating drop shadow.
  static const BoxShadow floatingShadow = BoxShadow(
    color: Color(0x33000000),
    offset: Offset(0, 8),
    blurRadius: 24,
  );

  /// Modal drop shadow.
  static const BoxShadow modalShadow = BoxShadow(
    color: Color(0x4D000000),
    offset: Offset(0, 16),
    blurRadius: 40,
  );

  List<BoxShadow> get _shadows {
    final customShadows = shadows;
    if (customShadows != null) return customShadows;

    switch (elevation) {
      case LiqGlassElevation.flat:
        return const <BoxShadow>[];
      case LiqGlassElevation.floating:
        return const <BoxShadow>[floatingShadow];
      case LiqGlassElevation.modal:
        return const <BoxShadow>[modalShadow];
    }
  }

  Color _baseFillFor(LiqGlassTint effectiveTint, {required bool isDark}) {
    final customBaseFill = baseFill;
    if (customBaseFill != null) return customBaseFill;

    switch (effectiveTint) {
      case LiqGlassTint.light:
        return lightTintBase;
      case LiqGlassTint.dark:
        return darkTintBase;
      case LiqGlassTint.opaque:
        return isDark ? opaqueDarkTintBase : opaqueLightTintBase;
    }
  }

  Color _rimColorFor(LiqGlassTint effectiveTint) {
    final customRimColor = rimColor;
    if (customRimColor != null) return customRimColor;

    switch (effectiveTint) {
      case LiqGlassTint.light:
      case LiqGlassTint.opaque:
        return lightRimColor;
      case LiqGlassTint.dark:
        return darkRimColor;
    }
  }

  Color _highlightStartFor(LiqGlassTint effectiveTint) {
    final customHighlightStart = highlightStart;
    if (customHighlightStart != null) return customHighlightStart;

    switch (effectiveTint) {
      case LiqGlassTint.light:
      case LiqGlassTint.opaque:
        return lightHighlightStart;
      case LiqGlassTint.dark:
        return darkHighlightStart;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final effectiveTint =
        context.liqUseOpaqueMaterials
            ? LiqGlassTint.opaque
            : tint == LiqGlassTint.light && isDark
            ? LiqGlassTint.dark
            : tint;
    final layers = <Widget>[];

    if (effectiveTint != LiqGlassTint.opaque) {
      layers.add(
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: const SizedBox.expand(),
          ),
        ),
      );
    }

    layers.add(
      Positioned.fill(
        child: ColoredBox(color: _baseFillFor(effectiveTint, isDark: isDark)),
      ),
    );

    final highlightStart = _highlightStartFor(effectiveTint);
    if (highlightStart.a > 0) {
      layers.add(
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[highlightStart, highlightEnd],
                  stops: const <double>[0, 0.16],
                ),
              ),
            ),
          ),
        ),
      );
    }

    layers
      ..add(
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  width: 0.5,
                  color: _rimColorFor(effectiveTint),
                ),
              ),
            ),
          ),
        ),
      )
      ..add(Padding(padding: padding, child: child));

    final clipped = ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: Stack(children: layers),
    );

    final shadows = _shadows;
    if (shadows.isEmpty) {
      return clipped;
    }

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: shadows),
      child: clipped,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqGlassTint>('tint', tint))
      ..add(EnumProperty<LiqGlassElevation>('elevation', elevation))
      ..add(ColorProperty('baseFill', baseFill, defaultValue: null))
      ..add(ColorProperty('rimColor', rimColor, defaultValue: null))
      ..add(ColorProperty('highlightStart', highlightStart, defaultValue: null))
      ..add(DoubleProperty('blurSigma', blurSigma))
      ..add(IterableProperty<BoxShadow>('shadows', shadows));
  }
}
