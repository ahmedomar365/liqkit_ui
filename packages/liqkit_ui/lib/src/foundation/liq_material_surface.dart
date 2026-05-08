import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/theme/liq_material.dart';
import 'package:liqkit_ui/src/theme/liq_quality.dart';
import 'package:liqkit_ui/src/theme/liq_theme.dart';

/// A theme-aware glass surface backed by a [LiqMaterial] spec.
///
/// Renders a backdrop blur, the material's tint, and clips the child to
/// the supplied [shape]. Honors [LiqQuality.minimal] by skipping the
/// [BackdropFilter] in favor of a flat tinted [ColoredBox].
///
/// Most components should prefer the higher-level `LiqGlassSurface`
/// primitive in `package:liqkit_ui/components.dart`, which exposes the
/// canonical iOS-26 tint / elevation presets without requiring callers
/// to mix a [LiqMaterial] spec.
final class LiqMaterialSurface extends StatelessWidget {
  /// Creates a material-driven glass surface.
  const LiqMaterialSurface({
    required this.material,
    required this.child,
    this.shape,
    this.backdropGroup,
    super.key,
  });

  /// The material spec.
  final LiqMaterial material;

  /// Child rendered above the glass.
  final Widget child;

  /// Optional clip shape.
  final ShapeBorder? shape;

  /// Reserved for future BackdropFilter compositor optimization.
  ///
  /// The intent (per spec §6.1) is that two surfaces sharing the
  /// same `backdropGroup` collapse to a single engine-level blur pass.
  /// Flutter does not yet expose an API for this; the parameter is
  /// accepted now so the public API is stable, but it has no runtime
  /// effect in this version.
  final Object? backdropGroup;

  @override
  Widget build(BuildContext context) {
    final theme = LiqTheme.of(context);
    final brightness =
        MediaQuery.maybeOf(context)?.platformBrightness ?? theme.brightness;
    final tint = material.tint.resolve(brightness);

    final clipShape =
        shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(theme.bezel.cornerRadius - 0.5),
          ),
        );

    // The previous implementation rolled its own
    // `BackdropFilter(ImageFilter.blur)` + `ColoredBox(tint)` — a second
    // glass implementation competing with `LiqGlassSurface`. Per the
    // no-fakes rule, every glass surface in liqkit_ui delegates to the
    // canonical `LiqGlassSurface` shader pipeline.
    final isOpaque =
        theme.quality == LiqQuality.minimal || material.blurRadius == 0;
    return ClipPath(
      clipper: ShapeBorderClipper(shape: clipShape),
      child: LiqGlassSurface(
        tint: isOpaque ? LiqGlassTint.opaque : LiqGlassTint.light,
        baseFill: tint,
        blurSigma: material.blurRadius,
        borderRadius: BorderRadius.zero,
        padding: EdgeInsets.zero,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<LiqMaterial>('material', material))
      ..add(
        DiagnosticsProperty<ShapeBorder?>('shape', shape, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty<Object?>(
          'backdropGroup',
          backdropGroup,
          defaultValue: null,
        ),
      );
  }
}
