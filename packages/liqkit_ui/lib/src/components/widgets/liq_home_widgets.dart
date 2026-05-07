import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme.dart';

/// Apple home-screen widget sizes, matching the iOS widget grid.
///
/// Values pulled from the iOS Home Screen widget specification:
///
/// * `small` — 2x2 grid (164 x 164 pt)
/// * `medium` — 4x2 grid (349 x 164 pt)
/// * `large` — 4x4 grid (349 x 365 pt)
enum LiqHomeWidgetSize {
  /// 2x2 grid widget — 164 x 164 pt.
  small(164, 164),

  /// 4x2 grid widget — 349 x 164 pt.
  medium(349, 164),

  /// 4x4 grid widget — 349 x 365 pt.
  large(349, 365);

  const LiqHomeWidgetSize(this.width, this.height);

  /// Logical pixel width of the widget.
  final double width;

  /// Logical pixel height of the widget.
  final double height;
}

/// iOS Home Screen widget gallery item.
///
/// Renders a glass-tinted rounded rectangle with optional title, subtitle,
/// leading icon, and a corner badge. The body of the widget is supplied
/// via [content] and may be any widget — typically a chart, list, or
/// status surface.
///
/// Pair with [LiqHomeWidgetGrid] or [LiqHomeWidgetStack] to compose
/// rich Home Screen layouts.
final class LiqHomeWidget extends StatelessWidget with Diagnosticable {
  /// Creates a Home Screen widget.
  const LiqHomeWidget({
    required this.content,
    this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.size,
    this.padding,
    this.showBadge = false,
    this.badgeText,
    this.badgeColor,
    this.tint = LiqGlassTint.light,
    this.elevation = LiqGlassElevation.floating,
    this.backgroundColor,
    this.borderRadius = 28,
    super.key,
  });

  /// Body content rendered below the optional header row.
  final Widget content;

  /// Optional title rendered next to the leading [icon].
  final String? title;

  /// Optional subtitle rendered below the [title]. Up to two lines.
  final String? subtitle;

  /// Optional leading icon, sized at 20pt.
  final IconData? icon;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Long-press callback.
  final VoidCallback? onLongPress;

  /// Explicit width override. Ignored when [size] is non-null.
  final double? width;

  /// Explicit height override. Ignored when [size] is non-null.
  final double? height;

  /// Canonical iOS widget size. When set, takes precedence over [width]
  /// and [height].
  final LiqHomeWidgetSize? size;

  /// Inner content padding. Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? padding;

  /// Whether to render a corner badge.
  final bool showBadge;

  /// Badge label text. Required when [showBadge] is true.
  final String? badgeText;

  /// Badge background color. Defaults to the system red HIG color.
  final Color? badgeColor;

  /// Glass tint preset.
  final LiqGlassTint tint;

  /// Glass elevation preset.
  final LiqGlassElevation elevation;

  /// Optional override for the glass base fill color.
  final Color? backgroundColor;

  /// Outer corner radius.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final brightness = LiqTheme.of(context).brightness;
    final palette = LiqApplePalette(brightness);
    final effectiveWidth = size?.width ?? width;
    final effectiveHeight = size?.height ?? height;
    final effectiveBadgeColor = badgeColor ?? palette.red;
    final headlineStyle = LiqAppleTypography.headline(brightness);
    final captionStyle = LiqAppleTypography.caption1(brightness).copyWith(
      color: brightness == Brightness.dark
          ? LiqAppleColors.secondaryLabelDark
          : LiqAppleColors.secondaryLabel,
    );

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          LiqGlassSurface(
            tint: tint,
            elevation: elevation,
            baseFill: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            child: SizedBox(
              width: effectiveWidth,
              height: effectiveHeight,
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (icon != null || title != null) ...<Widget>[
                      Row(
                        children: <Widget>[
                          if (icon != null)
                            Icon(icon, size: 20, color: palette.gray),
                          if (icon != null && title != null)
                            const SizedBox(width: 8),
                          if (title != null)
                            Expanded(
                              child: Text(
                                title!,
                                style: headlineStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      if (subtitle != null) ...<Widget>[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: captionStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],
                    Expanded(child: content),
                  ],
                ),
              ),
            ),
          ),
          if (showBadge && badgeText != null)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: effectiveBadgeColor,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(EnumProperty<LiqHomeWidgetSize?>('size', size, defaultValue: null))
      ..add(DoubleProperty('width', width, defaultValue: null))
      ..add(DoubleProperty('height', height, defaultValue: null))
      ..add(DiagnosticsProperty<bool>('showBadge', showBadge))
      ..add(StringProperty('badgeText', badgeText))
      ..add(ColorProperty('badgeColor', badgeColor, defaultValue: null))
      ..add(EnumProperty<LiqGlassTint>('tint', tint))
      ..add(EnumProperty<LiqGlassElevation>('elevation', elevation))
      ..add(ColorProperty(
        'backgroundColor',
        backgroundColor,
        defaultValue: null,
      ))
      ..add(DoubleProperty('borderRadius', borderRadius));
  }
}

/// Apple-styled wrapper around [LiqHomeWidget] with an app-name header.
///
/// Renders the Apple "App-name + accent icon" header bar that appears
/// above stock iOS widgets (Weather, Calendar, Stocks…). The tinted
/// header label is uppercase, semibold, with a 0.5pt letter spacing.
final class LiqAppleHomeWidget extends StatelessWidget with Diagnosticable {
  /// Creates an Apple-styled Home Screen widget.
  const LiqAppleHomeWidget({
    required this.size,
    required this.appName,
    required this.content,
    this.appIcon,
    this.accentColor,
    this.onTap,
    this.showLastUpdated = false,
    this.lastUpdated,
    super.key,
  });

  /// Canonical widget size.
  final LiqHomeWidgetSize size;

  /// Display name of the parent app — rendered uppercase in the header.
  final String appName;

  /// Optional leading app icon, rendered in a tinted square.
  final IconData? appIcon;

  /// Body content rendered between the header and footer.
  final Widget content;

  /// Accent color used for header text and icon background. Defaults to
  /// the iOS HIG system blue.
  final Color? accentColor;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Whether to show the "X minutes ago" footer.
  final bool showLastUpdated;

  /// Timestamp used to render the footer. Required when
  /// [showLastUpdated] is true.
  final DateTime? lastUpdated;

  @override
  Widget build(BuildContext context) {
    final brightness = LiqTheme.of(context).brightness;
    final palette = LiqApplePalette(brightness);
    final effectiveColor = accentColor ?? palette.blue;
    final caption2 = LiqAppleTypography.caption2(brightness);
    final caption2Secondary = caption2.copyWith(
      color: brightness == Brightness.dark
          ? LiqAppleColors.secondaryLabelDark
          : LiqAppleColors.secondaryLabel,
    );

    return LiqHomeWidget(
      size: size,
      onTap: onTap,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (appIcon != null)
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Icon(appIcon, size: 12, color: effectiveColor),
                ),
              if (appIcon != null) const SizedBox(width: 6),
              Expanded(
                child: Text(
                  appName.toUpperCase(),
                  style: caption2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: effectiveColor,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: content),
          if (showLastUpdated && lastUpdated != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              _formatLastUpdated(lastUpdated!),
              style: caption2Secondary.copyWith(fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }

  String _formatLastUpdated(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqHomeWidgetSize>('size', size))
      ..add(StringProperty('appName', appName))
      ..add(DiagnosticsProperty<IconData?>('appIcon', appIcon))
      ..add(ColorProperty('accentColor', accentColor, defaultValue: null))
      ..add(DiagnosticsProperty<bool>('showLastUpdated', showLastUpdated))
      ..add(DiagnosticsProperty<DateTime?>('lastUpdated', lastUpdated));
  }
}

/// Lightweight line+area chart used inside a [LiqHomeWidget].
///
/// Renders a stroked path through [data] with an optional grid behind
/// and a low-alpha fill below. Supply [maxValue] when the natural
/// maximum is not the right ceiling (e.g. fixed 100 % gauges).
final class LiqChartHomeWidget extends StatelessWidget with Diagnosticable {
  /// Creates a chart widget.
  const LiqChartHomeWidget({
    required this.data,
    this.color,
    this.maxValue,
    this.showGrid = true,
    this.showLabels = false,
    super.key,
  });

  /// Y-axis values.
  final List<double> data;

  /// Stroke + fill color. Defaults to iOS HIG system blue.
  final Color? color;

  /// Y-axis ceiling. Defaults to the largest value in [data].
  final double? maxValue;

  /// Whether to render the dotted background grid.
  final bool showGrid;

  /// Whether to render axis labels (reserved — not yet drawn).
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final brightness = LiqTheme.of(context).brightness;
    final palette = LiqApplePalette(brightness);
    final effectiveColor = color ?? palette.blue;
    final max = maxValue ??
        (data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b) : 100);
    return CustomPaint(
      painter: _ChartPainter(
        data: data,
        color: effectiveColor,
        maxValue: max,
        showGrid: showGrid,
        showLabels: showLabels,
      ),
      child: const SizedBox.expand(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<double>('data', data))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('maxValue', maxValue, defaultValue: null))
      ..add(DiagnosticsProperty<bool>('showGrid', showGrid))
      ..add(DiagnosticsProperty<bool>('showLabels', showLabels));
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.data,
    required this.color,
    required this.maxValue,
    required this.showGrid,
    required this.showLabels,
  });

  final List<double> data;
  final Color color;
  final double maxValue;
  final bool showGrid;
  final bool showLabels;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    if (showGrid) {
      for (var i = 0; i <= 4; i++) {
        final y = size.height * (i / 4);
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    final path = Path();
    final stepX = data.length > 1 ? size.width / (data.length - 1) : 0.0;

    for (var i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxValue) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.data != data ||
      oldDelegate.color != color ||
      oldDelegate.maxValue != maxValue ||
      oldDelegate.showGrid != showGrid ||
      oldDelegate.showLabels != showLabels;
}

/// One entry in a [LiqHomeWidgetStack].
///
/// Wraps an arbitrary widget with optional [flex] sizing. When [flex]
/// is non-null, the entry is wrapped in an [Expanded] inside the
/// stack's `Row` / `Column`.
final class LiqHomeWidgetStackItem with Diagnosticable {
  /// Creates a stack item.
  const LiqHomeWidgetStackItem({required this.widget, this.flex});

  /// The widget rendered for this entry.
  final Widget widget;

  /// Optional flex factor. When set, the entry is wrapped in
  /// [Expanded] with this factor.
  final int? flex;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('flex', flex, defaultValue: null));
  }
}

/// A vertical or horizontal stack of Home Screen widgets with built-in
/// spacing.
///
/// Use [LiqHomeWidgetStackItem.flex] to mix fixed-size and flexible
/// items; [spacing] inserts a `SizedBox` between every pair of
/// children.
final class LiqHomeWidgetStack extends StatefulWidget with Diagnosticable {
  /// Creates a Home Screen widget stack.
  const LiqHomeWidgetStack({
    required this.widgets,
    this.spacing = 16,
    this.padding,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    super.key,
  });

  /// Stack entries in render order.
  final List<LiqHomeWidgetStackItem> widgets;

  /// Gap inserted between every pair of children.
  final double spacing;

  /// Outer padding around the stack.
  final EdgeInsetsGeometry? padding;

  /// Stack direction.
  final Axis direction;

  /// Main-axis alignment of the underlying flex widget.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross-axis alignment of the underlying flex widget.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<LiqHomeWidgetStack> createState() => _LiqHomeWidgetStackState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('items', widgets.length))
      ..add(DoubleProperty('spacing', spacing))
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(EnumProperty<MainAxisAlignment>(
        'mainAxisAlignment',
        mainAxisAlignment,
      ))
      ..add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment',
        crossAxisAlignment,
      ));
  }
}

class _LiqHomeWidgetStackState extends State<LiqHomeWidgetStack> {
  @override
  Widget build(BuildContext context) {
    final children = widget.widgets.map(_buildWidgetItem).toList();
    final spaced = _addSpacing(children, widget.spacing);

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: widget.direction == Axis.vertical
          ? Column(
              mainAxisAlignment: widget.mainAxisAlignment,
              crossAxisAlignment: widget.crossAxisAlignment,
              children: spaced,
            )
          : Row(
              mainAxisAlignment: widget.mainAxisAlignment,
              crossAxisAlignment: widget.crossAxisAlignment,
              children: spaced,
            ),
    );
  }

  Widget _buildWidgetItem(LiqHomeWidgetStackItem item) {
    if (item.flex != null) {
      return Expanded(flex: item.flex!, child: item.widget);
    }
    return item.widget;
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (children.isEmpty) return children;
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) {
        spaced.add(
          SizedBox(
            width: widget.direction == Axis.horizontal ? spacing : 0,
            height: widget.direction == Axis.vertical ? spacing : 0,
          ),
        );
      }
    }
    return spaced;
  }
}

/// A non-scrollable grid of Home Screen widgets.
///
/// Renders [widgets] in a fixed-cross-axis-count grid with [spacing] /
/// [runSpacing] gaps and a [childAspectRatio]. The grid never scrolls
/// — callers should embed it inside their own scroll surface.
final class LiqHomeWidgetGrid extends StatelessWidget with Diagnosticable {
  /// Creates a Home Screen widget grid.
  const LiqHomeWidgetGrid({
    required this.widgets,
    this.crossAxisCount = 2,
    this.spacing = 16,
    this.runSpacing = 16,
    this.padding,
    this.childAspectRatio = 1.0,
    super.key,
  });

  /// Cells in row-major order.
  final List<Widget> widgets;

  /// Number of columns.
  final int crossAxisCount;

  /// Cross-axis (horizontal) spacing between cells.
  final double spacing;

  /// Main-axis (vertical) spacing between rows.
  final double runSpacing;

  /// Outer grid padding.
  final EdgeInsetsGeometry? padding;

  /// Width / height ratio of every cell.
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
      ),
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('items', widgets.length))
      ..add(IntProperty('crossAxisCount', crossAxisCount))
      ..add(DoubleProperty('spacing', spacing))
      ..add(DoubleProperty('runSpacing', runSpacing))
      ..add(DoubleProperty('childAspectRatio', childAspectRatio));
  }
}

/// Compact icon-and-label tile suitable for status grids and quick
/// actions.
///
/// Renders a square glass surface with a centered [icon], a [label],
/// and an optional [value] readout. When [isActive] is true, the tile
/// gains a 2pt accent border and the icon/label adopt the accent
/// color.
final class LiqMiniHomeWidget extends StatelessWidget with Diagnosticable {
  /// Creates a mini Home Screen tile.
  const LiqMiniHomeWidget({
    required this.icon,
    required this.label,
    this.value,
    this.color,
    this.onTap,
    this.isActive = false,
    this.size = 80,
    super.key,
  });

  /// Centered icon.
  final IconData icon;

  /// Label rendered below the icon.
  final String label;

  /// Optional value readout below the label.
  final String? value;

  /// Accent color. Defaults to iOS HIG system blue.
  final Color? color;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Whether the tile is in its active state.
  final bool isActive;

  /// Tile size — both width and height.
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = LiqTheme.of(context).brightness;
    final palette = LiqApplePalette(brightness);
    final isDark = brightness == Brightness.dark;
    final effectiveColor = color ?? palette.blue;
    final caption2 = LiqAppleTypography.caption2(brightness);

    return GestureDetector(
      onTap: onTap,
      child: LiqGlassSurface(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        elevation: LiqGlassElevation.flat,
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: isActive
                ? Border.all(
                    color: effectiveColor.withValues(alpha: 0.5),
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 24,
                color: isActive ? effectiveColor : palette.gray,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: caption2.copyWith(
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? effectiveColor
                      : (isDark
                          ? const Color(0xB3FFFFFF)
                          : const Color(0xDE000000)),
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              if (value != null) ...<Widget>[
                const SizedBox(height: 2),
                Text(
                  value!,
                  style: caption2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: effectiveColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(StringProperty('value', value))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DiagnosticsProperty<bool>('isActive', isActive))
      ..add(DoubleProperty('size', size));
  }
}

/// iOS Live Activity card — a glass surface with an animated pulse and
/// "LIVE" badge.
///
/// Useful for ongoing-activity surfaces (Sports scores, deliveries,
/// timers). The pulse animation runs continuously while [showPulse] is
/// true.
final class LiqLiveActivity extends StatefulWidget with Diagnosticable {
  /// Creates a Live Activity card.
  const LiqLiveActivity({
    required this.content,
    this.title,
    this.updateInterval = const Duration(seconds: 1),
    this.onTap,
    this.accentColor,
    this.showPulse = true,
    super.key,
  });

  /// Body content rendered below the header row.
  final Widget content;

  /// Optional title rendered next to the pulse indicator.
  final String? title;

  /// Logical update cadence — kept on the API for parity with the
  /// legacy widget. Consumers typically rebuild [content] on this
  /// interval themselves.
  final Duration updateInterval;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Accent color used for the pulse dot and "LIVE" label. Defaults to
  /// iOS HIG system green.
  final Color? accentColor;

  /// Whether to animate the pulse indicator.
  final bool showPulse;

  @override
  State<LiqLiveActivity> createState() => _LiqLiveActivityState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(DiagnosticsProperty<Duration>('updateInterval', updateInterval))
      ..add(ColorProperty('accentColor', accentColor, defaultValue: null))
      ..add(DiagnosticsProperty<bool>('showPulse', showPulse));
  }
}

class _LiqLiveActivityState extends State<LiqLiveActivity>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant LiqLiveActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPulse != oldWidget.showPulse) {
      if (widget.showPulse) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = LiqTheme.of(context).brightness;
    final palette = LiqApplePalette(brightness);
    final effectiveColor = widget.accentColor ?? palette.green;
    final subheadline = LiqAppleTypography.subheadline(brightness);
    final caption2 = LiqAppleTypography.caption2(brightness);

    return GestureDetector(
      onTap: widget.onTap,
      child: LiqGlassSurface(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.title != null) ...<Widget>[
                Row(
                  children: <Widget>[
                    if (widget.showPulse)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: effectiveColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                    if (widget.showPulse) const SizedBox(width: 8),
                    Text(
                      widget.title!,
                      style: subheadline.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      'LIVE',
                      style: caption2.copyWith(
                        color: effectiveColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              widget.content,
            ],
          ),
        ),
      ),
    );
  }
}

/// Wrapper that adds press-down scale animation and optional haptic
/// feedback to any child.
///
/// Compose around any other widget (including [LiqHomeWidget],
/// [LiqMiniHomeWidget], etc) to give it the standard iOS press
/// affordance.
final class LiqInteractiveHomeWidget extends StatefulWidget
    with Diagnosticable {
  /// Creates an interactive Home Screen widget.
  const LiqInteractiveHomeWidget({
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.enableHapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 150),
    this.pressedScale = 0.95,
    super.key,
  });

  /// Wrapped child.
  final Widget child;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Double-tap callback.
  final VoidCallback? onDoubleTap;

  /// Long-press callback.
  final VoidCallback? onLongPress;

  /// Whether to fire `HapticFeedback.lightImpact()` on tap-down.
  final bool enableHapticFeedback;

  /// Duration of the press scale animation.
  final Duration animationDuration;

  /// Scale factor applied while pressed. Defaults to 0.95.
  final double pressedScale;

  @override
  State<LiqInteractiveHomeWidget> createState() =>
      _LiqInteractiveHomeWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>(
        'enableHapticFeedback',
        enableHapticFeedback,
      ))
      ..add(DiagnosticsProperty<Duration>(
        'animationDuration',
        animationDuration,
      ))
      ..add(DoubleProperty('pressedScale', pressedScale));
  }
}

class _LiqInteractiveHomeWidgetState extends State<LiqInteractiveHomeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: widget.pressedScale)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}

/// Horizontally swipeable carousel of Home Screen widgets.
///
/// Wraps [PageView.builder] with viewport-fraction peeking, optional
/// auto-play, and optional infinite scroll.
final class LiqHomeWidgetCarousel extends StatefulWidget with Diagnosticable {
  /// Creates a Home Screen widget carousel.
  const LiqHomeWidgetCarousel({
    required this.widgets,
    this.height = 200,
    this.viewportFraction = 0.9,
    this.enableInfiniteScroll = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.onPageChanged,
    super.key,
  });

  /// Page widgets in render order.
  final List<Widget> widgets;

  /// Outer carousel height.
  final double height;

  /// Fraction of the viewport occupied by each page (peeking).
  final double viewportFraction;

  /// Whether the carousel should wrap around indefinitely.
  final bool enableInfiniteScroll;

  /// Whether to advance pages automatically.
  final bool autoPlay;

  /// Time between auto-play page advances.
  final Duration autoPlayInterval;

  /// Auto-play page transition duration.
  final Duration autoPlayAnimationDuration;

  /// Auto-play page transition curve.
  final Curve autoPlayCurve;

  /// Page-changed callback.
  final ValueChanged<int>? onPageChanged;

  @override
  State<LiqHomeWidgetCarousel> createState() => _LiqHomeWidgetCarouselState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('items', widgets.length))
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('viewportFraction', viewportFraction))
      ..add(DiagnosticsProperty<bool>(
        'enableInfiniteScroll',
        enableInfiniteScroll,
      ))
      ..add(DiagnosticsProperty<bool>('autoPlay', autoPlay))
      ..add(DiagnosticsProperty<Duration>(
        'autoPlayInterval',
        autoPlayInterval,
      ));
  }
}

class _LiqHomeWidgetCarouselState extends State<LiqHomeWidgetCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
    if (widget.autoPlay) {
      _scheduleAutoPlay();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _pageController.dispose();
    super.dispose();
  }

  void _scheduleAutoPlay() {
    Future<void>.delayed(widget.autoPlayInterval).then((_) {
      if (_disposed || !mounted || widget.widgets.isEmpty) return;
      final nextPage = (_currentPage + 1) % widget.widgets.length;
      _pageController.animateToPage(
        nextPage,
        duration: widget.autoPlayAnimationDuration,
        curve: widget.autoPlayCurve,
      );
      _scheduleAutoPlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
          widget.onPageChanged?.call(index);
        },
        itemCount: widget.enableInfiniteScroll ? null : widget.widgets.length,
        itemBuilder: (context, index) {
          if (widget.widgets.isEmpty) return const SizedBox.shrink();
          final actualIndex = index % widget.widgets.length;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: widget.widgets[actualIndex],
          );
        },
      ),
    );
  }
}
