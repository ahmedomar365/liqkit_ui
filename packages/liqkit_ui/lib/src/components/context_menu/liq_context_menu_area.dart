import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/menu/liq_menu.dart';

/// Wraps a [child] widget and shows a [LiqMenu] popup on long-press,
/// anchored at the gesture's global position. iOS-style "context
/// menu" — same UX as the legacy LiquidContextMenu wrapper.
///
/// Pass [LiqMenuItem]s (or `LiqMenuSeparator`s) via [items].
final class LiqContextMenuArea extends StatefulWidget with Diagnosticable {
  /// Creates a context-menu area.
  const LiqContextMenuArea({
    required this.child,
    required this.items,
    this.enableHaptics = true,
    this.menuWidth = 250,
    super.key,
  });

  /// Wrapped widget. The whole hit area triggers the menu on
  /// long-press.
  final Widget child;

  /// Menu rows shown on long-press.
  final List<Widget> items;

  /// When true, fires a `mediumImpact` haptic on long-press start.
  final bool enableHaptics;

  /// Width of the popup menu.
  final double menuWidth;

  @override
  State<LiqContextMenuArea> createState() => _LiqContextMenuAreaState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('itemCount', items.length))
      ..add(DoubleProperty('menuWidth', menuWidth));
  }
}

class _LiqContextMenuAreaState extends State<LiqContextMenuArea> {
  Offset _pressGlobal = Offset.zero;

  void _onLongPressStart(LongPressStartDetails details) {
    _pressGlobal = details.globalPosition;
    if (widget.enableHaptics) {
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _onLongPress() async {
    await LiqMenu.showPopup<void>(
      context: context,
      children: widget.items,
      position: _pressGlobal,
      width: widget.menuWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: _onLongPressStart,
      onLongPress: _onLongPress,
      child: widget.child,
    );
  }
}
