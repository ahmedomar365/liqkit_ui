import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Shared iOS-style press-drag-release selection surface.
///
/// Used by controls whose children form a horizontal strip of equal-width
/// targets. It previews the index under the active pointer and commits the
/// release index, matching native iOS tab and segmented-control scrubbing.
final class LiqScrubbableIndexSurface extends StatefulWidget {
  /// Creates a scrubbable index surface.
  const LiqScrubbableIndexSurface({
    required this.count,
    required this.child,
    this.enabled = true,
    this.padding = EdgeInsets.zero,
    this.spacing = 0,
    this.onPreview,
    this.onCommit,
    super.key,
  });

  /// Number of equal-width targets.
  final int count;

  /// Whether pointer tracking is enabled.
  final bool enabled;

  /// Horizontal/vertical padding around the target strip.
  final EdgeInsets padding;

  /// Space between adjacent targets.
  final double spacing;

  /// Called when the pointer enters a different target during tracking.
  final ValueChanged<int>? onPreview;

  /// Called with the target index where the active pointer is released.
  final ValueChanged<int>? onCommit;

  /// Child that visually represents the target strip.
  final Widget child;

  @override
  State<LiqScrubbableIndexSurface> createState() =>
      _LiqScrubbableIndexSurfaceState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('count', count))
      ..add(FlagProperty('enabled', value: enabled, ifTrue: 'enabled'))
      ..add(DoubleProperty('spacing', spacing))
      ..add(ObjectFlagProperty<ValueChanged<int>?>.has('onPreview', onPreview))
      ..add(ObjectFlagProperty<ValueChanged<int>?>.has('onCommit', onCommit));
  }
}

class _LiqScrubbableIndexSurfaceState extends State<LiqScrubbableIndexSurface> {
  int? _activePointer;
  int? _previewIndex;

  @override
  void didUpdateWidget(covariant LiqScrubbableIndexSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled ||
        widget.count != oldWidget.count ||
        (_previewIndex != null && _previewIndex! >= widget.count)) {
      _activePointer = null;
      _previewIndex = null;
    }
  }

  int _indexForOffset(Offset offset, Size size) {
    if (widget.count <= 0 || size.width <= 0) return 0;

    final left = widget.padding.left;
    final right = widget.padding.right;
    final availableWidth = math.max(0, size.width - left - right);
    final totalSpacing = math.max(0, widget.count - 1) * widget.spacing;
    final itemWidth = math.max(
      0,
      (availableWidth - totalSpacing) / widget.count,
    );
    if (itemWidth <= 0) return 0;

    final dx = (offset.dx - left).clamp(0.0, availableWidth);
    final step = itemWidth + widget.spacing;
    return (dx / step).floor().clamp(0, widget.count - 1);
  }

  void _preview(int index) {
    if (_previewIndex == index) return;
    _previewIndex = index;
    widget.onPreview?.call(index);
  }

  void _handlePointerDown(PointerDownEvent event, Size size) {
    if (!widget.enabled || widget.count <= 0 || _activePointer != null) {
      return;
    }

    _activePointer = event.pointer;
    _preview(_indexForOffset(event.localPosition, size));
  }

  void _handlePointerMove(PointerMoveEvent event, Size size) {
    if (event.pointer != _activePointer) return;
    _preview(_indexForOffset(event.localPosition, size));
  }

  void _handlePointerUp(PointerUpEvent event, Size size) {
    if (event.pointer != _activePointer) return;

    final index = _indexForOffset(event.localPosition, size);
    _activePointer = null;
    _previewIndex = null;
    widget.onCommit?.call(index);
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) return;
    _activePointer = null;
    _previewIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 0,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 0,
        );
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown:
              widget.enabled
                  ? (event) => _handlePointerDown(event, size)
                  : null,
          onPointerMove:
              widget.enabled
                  ? (event) => _handlePointerMove(event, size)
                  : null,
          onPointerUp:
              widget.enabled ? (event) => _handlePointerUp(event, size) : null,
          onPointerCancel: widget.enabled ? _handlePointerCancel : null,
          child: widget.child,
        );
      },
    );
  }
}
