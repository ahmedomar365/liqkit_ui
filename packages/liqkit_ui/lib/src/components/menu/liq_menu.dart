import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// iOS 26 menu surface — translucent rounded panel of quick actions and rows.
///
/// Sourced from the local iOS 26 Figma/native artifacts:
/// 238pt wide, 34pt corner radius, 10pt vertical padding, optional
/// three-column quick action strip, 16pt row-group padding, 52pt rows,
/// 21pt separators, and adaptive light/dark Liquid Glass tinting.
final class LiqMenu extends StatelessWidget {
  /// Creates a menu panel.
  const LiqMenu({
    required this.children,
    this.quickActions = const <LiqMenuQuickAction>[],
    this.width = 238,
    this.brightness,
    super.key,
  });

  /// Optional quick actions rendered above row items.
  final List<LiqMenuQuickAction> quickActions;

  /// Children — typically [LiqMenuItem], [LiqMenuSeparator], or
  /// [LiqMenuSectionTitle].
  final List<Widget> children;

  /// Panel width. Defaults to 238pt.
  final double width;

  /// Surface brightness. Defaults to the nearest liqkit theme brightness.
  final Brightness? brightness;

  static const Color _bgLight = Color(0xD6F5F5F5);
  static const Color _borderLight = Color(0xFFD8DCE3);
  static const Color _shadowLight = Color(0x33000000);
  static const Color _shadowDark = Color(0x6B000000);
  static const Color _rimDark = Color(0x70E4E9EF);

  @override
  Widget build(BuildContext context) {
    final resolvedBrightness = brightness ?? context.liqBrightness;
    final isDark = resolvedBrightness == Brightness.dark;
    final content = <Widget>[
      if (quickActions.isNotEmpty) ...<Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              for (var i = 0; i < quickActions.length; i++) ...<Widget>[
                Expanded(child: quickActions[i]),
                if (i != quickActions.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const LiqMenuSeparator(),
      ],
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ];

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(34)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: isDark ? _shadowDark : _shadowLight,
              offset: const Offset(0, 16),
              blurRadius: 40,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(34)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xD91A1A1A) : _bgLight,
                borderRadius: const BorderRadius.all(Radius.circular(34)),
                border: Border.fromBorderSide(
                  BorderSide(color: isDark ? _rimDark : _borderLight),
                ),
                gradient:
                    isDark
                        ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color(0x8FA5A5A5),
                            Color(0xC7898989),
                          ],
                        )
                        : null,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(34)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      if (isDark)
                        const Color(0x52FFFFFF)
                      else
                        const Color(0x99FFFFFF),
                      const Color(0x00FFFFFF),
                    ],
                    stops: const <double>[0, 0.28],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: content,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('quickActionsCount', quickActions.length))
      ..add(IntProperty('childrenCount', children.length))
      ..add(EnumProperty<Brightness?>('brightness', brightness))
      ..add(DoubleProperty('width', width));
  }
}

/// Compact icon+label action rendered in the top strip of [LiqMenu].
final class LiqMenuQuickAction extends StatefulWidget with Diagnosticable {
  /// Creates a quick action.
  const LiqMenuQuickAction({
    required this.label,
    required this.icon,
    this.onPressed,
    this.destructive = false,
    this.selected = false,
    this.brightness,
    super.key,
  });

  /// Action label.
  final String label;

  /// Icon rendered above [label].
  final Widget icon;

  /// Tap callback. Null renders a disabled/empty quick action.
  final VoidCallback? onPressed;

  /// Whether the action uses the destructive red accent.
  final bool destructive;

  /// Whether the action uses the selected quick-action fill.
  final bool selected;

  /// Surface brightness. Defaults to the nearest liqkit theme brightness.
  final Brightness? brightness;

  @override
  State<LiqMenuQuickAction> createState() => _LiqMenuQuickActionState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(FlagProperty('destructive', value: destructive, ifTrue: 'red'))
      ..add(FlagProperty('selected', value: selected, ifTrue: 'selected'))
      ..add(EnumProperty<Brightness?>('brightness', brightness));
  }
}

class _LiqMenuQuickActionState extends State<LiqMenuQuickAction> {
  var _pressed = false;

  static const Color _labelLight = Color(0xFF1A1A1A);
  static const Color _labelDark = Color(0xFFF5F5F5);
  static const Color _quickLight = Color(0xFFEDEDED);
  static const Color _quickLightActive = Color(0xFFDBDBDB);
  static const Color _quickDark = Color(0x1FFFFFFF);
  static const Color _quickDarkActive = Color(0x33FFFFFF);
  static const Color _destructiveLight = Color(0xFFFF383C);
  static const Color _destructiveDark = Color(0xFFFF4245);

  @override
  Widget build(BuildContext context) {
    final isDark =
        (widget.brightness ?? context.liqBrightness) == Brightness.dark;
    final enabled = widget.onPressed != null;
    final active = widget.selected || _pressed;
    final color =
        widget.destructive
            ? (isDark ? _destructiveDark : _destructiveLight)
            : (isDark ? _labelDark : _labelLight);
    final background =
        active
            ? (isDark ? _quickDarkActive : _quickLightActive)
            : (isDark ? _quickDark : _quickLight);

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: LiqPointerCursor(
        enabled: enabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
          child: AnimatedContainer(
            duration: LiqMotion.fast,
            curve: LiqMotion.snappy,
            constraints: const BoxConstraints(minHeight: 57),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: enabled ? background : const Color(0x00FFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DefaultTextStyle.merge(
                  style: TextStyle(color: color),
                  child: SizedBox(
                    width: 18,
                    height: 22,
                    child: Center(child: widget.icon),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                    fontSize: 12,
                    height: 18 / 12,
                    fontWeight: FontWeight.w500,
                    color: color.withValues(alpha: enabled ? 1 : 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Style for a single [LiqMenuItem].
enum LiqMenuItemStyle {
  /// Default action: dark label.
  regular,

  /// Destructive action: red label and trailing color.
  destructive,
}

/// Single row inside a [LiqMenu].
final class LiqMenuItem extends StatefulWidget with Diagnosticable {
  /// Creates a menu row.
  const LiqMenuItem({
    required this.label,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onPressed,
    this.style = LiqMenuItemStyle.regular,
    this.brightness,
    super.key,
  });

  /// Row label.
  final String label;

  /// Optional small subtitle rendered below [label].
  final String? subtitle;

  /// Optional leading 28×22 icon slot.
  final Widget? icon;

  /// Optional trailing widget (typically a shortcut or chevron).
  final Widget? trailing;

  /// Tap callback. When null the row is rendered disabled.
  final VoidCallback? onPressed;

  /// Visual style.
  final LiqMenuItemStyle style;

  /// Surface brightness (controls disabled / regular tints). Defaults to the
  /// nearest liqkit theme brightness.
  final Brightness? brightness;

  @override
  State<LiqMenuItem> createState() => _LiqMenuItemState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(EnumProperty<LiqMenuItemStyle>('style', style))
      ..add(EnumProperty<Brightness?>('brightness', brightness))
      ..add(
        FlagProperty(
          'enabled',
          value: onPressed != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}

class _LiqMenuItemState extends State<LiqMenuItem> {
  var _pressed = false;

  static const Color _labelLight = Color(0xFF1A1A1A);
  static const Color _labelDark = Color(0xFFF5F5F5);
  static const Color _disabledLight = Color(0xFFBFBFBF);
  static const Color _disabledDark = Color(0xFF404040);
  static const Color _destructiveLight = Color(0xFFFF383C);
  static const Color _destructiveDark = Color(0xFFFF4245);
  static const Color _pressLight = Color(0x12000000);
  static const Color _pressDark = Color(0x24FFFFFF);

  @override
  Widget build(BuildContext context) {
    final resolvedBrightness = widget.brightness ?? context.liqBrightness;
    final isDark = resolvedBrightness == Brightness.dark;
    final disabled = widget.onPressed == null;
    final labelColor = _resolveLabelColor(isDark, disabled);

    return Semantics(
      button: true,
      enabled: !disabled,
      label: widget.label,
      child: LiqPointerCursor(
        enabled: !disabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          onTapDown: !disabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: !disabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel:
              !disabled ? () => setState(() => _pressed = false) : null,
          child: AnimatedContainer(
            duration: LiqMotion.fast,
            curve: LiqMotion.snappy,
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.fromLTRB(6, 0, 8, 0),
            decoration: BoxDecoration(
              color:
                  _pressed
                      ? (isDark ? _pressDark : _pressLight)
                      : const Color(0x00FFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: <Widget>[
                if (widget.icon != null) ...<Widget>[
                  SizedBox(
                    width: 28,
                    height: 22,
                    child: Center(child: widget.icon),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontFamilyFallback: const <String>[
                            'SF Pro',
                            'sans-serif',
                          ],
                          fontSize: 17,
                          height: 20 / 17,
                          letterSpacing: -0.43,
                          fontWeight: FontWeight.w400,
                          color: labelColor,
                        ),
                      ),
                      if (widget.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 11,
                              height: 13 / 11,
                              letterSpacing: -0.08,
                              fontWeight: FontWeight.w400,
                              color:
                                  isDark
                                      ? const Color(0xFF8A8A8A)
                                      : const Color(0xFF727272),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.trailing != null) ...<Widget>[
                  const SizedBox(width: 8),
                  DefaultTextStyle.merge(
                    style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 15,
                      height: 20 / 15,
                      fontWeight: FontWeight.w500,
                      color:
                          disabled
                              ? (isDark
                                  ? const Color(0xFF909090)
                                  : const Color(0xFFD9D9D9))
                              : (isDark
                                  ? const Color(0xFF8A8A8A)
                                  : const Color(0xFF727272)),
                    ),
                    child: widget.trailing!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveLabelColor(bool isDark, bool disabled) {
    if (widget.style == LiqMenuItemStyle.destructive) {
      return isDark ? _destructiveDark : _destructiveLight;
    }
    if (disabled) return isDark ? _disabledDark : _disabledLight;
    return isDark ? _labelDark : _labelLight;
  }
}

/// 21pt horizontal divider between [LiqMenuItem]s.
final class LiqMenuSeparator extends StatelessWidget {
  /// Creates a separator.
  const LiqMenuSeparator({this.brightness, super.key});

  /// Surface brightness. Defaults to the nearest liqkit theme brightness.
  final Brightness? brightness;

  static const Color _light = Color(0xFFE6E6E6);
  static const Color _dark = Color(0xD1F5F5F5);

  @override
  Widget build(BuildContext context) {
    final resolvedBrightness = brightness ?? context.liqBrightness;
    final isDark = resolvedBrightness == Brightness.dark;
    return SizedBox(
      height: 21,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ColoredBox(
            color: isDark ? _dark : _light,
            child: const SizedBox(height: 1, width: double.infinity),
          ),
        ),
      ),
    );
  }
}

/// Small section title rendered above a group of menu items.
final class LiqMenuSectionTitle extends StatelessWidget {
  /// Creates a section title.
  const LiqMenuSectionTitle({required this.title, this.brightness, super.key});

  /// Title text.
  final String title;

  /// Surface brightness. Defaults to the nearest liqkit theme brightness.
  final Brightness? brightness;

  static const Color _fgLight = Color(0xFFBFBFBF);
  static const Color _fgDark = Color(0xDBF5F5F5);

  @override
  Widget build(BuildContext context) {
    final resolvedBrightness = brightness ?? context.liqBrightness;
    final isDark = resolvedBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'SF Pro Text',
          fontSize: 13,
          height: 15 / 13,
          letterSpacing: -0.08,
          fontWeight: FontWeight.w500,
          color: isDark ? _fgDark : _fgLight,
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(EnumProperty<Brightness?>('brightness', brightness));
  }
}
