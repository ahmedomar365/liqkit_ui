import 'dart:ui' show Color, ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/theme/liq_material.dart';
import 'package:liqkit_ui/src/theme/liq_quality.dart';
import 'package:liqkit_ui/src/theme/liq_theme.dart';

/// A glass surface: blur + tint + bezel-clipped child.
final class LiqGlassSurface extends StatelessWidget {
  /// Creates a glass surface.
  const LiqGlassSurface({
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
  /// The intent (per spec §6.1) is that two glass surfaces sharing the
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

    if (theme.quality == LiqQuality.minimal || material.blurRadius == 0) {
      return _solid(clipShape, tint);
    }

    return ClipPath(
      clipper: ShapeBorderClipper(shape: clipShape),
      child: Stack(
        children: <Widget>[
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: material.blurRadius,
              sigmaY: material.blurRadius,
            ),
            child: ColoredBox(color: tint),
          ),
          child,
        ],
      ),
    );
  }

  Widget _solid(ShapeBorder shape, Color tint) => ClipPath(
    clipper: ShapeBorderClipper(shape: shape),
    child: ColoredBox(color: tint, child: child),
  );

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
