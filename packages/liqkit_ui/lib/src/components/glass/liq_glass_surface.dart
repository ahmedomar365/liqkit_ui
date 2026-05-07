import 'dart:async';
import 'dart:ui' as ui;

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
/// Renders a translucent surface using the **real liquid-glass shader**
/// (refraction + frosted blur + adaptive tint + rim/Fresnel/specular
/// lighting) on Impeller (iOS / Android). On Flutter web (CanvasKit) —
/// where `ImageFilter.shader` isn't supported — falls back gracefully
/// to `ImageFilter.blur` + a tint overlay.
///
/// The visible material consists of, in order:
/// 1. An outer drop shadow driven by [elevation].
/// 2. A clipped rounded-rect.
/// 3. The shader-driven glass material (or blur+tint fallback on web).
/// 4. A 0.5pt hairline rim.
/// 5. The [child] wrapped in [padding].
///
/// The constructor API and exported constants are identical to the
/// previous glassmorphism implementation, so every component built on
/// `LiqGlassSurface` (LiqCard, LiqAppBar, LiqMenu, LiqSheet…) inherits
/// the upgrade automatically with zero code changes at the call site.
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

  /// **Deprecated visual hint** — ignored by the shader path. The shader's
  /// built-in rim cues replace the old gradient overlay. Kept on the API
  /// so existing callers compile unchanged.
  final Color? highlightStart;

  /// Backdrop blur sigma. With the shader path this is the radius of the
  /// 17-tap rosette blur kernel; with the web fallback it's the
  /// [ui.ImageFilter.blur] sigma.
  final double blurSigma;

  /// Optional shadow override for components with an artifact-specific
  /// elevation recipe.
  final List<BoxShadow>? shadows;

  /// Clip behavior for the inner [ClipRRect]. Defaults to
  /// [Clip.antiAlias] for crisp rounded corners.
  final Clip clipBehavior;

  // -- iOS 26 spec values ----------------------------------------------------
  // (Constants kept compatible — other components reference them.)

  /// Light tint base fill.
  static const Color lightTintBase = Color(0xE6F5F5F7);

  /// Dark tint base fill.
  static const Color darkTintBase = Color(0xE61C1C1E);

  /// Opaque light fallback.
  static const Color opaqueLightTintBase = Color(0xFFFAFAFA);

  /// Opaque dark fallback.
  static const Color opaqueDarkTintBase = Color(0xFF1C1C1E);

  /// Light-tint hairline rim color: 8% black.
  static const Color lightRimColor = Color(0x14000000);

  /// Dark-tint hairline rim color: 8% white.
  static const Color darkRimColor = Color(0x14FFFFFF);

  /// Optional optical highlight start color for light tint (legacy).
  static const Color lightHighlightStart = Color(0x06FFFFFF);

  /// Optional optical highlight start color for dark tint (legacy).
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

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final effectiveTint =
        context.liqUseOpaqueMaterials
            ? LiqGlassTint.opaque
            : tint == LiqGlassTint.light && isDark
            ? LiqGlassTint.dark
            : tint;

    // Opaque path — accessibility "reduce transparency" or explicit opaque
    // request. No shader, no blur, just a solid surface with rim and shadow.
    if (effectiveTint == LiqGlassTint.opaque) {
      return _OpaqueSurface(
        borderRadius: borderRadius,
        padding: padding,
        fill: _baseFillFor(effectiveTint, isDark: isDark),
        rim: _rimColorFor(effectiveTint),
        shadows: _shadows,
        clipBehavior: clipBehavior,
        child: child,
      );
    }

    // Glass path — real shader on Impeller, blur+tint fallback on web.
    final fill = _baseFillFor(effectiveTint, isDark: isDark);
    return _LiquidGlassMaterial(
      borderRadius: borderRadius,
      padding: padding,
      tintRgb: Color.fromRGBO(
        (fill.r * 255).round(),
        (fill.g * 255).round(),
        (fill.b * 255).round(),
        1,
      ),
      tintAmount: fill.a,
      isDark: effectiveTint == LiqGlassTint.dark,
      blurPx: blurSigma,
      rim: _rimColorFor(effectiveTint),
      shadows: _shadows,
      clipBehavior: clipBehavior,
      child: child,
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

// ---------------------------------------------------------------------------
// Implementation widgets — private to this file. Kept inline so the public
// API stays one widget + two enums + a handful of constants.
// ---------------------------------------------------------------------------

/// Opaque (no-glass) variant — no [BackdropFilter], no shader.
class _OpaqueSurface extends StatelessWidget {
  const _OpaqueSurface({
    required this.borderRadius,
    required this.padding,
    required this.fill,
    required this.rim,
    required this.shadows,
    required this.clipBehavior,
    required this.child,
  });

  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Color fill;
  final Color rim;
  final List<BoxShadow> shadows;
  final Clip clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final body = ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: ColoredBox(color: fill)),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(width: 0.5, color: rim),
                ),
              ),
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
    if (shadows.isEmpty) return body;
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: shadows),
      child: body,
    );
  }
}

/// Real liquid-glass material — uses the .frag shader on Impeller, falls
/// back to a `BackdropFilter(blur)` + tint overlay on Flutter web.
class _LiquidGlassMaterial extends StatefulWidget {
  const _LiquidGlassMaterial({
    required this.borderRadius,
    required this.padding,
    required this.tintRgb,
    required this.tintAmount,
    required this.isDark,
    required this.blurPx,
    required this.rim,
    required this.shadows,
    required this.clipBehavior,
    required this.child,
  });

  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Color tintRgb;       // opaque RGB (alpha ignored)
  final double tintAmount;   // mix amount toward tintRgb, 0..1
  final bool isDark;
  final double blurPx;
  final Color rim;
  final List<BoxShadow> shadows;
  final Clip clipBehavior;
  final Widget child;

  @override
  State<_LiquidGlassMaterial> createState() => _LiquidGlassMaterialState();
}

class _LiquidGlassMaterialState extends State<_LiquidGlassMaterial> {
  static ui.FragmentProgram? _program;
  static Future<ui.FragmentProgram>? _programLoading;
  ui.FragmentShader? _shader;
  bool _shaderUnavailable = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _shaderUnavailable = true;
    } else {
      unawaited(_loadShader());
    }
  }

  Future<void> _loadShader() async {
    try {
      final p = _program ??
          await (_programLoading ??= ui.FragmentProgram.fromAsset(
            'packages/liqkit_ui/shaders/liq_liquid_glass.frag',
          ));
      _program = p;
      _programLoading = null;
      if (!mounted) return;
      setState(() => _shader = p.fragmentShader());
    } catch (_) {
      if (mounted) setState(() => _shaderUnavailable = true);
    }
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clipped = ClipRRect(
      borderRadius: widget.borderRadius,
      clipBehavior: widget.clipBehavior,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: _shaderUnavailable || _shader == null
                ? _BlurFallback(
                    blurPx: widget.blurPx,
                    tintRgb: widget.tintRgb,
                    tintAmount: widget.tintAmount,
                  )
                : _ShaderHost(
                    shader: _shader!,
                    radius: widget.borderRadius.topLeft.x,
                    blurPx: widget.blurPx * 0.6, // shader's 17-tap is heavier
                    tintRgb: widget.tintRgb,
                    tintAmount: widget.tintAmount,
                    isDark: widget.isDark,
                  ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  border: Border.all(width: 0.5, color: widget.rim),
                ),
              ),
            ),
          ),
          Padding(padding: widget.padding, child: widget.child),
        ],
      ),
    );
    if (widget.shadows.isEmpty) return clipped;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        boxShadow: widget.shadows,
      ),
      child: clipped,
    );
  }
}

/// Web (CanvasKit) — `BackdropFilter(blur)` + tint overlay. Visually
/// continues to look like the prior glassmorphism, no regressions.
class _BlurFallback extends StatelessWidget {
  const _BlurFallback({
    required this.blurPx,
    required this.tintRgb,
    required this.tintAmount,
  });

  final double blurPx;
  final Color tintRgb;
  final double tintAmount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: blurPx, sigmaY: blurPx),
            child: const SizedBox.expand(),
          ),
        ),
        Positioned.fill(
          child: ColoredBox(color: tintRgb.withValues(alpha: tintAmount)),
        ),
      ],
    );
  }
}

/// Impeller — real shader filter.
class _ShaderHost extends StatelessWidget {
  const _ShaderHost({
    required this.shader,
    required this.radius,
    required this.blurPx,
    required this.tintRgb,
    required this.tintAmount,
    required this.isDark,
  });

  final ui.FragmentShader shader;
  final double radius;
  final double blurPx;
  final Color tintRgb;
  final double tintAmount;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    // Set the non-sampler uniforms. Engine auto-binds uSize (idx 0,1) and
    // uBackdrop (sampler 0) when used via ImageFilter.shader.
    shader
      ..setFloat(2, radius * dpr)        // uParams1.x — radius
      ..setFloat(3, 1.55)                 // uParams1.y — ior
      ..setFloat(4, 18 * dpr)             // uParams1.z — thickness
      ..setFloat(5, 18 * dpr)             // uParams1.w — edgeWidth
      ..setFloat(6, 0.30)                 // uParams2.x — chroma
      ..setFloat(7, blurPx * dpr)         // uParams2.y — blurPx
      ..setFloat(8, isDark ? 0.55 : 1.0)  // uParams2.z — rimBrightness
                                          // (dark mode: subtler rim — Apple's
                                          // dark glass has lower-amplitude
                                          // highlights, not higher.)
      ..setFloat(9, 2.0)                  // uParams2.w — mode (full)
      ..setFloat(10, tintRgb.r)           // uTintRGB.x
      ..setFloat(11, tintRgb.g)           // uTintRGB.y
      ..setFloat(12, tintRgb.b)           // uTintRGB.z
      ..setFloat(13, tintAmount);         // uTintRGB.w — tint amount
    return BackdropFilter(
      filter: ui.ImageFilter.shader(shader),
      child: const SizedBox.expand(),
    );
  }
}
