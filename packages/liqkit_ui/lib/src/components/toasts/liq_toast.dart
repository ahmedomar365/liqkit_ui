import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';

/// Visual variant of a [LiqToast].
enum LiqToastVariant {
  /// Green success toast.
  success,

  /// Red error toast.
  error,

  /// Dark glass info toast (default).
  info,
}

/// iOS 26 transient toast — pill-shaped notification typically shown
/// briefly at the bottom of the screen.
///
/// `LiqToast` itself is a self-contained, statically rendered pill. For
/// programmatic toasts that auto-dismiss after a short duration, use
/// [LiqToastOverlay.show].
final class LiqToast extends StatelessWidget {
  /// Creates a toast pill.
  const LiqToast({
    required this.message,
    this.variant = LiqToastVariant.info,
    this.icon,
    super.key,
  });

  /// Toast body text.
  final String message;

  /// Visual variant — controls background color and the default icon.
  final LiqToastVariant variant;

  /// Override the default per-variant icon.
  final IconData? icon;

  /// Pill background color for [LiqToastVariant.success].
  static const Color successBackgroundColor = Color(0xFF34C759);

  /// Pill background color for [LiqToastVariant.error].
  static const Color errorBackgroundColor = Color(0xFFFF3B30);

  /// Pill background color for [LiqToastVariant.info] — dark glass at
  /// 90% alpha, matching the tooltip palette.
  static const Color infoBackgroundColor = Color(0xE61C1C1E);

  /// Foreground (text + icon) color.
  static const Color foregroundColor = Color(0xFFFFFFFF);

  /// Default icon for [LiqToastVariant.success].
  static const IconData successIcon = Icons.check_circle_outline;

  /// Default icon for [LiqToastVariant.error].
  static const IconData errorIcon = Icons.error_outline;

  /// Default icon for [LiqToastVariant.info].
  static const IconData infoIcon = Icons.info_outline;

  /// Pill internal padding.
  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  /// Pill corner radius (full pill).
  static const double radius = 100;

  /// Maximum pill width before the message text wraps.
  static const double maxWidth = 480;

  /// Body text font size.
  static const double fontSize = 14;

  /// Default icon size matched to the text.
  static const double iconSize = 18;

  /// Pill drop shadow.
  static const BoxShadow shadow = BoxShadow(
    color: Color(0x33000000),
    offset: Offset(0, 8),
    blurRadius: 24,
  );

  /// Background color for [variant].
  static Color backgroundColorFor(LiqToastVariant variant) {
    switch (variant) {
      case LiqToastVariant.success:
        return successBackgroundColor;
      case LiqToastVariant.error:
        return errorBackgroundColor;
      case LiqToastVariant.info:
        return infoBackgroundColor;
    }
  }

  /// Default icon for [variant].
  static IconData defaultIconFor(LiqToastVariant variant) {
    switch (variant) {
      case LiqToastVariant.success:
        return successIcon;
      case LiqToastVariant.error:
        return errorIcon;
      case LiqToastVariant.info:
        return infoIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = icon ?? defaultIconFor(variant);
    final body = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(resolvedIcon, color: foregroundColor, size: iconSize),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
              height: 1.25,
            ),
          ),
        ),
      ],
    );

    if (variant == LiqToastVariant.info) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: LiqGlassSurface(
          tint: LiqGlassTint.dark,
          borderRadius: const BorderRadius.all(Radius.circular(radius)),
          padding: padding,
          child: body,
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColorFor(variant),
          borderRadius: const BorderRadius.all(Radius.circular(radius)),
          boxShadow: const <BoxShadow>[shadow],
        ),
        child: Padding(padding: padding, child: body),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqToastVariant>('variant', variant))
      ..add(
        FlagProperty(
          'hasCustomIcon',
          value: icon != null,
          ifTrue: 'custom icon',
        ),
      )
      ..add(IntProperty('messageLength', message.length));
  }
}

/// Imperative helper for showing a [LiqToast] over the nearest
/// [Overlay], with a slide-up + fade animation and auto-dismiss.
///
/// Calling [show] again while a previous toast is still visible
/// dismisses the previous one first — only one toast is on screen at
/// a time.
final class LiqToastOverlay {
  LiqToastOverlay._();

  /// Slide-up + fade animation duration.
  static const Duration animationDuration = Duration(milliseconds: 240);

  /// Animation curve for both directions.
  static const Curve animationCurve = LiqMotion.standard;

  /// Vertical offset applied to the toast at the start of the slide-up
  /// animation (and at the end of the dismiss animation).
  static const Offset hiddenOffset = Offset(0, 32);

  /// Bottom inset applied above the safe area when positioning the
  /// toast.
  static const double bottomInset = 24;

  static _LiqToastEntry? _current;

  /// Shows a toast over the nearest [Overlay] and dismisses it after
  /// [duration]. Returns when the toast has finished its dismiss
  /// animation. Calling again dismisses the previous toast first.
  static Future<void> show(
    BuildContext context,
    String message, {
    LiqToastVariant variant = LiqToastVariant.info,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) async {
    final overlay = Overlay.of(context, rootOverlay: true);

    // Dismiss any existing toast first so only one is visible at a time.
    await _current?.dismiss();

    final entry = _LiqToastEntry(
      overlay: overlay,
      message: message,
      variant: variant,
      icon: icon,
      duration: duration,
    );
    _current = entry;
    await entry.run();
    if (identical(_current, entry)) {
      _current = null;
    }
  }
}

class _LiqToastEntry {
  _LiqToastEntry({
    required this.overlay,
    required this.message,
    required this.variant,
    required this.icon,
    required this.duration,
  });

  final OverlayState overlay;
  final String message;
  final LiqToastVariant variant;
  final IconData? icon;
  final Duration duration;

  OverlayEntry? _entry;
  _LiqToastBodyState? _state;
  final Completer<void> _done = Completer<void>();
  bool _dismissed = false;

  Future<void> run() {
    final entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return _LiqToastBody(
          message: message,
          variant: variant,
          icon: icon,
          duration: duration,
          onAttach: (state) => _state = state,
          onDismissed: () {
            if (!_done.isCompleted) {
              _done.complete();
            }
            _entry?.remove();
            _entry = null;
          },
        );
      },
    );
    _entry = entry;
    overlay.insert(entry);
    return _done.future;
  }

  Future<void> dismiss() async {
    if (_dismissed) return _done.future;
    _dismissed = true;
    final state = _state;
    if (state == null) {
      // Not yet mounted — drop the entry directly.
      _entry?.remove();
      _entry = null;
      if (!_done.isCompleted) {
        _done.complete();
      }
      return;
    }
    await state.dismiss();
  }
}

class _LiqToastBody extends StatefulWidget {
  const _LiqToastBody({
    required this.message,
    required this.variant,
    required this.icon,
    required this.duration,
    required this.onAttach,
    required this.onDismissed,
  });

  final String message;
  final LiqToastVariant variant;
  final IconData? icon;
  final Duration duration;
  final void Function(_LiqToastBodyState state) onAttach;
  final VoidCallback onDismissed;

  @override
  State<_LiqToastBody> createState() => _LiqToastBodyState();
}

class _LiqToastBodyState extends State<_LiqToastBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _autoDismiss;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LiqToastOverlay.animationDuration,
    );
    widget.onAttach(this);
    _controller.forward();
    _autoDismiss = Timer(widget.duration, () {
      if (!mounted) return;
      dismiss();
    });
  }

  @override
  void dispose() {
    _autoDismiss?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
    _autoDismiss?.cancel();
    if (!mounted) {
      widget.onDismissed();
      return;
    }
    await _controller.reverse();
    if (!mounted) {
      widget.onDismissed();
      return;
    }
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context) ?? const MediaQueryData();
    final bottom = media.padding.bottom + LiqToastOverlay.bottomInset;

    final curved = CurvedAnimation(
      parent: _controller,
      curve: LiqToastOverlay.animationCurve,
      reverseCurve: LiqToastOverlay.animationCurve,
    );
    final slide = Tween<Offset>(
      begin: LiqToastOverlay.hiddenOffset,
      end: Offset.zero,
    ).animate(curved);

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottom,
      child: IgnorePointer(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedBuilder(
            animation: curved,
            builder: (BuildContext _, Widget? child) {
              return Opacity(
                opacity: curved.value.clamp(0.0, 1.0),
                child: Transform.translate(offset: slide.value, child: child),
              );
            },
            child: LiqToast(
              message: widget.message,
              variant: widget.variant,
              icon: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}
