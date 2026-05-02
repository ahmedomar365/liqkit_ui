import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_motion.dart';

/// Axis along which a [LiqResizable] arranges its two panes.
enum LiqResizableDirection {
  /// Panes are arranged left-to-right with a vertical divider between
  /// them; dragging the divider adjusts the horizontal split ratio.
  horizontal,

  /// Panes are arranged top-to-bottom with a horizontal divider between
  /// them; dragging the divider adjusts the vertical split ratio.
  vertical,
}

/// iOS 26 split-pane container with a draggable divider between two
/// children.
///
/// Pass [initialRatio] in `(0, 1)` — the fraction of the total size the
/// `first` child occupies initially. Drag clamps to
/// `[minRatio, maxRatio]`. Useful for IDE-style left-sidebar / main /
/// right-inspector layouts.
final class LiqResizable extends StatefulWidget {
  /// Creates a split-pane container.
  const LiqResizable({
    required this.first,
    required this.second,
    this.direction = LiqResizableDirection.horizontal,
    this.initialRatio = 0.5,
    this.minRatio = 0.15,
    this.maxRatio = 0.85,
    this.dividerThickness = 8,
    this.onRatioChanged,
    super.key,
  }) : assert(
         initialRatio > 0 && initialRatio < 1,
         'initialRatio must be in (0, 1)',
       ),
       assert(minRatio < maxRatio, 'minRatio must be < maxRatio'),
       assert(minRatio > 0 && maxRatio < 1, 'min/max must be in (0, 1)'),
       assert(
         initialRatio >= minRatio && initialRatio <= maxRatio,
         'initialRatio must be within [minRatio, maxRatio]',
       );

  /// Leading pane — left when [direction] is horizontal, top when vertical.
  final Widget first;

  /// Trailing pane — right when [direction] is horizontal, bottom when
  /// vertical.
  final Widget second;

  /// Layout axis.
  final LiqResizableDirection direction;

  /// Initial fraction of the total size that [first] occupies. Must be
  /// inside `(0, 1)` and inside `[minRatio, maxRatio]`.
  final double initialRatio;

  /// Minimum allowed ratio for [first]. The divider cannot be dragged
  /// past this point.
  final double minRatio;

  /// Maximum allowed ratio for [first]. The divider cannot be dragged
  /// past this point.
  final double maxRatio;

  /// Thickness of the draggable divider, in logical pixels.
  final double dividerThickness;

  /// Called every drag update with the new clamped ratio.
  final ValueChanged<double>? onRatioChanged;

  /// Idle divider band fill — iOS 26 hairline-ish 8% black.
  static const Color dividerColorIdle = Color(0x14000000);

  /// Active/hover divider band fill — iOS 26 system blue.
  static const Color dividerColorActive = Color(0xFF007AFF);

  /// Grip rectangle fill — iOS 26 system gray 4.
  static const Color gripColor = Color(0xFFC7C7CC);

  /// Grip rectangle long edge length.
  static const double gripLong = 24;

  /// Grip rectangle short edge length.
  static const double gripShort = 3;

  /// Color tween duration for hover/active state.
  static const Duration animationDuration = LiqMotion.fast;

  /// Stable [Key] for the divider — exposed so tests and consumers can
  /// locate it without depending on internal widget classes.
  static const Key dividerKey = Key('liq.resizable.divider');

  @override
  State<LiqResizable> createState() => _LiqResizableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqResizableDirection>('direction', direction))
      ..add(DoubleProperty('initialRatio', initialRatio))
      ..add(DoubleProperty('minRatio', minRatio))
      ..add(DoubleProperty('maxRatio', maxRatio))
      ..add(DoubleProperty('dividerThickness', dividerThickness));
  }
}

class _LiqResizableState extends State<LiqResizable> {
  late double _ratio;
  bool _hovered = false;
  bool _pressing = false;

  @override
  void initState() {
    super.initState();
    _ratio = widget.initialRatio;
  }

  @override
  void didUpdateWidget(covariant LiqResizable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If clamps tightened around the current ratio, re-clamp so the
    // displayed split stays inside the new bounds.
    if (oldWidget.minRatio != widget.minRatio ||
        oldWidget.maxRatio != widget.maxRatio) {
      final clamped = _ratio.clamp(widget.minRatio, widget.maxRatio);
      if (clamped != _ratio) {
        _ratio = clamped;
      }
    }
  }

  void _setRatio(double next) {
    final clamped = next.clamp(widget.minRatio, widget.maxRatio);
    if (clamped == _ratio) return;
    setState(() => _ratio = clamped);
    widget.onRatioChanged?.call(clamped);
  }

  void _onPanStart(DragStartDetails _) {
    setState(() => _pressing = true);
  }

  void _onPanEnd(DragEndDetails _) {
    setState(() => _pressing = false);
  }

  void _onPanCancel() {
    setState(() => _pressing = false);
  }

  void _onPanUpdate(DragUpdateDetails details, double total) {
    if (total <= 0) return;
    final delta =
        widget.direction == LiqResizableDirection.horizontal
            ? details.delta.dx
            : details.delta.dy;
    _setRatio(_ratio + delta / total);
  }

  void _onEnter(PointerEnterEvent _) {
    setState(() => _hovered = true);
  }

  void _onExit(PointerExitEvent _) {
    setState(() => _hovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final horizontal = widget.direction == LiqResizableDirection.horizontal;
    final cursor =
        horizontal
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.resizeRow;
    final activeColor =
        (_hovered || _pressing)
            ? LiqResizable.dividerColorActive
            : LiqResizable.dividerColorIdle;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final total = horizontal ? constraints.maxWidth : constraints.maxHeight;
        final dividerThickness = widget.dividerThickness;
        // When constraints are unbounded fall back to a reasonable size
        // so the panes still render. Tests/snippets always supply
        // bounded sizes.
        final safeTotal =
            total.isFinite && total > dividerThickness
                ? total
                : dividerThickness + 2;
        final firstSize = (safeTotal * _ratio).clamp(0.0, safeTotal);
        final secondSize = (safeTotal - firstSize - dividerThickness).clamp(
          0.0,
          safeTotal,
        );

        final divider = MouseRegion(
          cursor: cursor,
          onEnter: _onEnter,
          onExit: _onExit,
          child: GestureDetector(
            key: LiqResizable.dividerKey,
            behavior: HitTestBehavior.opaque,
            onPanStart: _onPanStart,
            onPanEnd: _onPanEnd,
            onPanCancel: _onPanCancel,
            onPanUpdate:
                (DragUpdateDetails details) => _onPanUpdate(details, safeTotal),
            child: SizedBox(
              width: horizontal ? dividerThickness : double.infinity,
              height: horizontal ? double.infinity : dividerThickness,
              child: AnimatedContainer(
                duration: LiqResizable.animationDuration,
                color: activeColor,
                alignment: Alignment.center,
                child: SizedBox(
                  width:
                      horizontal
                          ? LiqResizable.gripShort
                          : LiqResizable.gripLong,
                  height:
                      horizontal
                          ? LiqResizable.gripLong
                          : LiqResizable.gripShort,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: LiqResizable.gripColor,
                      borderRadius: BorderRadius.all(Radius.circular(1.5)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        Widget paneOf(Widget child, double size) {
          return SizedBox(
            width: horizontal ? size : double.infinity,
            height: horizontal ? double.infinity : size,
            child: ClipRect(child: child),
          );
        }

        final children = <Widget>[
          paneOf(widget.first, firstSize),
          divider,
          paneOf(widget.second, secondSize),
        ];

        return horizontal
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            );
      },
    );
  }
}
