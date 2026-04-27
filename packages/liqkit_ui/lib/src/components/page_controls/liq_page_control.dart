import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Surface brightness for [LiqPageControl].
enum LiqPageControlBrightness {
  /// Light surface — black dots.
  light,

  /// Dark surface — light dots.
  dark,
}

/// iOS 26 page control (paged-content dots indicator).
///
/// Sourced from `native/components/page-controls.css`:
///   - dot 8x8 default; sm 6x6; xs 4x4 (used to fade adjacent peripheral dots)
///   - light: dot #000 @ 0.3, active #000 @ 1.0
///   - dark : dot #F5F5F5 @ 0.35, active #FFFFFF @ 1.0
///   - gap 8pt
///
/// When [count] exceeds [maxVisible] the indicator centers around
/// [activeIndex] and fades the outermost dots to the smaller size.
final class LiqPageControl extends StatelessWidget {
  /// Creates a page-control indicator.
  const LiqPageControl({
    required this.count,
    required this.activeIndex,
    this.brightness = LiqPageControlBrightness.light,
    this.maxVisible = 7,
    super.key,
  }) : assert(count >= 0, 'count must be non-negative'),
       assert(maxVisible >= 3, 'maxVisible must be at least 3');

  /// Total number of pages.
  final int count;

  /// Active page index (0..count-1).
  final int activeIndex;

  /// Surface brightness.
  final LiqPageControlBrightness brightness;

  /// Maximum number of dots rendered before peripheral fading kicks in.
  final int maxVisible;

  static const double _gap = 8;
  static const double _dotLarge = 8;
  static const double _dotMedium = 6;
  static const double _dotSmall = 4;
  static const Color _lightDot = Color(0x4D000000); // #000 @ 0.3
  static const Color _lightActive = Color(0xFF000000);
  static const Color _darkDot = Color(0x59F5F5F5); // #F5F5F5 @ 0.35
  static const Color _darkActive = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    final isDark = brightness == LiqPageControlBrightness.dark;
    final dotColor = isDark ? _darkDot : _lightDot;
    final activeColor = isDark ? _darkActive : _lightActive;

    // Determine the visible range of dots. When count <= maxVisible we
    // render every dot. Otherwise we slide a window of maxVisible dots
    // centered on activeIndex.
    int start;
    int end;
    if (count <= maxVisible) {
      start = 0;
      end = count;
    } else {
      final half = maxVisible ~/ 2;
      start = (activeIndex - half).clamp(0, count - maxVisible);
      end = start + maxVisible;
    }

    return Semantics(
      label: 'page control',
      value: '${activeIndex + 1} of $count',
      child: SizedBox(
        height: 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var i = start; i < end; i++) ...<Widget>[
              if (i > start) const SizedBox(width: _gap),
              _Dot(
                size: _sizeFor(
                  index: i,
                  start: start,
                  end: end,
                  windowed: count > maxVisible,
                ),
                color: i == activeIndex ? activeColor : dotColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static double _sizeFor({
    required int index,
    required int start,
    required int end,
    required bool windowed,
  }) {
    if (!windowed) return _dotLarge;
    final isOuter = index == start || index == end - 1;
    final isPenultimate = index == start + 1 || index == end - 2;
    if (isOuter) return _dotSmall;
    if (isPenultimate) return _dotMedium;
    return _dotLarge;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('count', count))
      ..add(IntProperty('activeIndex', activeIndex))
      ..add(EnumProperty<LiqPageControlBrightness>('brightness', brightness))
      ..add(IntProperty('maxVisible', maxVisible));
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: LiqPageControl._dotLarge,
      height: LiqPageControl._dotLarge,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
        ),
      ),
    );
  }
}
