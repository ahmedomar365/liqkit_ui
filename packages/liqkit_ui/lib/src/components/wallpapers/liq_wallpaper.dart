import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Type axis for [LiqWallpaper].
enum LiqWallpaperType {
  /// Linear gradient between two or more colors.
  gradient,

  /// Image asset or network image as the backdrop.
  image,

  /// Solid fill (single color).
  solid,

  /// Multi-color radial mesh — multiple radial gradients composited
  /// with [BlendMode.softLight] for an iOS-26 lock-screen feel.
  mesh,
}

/// Backdrop wallpaper widget — fills the parent with a gradient,
/// image, solid color, or mesh, optionally overlays content via [child].
final class LiqWallpaper extends StatelessWidget {
  /// Creates a wallpaper.
  const LiqWallpaper({
    this.type = LiqWallpaperType.gradient,
    this.gradientColors,
    this.gradientStops,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    this.tileMode = TileMode.clamp,
    this.image,
    this.imageFit = BoxFit.cover,
    this.solidColor,
    this.blurAmount = 0,
    this.opacity = 1,
    this.child,
    this.brightness,
    super.key,
  });

  /// Wallpaper kind.
  final LiqWallpaperType type;

  /// Color stops for [LiqWallpaperType.gradient]. When omitted, a
  /// brightness-aware default `[blue, purple, pink]` is used.
  final List<Color>? gradientColors;

  /// Optional explicit gradient stops in `[0, 1]`.
  final List<double>? gradientStops;

  /// Linear-gradient anchor begin.
  final Alignment gradientBegin;

  /// Linear-gradient anchor end.
  final Alignment gradientEnd;

  /// Tile mode applied to the gradient.
  final TileMode tileMode;

  /// Image source for [LiqWallpaperType.image]. Use `AssetImage`,
  /// `NetworkImage`, etc.
  final ImageProvider? image;

  /// Image fit when [type] is `image`.
  final BoxFit imageFit;

  /// Solid backdrop color for [LiqWallpaperType.solid]. Falls back to
  /// the surface background color when null.
  final Color? solidColor;

  /// Optional Gaussian blur applied behind [child].
  final double blurAmount;

  /// Optional opacity applied to the backdrop.
  final double opacity;

  /// Optional foreground content that sits over the backdrop.
  final Widget? child;

  /// Override surface brightness.
  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    final isDark =
        (brightness ?? context.liqBrightness) == Brightness.dark;
    var backdrop = _buildBackdrop(isDark);
    if (blurAmount > 0) {
      backdrop = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: backdrop,
      );
    }
    if (opacity < 1) {
      backdrop = Opacity(opacity: opacity, child: backdrop);
    }
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        backdrop,
        if (child != null) child!,
      ],
    );
  }

  Widget _buildBackdrop(bool isDark) {
    switch (type) {
      case LiqWallpaperType.gradient:
        final colors = gradientColors ??
            (isDark
                ? const <Color>[
                    Color(0xFF0A1B3D),
                    Color(0xFF351260),
                    Color(0xFF601B53),
                  ]
                : const <Color>[
                    Color(0xFFCFE6FF),
                    Color(0xFFE0D8FF),
                    Color(0xFFFFD8EE),
                  ]);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: gradientBegin,
              end: gradientEnd,
              colors: colors,
              stops: gradientStops,
              tileMode: tileMode,
            ),
          ),
        );
      case LiqWallpaperType.image:
        if (image == null) {
          return ColoredBox(color: _solidFallback(isDark));
        }
        return Image(image: image!, fit: imageFit);
      case LiqWallpaperType.solid:
        return ColoredBox(color: solidColor ?? _solidFallback(isDark));
      case LiqWallpaperType.mesh:
        return _MeshBackdrop(isDark: isDark, customColors: gradientColors);
    }
  }

  Color _solidFallback(bool isDark) => isDark
      ? const Color(0xFF000000)
      : LiqAppleColors.systemGroupedBackground;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqWallpaperType>('type', type))
      ..add(DoubleProperty('blurAmount', blurAmount))
      ..add(DoubleProperty('opacity', opacity))
      ..add(EnumProperty<Brightness?>('brightness', brightness));
  }
}

/// Multi-color radial mesh — three soft-light radial gradients
/// composited over a base color.
class _MeshBackdrop extends StatelessWidget {
  const _MeshBackdrop({required this.isDark, this.customColors});

  final bool isDark;
  final List<Color>? customColors;

  @override
  Widget build(BuildContext context) {
    final palette = customColors ??
        (isDark
            ? const <Color>[
                Color(0xFF1A0B3D),
                Color(0xFF6322FF),
                Color(0xFFFF2D55),
              ]
            : const <Color>[
                Color(0xFFC1E0FF),
                Color(0xFFFFD2F0),
                Color(0xFFFFE9C9),
              ]);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ColoredBox(
          color: isDark ? const Color(0xFF080820) : const Color(0xFFEFF3FF),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.7, -0.6),
              radius: 1.1,
              colors: <Color>[
                palette[0].withValues(alpha: 0.85),
                palette[0].withValues(alpha: 0),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.8, -0.4),
              radius: 1,
              colors: <Color>[
                palette[1].withValues(alpha: 0.7),
                palette[1].withValues(alpha: 0),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, 0.9),
              radius: 1.2,
              colors: <Color>[
                palette[2].withValues(alpha: 0.65),
                palette[2].withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
