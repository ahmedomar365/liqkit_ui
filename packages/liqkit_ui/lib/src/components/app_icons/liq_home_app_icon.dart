import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/app_icons/liq_app_icon.dart';
import 'package:liqkit_ui/src/components/progress/liq_progress_extras.dart';

/// iOS 26 home-screen app icon with badge / download / edit-mode
/// affordances.
///
/// This is the higher-level composite around [LiqAppIcon] used by the
/// home-grid pattern. The base tile renders via [LiqAppIcon]; on top
/// of it [LiqHomeAppIcon] composes:
///
/// - an unread-count badge at top-right (when [showBadge] is true and
///   [badgeCount] > 0)
/// - a circular download-progress ring (when [isDownloading] is true)
/// - a small minus-button delete affordance at top-left (when
///   [showDeleteButton] is true)
/// - a subtle continuous wiggle (when [isJiggling] is true — typical
///   iOS edit-mode behavior)
final class LiqHomeAppIcon extends StatefulWidget with Diagnosticable {
  /// Creates a home-screen app icon.
  const LiqHomeAppIcon({
    required this.icon,
    this.label,
    this.backgroundColor,
    this.iconColor,
    this.size = 60,
    this.onTap,
    this.onLongPress,
    this.showBadge = false,
    this.badgeCount = 0,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
    this.showDeleteButton = false,
    this.onDelete,
    this.isJiggling = false,
    super.key,
  })  : assert(
          downloadProgress >= 0 && downloadProgress <= 1,
          'downloadProgress must be in [0, 1]',
        ),
        assert(badgeCount >= 0, 'badgeCount must be non-negative');

  /// The icon glyph rendered centered on the tile.
  final IconData icon;

  /// Optional label rendered below the tile.
  final String? label;

  /// Tile background color. Defaults to system blue when null.
  final Color? backgroundColor;

  /// Glyph color. Defaults to white when null.
  final Color? iconColor;

  /// Tile diameter (square). Default 60pt.
  final double size;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Long-press callback.
  final VoidCallback? onLongPress;

  /// When true, renders a badge with [badgeCount] at the top-right.
  final bool showBadge;

  /// Unread count rendered inside the badge.
  final int badgeCount;

  /// When true, renders a circular progress ring around the icon.
  final bool isDownloading;

  /// Progress value in `[0, 1]`. Ignored when [isDownloading] is false.
  final double downloadProgress;

  /// When true, renders a minus-circle delete button at the top-left.
  final bool showDeleteButton;

  /// Tap callback for the delete button.
  final VoidCallback? onDelete;

  /// When true, the tile rocks back-and-forth (iOS edit-mode wiggle).
  final bool isJiggling;

  @override
  State<LiqHomeAppIcon> createState() => _LiqHomeAppIconState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DoubleProperty('size', size))
      ..add(FlagProperty('showBadge', value: showBadge, ifTrue: 'badged'))
      ..add(IntProperty('badgeCount', badgeCount))
      ..add(FlagProperty('isDownloading',
          value: isDownloading, ifTrue: 'downloading'))
      ..add(DoubleProperty('downloadProgress', downloadProgress))
      ..add(FlagProperty('showDeleteButton',
          value: showDeleteButton, ifTrue: 'deletable'))
      ..add(FlagProperty('isJiggling', value: isJiggling, ifTrue: 'jiggling'));
  }
}

class _LiqHomeAppIconState extends State<LiqHomeAppIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _jiggleController;
  late final Animation<double> _jiggle;

  @override
  void initState() {
    super.initState();
    // Eagerly construct the controller (don't rely on a `late final`
    // initializer). If isJiggling is false on first build the field is
    // never read, and then dispose() would lazily construct it AFTER
    // the element is deactivated — triggering the framework assertion
    // about ancestor lookup on a deactivated widget.
    _jiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _jiggle = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(
      CurvedAnimation(parent: _jiggleController, curve: Curves.easeInOut),
    );
    if (widget.isJiggling) _jiggleController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(LiqHomeAppIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isJiggling != oldWidget.isJiggling) {
      if (widget.isJiggling) {
        _jiggleController.repeat(reverse: true);
      } else {
        _jiggleController
          ..stop()
          ..value = 0;
      }
    }
  }

  @override
  void dispose() {
    _jiggleController.dispose();
    super.dispose();
  }

  void _handleLongPress() {
    HapticFeedback.mediumImpact();
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final tile = LiqAppIcon(
      size: widget.size,
      color: widget.backgroundColor ?? const Color(0xFF0088FF),
      glyph: Icon(
        widget.icon,
        size: widget.size * 0.5,
        color: widget.iconColor ?? const Color(0xFFFFFFFF),
      ),
      badge: widget.showBadge && widget.badgeCount > 0
          ? LiqAppIconBadge(count: widget.badgeCount)
          : null,
      label: widget.label,
      onPressed: widget.onTap,
    );

    Widget body = GestureDetector(
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          tile,
          if (widget.isDownloading)
            Positioned(
              left: 0,
              top: 0,
              width: widget.size,
              height: widget.size,
              child: Padding(
                padding: EdgeInsets.all(widget.size * 0.1),
                child: LiqCircularProgress(
                  value: widget.downloadProgress.clamp(0.0, 1.0),
                  size: widget.size * 0.8,
                  strokeWidth: 2,
                  progressColor: const Color(0xCCFFFFFF),
                  backgroundColor: const Color(0x4DFFFFFF),
                  showPercentage: false,
                ),
              ),
            ),
          if (widget.showDeleteButton)
            Positioned(
              top: -8,
              left: -8,
              child: GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF3B30),
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Color(0xFFFFFFFF), width: 2),
                    ),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 12,
                      height: 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (widget.isJiggling) {
      body = AnimatedBuilder(
        animation: _jiggle,
        builder: (context, child) =>
            Transform.rotate(angle: _jiggle.value, child: child),
        child: body,
      );
    }
    return body;
  }
}
