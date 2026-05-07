import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/app_icons/liq_app_icon.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// High-level home-screen app icon convenience wrapper that takes an
/// [IconData] glyph (instead of a Widget), supports a download
/// progress overlay, and has an edit-mode "delete" affordance.
///
/// Composes [LiqAppIcon] internally. For low-level / fully custom
/// glyph rendering, use [LiqAppIcon] directly.
final class LiqHomeIcon extends StatelessWidget with Diagnosticable {
  /// Creates a home icon.
  const LiqHomeIcon({
    required this.icon,
    this.label,
    this.backgroundColor,
    this.iconColor,
    this.gradient,
    this.size = 66,
    this.showBadge = false,
    this.badgeCount = 0,
    this.isDownloading = false,
    this.downloadProgress = 0,
    this.isEditing = false,
    this.onPressed,
    this.onLongPress,
    this.onDelete,
    super.key,
  });

  final IconData icon;
  final String? label;
  final Color? backgroundColor;
  final Color? iconColor;
  final Gradient? gradient;
  final double size;
  final bool showBadge;
  final int badgeCount;
  final bool isDownloading;
  final double downloadProgress;
  final bool isEditing;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? LiqAppleColors.systemBlue;
    final iconFg = iconColor ?? const Color(0xFFFFFFFF);
    final tile = LiqAppIcon(
      size: size,
      color: gradient == null ? bg : null,
      gradient: gradient,
      glyph: Icon(icon, color: iconFg, size: size * 0.55),
      label: label,
      onPressed: onPressed,
      badge: showBadge && badgeCount > 0
          ? LiqAppIconBadge(count: badgeCount)
          : null,
    );

    Widget result = tile;

    if (isDownloading) {
      result = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(opacity: 0.4, child: tile),
          SizedBox(
            width: size * 0.55,
            height: size * 0.55,
            child: CustomPaint(
              painter: _DownloadProgressPainter(
                progress: downloadProgress.clamp(0.0, 1.0),
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      );
    }

    if (isEditing) {
      result = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Wiggle visual not implemented; just the - button
          result,
          Positioned(
            top: -6,
            left: -6,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E5EA),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 10,
                    height: 2,
                    child: ColoredBox(color: Color(0xFF000000)),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onLongPress != null) {
      result = GestureDetector(
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: result,
      );
    }

    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(IntProperty('badgeCount', badgeCount))
      ..add(DoubleProperty('downloadProgress', downloadProgress))
      ..add(FlagProperty('isEditing', value: isEditing, ifTrue: 'editing'));
  }
}

class _DownloadProgressPainter extends CustomPainter {
  const _DownloadProgressPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final track = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 1.5, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1.5),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fill,
    );
    // Square stop glyph
    final s = radius * 0.5;
    canvas.drawRect(
      Rect.fromCenter(center: center, width: s, height: s),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _DownloadProgressPainter old) =>
      progress != old.progress || color != old.color;
}

/// 4-column home-screen-style grid of app icons. Hands off layout to
/// [Wrap] so it adapts to bounded width.
final class LiqAppIconGrid extends StatelessWidget with Diagnosticable {
  /// Creates a home grid.
  const LiqAppIconGrid({
    required this.icons,
    this.spacing = 18,
    this.runSpacing = 24,
    this.isEditing = false,
    super.key,
  });

  final List<Widget> icons;
  final double spacing;
  final double runSpacing;

  /// When true, child icons that support edit-mode (e.g. [LiqHomeIcon])
  /// should render their delete affordance. Pass through manually —
  /// this widget exposes the flag for documentation only.
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: WrapAlignment.center,
      children: icons,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('iconCount', icons.length))
      ..add(FlagProperty('isEditing', value: isEditing, ifTrue: 'editing'));
  }
}

/// iOS-style folder tile — squircle with up to 9 mini preview glyphs
/// inside a 3×3 grid, plus a label below.
final class LiqFolderIcon extends StatelessWidget with Diagnosticable {
  /// Creates a folder.
  const LiqFolderIcon({
    required this.previewIcons,
    this.label,
    this.size = 66,
    this.backgroundColor,
    this.isOpen = false,
    this.onTap,
    super.key,
  });

  final List<IconData> previewIcons;
  final String? label;
  final double size;
  final Color? backgroundColor;
  final bool isOpen;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final tileBg = backgroundColor ??
        (isDark
            ? const Color(0x4D767680)
            : const Color(0x33767680));
    final radius = size * (14 / 66);
    final cellSize = (size - 8) / 3 - 2;
    final preview = previewIcons.take(9).toList();
    final tile = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      padding: const EdgeInsets.all(4),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (var i = 0; i < 9; i++)
            if (i < preview.length)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius:
                      BorderRadius.all(Radius.circular(cellSize * 0.25)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  preview[i],
                  size: cellSize * 0.6,
                  color: const Color(0xFF000000),
                ),
              )
            else
              const SizedBox.shrink(),
        ],
      ),
    );
    final scaled = isOpen
        ? Transform.scale(scale: 1.05, child: tile)
        : tile;
    Widget content = GestureDetector(
      onTap: onTap,
      child: scaled,
    );
    if (label != null) {
      final labelColor =
          isDark ? const Color(0xFFFFFFFF) : const Color(0xFF12161F);
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          content,
          const SizedBox(height: 6),
          SizedBox(
            width: size + 24,
            child: Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: labelColor,
              ),
            ),
          ),
        ],
      );
    }
    return content;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(IntProperty('previewCount', previewIcons.length))
      ..add(FlagProperty('isOpen', value: isOpen, ifTrue: 'open'));
  }
}

/// Bottom-of-screen pill of icons (typically 4) on a glass surface.
final class LiqAppIconDock extends StatelessWidget with Diagnosticable {
  /// Creates a dock.
  const LiqAppIconDock({
    required this.icons,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    super.key,
  });

  final List<Widget> icons;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return LiqGlassSurface(
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < icons.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 12),
            icons[i],
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('iconCount', icons.length));
  }
}
