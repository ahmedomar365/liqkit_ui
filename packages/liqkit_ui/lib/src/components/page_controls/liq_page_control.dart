import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

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
    this.onPageChanged,
    this.brightness,
    this.maxVisible = 7,
    this.activeColor,
    this.inactiveColor,
    this.dotSize,
    this.spacing,
    this.hidesForSinglePage = false,
    super.key,
  }) : assert(count >= 0, 'count must be non-negative'),
       assert(maxVisible >= 3, 'maxVisible must be at least 3');

  /// Total number of pages.
  final int count;

  /// Active page index (0..count-1).
  final int activeIndex;

  /// Optional tap callback. When non-null, each dot becomes tappable
  /// and reports the tapped index.
  final ValueChanged<int>? onPageChanged;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final LiqPageControlBrightness? brightness;

  /// Maximum number of dots rendered before peripheral fading kicks in.
  final int maxVisible;

  /// Optional override for the active dot color.
  final Color? activeColor;

  /// Optional override for the inactive dot color.
  final Color? inactiveColor;

  /// Optional override for the base dot size (default 8pt).
  final double? dotSize;

  /// Optional override for the gap between dots (default 8pt).
  final double? spacing;

  /// When true, the indicator collapses to nothing when [count] <= 1.
  final bool hidesForSinglePage;

  static const double _gap = 8;
  static const double _dotLarge = 8;
  static const double _dotMedium = 6;
  static const double _dotSmall = 4;
  static const double _tapTarget = 28;
  static const Color _lightDot = Color(0x4D000000); // #000 @ 0.3
  static const Color _lightActive = Color(0xFF000000);
  static const Color _darkDot = Color(0x59F5F5F5); // #F5F5F5 @ 0.35
  static const Color _darkActive = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    if (hidesForSinglePage && count <= 1) return const SizedBox.shrink();

    final resolvedBrightness =
        brightness ??
        switch (context.liqBrightness) {
          Brightness.dark => LiqPageControlBrightness.dark,
          Brightness.light => LiqPageControlBrightness.light,
        };
    final isDark = resolvedBrightness == LiqPageControlBrightness.dark;
    final dotColor = inactiveColor ?? (isDark ? _darkDot : _lightDot);
    final activeDotColor = activeColor ?? (isDark ? _darkActive : _lightActive);
    final gap = spacing ?? _gap;

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
              if (i > start) SizedBox(width: gap),
              _Dot(
                size: _sizeFor(
                  index: i,
                  start: start,
                  end: end,
                  windowed: count > maxVisible,
                  override: dotSize,
                ),
                color: i == activeIndex ? activeDotColor : dotColor,
                index: i,
                onPressed: onPageChanged,
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
    double? override,
  }) {
    final base = override ?? _dotLarge;
    if (!windowed) return base;
    final isOuter = index == start || index == end - 1;
    final isPenultimate = index == start + 1 || index == end - 2;
    if (isOuter) return base * (_dotSmall / _dotLarge);
    if (isPenultimate) return base * (_dotMedium / _dotLarge);
    return base;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('count', count))
      ..add(IntProperty('activeIndex', activeIndex))
      ..add(EnumProperty<LiqPageControlBrightness?>('brightness', brightness))
      ..add(IntProperty('maxVisible', maxVisible));
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.size,
    required this.color,
    required this.index,
    this.onPressed,
  });

  final double size;
  final Color color;
  final int index;
  final ValueChanged<int>? onPressed;

  @override
  Widget build(BuildContext context) {
    final visualDot = SizedBox(
      width: LiqPageControl._dotLarge,
      height: LiqPageControl._dotLarge,
      child: Center(
        child: AnimatedContainer(
          duration: context.liqMotionDuration(LiqMotion.fast),
          curve: LiqMotion.snappy,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
        ),
      ),
    );
    final dot =
        onPressed == null
            ? visualDot
            : SizedOverflowBox(
              size: const Size.square(LiqPageControl._dotLarge),
              child: SizedBox.square(
                dimension: LiqPageControl._tapTarget,
                child: Center(child: visualDot),
              ),
            );
    if (onPressed == null) return dot;
    return Semantics(
      button: true,
      label: 'Go to page ${index + 1}',
      child: LiqPointerCursor(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onPressed!(index),
          child: dot,
        ),
      ),
    );
  }
}
