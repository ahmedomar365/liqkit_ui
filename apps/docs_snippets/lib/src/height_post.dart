import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// ignore: always_use_package_imports, conditional_uri_does_not_exist // relative URIs are required for conditional dart.library imports
import 'height_post_io.dart'
    if (dart.library.js_interop) 'height_post_web.dart'
    as platform;

/// Wraps [child] and forwards its laid-out height (rounded to int
/// pixels) to [publish] after layout settles.
///
/// On web, the default publisher posts a {type: 'liq.height', px: N}
/// message to window.parent. On other targets, the default publisher
/// is a no-op.
///
/// Snippet roots use `Align(heightFactor: 1.0, …)` so the snippet's
/// height matches its content (not the iframe's window height). We
/// add a small vertical [Padding] for breathing room and report the
/// resulting size to the parent frame.
///
/// To avoid the slow-shrink artefact where Flutter's window resizes
/// in response to the iframe shrinking — which then triggers another
/// layout, another report, and another shrink — we only re-emit a
/// height once it has been stable for two consecutive layout passes.
/// The very first report fires immediately so the iframe leaves its
/// React-side initial height as fast as possible.
class LiqHeightReporter extends StatelessWidget {
  /// Creates a [LiqHeightReporter].
  const LiqHeightReporter({required this.child, this.publish, super.key});

  /// The widget whose laid-out height is reported.
  final Widget child;

  /// Called with the rounded pixel height after each layout.
  ///
  /// Defaults to [platform.postHeightToParent] when null.
  final void Function(int px)? publish;

  @override
  Widget build(BuildContext context) {
    return _SizeReporter(
      onLayout: (size) {
        final px = size.height.round();
        (publish ?? platform.postHeightToParent).call(px);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: child,
      ),
    );
  }
}

class _SizeReporter extends SingleChildRenderObjectWidget {
  const _SizeReporter({required this.onLayout, required Widget child})
    : super(child: child);

  final void Function(Size) onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSizeReporter(onLayout);

  @override
  void updateRenderObject(BuildContext context, _RenderSizeReporter ro) {
    ro.onLayout = onLayout;
  }
}

class _RenderSizeReporter extends RenderProxyBox {
  _RenderSizeReporter(this.onLayout);

  void Function(Size) onLayout;
  Size? _lastEmitted;
  Size? _pending;
  int _stableFrames = 0;
  bool _scheduled = false;

  void _scheduleEmit(Size size) {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      onLayout(size);
    });
  }

  @override
  void performLayout() {
    if (child == null) {
      size = constraints.constrain(Size.zero);
      return;
    }
    // Layout child with UNBOUNDED vertical so the snippet reports its
    // natural intrinsic content height — independent of the iframe's
    // current height. Otherwise the iframe's size clamps the child,
    // which clamps the reported height, which keeps the iframe small
    // even when the content needs more room (sidebars, lists, etc).
    final childConstraints = BoxConstraints(maxWidth: constraints.maxWidth);
    child!.layout(childConstraints, parentUsesSize: true);
    size = Size(
      constraints.constrainWidth(child!.size.width),
      child!.size.height,
    );
    final next = child!.size;
    if (next == _pending) {
      _stableFrames++;
    } else {
      _pending = next;
      _stableFrames = 1;
    }
    final firstReport = _lastEmitted == null;
    final stable = _stableFrames >= 2;
    if ((firstReport || stable) && _lastEmitted != next) {
      _lastEmitted = next;
      _scheduleEmit(next);
    }
  }
}
