import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/components/page_controls/liq_page_control.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';

/// iOS 26 horizontal carousel.
///
/// Renders a paged, snap-to-page horizontal slider for browsing cards,
/// photos, or arbitrary widgets, with an optional [LiqPageControl] page
/// indicator beneath. Supports optional auto-advance every
/// [autoplayInterval]; auto-advance pauses while the user is dragging
/// and resumes after the drag ends.
final class LiqCarousel extends StatefulWidget {
  /// Creates a carousel.
  const LiqCarousel({
    required this.items,
    this.controller,
    this.height = 200,
    this.itemSpacing = 12,
    this.viewportFraction = 0.92,
    this.autoplay = false,
    this.autoplayInterval = const Duration(seconds: 4),
    this.showIndicator = true,
    super.key,
  }) : assert(items.length > 0, 'carousel needs at least 1 item'),
       assert(
         viewportFraction > 0 && viewportFraction <= 1,
         'viewportFraction must be in (0, 1]',
       );

  /// Items to display, in order.
  final List<Widget> items;

  /// Optional external [PageController]. When `null` an internal
  /// controller is created and disposed by the carousel.
  final PageController? controller;

  /// Carousel viewport height. Items are forced to this height.
  final double height;

  /// Horizontal gap between adjacent items.
  final double itemSpacing;

  /// Visible width of one item as a fraction of the viewport. Defaults
  /// to `0.92` so the next/prev edges peek in.
  final double viewportFraction;

  /// Whether the carousel auto-advances to the next item every
  /// [autoplayInterval]. Auto-advance pauses while the user drags.
  final bool autoplay;

  /// Duration between auto-advance ticks when [autoplay] is true.
  final Duration autoplayInterval;

  /// Whether to render a [LiqPageControl] page-dot indicator below the
  /// carousel.
  final bool showIndicator;

  /// Vertical gap between the carousel viewport and the page indicator.
  static const double indicatorGap = 12;

  /// Page-transition curve used by the auto-advance animator.
  static const Curve pageCurve = LiqMotion.standard;

  /// Page-transition duration used by the auto-advance animator.
  static const Duration pageDuration = LiqMotion.normal;

  /// Default per-item rounded-corner radius applied around the child.
  static const double itemBorderRadius = 14;

  @override
  State<LiqCarousel> createState() => _LiqCarouselState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('itemsCount', items.length))
      ..add(FlagProperty('autoplay', value: autoplay, ifTrue: 'autoplay'))
      ..add(DoubleProperty('viewportFraction', viewportFraction));
  }
}

class _LiqCarouselState extends State<LiqCarousel> {
  PageController? _internalController;
  Timer? _autoplayTimer;
  Timer? _resumeTimer;
  int _currentIndex = 0;
  bool _dragging = false;

  PageController get _controller =>
      widget.controller ?? (_internalController ??= _makeController());

  PageController _makeController() =>
      PageController(viewportFraction: widget.viewportFraction);

  @override
  void initState() {
    super.initState();
    if (widget.autoplay) {
      _startAutoplay();
    }
  }

  @override
  void didUpdateWidget(covariant LiqCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // External controller swapped in/out — drop the internal one if
      // we no longer need it.
      if (widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      }
    }
    if (oldWidget.autoplay && !widget.autoplay) {
      _stopAutoplay();
    } else if (!oldWidget.autoplay && widget.autoplay) {
      _startAutoplay();
    } else if (widget.autoplay &&
        oldWidget.autoplayInterval != widget.autoplayInterval) {
      _stopAutoplay();
      _startAutoplay();
    }
    if (oldWidget.items.length != widget.items.length) {
      if (_currentIndex >= widget.items.length) {
        _currentIndex = widget.items.length - 1;
      }
    }
  }

  @override
  void dispose() {
    _stopAutoplay();
    _internalController?.dispose();
    super.dispose();
  }

  void _startAutoplay() {
    _autoplayTimer?.cancel();
    _autoplayTimer = Timer.periodic(widget.autoplayInterval, (_) {
      if (!mounted || widget.items.length < 2) return;
      final next = (_currentIndex + 1) % widget.items.length;
      _controller.animateToPage(
        next,
        duration: LiqCarousel.pageDuration,
        curve: LiqCarousel.pageCurve,
      );
    });
  }

  void _stopAutoplay() {
    _autoplayTimer?.cancel();
    _autoplayTimer = null;
    _resumeTimer?.cancel();
    _resumeTimer = null;
  }

  void _pauseAutoplay() {
    if (!widget.autoplay) return;
    _autoplayTimer?.cancel();
    _autoplayTimer = null;
    _resumeTimer?.cancel();
    _resumeTimer = null;
  }

  void _scheduleResumeAutoplay() {
    if (!widget.autoplay) return;
    _resumeTimer?.cancel();
    _resumeTimer = Timer(widget.autoplayInterval, () {
      if (!mounted || !widget.autoplay) return;
      _startAutoplay();
    });
  }

  void _handlePageChanged(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  void _handlePointerDown(PointerDownEvent event) {
    _pauseAutoplay();
    if (_dragging) return;
    setState(() => _dragging = true);
  }

  void _handlePointerEnd(PointerEvent event) {
    _scheduleResumeAutoplay();
    if (!_dragging) return;
    setState(() => _dragging = false);
  }

  @override
  Widget build(BuildContext context) {
    final pageView = ScrollConfiguration(
      behavior: const _CarouselScrollBehavior(),
      child: LiqPointerCursor(
        cursor:
            _dragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.items.length,
          onPageChanged: _handlePageChanged,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.itemSpacing / 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  LiqCarousel.itemBorderRadius,
                ),
                child: SizedBox(
                  height: widget.height,
                  child: widget.items[index],
                ),
              ),
            );
          },
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: widget.height,
          child: Listener(
            onPointerDown: _handlePointerDown,
            onPointerUp: _handlePointerEnd,
            onPointerCancel: _handlePointerEnd,
            child: pageView,
          ),
        ),
        if (widget.showIndicator) ...<Widget>[
          const SizedBox(height: LiqCarousel.indicatorGap),
          LiqPageControl(
            count: widget.items.length,
            activeIndex: _currentIndex.clamp(0, widget.items.length - 1),
          ),
        ],
      ],
    );
  }
}

class _CarouselScrollBehavior extends ScrollBehavior {
  const _CarouselScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}
