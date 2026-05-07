import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/components/shared/liq_scrubbable_index_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

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
  static const Color _darkTrackBg = Color(0x3D767680);
  static const Color _darkSelectedBg = Color(0xFF636366);
  static const Color _darkInactiveLabel = Color(0xB2EBEBF5);
  static const Color _darkSelectedLabel = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final palette = _SegmentedPalette.resolve(context);
    final disabled = onChanged == null;
    final selectedIndex = segments.indexWhere(
      (segment) => segment.value == value,
    );
    return Semantics(
      label: 'segmented control',
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width =
                constraints.hasBoundedWidth ? constraints.maxWidth : 320.0;
            final count = segments.length;
            final usableWidth =
                width - 2 * _padding - (count - 1).clamp(0, count) * _gap;
            final segmentWidth =
                count == 0
                    ? 0.0
                    : usableWidth.clamp(0.0, double.infinity) / count;
            final hasSelection = selectedIndex >= 0 && count > 0;

            return _SegmentedGestureSurface<T>(
              disabled: disabled,
              width: width,
              segments: segments,
              value: value,
              onChanged: onChanged,
              child: SizedBox(
                height: _height,
                child: LiqGlassSurface(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  padding: const EdgeInsets.all(_padding),
                  child: Stack(
                  children: <Widget>[
                    if (hasSelection)
                      AnimatedPositioned(
                        duration: context.liqMotionDuration(LiqMotion.normal),
                        curve: LiqMotion.snappy,
                        left: selectedIndex * (segmentWidth + _gap),
                        top: 0,
                        width: segmentWidth,
                        height: _segmentHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: palette.selected,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    Row(
                      children: <Widget>[
                        for (var i = 0; i < segments.length; i++) ...<Widget>[
                          if (i > 0) const SizedBox(width: _gap),
                          Expanded(
                            child: _Segment(
                              label: segments[i].label,
                              selected: segments[i].value == value,
                              palette: palette,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<String>('segments', segments.map((s) => s.label)))
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

class _SegmentedGestureSurface<T> extends StatefulWidget {
  const _SegmentedGestureSurface({
    required this.disabled,
    required this.width,
    required this.segments,
    required this.value,
    required this.onChanged,
    required this.child,
  });

  final bool disabled;
  final double width;
  final List<({T value, String label})> segments;
  final T value;
  final ValueChanged<T>? onChanged;
  final Widget child;

  @override
  State<_SegmentedGestureSurface<T>> createState() =>
      _SegmentedGestureSurfaceState<T>();
}

class _SegmentedGestureSurfaceState<T>
    extends State<_SegmentedGestureSurface<T>> {
  void _selectIndex(int index) {
    final next = widget.segments[index].value;
    if (next != widget.value) {
      widget.onChanged!(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LiqPointerCursor(
      enabled: !widget.disabled,
      child: LiqScrubbableIndexSurface(
        count: widget.segments.length,
        enabled: !widget.disabled,
        padding: const EdgeInsets.all(LiqSegmentedControl._padding),
        spacing: LiqSegmentedControl._gap,
        onPreview: _selectIndex,
        onCommit: _selectIndex,
        child: widget.child,
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.palette,
  });
  final String label;
  final bool selected;
  final _SegmentedPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: LiqSegmentedControl._segmentHeight,
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
          color: selected ? palette.selectedLabel : palette.inactiveLabel,
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

final class _SegmentedPalette {
  const _SegmentedPalette({
    required this.track,
    required this.selected,
    required this.selectedLabel,
    required this.inactiveLabel,
  });

  factory _SegmentedPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _SegmentedPalette(
        track: LiqSegmentedControl._trackBg,
        selected: LiqSegmentedControl._selectedBg,
        selectedLabel: LiqSegmentedControl._label,
        inactiveLabel: LiqSegmentedControl._label,
      );
    }

    return const _SegmentedPalette(
      track: LiqSegmentedControl._darkTrackBg,
      selected: LiqSegmentedControl._darkSelectedBg,
      selectedLabel: LiqSegmentedControl._darkSelectedLabel,
      inactiveLabel: LiqSegmentedControl._darkInactiveLabel,
    );
  }

  final Color track;
  final Color selected;
  final Color selectedLabel;
  final Color inactiveLabel;
}
