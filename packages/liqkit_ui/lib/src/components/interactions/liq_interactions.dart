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

/// Constants matching `CupertinoPageRoute`.
const Duration _kLiqPushDuration = Duration(milliseconds: 500);
const Duration _kLiqDroppedSwipeDuration = Duration(milliseconds: 350);
const double _kLiqBackGestureWidth = 20;
const double _kLiqMinFlingVelocity = 1; // screen-widths per second

/// Tween used by every `LiqPageRoute` for the incoming page (slides
/// in from the trailing edge to rest position). The actual leading
/// vs. trailing direction is resolved by `SlideTransition.textDirection`.
final Animatable<Offset> _kLiqRightMiddleTween = Tween<Offset>(
  begin: const Offset(1, 0),
  end: Offset.zero,
);

/// Tween used for the parallax of the page below — when something is
/// pushed on top of it the page slides 1/3 of the way to the leading
/// edge. Reversed during pop.
final Animatable<Offset> _kLiqMiddleLeftTween = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(-1 / 3, 0),
);

/// iOS-26-style page transition route. Mirrors `CupertinoPageRoute`
/// pixel-for-pixel — same constants, curves, gesture semantics — but
/// rebuilt on `flutter/widgets` + `flutter/gestures` so liqkit_ui
/// imports zero Cupertino.
///
/// During an interactive back-swipe the position is mapped linearly so
/// the page tracks the finger 1:1; the curve only applies to automatic
/// push/pop and to the post-release animation (where the curve is
/// passed at the controller level via `animateTo`).
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
  Duration get transitionDuration => _kLiqPushDuration;

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
            curve: Curves.fastEaseInToSlowEaseOut,
            reverseCurve: Curves.fastEaseInToSlowEaseOut.flipped,
          ),
        ),
        child: child,
      );
    }
    // While the user is dragging the page, position must map linearly
    // to controller value — the page should track the finger 1:1.
    // For automatic push/pop the curves kick in. The flag flips when
    // `_LiqPageTransition`'s state sees `linearTransition` change in
    // `didUpdateWidget`, mirroring `CupertinoPageTransition`.
    final transition = _LiqPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: navigator?.userGestureInProgress ?? false,
      child: child,
    );
    return _LiqBackGestureDetector<T>(
      enabledCallback: () => _isPopGestureEnabled,
      onStartPopGesture: () => _startPopGesture(),
      child: transition,
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
    // Curve eyeballed against native iOS — same one Cupertino uses for
    // its dropped-swipe completion.
    const Curve animationCurve = Curves.fastEaseInToSlowEaseOut;
    final bool animateForward;
    if (velocity.abs() >= _kLiqMinFlingVelocity) {
      // Fling: dragging right (positive velocity in LTR after `_logical`
      // normalization) means commit-pop; left flick means snap back.
      animateForward = velocity <= 0;
    } else {
      // No fling — past the halfway point counts as commit-pop.
      animateForward = controller.value > 0.5;
    }

    // Native iOS uses a single FIXED duration for the post-release
    // animation regardless of how much is left. Scaling by remaining
    // distance (which the previous version did) makes partial drags
    // snap visibly fast and feels broken — the spec is 350ms flat.
    if (animateForward) {
      controller.animateTo(
        1,
        duration: _kLiqDroppedSwipeDuration,
        curve: animationCurve,
      );
    } else {
      navigator.pop();
      if (controller.isAnimating) {
        controller.animateBack(
          0,
          duration: _kLiqDroppedSwipeDuration,
          curve: animationCurve,
        );
      }
    }

    if (controller.isAnimating) {
      // Keep userGestureInProgress true so `_LiqPageTransition` doesn't
      // re-curve the position mid-flight — the controller's curve is
      // already driving the easing.
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

/// Internal — paints the actual slide / parallax / shadow for a
/// `LiqPageRoute`. Mirrors `CupertinoPageTransition`'s state lifecycle:
/// holds `CurvedAnimation`s as state, recreates them when
/// `linearTransition` or the parent animations change, and disposes
/// them on widget unmount.
class _LiqPageTransition extends StatefulWidget {
  const _LiqPageTransition({
    required this.primaryRouteAnimation,
    required this.secondaryRouteAnimation,
    required this.linearTransition,
    required this.child,
  });

  final Animation<double> primaryRouteAnimation;
  final Animation<double> secondaryRouteAnimation;
  final bool linearTransition;
  final Widget child;

  @override
  State<_LiqPageTransition> createState() => _LiqPageTransitionState();
}

class _LiqPageTransitionState extends State<_LiqPageTransition> {
  // Slides the incoming page from the trailing edge to rest.
  late Animation<Offset> _primaryPositionAnimation;
  // Parallaxes the page below 1/3 of the way to the leading edge.
  late Animation<Offset> _secondaryPositionAnimation;

  CurvedAnimation? _primaryCurve;
  CurvedAnimation? _secondaryCurve;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(covariant _LiqPageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.primaryRouteAnimation != widget.primaryRouteAnimation ||
        oldWidget.secondaryRouteAnimation !=
            widget.secondaryRouteAnimation ||
        oldWidget.linearTransition != widget.linearTransition) {
      _disposeCurves();
      _setupAnimations();
    }
  }

  @override
  void dispose() {
    _disposeCurves();
    super.dispose();
  }

  void _disposeCurves() {
    _primaryCurve?.dispose();
    _secondaryCurve?.dispose();
    _primaryCurve = null;
    _secondaryCurve = null;
  }

  void _setupAnimations() {
    if (!widget.linearTransition) {
      // Same curves Cupertino uses — chosen to match the native iOS
      // push feel (snappy start, smooth end on the incoming page;
      // gentle parallax on the outgoing page).
      _primaryCurve = CurvedAnimation(
        parent: widget.primaryRouteAnimation,
        curve: Curves.fastEaseInToSlowEaseOut,
        reverseCurve: Curves.fastEaseInToSlowEaseOut.flipped,
      );
      _secondaryCurve = CurvedAnimation(
        parent: widget.secondaryRouteAnimation,
        curve: Curves.linearToEaseOut,
        reverseCurve: Curves.easeInToLinear,
      );
    }
    _primaryPositionAnimation = (_primaryCurve ?? widget.primaryRouteAnimation)
        .drive(_kLiqRightMiddleTween);
    _secondaryPositionAnimation =
        (_secondaryCurve ?? widget.secondaryRouteAnimation)
            .drive(_kLiqMiddleLeftTween);
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return SlideTransition(
      // The outermost slide is the parallax of THIS page when something
      // is pushed on top of us. `textDirection` flips the offset for
      // RTL automatically — left becomes right.
      position: _secondaryPositionAnimation,
      textDirection: textDirection,
      transformHitTests: false,
      child: SlideTransition(
        // The inner slide is the page's own incoming/outgoing motion.
        position: _primaryPositionAnimation,
        textDirection: textDirection,
        child: widget.child,
      ),
    );
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
        ? padding.left + _kLiqBackGestureWidth
        : padding.right + _kLiqBackGestureWidth;
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
