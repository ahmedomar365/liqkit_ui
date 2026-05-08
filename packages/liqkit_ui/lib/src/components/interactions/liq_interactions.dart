import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
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

/// iOS-26-style page transition route. Built directly on
/// [PageRouteBuilder] so liqkit_ui doesn't pull in Cupertino for the
/// page-push animation.
///
/// Pushes slide in from the right and pop animates back. The previous
/// page parallaxes out to the left at half speed (the standard
/// iOS-style slide).
///
/// ```dart
/// Navigator.of(context).push(
///   LiqPageRoute<void>(builder: (_) => const NextScreen()),
/// );
/// ```
class LiqPageRoute<T> extends PageRoute<T> {
  /// Creates an iOS-style push route.
  LiqPageRoute({
    required this.builder,
    super.settings,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    this.barrierDismissible = false,
  });

  /// Builds the page contents.
  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  final bool fullscreenDialog;

  @override
  final bool allowSnapshotting;

  @override
  final bool barrierDismissible;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 260);

  @override
  Duration get reverseTransitionDuration =>
      const Duration(milliseconds: 200);

  @override
  bool get opaque => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Builder(builder: builder);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (fullscreenDialog) {
      // Fullscreen dialogs slide up from the bottom and don't get the
      // edge back-swipe (iOS reserves that for stack pushes).
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart,
            reverseCurve: Curves.easeInQuart,
          ),
        ),
        child: child,
      );
    }
    // Direction-aware push: in LTR the incoming page slides from the
    // right edge; in RTL it slides from the left. The outgoing page
    // parallaxes to the opposite edge.
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final incomingBeginX = isRtl ? -1.0 : 1.0;
    final outgoingEndX = isRtl ? 0.33 : -0.33;
    final incoming = SlideTransition(
      position: Tween<Offset>(
        begin: Offset(incomingBeginX, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
          reverseCurve: Curves.easeInQuart,
        ),
      ),
      child: child,
    );
    final parallax = SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: Offset(outgoingEndX, 0),
      ).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOutQuart,
          reverseCurve: Curves.easeInQuart,
        ),
      ),
      child: incoming,
    );
    return _LiqBackGestureDetector<T>(
      enabledCallback: () => _isPopGestureEnabled,
      onStartPopGesture: () => _startPopGesture(),
      child: parallax,
    );
  }

  // ─── back-swipe-to-pop ────────────────────────────────────────────
  // Lifted from `CupertinoRouteTransitionMixin` semantics, rebuilt from
  // scratch on `flutter/widgets` + `flutter/gestures` so liqkit_ui
  // doesn't have to import `flutter/cupertino.dart`. Drags that begin
  // within ~20pt of the leading edge drive `controller.value` from 1.0
  // toward 0.0; on release we either commit the pop or animate back to
  // the incoming position.
  bool get _isPopGestureEnabled {
    if (isFirst) return false;
    if (willHandlePopInternally) return false;
    if (popDisposition == RoutePopDisposition.doNotPop) return false;
    if (fullscreenDialog) return false;
    if (animation!.status != AnimationStatus.completed) return false;
    if (secondaryAnimation!.status != AnimationStatus.dismissed) return false;
    if (navigator!.userGestureInProgress) return false;
    return true;
  }

  _LiqBackGestureController<T> _startPopGesture() {
    return _LiqBackGestureController<T>(
      navigator: navigator!,
      controller: controller!,
    );
  }
}

/// Internal — drives the route's animation controller during a
/// left-edge drag and commits or cancels the pop on release.
class _LiqBackGestureController<T> {
  _LiqBackGestureController({required this.navigator, required this.controller}) {
    navigator.didStartUserGesture();
  }

  final NavigatorState navigator;
  final AnimationController controller;

  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  void dragEnd(double velocity) {
    // Snappier than easeOutCubic; matches the feel of the iOS native
    // pop animation where the page accelerates the rest of the way
    // out instead of easing in.
    const Curve animationCurve = Curves.easeOutQuart;
    final bool animateForward;
    if (velocity.abs() >= 1) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      // Snap-back when the user didn't drag far enough — short and
      // immediate so the page returns to its rest position quickly.
      final ms = math.min(
        lerpDouble(180, 0, controller.value)!.floor(),
        160,
      );
      controller.animateTo(
        1,
        duration: Duration(milliseconds: ms),
        curve: animationCurve,
      );
    } else {
      // Commit-pop — finish the slide-out promptly. Cap at 200ms so
      // the navigation feels instant on release.
      navigator.pop();
      if (controller.isAnimating) {
        final ms = math.min(
          lerpDouble(0, 200, controller.value)!.floor(),
          200,
        );
        controller.animateBack(
          0,
          duration: Duration(milliseconds: ms),
          curve: animationCurve,
        );
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener cb;
      cb = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(cb);
      };
      controller.addStatusListener(cb);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

/// Internal — installs an invisible left-edge drag detector that
/// initiates a back-swipe when the user drags from the leading edge.
class _LiqBackGestureDetector<T> extends StatefulWidget {
  const _LiqBackGestureDetector({
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  final ValueGetter<bool> enabledCallback;
  final ValueGetter<_LiqBackGestureController<T>> onStartPopGesture;
  final Widget child;

  @override
  State<_LiqBackGestureDetector<T>> createState() =>
      _LiqBackGestureDetectorState<T>();
}

class _LiqBackGestureDetectorState<T>
    extends State<_LiqBackGestureDetector<T>> {
  _LiqBackGestureController<T>? _controller;
  late HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _controller = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final width = context.size!.width;
    _controller!.dragUpdate(_logical(details.primaryDelta! / width));
  }

  void _handleDragEnd(DragEndDetails details) {
    final width = context.size!.width;
    _controller!.dragEnd(
      _logical(details.velocity.pixelsPerSecond.dx / width),
    );
    _controller = null;
  }

  void _handleDragCancel() {
    _controller?.dragEnd(0);
    _controller = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) _recognizer.addPointer(event);
  }

  double _logical(double value) {
    return Directionality.of(context) == TextDirection.rtl ? -value : value;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? padding.left + 20
        : padding.right + 20;
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0,
          top: 0,
          bottom: 0,
          width: dragAreaWidth,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
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
