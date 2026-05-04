import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// One option in a [LiqToggleGroup].
///
/// Each item carries an opaque [value] (used for selection state) and at
/// least one of [label] or [icon] for rendering. Passing both is allowed
/// — the icon is rendered to the leading edge of the label.
@immutable
final class LiqToggleGroupItem<T> {
  /// Creates a toggle group item. At least one of [label] or [icon] must
  /// be non-null.
  const LiqToggleGroupItem({required this.value, this.label, this.icon})
    : assert(label != null || icon != null, 'item needs a label or an icon');

  /// Opaque value associated with this item. Used as the [Set] member
  /// when this item is active.
  final T value;

  /// Optional label rendered inside the segment.
  final String? label;

  /// Optional leading icon rendered at 14×14, in the segment's
  /// foreground color.
  final IconData? icon;
}

/// iOS 26 multi-select segmented pill.
///
/// `LiqToggleGroup` renders a row of buttons where any subset can be
/// active simultaneously — for example, a text-style toolbar where Bold,
/// Italic, and Underline can each be on or off independently. This is
/// distinct from `LiqSegmentedControl`, which is mutually exclusive
/// (exactly one segment selected at a time).
///
/// Pass [selected] (a `Set<T>`) for the currently active values and
/// receive the new full set via [onChanged] whenever the user taps any
/// segment. The callback receives the entire new set rather than a
/// single delta so consumers can react idempotently. When [onChanged] is
/// `null` the entire control is dimmed and non-tappable.
final class LiqToggleGroup<T> extends StatelessWidget with Diagnosticable {
  /// Creates a toggle group.
  const LiqToggleGroup({
    required this.items,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// Ordered list of options. Must be non-empty.
  final List<LiqToggleGroupItem<T>> items;

  /// Currently active values. May be empty.
  final Set<T> selected;

  /// Called with the new full set whenever the user taps a segment.
  /// When `null` the control is rendered disabled (40% opacity, no
  /// gestures).
  final ValueChanged<Set<T>>? onChanged;

  /// Outer pill background color.
  static const Color trackColor = Color(0x14000000);

  /// Outer pill corner radius.
  static const double trackRadius = 12;

  /// Outer pill padding around the row of segments.
  static const double trackPadding = 4;

  /// Minimum height of each segment.
  static const double segmentMinHeight = 32;

  /// Vertical padding inside each segment.
  static const double segmentVerticalPadding = 6;

  /// Horizontal padding inside each segment.
  static const double segmentHorizontalPadding = 12;

  /// Inner-segment corner radius (computed so the pill nests inside
  /// the outer track padding without overlapping).
  static const double segmentRadius = trackRadius - trackPadding;

  /// Active segment background color.
  static const Color activeBackgroundColor = Color(0xFFFFFFFF);

  /// Active foreground color (label + icon).
  static const Color activeForegroundColor = Color(0xFF000000);

  /// Inactive foreground color (label + icon).
  static const Color inactiveForegroundColor = Color(0xFF8E8E93);

  /// Soft shadow rendered behind the active segment.
  static const BoxShadow activeShadow = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 2),
    blurRadius: 8,
  );

  /// Leading icon size.
  static const double iconSize = 14;

  /// Padding between leading icon and label when both are present.
  static const double iconLabelGap = 4;

  /// Color/shadow transition duration.
  static const Duration animationDuration = LiqMotion.fast;

  /// Color/shadow transition curve.
  static const Curve animationCurve = LiqMotion.snappy;

  /// Opacity used when the entire control is disabled.
  static const double disabledOpacity = 0.4;

  /// Segment text style (SF semibold 14pt).
  static const TextStyle textStyle = TextStyle(
    fontFamily: 'SF Pro Text',
    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    final palette = _ToggleGroupPalette.resolve(context);
    final disabled = onChanged == null;

    Widget control = Container(
      padding: const EdgeInsets.all(trackPadding),
      decoration: BoxDecoration(
        color: palette.track,
        borderRadius: const BorderRadius.all(Radius.circular(trackRadius)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final item in items)
            _Segment<T>(
              item: item,
              active: selected.contains(item.value),
              enabled: !disabled,
              palette: palette,
              onTap:
                  disabled
                      ? null
                      : () {
                        final next = Set<T>.of(selected);
                        if (next.contains(item.value)) {
                          next.remove(item.value);
                        } else {
                          next.add(item.value);
                        }
                        onChanged!(next);
                      },
            ),
        ],
      ),
    );

    if (disabled) {
      control = Opacity(opacity: disabledOpacity, child: control);
    }

    return control;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('count', items.length))
      ..add(IntProperty('selectedCount', selected.length))
      ..add(
        FlagProperty(
          'enabled',
          value: onChanged != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.item,
    required this.active,
    required this.enabled,
    required this.palette,
    required this.onTap,
  });

  final LiqToggleGroupItem<T> item;
  final bool active;
  final bool enabled;
  final _ToggleGroupPalette palette;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground =
        active ? palette.activeForeground : palette.inactiveForeground;

    final children = <Widget>[
      if (item.icon != null)
        Icon(
          item.icon,
          size: LiqToggleGroup.iconSize,
          color: foreground,
          textDirection: TextDirection.ltr,
        ),
      if (item.icon != null && item.label != null)
        const SizedBox(width: LiqToggleGroup.iconLabelGap),
      if (item.label != null)
        Text(
          item.label!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: LiqToggleGroup.textStyle.copyWith(color: foreground),
          textDirection: TextDirection.ltr,
        ),
    ];

    Widget segment = AnimatedContainer(
      duration: LiqToggleGroup.animationDuration,
      curve: LiqToggleGroup.animationCurve,
      constraints: const BoxConstraints(
        minHeight: LiqToggleGroup.segmentMinHeight,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: LiqToggleGroup.segmentVerticalPadding,
        horizontal: LiqToggleGroup.segmentHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: active ? palette.activeBackground : const Color(0x00000000),
        borderRadius: const BorderRadius.all(
          Radius.circular(LiqToggleGroup.segmentRadius),
        ),
        boxShadow:
            active ? const <BoxShadow>[LiqToggleGroup.activeShadow] : null,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );

    if (onTap != null) {
      segment = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: segment,
      );
    }

    return Semantics(
      button: true,
      selected: active,
      enabled: enabled,
      label: item.label ?? 'toggle',
      child: segment,
    );
  }
}

final class _ToggleGroupPalette {
  const _ToggleGroupPalette({
    required this.track,
    required this.activeBackground,
    required this.activeForeground,
    required this.inactiveForeground,
  });

  factory _ToggleGroupPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _ToggleGroupPalette(
        track: LiqToggleGroup.trackColor,
        activeBackground: LiqToggleGroup.activeBackgroundColor,
        activeForeground: LiqToggleGroup.activeForegroundColor,
        inactiveForeground: LiqToggleGroup.inactiveForegroundColor,
      );
    }

    final secondary = context.liqSecondaryLabelColor;
    return _ToggleGroupPalette(
      track: secondary.withValues(alpha: 0.16),
      activeBackground: const Color(0xFF1C1C1E),
      activeForeground: context.liqLabelColor,
      inactiveForeground: secondary,
    );
  }

  final Color track;
  final Color activeBackground;
  final Color activeForeground;
  final Color inactiveForeground;
}
