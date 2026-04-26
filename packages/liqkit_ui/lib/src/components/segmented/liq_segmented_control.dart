import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 segmented control.
///
/// Sourced from `native/components/segmented-controls.css`:
///   - container: 32pt tall, radius 100px, bg rgba(118,118,128,0.12) =
///     `#1F767680`, 2pt padding, 4pt gap between segments.
///   - segment: 28pt tall, radius 20px, font 500 13.333/18 SF Pro Text,
///     letter-spacing -0.08, color #000000. Selected: bg #FFFFFF + 600
///     weight.
final class LiqSegmentedControl<T> extends StatelessWidget {
  /// Creates a segmented control.
  const LiqSegmentedControl({
    required this.segments,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Ordered (value, label) pairs.
  final List<({T value, String label})> segments;

  /// Currently selected value.
  final T value;

  /// Selection callback. Null disables the control.
  final ValueChanged<T>? onChanged;

  static const double _height = 32;
  static const double _segmentHeight = 28;
  static const double _padding = 2;
  static const double _gap = 4;
  static const Color _trackBg = Color(0x1F767680);
  static const Color _selectedBg = Color(0xFFFFFFFF);
  static const Color _label = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    return Semantics(
      label: 'segmented control',
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Container(
          height: _height,
          padding: const EdgeInsets.all(_padding),
          decoration: const BoxDecoration(
            color: _trackBg,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Row(
            children: <Widget>[
              for (var i = 0; i < segments.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: _gap),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: disabled
                        ? null
                        : () {
                            if (segments[i].value != value) {
                              onChanged!(segments[i].value);
                            }
                          },
                    child: _Segment(
                      label: segments[i].label,
                      selected: segments[i].value == value,
                    ),
                  ),
                ),
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
      ..add(IterableProperty<String>(
        'segments',
        segments.map((s) => s.label),
      ))
      ..add(DiagnosticsProperty<T>('value', value))
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

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.selected});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: LiqSegmentedControl._segmentHeight,
      decoration: BoxDecoration(
        color: selected ? LiqSegmentedControl._selectedBg : null,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'SF Pro Text',
          fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
          fontSize: 13.333,
          height: 18 / 13.333,
          letterSpacing: -0.08,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: LiqSegmentedControl._label,
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
