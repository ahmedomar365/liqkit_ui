import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Tri-state value for [LiqCheckbox].
enum LiqCheckboxState {
  /// The checkbox is empty.
  unchecked,

  /// The checkbox is filled with a checkmark glyph.
  checked,

  /// The checkbox is filled with a horizontal bar glyph indicating a
  /// mixed/partial state (e.g. a "select all" affordance whose children
  /// are partially selected).
  indeterminate,
}

/// iOS 26 checkbox.
///
/// A 22x22 squircle that animates between unchecked / checked /
/// indeterminate states. Tap target is expanded to 44x44 for comfortable
/// hit testing while the visible box remains 22x22.
final class LiqCheckbox extends StatelessWidget {
  /// Creates a checkbox.
  const LiqCheckbox({required this.value, required this.onChanged, super.key});

  /// Current tri-state value.
  final LiqCheckboxState value;

  /// Tap callback. Receives the *next* value:
  ///
  /// * [LiqCheckboxState.unchecked]     -> [LiqCheckboxState.checked]
  /// * [LiqCheckboxState.checked]       -> [LiqCheckboxState.unchecked]
  /// * [LiqCheckboxState.indeterminate] -> [LiqCheckboxState.checked]
  ///
  /// When `null` the checkbox is non-interactive and dimmed to 40% opacity.
  final ValueChanged<LiqCheckboxState>? onChanged;

  /// Visible box width/height in logical pixels.
  static const double boxSize = 22;

  /// Tap target expansion size in logical pixels.
  static const double hitSize = 44;

  /// Visible box corner radius (squircle approximation).
  static const double cornerRadius = 6;

  /// Border thickness for the unchecked state.
  static const double borderWidth = 1.5;

  /// Filled background color for checked / indeterminate states.
  static const Color filledColor = Color(0xFF007AFF);

  /// Unchecked-state background color.
  static const Color uncheckedBackground = Color(0xFFFFFFFF);

  /// Unchecked-state border color.
  static const Color uncheckedBorder = Color(0xFFC7C7CC);

  /// Checkmark / bar glyph color.
  static const Color glyphColor = Color(0xFFFFFFFF);

  /// Animation duration for state changes.
  static const Duration animationDuration = Duration(milliseconds: 160);

  /// Animation curve for state changes.
  static const Curve animationCurve = Curves.easeOut;

  LiqCheckboxState get _next {
    switch (value) {
      case LiqCheckboxState.unchecked:
        return LiqCheckboxState.checked;
      case LiqCheckboxState.checked:
        return LiqCheckboxState.unchecked;
      case LiqCheckboxState.indeterminate:
        return LiqCheckboxState.checked;
    }
  }

  bool get _filled =>
      value == LiqCheckboxState.checked ||
      value == LiqCheckboxState.indeterminate;

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;

    final Widget glyph;
    switch (value) {
      case LiqCheckboxState.checked:
        glyph = const _CheckGlyph(
          key: ValueKey<LiqCheckboxState>(LiqCheckboxState.checked),
        );
      case LiqCheckboxState.indeterminate:
        glyph = const _IndeterminateGlyph(
          key: ValueKey<LiqCheckboxState>(LiqCheckboxState.indeterminate),
        );
      case LiqCheckboxState.unchecked:
        glyph = const SizedBox.shrink(
          key: ValueKey<LiqCheckboxState>(LiqCheckboxState.unchecked),
        );
    }

    final box = AnimatedContainer(
      duration: animationDuration,
      curve: animationCurve,
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: _filled ? filledColor : uncheckedBackground,
        borderRadius: const BorderRadius.all(Radius.circular(cornerRadius)),
        border:
            _filled
                ? null
                : Border.all(color: uncheckedBorder, width: borderWidth),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: animationDuration,
          switchInCurve: animationCurve,
          switchOutCurve: animationCurve,
          child: glyph,
        ),
      ),
    );

    return Semantics(
      checked: value == LiqCheckboxState.checked,
      mixed: value == LiqCheckboxState.indeterminate,
      enabled: !disabled,
      label: 'checkbox',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : () => onChanged!(_next),
        child: SizedBox(
          width: hitSize,
          height: hitSize,
          child: Center(
            child: Opacity(opacity: disabled ? 0.4 : 1, child: box),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqCheckboxState>('value', value))
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

class _CheckGlyph extends StatelessWidget {
  const _CheckGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: LiqCheckbox.boxSize,
      height: LiqCheckbox.boxSize,
      child: CustomPaint(painter: _CheckPainter()),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = LiqCheckbox.glyphColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // SF-symbol-style checkmark — two strokes forming a check.
    // Coordinates expressed as fractions of the 22x22 box and then scaled.
    final w = size.width;
    final h = size.height;

    final path =
        Path()
          ..moveTo(w * 0.24, h * 0.52)
          ..lineTo(w * 0.44, h * 0.70)
          ..lineTo(w * 0.76, h * 0.34);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => false;
}

class _IndeterminateGlyph extends StatelessWidget {
  const _IndeterminateGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 2,
      decoration: const BoxDecoration(
        color: LiqCheckbox.glyphColor,
        borderRadius: BorderRadius.all(Radius.circular(1)),
      ),
    );
  }
}
