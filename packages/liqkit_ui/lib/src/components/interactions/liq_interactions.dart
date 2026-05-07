import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/progress/liq_progress_indicator.dart';

/// Direction in which a [LiqDismissible] can be swiped to dismiss.
///
/// Mirrors Flutter's `widgets/DismissDirection` so consumer code can
/// drop the Material import that historically pulled it in (the type
/// itself ships in `widgets/dismissible.dart`, not Material).
typedef LiqDismissDirection = DismissDirection;

/// Swipe-to-dismiss wrapper around a [child].
///
/// Thin alias for Flutter's [Dismissible] (which is already part of
/// `package:flutter/widgets.dart`). The class exists in this namespace
/// so liqkit_ui consumers can write `LiqDismissible(...)` and never
/// need to reach into Material or low-level widgets imports.
///
/// API matches [Dismissible] exactly — pass [key], [child], [onDismissed],
/// optional [background] / [secondaryBackground], and one of the
/// [LiqDismissDirection] modes.
class LiqDismissible extends Dismissible {
  /// Creates a dismissible row.
  const LiqDismissible({
    required super.key,
    required super.child,
    super.background,
    super.secondaryBackground,
    super.confirmDismiss,
    super.onResize,
    super.onUpdate,
    super.onDismissed,
    super.direction = DismissDirection.horizontal,
    super.resizeDuration = const Duration(milliseconds: 300),
    super.dismissThresholds = const <DismissDirection, double>{},
    super.movementDuration = const Duration(milliseconds: 200),
    super.crossAxisEndOffset = 0.0,
    super.dragStartBehavior = DragStartBehavior.start,
    super.behavior = HitTestBehavior.opaque,
  });
}

/// iOS-style page transition route — alias for [CupertinoPageRoute].
///
/// Use as a drop-in replacement for Material's `MaterialPageRoute`:
///
/// ```dart
/// Navigator.of(context).push(
///   LiqPageRoute<void>(builder: (_) => const NextScreen()),
/// );
/// ```
class LiqPageRoute<T> extends CupertinoPageRoute<T> {
  /// Creates an iOS-style push route.
  LiqPageRoute({
    required super.builder,
    super.title,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
  });
}

/// Drag-to-reorder list — composition over [ReorderableList] (which is
/// part of `package:flutter/widgets.dart` and does NOT depend on Material).
///
/// Renders a vertical list of [children] where each row can be dragged
/// to reorder. Each child must carry a unique `Key` (typically a
/// `ValueKey`) so the list can track items across rebuilds.
final class LiqReorderableList extends StatefulWidget {
  /// Creates a reorderable list.
  ///
  /// [onReorder] is invoked with the original and new index when the
  /// user finishes a drag.
  const LiqReorderableList({
    required this.children,
    required this.onReorder,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    super.key,
  });

  /// Items to render. Each child must have a unique [Key].
  final List<Widget> children;

  /// Called when an item is dropped at a new index.
  final void Function(int oldIndex, int newIndex) onReorder;

  /// Outer padding around the list.
  final EdgeInsetsGeometry? padding;

  /// When true, the list sizes itself to its children.
  final bool shrinkWrap;

  /// Optional physics override.
  final ScrollPhysics? physics;

  @override
  State<LiqReorderableList> createState() => _LiqReorderableListState();
}

class _LiqReorderableListState extends State<LiqReorderableList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      slivers: <Widget>[
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverReorderableList(
            itemCount: widget.children.length,
            itemBuilder: (context, index) {
              final child = widget.children[index];
              assert(
                child.key != null,
                'LiqReorderableList children must each have a unique Key.',
              );
              return ReorderableDelayedDragStartListener(
                key: child.key,
                index: index,
                child: child,
              );
            },
            onReorder: widget.onReorder,
          ),
        ),
      ],
    );
  }
}

/// iOS-style pull-to-refresh wrapper.
///
/// Hosts [child] inside a [CustomScrollView] with a [Cupertino-style]
/// refresh control on top. When the user drags down past the trigger
/// distance, [onRefresh] fires; the indicator stays visible until the
/// returned [Future] completes.
///
/// Drops the Material `RefreshIndicator` dependency in favor of the
/// iOS-native pulling spinner (renders [LiqSpinner] during refresh).
final class LiqRefreshIndicator extends StatelessWidget {
  /// Creates a pull-to-refresh wrapper.
  const LiqRefreshIndicator({
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
    super.key,
  });

  /// Async callback fired when the user pulls past the trigger distance.
  final Future<void> Function() onRefresh;

  /// Wrapped scroll-host widget. Typically a [ListView], [GridView], or
  /// [CustomScrollView].
  final Widget child;

  /// Spinner accent color.
  final Color? color;

  /// Optional background tint behind the spinner. Currently unused —
  /// kept for source-compat with Material's `RefreshIndicator`.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return _LiqRefreshHost(
      onRefresh: onRefresh,
      color: color,
      child: child,
    );
  }
}

class _LiqRefreshHost extends StatefulWidget {
  const _LiqRefreshHost({
    required this.onRefresh,
    required this.child,
    this.color,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;

  @override
  State<_LiqRefreshHost> createState() => _LiqRefreshHostState();
}

class _LiqRefreshHostState extends State<_LiqRefreshHost> {
  bool _refreshing = false;
  double _drag = 0;
  static const double _trigger = 72;

  Future<void> _maybeFire() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    await widget.onRefresh();
    if (!mounted) return;
    setState(() {
      _refreshing = false;
      _drag = 0;
    });
  }

  bool _onNotification(ScrollNotification n) {
    if (n is OverscrollNotification && n.overscroll < 0 && !_refreshing) {
      setState(() => _drag = (_drag - n.overscroll).clamp(0, _trigger * 1.5));
    } else if (n is ScrollEndNotification) {
      if (_drag >= _trigger && !_refreshing) {
        _maybeFire();
      } else if (!_refreshing && _drag != 0) {
        setState(() => _drag = 0);
      }
    } else if (n is ScrollUpdateNotification &&
        (n.metrics.pixels) > 0 &&
        !_refreshing) {
      if (_drag != 0) setState(() => _drag = 0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final indicatorOffset = _refreshing ? 28.0 : (_drag * 0.6);
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollNotification>(
          onNotification: _onNotification,
          child: widget.child,
        ),
        if (_refreshing || _drag > 0)
          Positioned(
            top: indicatorOffset - 28,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: _refreshing
                    ? const LiqSpinner(size: LiqSpinnerSize.small)
                    : Opacity(
                        opacity: (_drag / _trigger).clamp(0.0, 1.0),
                        child: const LiqSpinner(size: LiqSpinnerSize.small),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
