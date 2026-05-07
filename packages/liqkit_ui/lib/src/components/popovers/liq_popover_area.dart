import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/popovers/liq_popover.dart';

/// Tap-to-show popover wrapper.
///
/// Wraps [child] (typically a button or icon) and opens a [LiqPopover]
/// anchored at the child's center when the user taps it. The popover
/// renders [content] and dismisses on barrier tap (when
/// [barrierDismissible] is true).
///
/// This is the highest-level popover convenience: drop it around any
/// trigger widget without managing keys, render boxes, or anchors
/// manually. Use [LiqPopover.show] directly when you need to anchor
/// at an arbitrary point.
final class LiqPopoverArea extends StatefulWidget {
  /// Creates a tap-to-show popover area.
  const LiqPopoverArea({
    required this.child,
    required this.content,
    this.side = LiqPopoverSide.bottom,
    this.alignment = LiqPopoverAlignment.center,
    this.width = 220,
    this.padding = const EdgeInsets.all(14),
    this.barrierDismissible = true,
    super.key,
  });

  /// The trigger widget. Tap to open the popover.
  final Widget child;

  /// Popover body.
  final Widget content;

  /// Side of the bubble whose tip points at the trigger.
  final LiqPopoverSide side;

  /// Position of the tip along the chosen edge.
  final LiqPopoverAlignment alignment;

  /// Popover bubble width.
  final double width;

  /// Inner padding inside the bubble.
  final EdgeInsets padding;

  /// When true, tapping the scrim dismisses the popover.
  final bool barrierDismissible;

  @override
  State<LiqPopoverArea> createState() => _LiqPopoverAreaState();
}

class _LiqPopoverAreaState extends State<LiqPopoverArea> {
  final GlobalKey _anchorKey = GlobalKey();

  Future<void> _open() async {
    final renderObject = _anchorKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;
    final size = renderObject.size;
    final anchor = renderObject.localToGlobal(
      Offset(size.width / 2, size.height / 2),
    );
    await LiqPopover.show<void>(
      context: context,
      anchor: anchor,
      side: widget.side,
      alignment: widget.alignment,
      width: widget.width,
      padding: widget.padding,
      barrierDismissible: widget.barrierDismissible,
      child: widget.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _anchorKey,
      behavior: HitTestBehavior.opaque,
      onTap: _open,
      child: widget.child,
    );
  }
}
