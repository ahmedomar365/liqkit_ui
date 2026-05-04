import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Diameter preset for [LiqAvatar].
enum LiqAvatarSize {
  /// 24pt diameter, 12pt initials.
  small,

  /// 40pt diameter, 16pt initials.
  medium,

  /// 56pt diameter, 20pt initials.
  large,
}

/// iOS 26 Liquid Glass circular avatar.
///
/// Renders one of three things, in priority order:
/// 1. The provided [image], clipped to a circle.
/// 2. A solid colored circle with up to 2 [initials] in white.
/// 3. A neutral grey circle with a generic person glyph fallback.
///
/// When no [backgroundColor] is supplied, the initials variant picks a
/// deterministic color from the iOS pastel palette by hashing the
/// initials string.
final class LiqAvatar extends StatelessWidget {
  /// Creates an avatar.
  const LiqAvatar({
    this.image,
    this.initials,
    this.size = LiqAvatarSize.medium,
    this.backgroundColor,
    super.key,
  });

  /// The photo to render. Falls back to [initials] when null or on error.
  final ImageProvider? image;

  /// Up to 2 characters shown when [image] is null or fails to load.
  final String? initials;

  /// Diameter preset.
  final LiqAvatarSize size;

  /// Override for the background fill behind initials. Defaults to a
  /// hash-derived iOS pastel.
  final Color? backgroundColor;

  /// Diameter in logical pixels for [LiqAvatarSize.small].
  static const double diameterSmall = 24;

  /// Diameter in logical pixels for [LiqAvatarSize.medium].
  static const double diameterMedium = 40;

  /// Diameter in logical pixels for [LiqAvatarSize.large].
  static const double diameterLarge = 56;

  /// Initials font size for [LiqAvatarSize.small].
  static const double initialsFontSmall = 12;

  /// Initials font size for [LiqAvatarSize.medium].
  static const double initialsFontMedium = 16;

  /// Initials font size for [LiqAvatarSize.large].
  static const double initialsFontLarge = 20;

  /// White text color used for initials glyphs.
  static const Color initialsColor = Color(0xFFFFFFFF);

  /// Neutral grey used for the generic glyph fallback and `+N` pill.
  static const Color neutralBackground = Color(0xFFE5E5EA);

  /// Dark neutral used for the generic glyph fallback and `+N` pill.
  static const Color darkNeutralBackground = Color(0xFF3A3A3C);

  /// Foreground color for the `+N` pill in [LiqAvatarGroup].
  static const Color neutralForeground = Color(0xFF1C1C1E);

  /// Dark foreground color for the `+N` pill in [LiqAvatarGroup].
  static const Color darkNeutralForeground = Color(0xFFFFFFFF);

  /// Generic glyph color for the neutral avatar fallback.
  static const Color glyphColor = Color(0xFF8E8E93);

  /// Dark generic glyph color for the neutral avatar fallback.
  static const Color darkGlyphColor = Color(0xB2EBEBF5);

  /// Six iOS pastel colors used for the deterministic background hash.
  static const List<Color> palette = <Color>[
    Color(0xFF34C759),
    Color(0xFF007AFF),
    Color(0xFFFF9500),
    Color(0xFFAF52DE),
    Color(0xFFFF3B30),
    Color(0xFF5AC8FA),
  ];

  /// The pixel diameter for [size].
  static double diameterFor(LiqAvatarSize size) {
    switch (size) {
      case LiqAvatarSize.small:
        return diameterSmall;
      case LiqAvatarSize.medium:
        return diameterMedium;
      case LiqAvatarSize.large:
        return diameterLarge;
    }
  }

  /// The initials font size for [size].
  static double initialsFontFor(LiqAvatarSize size) {
    switch (size) {
      case LiqAvatarSize.small:
        return initialsFontSmall;
      case LiqAvatarSize.medium:
        return initialsFontMedium;
      case LiqAvatarSize.large:
        return initialsFontLarge;
    }
  }

  /// Deterministic palette pick for [initials].
  ///
  /// Hashes by summing code units modulo the palette length.
  static Color paletteColorFor(String initials) {
    final sum = initials.codeUnits.fold<int>(0, (a, b) => a + b);
    return palette[sum % palette.length];
  }

  /// Reduces a free-form name to up to 2 uppercase letters.
  ///
  /// Splits on whitespace and takes the first letter of each token; if a
  /// single token is given, returns its first 2 characters.
  static String formatInitials(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final a = parts[0].isNotEmpty ? parts[0][0] : '';
      final b = parts[1].isNotEmpty ? parts[1][0] : '';
      return (a + b).toUpperCase();
    }
    final only = parts[0];
    return (only.length >= 2 ? only.substring(0, 2) : only).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final diameter = diameterFor(size);
    return SizedBox(
      width: diameter,
      height: diameter,
      child: _buildContents(context, diameter),
    );
  }

  Widget _buildContents(BuildContext context, double diameter) {
    final image = this.image;
    if (image != null) {
      return ClipOval(
        child: Image(
          image: image,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stack) => _buildInitialsOrGlyph(context),
        ),
      );
    }
    return _buildInitialsOrGlyph(context);
  }

  Widget _buildInitialsOrGlyph(BuildContext context) {
    final initials = this.initials;
    if (initials != null && initials.trim().isNotEmpty) {
      final formatted = formatInitials(initials);
      final bg = backgroundColor ?? paletteColorFor(formatted);
      return _CircleFill(
        color: bg,
        child: Center(
          child: Text(
            formatted,
            style: TextStyle(
              fontFamily: '.SF Pro Text',
              fontFamilyFallback: const <String>[
                'SF Pro Text',
                'SF Pro',
                'system-ui',
              ],
              fontSize: initialsFontFor(size),
              fontWeight: FontWeight.w600,
              color: initialsColor,
              height: 1,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final palette = _AvatarNeutralPalette.resolve(context);
    return _CircleFill(
      color: backgroundColor ?? palette.background,
      child: CustomPaint(painter: _PersonGlyphPainter(color: palette.glyph)),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqAvatarSize>('size', size))
      ..add(DiagnosticsProperty<bool>('hasImage', image != null))
      ..add(StringProperty('initials', initials, defaultValue: null));
  }
}

class _CircleFill extends StatelessWidget {
  const _CircleFill({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: child,
    );
  }
}

class _PersonGlyphPainter extends CustomPainter {
  _PersonGlyphPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;

    // Head: circle centered horizontally at ~38% down, radius ~16% of width.
    final headRadius = w * 0.16;
    final headCenter = Offset(w * 0.5, h * 0.38);
    canvas.drawCircle(headCenter, headRadius, paint);

    // Shoulders: capsule (rounded rect) below the head.
    final shoulderRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.82),
      width: w * 0.62,
      height: h * 0.32,
    );
    final shoulderRRect = RRect.fromRectAndRadius(
      shoulderRect,
      Radius.circular(shoulderRect.height / 2),
    );
    canvas.drawRRect(shoulderRRect, paint);
  }

  @override
  bool shouldRepaint(covariant _PersonGlyphPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// Horizontal stack of overlapping [LiqAvatar]s, with a `+N` overflow pill.
final class LiqAvatarGroup extends StatelessWidget {
  /// Creates an avatar group.
  const LiqAvatarGroup({
    required this.avatars,
    this.maxVisible = 3,
    this.overlap = 12,
    super.key,
  });

  /// Avatars to render. Only the first [maxVisible] are shown.
  final List<LiqAvatar> avatars;

  /// Maximum number of avatars rendered before collapsing the rest into a
  /// `+N` pill.
  final int maxVisible;

  /// Pixel overlap between adjacent avatars.
  final double overlap;

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) return const SizedBox.shrink();
    final visibleCount =
        avatars.length <= maxVisible ? avatars.length : maxVisible;
    final overflow = avatars.length - visibleCount;
    final referenceSize = avatars.first.size;
    final diameter = LiqAvatar.diameterFor(referenceSize);

    final tiles = <Widget>[
      for (var i = 0; i < visibleCount; i++) avatars[i],
      if (overflow > 0) _OverflowPill(size: referenceSize, count: overflow),
    ];

    final stride = diameter - overlap;
    final totalWidth = diameter + stride * (tiles.length - 1);

    return SizedBox(
      width: totalWidth,
      height: diameter,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          for (var i = 0; i < tiles.length; i++)
            Positioned(left: i * stride, top: 0, child: tiles[i]),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('avatarCount', avatars.length))
      ..add(IntProperty('maxVisible', maxVisible))
      ..add(DoubleProperty('overlap', overlap));
  }
}

class _OverflowPill extends StatelessWidget {
  const _OverflowPill({required this.size, required this.count});

  final LiqAvatarSize size;
  final int count;

  @override
  Widget build(BuildContext context) {
    final diameter = LiqAvatar.diameterFor(size);
    final palette = _AvatarNeutralPalette.resolve(context);
    return SizedBox(
      width: diameter,
      height: diameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.background,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '+$count',
            style: TextStyle(
              fontFamily: '.SF Pro Text',
              fontFamilyFallback: const <String>[
                'SF Pro Text',
                'SF Pro',
                'system-ui',
              ],
              fontSize: LiqAvatar.initialsFontFor(size),
              fontWeight: FontWeight.w600,
              color: palette.foreground,
              height: 1,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

final class _AvatarNeutralPalette {
  const _AvatarNeutralPalette({
    required this.background,
    required this.foreground,
    required this.glyph,
  });

  factory _AvatarNeutralPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _AvatarNeutralPalette(
        background: LiqAvatar.neutralBackground,
        foreground: LiqAvatar.neutralForeground,
        glyph: LiqAvatar.glyphColor,
      );
    }

    return const _AvatarNeutralPalette(
      background: LiqAvatar.darkNeutralBackground,
      foreground: LiqAvatar.darkNeutralForeground,
      glyph: LiqAvatar.darkGlyphColor,
    );
  }

  final Color background;
  final Color foreground;
  final Color glyph;
}
