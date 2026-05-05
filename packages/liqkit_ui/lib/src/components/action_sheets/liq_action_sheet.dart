import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/alerts/liq_alert.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 action sheet — bottom-anchored stack of full-width actions.
///
/// Sourced from `native/components/action-sheets.css` + `shared-surfaces.css`:
/// shares the translucent dialog surface with [LiqAlert], with a 14pt
/// padding, 10pt action gap, and a (typically) longer action list.
///
/// When [cancelAction] is provided, the cancel button is rendered separately
/// at the bottom with a small visual gap and bold weight, matching iOS'
/// native action sheet pattern.
final class LiqActionSheet extends StatelessWidget {
  /// Creates an action sheet.
  const LiqActionSheet({
    required this.actions,
    this.title,
    this.description,
    this.cancelAction,
    super.key,
  });

  /// Optional bold title.
  final String? title;

  /// Optional description below the title.
  final String? description;

  /// Primary action stack (≥1).
  final List<LiqAlertAction> actions;

  /// Optional separated cancel action shown at the bottom.
  final LiqAlertAction? cancelAction;

  static const Color _surfaceFill = Color(0x99F5F5F5);
  static const Color _surfaceFillDark = Color(0xCC1C1C1E);
  static const Color _innerScrim = Color(0x14000000);
  static const Color _innerScrimDark = Color(0x24FFFFFF);
  static const Color _cancelBg = Color(0xCCFFFFFF);
  static const Color _cancelBgDark = Color(0xE62C2C2E);
  static const Color _cancelFg = Color(0xFF0088FF);
  static const double _surfaceWidth = 300;
  static const double _surfaceRadius = 34;

  @override
  Widget build(BuildContext context) {
    assert(actions.isNotEmpty, 'LiqActionSheet requires at least one action.');
    final isDark = context.liqIsDark;
    final titleColor =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: _surfaceWidth,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(_surfaceRadius),
            ),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ColoredBox(
                    color: isDark ? _innerScrimDark : _innerScrim,
                  ),
                ),
                Positioned.fill(
                  child: ColoredBox(
                    color: isDark ? _surfaceFillDark : _surfaceFill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (title != null || description != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (title != null)
                                Text(
                                  title!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontFamilyFallback: const <String>[
                                      'SF Pro',
                                      'sans-serif',
                                    ],
                                    fontSize: 17,
                                    height: 22 / 17,
                                    letterSpacing: -0.43,
                                    fontWeight: FontWeight.w600,
                                    color: titleColor,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                              if (title != null && description != null)
                                const SizedBox(height: 10),
                              if (description != null)
                                Text(
                                  description!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontFamilyFallback: const <String>[
                                      'SF Pro',
                                      'sans-serif',
                                    ],
                                    fontSize: 17,
                                    height: 22 / 17,
                                    letterSpacing: -0.43,
                                    fontWeight: FontWeight.w400,
                                    color: titleColor,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                            ],
                          ),
                        ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (var i = 0; i < actions.length; i++) ...<Widget>[
                            if (i > 0) const SizedBox(height: 10),
                            _ActionButton(action: actions[i]),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (cancelAction != null) ...<Widget>[
          const SizedBox(height: 8),
          SizedBox(
            width: _surfaceWidth,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(_surfaceRadius),
              ),
              child: ColoredBox(
                color: isDark ? _cancelBgDark : _cancelBg,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: _ActionButton(
                    action: cancelAction!,
                    boldOverride: true,
                    fgOverride: _cancelFg,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('description', description))
      ..add(IntProperty('actionCount', actions.length))
      ..add(
        FlagProperty(
          'hasCancel',
          value: cancelAction != null,
          ifTrue: 'with cancel',
        ),
      );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.action,
    this.boldOverride = false,
    this.fgOverride,
  });

  final LiqAlertAction action;
  final bool boldOverride;
  final Color? fgOverride;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  static const Color _bg = Color(0x29787880);
  static const Color _bgDark = Color(0x33767680);
  static const Color _pressedBg = Color(0x33787880);
  static const Color _pressedBgDark = Color(0x47FFFFFF);
  static const Color _filledBg = Color(0xFF0088FF);
  static const Color _filledPressedBg = Color(0xFF0074D9);
  static const Color _filledFg = Color(0xFFFFFFFF);
  static const Color _destructiveFg = Color(0xFFFF383C);
  static const Color _regularFg = Color(0xFF000000);
  static const Color _regularFgDark = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.action.style == LiqAlertActionStyle.filled;
    final isDestructive =
        widget.action.style == LiqAlertActionStyle.destructive;
    final disabled = widget.action.onPressed == null;
    final isDark = context.liqIsDark;
    final fg =
        widget.fgOverride ??
        (isFilled
            ? _filledFg
            : (isDestructive
                ? _destructiveFg
                : (isDark ? _regularFgDark : _regularFg)));
    final bg =
        isFilled
            ? (_pressed ? _filledPressedBg : _filledBg)
            : (isDark
                ? (_pressed ? _pressedBgDark : _bgDark)
                : (_pressed ? _pressedBg : _bg));
    final motionDuration = context.liqMotionDuration(LiqMotion.fast);
    return Semantics(
      button: true,
      enabled: !disabled,
      label: widget.action.label,
      child: LiqPointerCursor(
        enabled: !disabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: disabled ? null : (_) => _setPressed(true),
          onTapCancel: disabled ? null : () => _setPressed(false),
          onTapUp: disabled ? null : (_) => _setPressed(false),
          onTap: widget.action.onPressed,
          child: AnimatedScale(
            scale: _pressed ? 0.985 : 1,
            duration: motionDuration,
            curve: LiqMotion.snappy,
            child: AnimatedOpacity(
              opacity: disabled ? 0.5 : 1,
              duration: motionDuration,
              curve: LiqMotion.standard,
              child: AnimatedContainer(
                duration: motionDuration,
                curve: LiqMotion.snappy,
                height: 48,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.action.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                    fontSize: 17,
                    height: 22 / 17,
                    letterSpacing: -0.43,
                    fontWeight:
                        widget.boldOverride ? FontWeight.w600 : FontWeight.w500,
                    color: fg,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
