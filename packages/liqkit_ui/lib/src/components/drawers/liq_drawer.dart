import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';

/// The screen edge a [LiqDrawer] is anchored to.
enum LiqDrawerSide {
  /// Anchored to the leading edge (left in LTR layouts).
  left,

  /// Anchored to the trailing edge (right in LTR layouts).
  right,
}

/// iOS 26 side drawer — a panel anchored to the leading or trailing
/// screen edge, used for navigation or secondary content.
///
/// `LiqDrawer` itself is a self-contained, statically rendered surface.
/// For programmatic drawers with a dimmed scrim and slide-in animation,
/// use [LiqDrawerOverlay.show].
final class LiqDrawer extends StatelessWidget {
  /// Creates a drawer surface anchored to [side].
  const LiqDrawer({
    required this.child,
    this.side = LiqDrawerSide.left,
    this.width = 320,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  /// Drawer body.
  final Widget child;

  /// Edge the drawer is anchored to.
  final LiqDrawerSide side;

  /// Drawer width. Clamps to `MediaQuery.size.width` when smaller.
  final double width;

  /// Internal padding around [child].
  final EdgeInsets padding;

  /// Surface background color (light glass).
  static const Color backgroundColor = Color(0xFFFAFAFA);

  /// Hairline border color along the inside edge (the edge facing the
  /// content area).
  static const Color hairlineColor = Color(0x29000000);

  /// Hairline border width on the inside edge.
  static const double hairlineWidth = 0.33;

  /// Soft drop shadow color.
  static const Color shadowColor = Color(0x33000000);

  /// Soft drop shadow blur radius.
  static const double shadowBlurRadius = 32;

  /// Horizontal offset magnitude used for the soft drop shadow. The
  /// shadow falls outward toward the content area, so the effective
  /// offset is negated for [LiqDrawerSide.right].
  static const double shadowOffsetMagnitude = 12;

  /// Default drawer width.
  static const double defaultWidth = 320;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    final screenWidth = media?.size.width ?? double.infinity;
    final clampedWidth =
        width.isFinite && screenWidth.isFinite
            ? (width > screenWidth ? screenWidth : width)
            : width;

    return SizedBox(
      width: clampedWidth,
      child: LiqGlassSurface(
        elevation: LiqGlassElevation.modal,
        borderRadius: BorderRadius.zero,
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqDrawerSide>('side', side))
      ..add(DoubleProperty('width', width));
  }
}

/// Imperative helper for showing a [LiqDrawer] over the nearest
/// [Overlay], with a slide-in animation, dimmed scrim, and dismiss-on
/// scrim-tap or Escape-key.
final class LiqDrawerOverlay {
  LiqDrawerOverlay._();

  /// Slide-in animation duration.
  static const Duration animationDuration = LiqMotion.normal;

  /// Animation curve for both directions.
  static const Curve animationCurve = LiqMotion.standard;

  /// Default scrim color (~40% black).
  static const Color defaultScrimColor = Color(0x66000000);

  /// Shows a drawer over the nearest [Overlay], dims the background with
  /// [scrimColor], and dismisses on scrim tap or Escape key. The
  /// returned [Future] completes once the drawer has finished its
  /// dismiss animation.
  static Future<void> show({
    required BuildContext context,
    required Widget child,
    LiqDrawerSide side = LiqDrawerSide.left,
    double width = LiqDrawer.defaultWidth,
    Color scrimColor = defaultScrimColor,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = _LiqDrawerEntry(
      overlay: overlay,
      child: child,
      side: side,
      width: width,
      scrimColor: scrimColor,
    );
    return entry.run();
  }
}

class _LiqDrawerEntry {
  _LiqDrawerEntry({
    required this.overlay,
    required this.child,
    required this.side,
    required this.width,
    required this.scrimColor,
  });

  final OverlayState overlay;
  final Widget child;
  final LiqDrawerSide side;
  final double width;
  final Color scrimColor;

  OverlayEntry? _entry;
  _LiqDrawerBodyState? _state;
  final Completer<void> _done = Completer<void>();
  bool _dismissed = false;

  Future<void> run() {
    final entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return _LiqDrawerBody(
          side: side,
          width: width,
          scrimColor: scrimColor,
          onAttach: (state) => _state = state,
          onScrimTap: dismiss,
          onDismissed: () {
            if (!_done.isCompleted) {
              _done.complete();
            }
            _entry?.remove();
            _entry = null;
          },
          child: child,
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

class _LiqDrawerBody extends StatefulWidget {
  const _LiqDrawerBody({
    required this.child,
    required this.side,
    required this.width,
    required this.scrimColor,
    required this.onAttach,
    required this.onScrimTap,
    required this.onDismissed,
  });

  final Widget child;
  final LiqDrawerSide side;
  final double width;
  final Color scrimColor;
  final void Function(_LiqDrawerBodyState state) onAttach;
  final VoidCallback onScrimTap;
  final VoidCallback onDismissed;

  @override
  State<_LiqDrawerBody> createState() => _LiqDrawerBodyState();
}

class _LiqDrawerBodyState extends State<_LiqDrawerBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final FocusNode _focusNode = FocusNode(debugLabel: 'LiqDrawerOverlay');
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LiqDrawerOverlay.animationDuration,
    );
    widget.onAttach(this);
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
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

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onScrimTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final isLeft = widget.side == LiqDrawerSide.left;
    final curved = CurvedAnimation(
      parent: _controller,
      curve: LiqDrawerOverlay.animationCurve,
      reverseCurve: LiqDrawerOverlay.animationCurve,
    );
    final slide = Tween<Offset>(
      begin: Offset(isLeft ? -1 : 1, 0),
      end: Offset.zero,
    ).animate(curved);

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: AnimatedBuilder(
        animation: curved,
        builder: (BuildContext context, Widget? _) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onScrimTap,
                  child: ColoredBox(
                    color: widget.scrimColor.withValues(
                      alpha:
                          (widget.scrimColor.a) * curved.value.clamp(0.0, 1.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: isLeft ? 0 : null,
                right: isLeft ? null : 0,
                child: FractionalTranslation(
                  translation: slide.value,
                  child: LiqDrawer(
                    side: widget.side,
                    width: widget.width,
                    child: widget.child,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
