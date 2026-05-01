import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 themed-scrollbar scroll container.
///
/// `LiqScrollArea` wraps any vertically (or horizontally) overflowing
/// [child] inside a [SingleChildScrollView] whose default platform
/// scrollbar is replaced with the iOS 26 hairline pill — a 4pt-thick
/// thumb that appears while scrolling and fades after 600ms of inactivity.
/// shadcn ships an analogous primitive for desktop scroll areas where the
/// default OS scrollbar is intrusive.
///
/// Pass [axis] to switch the scroll direction; defaults to
/// [Axis.vertical]. Provide a [controller] to drive scrolling externally —
/// when omitted an internal [ScrollController] is created and disposed
/// alongside the widget. [padding] is applied inside the viewport so the
/// scrollbar paints over the gutter and the [child] sits inset.
final class LiqScrollArea extends StatefulWidget {
  /// Creates a themed scroll area.
  const LiqScrollArea({
    required this.child,
    this.axis = Axis.vertical,
    this.controller,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  /// Content to render inside the scroll viewport.
  final Widget child;

  /// Scroll direction. Defaults to [Axis.vertical].
  final Axis axis;

  /// Optional consumer-owned [ScrollController]. When `null` an internal
  /// controller is created and disposed with the widget.
  final ScrollController? controller;

  /// Padding applied inside the viewport, around [child].
  final EdgeInsets padding;

  /// Idle thumb color — 40% black hairline.
  static const Color thumbColor = Color(0x66000000);

  /// Hover/drag thumb color — 80% black.
  static const Color thumbHoverColor = Color(0xCC000000);

  /// Thumb thickness in logical pixels.
  static const double thumbThickness = 4;

  /// Minimum thumb length in logical pixels.
  static const double thumbMinLength = 32;

  /// Thumb corner radius — full pill given a 4pt thumb.
  static const Radius thumbRadius = Radius.circular(2);

  /// Opacity-fade duration when the scrollbar appears or disappears.
  static const Duration fadeDuration = Duration(milliseconds: 200);

  /// Idle delay before the thumb begins fading after scrolling stops.
  static const Duration timeToFade = Duration(milliseconds: 600);

  @override
  State<LiqScrollArea> createState() => _LiqScrollAreaState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<Axis>('axis', axis))
      ..add(
        FlagProperty(
          'hasController',
          value: controller != null,
          ifTrue: 'externalController',
          ifFalse: 'internalController',
        ),
      )
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }
}

class _LiqScrollAreaState extends State<LiqScrollArea> {
  ScrollController? _internalController;

  ScrollController get _effectiveController =>
      widget.controller ?? (_internalController ??= ScrollController());

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _effectiveController;

    return RawScrollbar(
      controller: controller,
      thumbColor: LiqScrollArea.thumbColor,
      thickness: LiqScrollArea.thumbThickness,
      minThumbLength: LiqScrollArea.thumbMinLength,
      radius: LiqScrollArea.thumbRadius,
      fadeDuration: LiqScrollArea.fadeDuration,
      // 600ms matches RawScrollbar's default; passed explicitly so the
      // iOS 26 spec value remains discoverable at the call site.
      // ignore: avoid_redundant_argument_values
      timeToFade: LiqScrollArea.timeToFade,
      child: SingleChildScrollView(
        scrollDirection: widget.axis,
        controller: controller,
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
