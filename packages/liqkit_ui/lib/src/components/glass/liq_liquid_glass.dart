import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Quality / cost tier for [LiqLiquidGlass]. The shader runs the same
/// real-refraction physics for all three; tiers differ only in how many
/// extra texture samples and lighting layers stack on top.
enum LiqLiquidGlassTier {
  /// Cheapest. Refraction + frosted blur + tint + soft rim. Best for many
  /// surfaces in one screen (lists, grids).
  light,

  /// + Schlick Fresnel rim brightening. Adds the "lit-edge" cue that makes
  /// the surface read as a 3D object. Best for buttons, nav bars.
  medium,

  /// + chromatic dispersion at the rim + Blinn-Phong specular catch-light.
  /// Heaviest, most physical. Best for hero surfaces (modal sheets, primary
  /// CTAs, the focused-card-of-the-screen).
  full,
}

/// iOS-26-style **liquid glass** material — real refraction + frosted blur +
/// adaptive tint + lighting cues.
///
/// On Impeller (iOS / Android) this uses
/// [BackdropFilter] + [ui.ImageFilter.shader] so the live backdrop is
/// refracted in real time as content moves underneath.
///
/// On Flutter web (CanvasKit) the shader filter is not supported, so we
/// fall back to [ui.ImageFilter.blur] + a tint overlay — visually similar
/// but missing the refractive lensing at the rim.
///
/// Wrap a widget that draws on top of an existing background:
///
/// ```dart
/// Stack(
///   children: [
///     Positioned.fill(child: MyBackdrop()),
///     Center(
///       child: LiqLiquidGlass(
///         tier: LiqLiquidGlassTier.full,
///         child: SizedBox(
///           width: 280,
///           child: Padding(
///             padding: EdgeInsets.all(20),
///             child: Text('Continue'),
///           ),
///         ),
///       ),
///     ),
///   ],
/// )
/// ```
class LiqLiquidGlass extends StatefulWidget {
  /// Creates a liquid-glass surface.
  const LiqLiquidGlass({
    required this.child,
    this.tier = LiqLiquidGlassTier.full,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.tintColor,
    this.tintAmount = 0.55,
    this.blurPx = 18,
    this.rimBrightness = 1.2,
    this.ior = 1.55,
    this.thickness = 18,
    this.edgeWidth = 18,
    this.chroma = 0.30,
    super.key,
  });

  /// Foreground content rendered ON TOP of the glass — text, icons, controls.
  /// Not refracted (the glass refracts the backdrop, not its own children).
  final Widget child;

  /// Quality tier. Heavier tiers cost slightly more GPU per pixel.
  final LiqLiquidGlassTier tier;

  /// Outer corner radius. Should be supplied as a `BorderRadius.all` of a
  /// uniform radius — non-uniform radii are clipped via [ClipRRect] but the
  /// shader's SDF only models a single radius.
  final BorderRadius borderRadius;

  /// Color the blurred backdrop is mixed toward. Defaults to:
  ///   * dark `0xFF1A1A1F` when surrounding `MediaQuery.platformBrightness`
  ///     is dark
  ///   * light `0xFFF6F5F7` when surrounding brightness is light
  ///
  /// Pass an explicit value to override (Apple's macOS dark-mode menus use
  /// `~0xFF0F0F12`; light-mode menus use `~0xFFEFEEF0`).
  final Color? tintColor;

  /// 0 = no tint (pure frosted blur); 1 = solid tint color (no backdrop
  /// shows). Apple's right-click menu uses ~0.72 in dark, ~0.82 in light.
  final double tintAmount;

  /// Frosted-blur radius in logical pixels. ~6 for a small button, ~18 for
  /// a Control-Center pill, ~22 for a dark menu, ~60 for a light menu.
  final double blurPx;

  /// Multiplier on the always-visible rim cues (top highlight, bottom
  /// shadow, perimeter glow). 1.0 default; raise on darker tints.
  final double rimBrightness;

  /// Index of refraction. Water = 1.33, glass = 1.45–1.55, sapphire = 1.77.
  final double ior;

  /// Glass thickness in logical pixels — controls how far refraction
  /// displaces the backdrop sample at the rim.
  final double thickness;

  /// Width of the edge-bulge falloff in logical pixels. Bigger = the
  /// lensing band extends further into the interior.
  final double edgeWidth;

  /// Chromatic dispersion intensity (full tier only). Visible as red/blue
  /// fringing along the rim.
  final double chroma;

  @override
  State<LiqLiquidGlass> createState() => _LiqLiquidGlassState();
}

class _LiqLiquidGlassState extends State<LiqLiquidGlass> {
  static ui.FragmentProgram? _program;
  static Future<ui.FragmentProgram>? _programLoading;

  ui.FragmentShader? _shader;
  bool _shaderUnavailable = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      // Only attempt the shader path on non-web (CanvasKit doesn't support
      // ImageFilter.shader). Web takes the blur fallback in build().
      unawaited(_loadShader());
    } else {
      _shaderUnavailable = true;
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
    } catch (e) {
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
    final brightness = MediaQuery.platformBrightnessOf(context);
    final defaultTint = brightness == Brightness.dark
        ? const Color(0xFF1A1A1F)
        : const Color(0xFFF6F5F7);
    final tint = widget.tintColor ?? defaultTint;
    final clip = ClipRRect(
      borderRadius: widget.borderRadius,
      child: _GlassFilterHost(
        shader: _shader,
        useShaderFallback: _shaderUnavailable,
        tier: widget.tier,
        tint: tint,
        tintAmount: widget.tintAmount,
        blurPx: widget.blurPx,
        rimBrightness: widget.rimBrightness,
        ior: widget.ior,
        thickness: widget.thickness,
        edgeWidth: widget.edgeWidth,
        chroma: widget.chroma,
        // We can't pass a path-radius to the shader (only a single circular
        // radius), so use the top-left as the canonical value.
        radiusLogical: widget.borderRadius.topLeft.x,
        child: widget.child,
      ),
    );
    return clip;
  }
}

/// Switches between the real shader filter and a blur+tint fallback.
class _GlassFilterHost extends StatelessWidget {
  const _GlassFilterHost({
    required this.shader,
    required this.useShaderFallback,
    required this.tier,
    required this.tint,
    required this.tintAmount,
    required this.blurPx,
    required this.rimBrightness,
    required this.ior,
    required this.thickness,
    required this.edgeWidth,
    required this.chroma,
    required this.radiusLogical,
    required this.child,
  });

  final ui.FragmentShader? shader;
  final bool useShaderFallback;
  final LiqLiquidGlassTier tier;
  final Color tint;
  final double tintAmount;
  final double blurPx;
  final double rimBrightness;
  final double ior;
  final double thickness;
  final double edgeWidth;
  final double chroma;
  final double radiusLogical;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (useShaderFallback || shader == null) {
      // Web / shader-load-failed path: blur + tint overlay. Visually
      // similar — minus the refractive rim lensing.
      return BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blurPx, sigmaY: blurPx),
        child: Container(
          color: tint.withValues(alpha: tintAmount),
          child: child,
        ),
      );
    }
    // Real shader path on Impeller.
    final dpr = MediaQuery.of(context).devicePixelRatio;
    return _ShaderBackdropFilter(
      shader: shader!,
      tier: tier,
      tint: tint,
      tintAmount: tintAmount,
      blurPx: blurPx,
      rimBrightness: rimBrightness,
      ior: ior,
      thickness: thickness,
      edgeWidth: edgeWidth,
      chroma: chroma,
      radiusLogical: radiusLogical,
      dpr: dpr,
      child: child,
    );
  }
}

class _ShaderBackdropFilter extends StatelessWidget {
  const _ShaderBackdropFilter({
    required this.shader,
    required this.tier,
    required this.tint,
    required this.tintAmount,
    required this.blurPx,
    required this.rimBrightness,
    required this.ior,
    required this.thickness,
    required this.edgeWidth,
    required this.chroma,
    required this.radiusLogical,
    required this.dpr,
    required this.child,
  });

  final ui.FragmentShader shader;
  final LiqLiquidGlassTier tier;
  final Color tint;
  final double tintAmount;
  final double blurPx;
  final double rimBrightness;
  final double ior;
  final double thickness;
  final double edgeWidth;
  final double chroma;
  final double radiusLogical;
  final double dpr;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final modeIdx = switch (tier) {
      LiqLiquidGlassTier.light => 0.0,
      LiqLiquidGlassTier.medium => 1.0,
      LiqLiquidGlassTier.full => 2.0,
    };

    // Set non-sampler uniforms. uSize (idx 0,1) and uBackdrop (sampler 0)
    // are auto-set by the engine when this shader is wrapped in
    // ImageFilter.shader.
    shader
      ..setFloat(2, radiusLogical * dpr)   // uParams1.x — radius
      ..setFloat(3, ior)                    // uParams1.y
      ..setFloat(4, thickness * dpr)        // uParams1.z
      ..setFloat(5, edgeWidth * dpr)        // uParams1.w
      ..setFloat(6, chroma)                 // uParams2.x
      ..setFloat(7, blurPx * dpr)           // uParams2.y
      ..setFloat(8, rimBrightness)          // uParams2.z
      ..setFloat(9, modeIdx)                // uParams2.w
      ..setFloat(10, tint.r)                // uTintRGB.x
      ..setFloat(11, tint.g)                // uTintRGB.y
      ..setFloat(12, tint.b)                // uTintRGB.z
      ..setFloat(13, tintAmount);           // uTintRGB.w (tint amount)

    return BackdropFilter(
      filter: ui.ImageFilter.shader(shader),
      child: child,
    );
  }
}
