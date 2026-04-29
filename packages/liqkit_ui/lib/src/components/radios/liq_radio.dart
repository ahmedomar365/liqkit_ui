import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 single-select radio circle.
///
/// A 22x22 ring that animates in a centered 12x12 dot when its [value]
/// matches the surrounding [groupValue]. Tap target is expanded to
/// 44x44 for comfortable hit testing while the visible ring remains
/// 22x22.
final class LiqRadio<T> extends StatelessWidget {
  /// Creates a radio.
  const LiqRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  /// The value this radio represents.
  final T value;

  /// The currently selected value in the group; this radio is selected
  /// iff `value == groupValue`.
  final T? groupValue;

  /// Called with [value] when this radio is tapped. When `null` the
  /// radio is non-interactive and dimmed to 40% opacity.
  final ValueChanged<T>? onChanged;

  /// Visible outer-ring width/height in logical pixels.
  static const double ringSize = 22;

  /// Inner filled-dot width/height in logical pixels.
  static const double dotSize = 12;

  /// Tap target expansion size in logical pixels.
  static const double hitSize = 44;

  /// Border thickness for the outer ring.
  static const double borderWidth = 1.5;

  /// Selected-state ring border + inner-dot color.
  static const Color selectedColor = Color(0xFF007AFF);

  /// Ring background color.
  static const Color ringBackground = Color(0xFFFFFFFF);

  /// Unselected-state ring border color.
  static const Color unselectedBorder = Color(0xFFC7C7CC);

  /// Animation duration for selection state changes.
  static const Duration animationDuration = Duration(milliseconds: 160);

  /// Animation curve for selection state changes.
  static const Curve animationCurve = Curves.easeOut;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    final selected = _selected;

    final ring = Container(
      width: ringSize,
      height: ringSize,
      decoration: BoxDecoration(
        color: ringBackground,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? selectedColor : unselectedBorder,
          width: borderWidth,
        ),
      ),
      child: Center(
        child: AnimatedOpacity(
          opacity: selected ? 1 : 0,
          duration: animationDuration,
          curve: animationCurve,
          child: AnimatedScale(
            scale: selected ? 1 : 0,
            duration: animationDuration,
            curve: animationCurve,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: selectedColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      enabled: !disabled,
      label: 'radio',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : () => onChanged!(value),
        child: SizedBox(
          width: hitSize,
          height: hitSize,
          child: Center(
            child: Opacity(opacity: disabled ? 0.4 : 1, child: ring),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<T>('value', value))
      ..add(DiagnosticsProperty<T?>('groupValue', groupValue))
      ..add(
        FlagProperty(
          'selected',
          value: _selected,
          ifTrue: 'selected',
          ifFalse: 'unselected',
        ),
      )
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

/// Convenience wrapper that lays out a vertical list of `(value, label)`
/// pairs as [LiqRadio]s, each tappable on its full row.
final class LiqRadioGroup<T> extends StatelessWidget {
  /// Creates a radio group.
  const LiqRadioGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    this.spacing = 12,
    super.key,
  });

  /// The list of `(value, label)` pairs rendered as rows.
  final List<({T value, String label})> options;

  /// The currently selected value, or `null` when none is selected.
  final T? value;

  /// Called with the row's value when the row is tapped. When `null`
  /// the entire group is non-interactive; each [LiqRadio] is dimmed.
  final ValueChanged<T>? onChanged;

  /// Vertical spacing in logical pixels between rows.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    final children = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      if (i > 0) {
        children.add(SizedBox(height: spacing));
      }
      final option = options[i];
      children.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: disabled ? null : () => onChanged!(option.value),
          child: Row(
            children: [
              LiqRadio<T>(
                value: option.value,
                groupValue: value,
                onChanged: disabled ? null : onChanged,
              ),
              const Padding(padding: EdgeInsets.only(left: 12)),
              Expanded(child: Text(option.label)),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('options', options.length))
      ..add(DiagnosticsProperty<T?>('value', value))
      ..add(DoubleProperty('spacing', spacing))
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
