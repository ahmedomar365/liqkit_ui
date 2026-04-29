import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A button shown in the action row of a [LiqDialog].
///
/// Set [destructive] to render the label in red. Set [isDefault] to
/// render the label in semibold weight (typically used for the primary
/// action).
final class LiqDialogAction {
  /// Creates a dialog action.
  const LiqDialogAction({
    required this.label,
    required this.onPressed,
    this.destructive = false,
    this.isDefault = false,
  });

  /// Action label.
  final String label;

  /// Tap callback.
  final VoidCallback onPressed;

  /// When `true`, the label is rendered in destructive red.
  final bool destructive;

  /// When `true`, the label is rendered in semibold weight to mark it as
  /// the primary/default action.
  final bool isDefault;
}

/// iOS 26 modal dialog box — a center-anchored glass card with an
/// optional title, message, and action row.
///
/// `LiqDialog` itself is a self-contained, statically rendered surface.
/// For programmatic dialogs with a dimmed scrim and scale+fade
/// animation, use [LiqDialogOverlay.show].
final class LiqDialog extends StatelessWidget {
  /// Creates a dialog surface.
  const LiqDialog({
    required this.title,
    this.message,
    this.actions = const <LiqDialogAction>[],
    this.maxWidth = 320,
    super.key,
  });

  /// Title shown at the top of the dialog.
  final String title;

  /// Optional message shown below the title.
  final String? message;

  /// Action buttons shown beneath the message. May be empty.
  final List<LiqDialogAction> actions;

  /// Maximum dialog width. Defaults to 320pt.
  final double maxWidth;

  /// Background fill color (light glass, ~95% opaque).
  static const Color backgroundColor = Color(0xF2FAFAFA);

  /// Hairline border color.
  static const Color borderColor = Color(0x14000000);

  /// Hairline border width.
  static const double borderWidth = 0.5;

  /// Outer corner radius.
  static const double radius = 14;

  /// Soft drop shadow.
  static const BoxShadow shadow = BoxShadow(
    color: Color(0x33000000),
    offset: Offset(0, 12),
    blurRadius: 32,
  );

  /// Padding inside the dialog around the title + message.
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(20, 20, 20, 16);

  /// Hairline color used between the message zone and the action row,
  /// and as the per-button vertical separators.
  static const Color separatorColor = Color(0x29000000);

  /// Hairline width for the action row separator.
  static const double separatorWidth = 0.33;

  /// Default tint used for non-destructive action labels.
  static const Color actionTintColor = Color(0xFF007AFF);

  /// Tint used for destructive action labels.
  static const Color destructiveActionColor = Color(0xFFFF3B30);

  /// Title text color.
  static const Color titleColor = Color(0xFF000000);

  /// Message text color.
  static const Color messageColor = Color(0xFF1C1C1E);

  /// Minimum action button height.
  static const double actionMinHeight = 44;

  /// Default maximum dialog width.
  static const double defaultMaxWidth = 320;

  static const TextStyle _titleStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: titleColor,
  );

  static const TextStyle _messageStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: messageColor,
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(radius)),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: const <BoxShadow>[shadow],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(radius)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: contentPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: _titleStyle,
                      textDirection: TextDirection.ltr,
                    ),
                    if (message != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        message!,
                        textAlign: TextAlign.center,
                        style: _messageStyle,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...<Widget>[
                const _LiqDialogSeparator(horizontal: true),
                _LiqDialogActions(actions: actions),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('titleLength', title.length))
      ..add(DiagnosticsProperty<bool>('hasMessage', message != null))
      ..add(IntProperty('actionCount', actions.length));
  }
}

class _LiqDialogSeparator extends StatelessWidget {
  const _LiqDialogSeparator({required this.horizontal});

  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: horizontal ? double.infinity : LiqDialog.separatorWidth,
      height: horizontal ? LiqDialog.separatorWidth : double.infinity,
      child: const ColoredBox(color: LiqDialog.separatorColor),
    );
  }
}

class _LiqDialogActions extends StatelessWidget {
  const _LiqDialogActions({required this.actions});

  final List<LiqDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (var i = 0; i < actions.length; i++) ...<Widget>[
            if (i > 0) const _LiqDialogSeparator(horizontal: false),
            Expanded(child: _LiqDialogActionButton(action: actions[i])),
          ],
        ],
      ),
    );
  }
}

class _LiqDialogActionButton extends StatelessWidget {
  const _LiqDialogActionButton({required this.action});

  final LiqDialogAction action;

  @override
  Widget build(BuildContext context) {
    final fg =
        action.destructive
            ? LiqDialog.destructiveActionColor
            : LiqDialog.actionTintColor;
    final weight = action.isDefault ? FontWeight.w600 : FontWeight.w400;
    return Semantics(
      button: true,
      enabled: true,
      label: action.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: action.onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: LiqDialog.actionMinHeight,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                action.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                  fontSize: 17,
                  fontWeight: weight,
                  color: fg,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Imperative helper for showing a [LiqDialog] over the nearest
/// [Overlay], with a scale+fade animation, dimmed scrim, and
/// dismiss-on-scrim-tap or Escape-key.
final class LiqDialogOverlay {
  LiqDialogOverlay._();

  /// Animation duration for both directions.
  static const Duration animationDuration = Duration(milliseconds: 200);

  /// Animation curve for both directions.
  static const Curve animationCurve = Curves.easeOutCubic;

  /// Default scrim color (~40% black).
  static const Color defaultScrimColor = Color(0x66000000);

  /// Shows a dialog over the nearest [Overlay], dims the background
  /// with [scrimColor], and dismisses on scrim tap (when
  /// [barrierDismissible] is `true`) or Escape key. Each action's
  /// `onPressed` is invoked first, then the dialog is dismissed.
  ///
  /// The returned [Future] completes once the dialog has finished its
  /// dismiss animation.
  static Future<void> show({
    required BuildContext context,
    required String title,
    String? message,
    List<LiqDialogAction> actions = const <LiqDialogAction>[],
    double maxWidth = LiqDialog.defaultMaxWidth,
    bool barrierDismissible = true,
    Color scrimColor = defaultScrimColor,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = _LiqDialogEntry(
      overlay: overlay,
      title: title,
      message: message,
      actions: actions,
      maxWidth: maxWidth,
      barrierDismissible: barrierDismissible,
      scrimColor: scrimColor,
    );
    return entry.run();
  }
}

class _LiqDialogEntry {
  _LiqDialogEntry({
    required this.overlay,
    required this.title,
    required this.message,
    required this.actions,
    required this.maxWidth,
    required this.barrierDismissible,
    required this.scrimColor,
  });

  final OverlayState overlay;
  final String title;
  final String? message;
  final List<LiqDialogAction> actions;
  final double maxWidth;
  final bool barrierDismissible;
  final Color scrimColor;

  OverlayEntry? _entry;
  _LiqDialogBodyState? _state;
  final Completer<void> _done = Completer<void>();
  bool _dismissed = false;

  Future<void> run() {
    final wrappedActions = <LiqDialogAction>[
      for (final action in actions)
        LiqDialogAction(
          label: action.label,
          destructive: action.destructive,
          isDefault: action.isDefault,
          onPressed: () {
            action.onPressed();
            unawaited(dismiss());
          },
        ),
    ];

    final entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return _LiqDialogBody(
          title: title,
          message: message,
          actions: wrappedActions,
          maxWidth: maxWidth,
          barrierDismissible: barrierDismissible,
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

class _LiqDialogBody extends StatefulWidget {
  const _LiqDialogBody({
    required this.title,
    required this.message,
    required this.actions,
    required this.maxWidth,
    required this.barrierDismissible,
    required this.scrimColor,
    required this.onAttach,
    required this.onScrimTap,
    required this.onDismissed,
  });

  final String title;
  final String? message;
  final List<LiqDialogAction> actions;
  final double maxWidth;
  final bool barrierDismissible;
  final Color scrimColor;
  final void Function(_LiqDialogBodyState state) onAttach;
  final VoidCallback onScrimTap;
  final VoidCallback onDismissed;

  @override
  State<_LiqDialogBody> createState() => _LiqDialogBodyState();
}

class _LiqDialogBodyState extends State<_LiqDialogBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final FocusNode _focusNode = FocusNode(debugLabel: 'LiqDialogOverlay');
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: LiqDialogOverlay.animationDuration,
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
      unawaited(dismiss());
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handleScrimTap() {
    if (!widget.barrierDismissible) return;
    widget.onScrimTap();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: LiqDialogOverlay.animationCurve,
      reverseCurve: LiqDialogOverlay.animationCurve,
    );
    final scale = Tween<double>(begin: 0.92, end: 1).animate(curved);

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: AnimatedBuilder(
        animation: curved,
        builder: (BuildContext context, Widget? _) {
          final t = curved.value.clamp(0.0, 1.0);
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleScrimTap,
                  child: ColoredBox(
                    color: widget.scrimColor.withValues(
                      alpha: widget.scrimColor.a * t,
                    ),
                  ),
                ),
              ),
              Center(
                child: Opacity(
                  opacity: t,
                  child: Transform.scale(
                    scale: scale.value,
                    child: LiqDialog(
                      title: widget.title,
                      message: widget.message,
                      actions: widget.actions,
                      maxWidth: widget.maxWidth,
                    ),
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
