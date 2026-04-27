import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// ignore: always_use_package_imports, conditional_uri_does_not_exist // relative URIs are required for conditional dart.library imports
import 'height_post_io.dart'
    if (dart.library.js_interop) 'height_post_web.dart' as platform;

/// Wraps [child] and forwards the laid-out height (rounded to int pixels)
/// to [publish] after each layout pass.
///
/// On web, the default publisher posts a {type: 'liq.height', px: N}
/// message to window.parent. On other targets, the default publisher
/// is a no-op.
class LiqHeightReporter extends StatelessWidget {
  /// Creates a [LiqHeightReporter].
  const LiqHeightReporter({
    required this.child,
    this.publish,
    super.key,
  });

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
      child: child,
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
  Size? _last;

  @override
  void performLayout() {
    // Give the child loose constraints so it can report its natural height.
    final looseConstraints = constraints.loosen();
    if (child != null) {
      child!.layout(looseConstraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.constrain(Size.zero);
    }
    // Report the child's natural height, not the parent-clamped size.
    final natural = child != null ? child!.size : Size.zero;
    if (natural != _last) {
      _last = natural;
      // Defer to post-frame so consumers don't mutate during layout.
      WidgetsBinding.instance.addPostFrameCallback((_) => onLayout(natural));
    }
  }
}
