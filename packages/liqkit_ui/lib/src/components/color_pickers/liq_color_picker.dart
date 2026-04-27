import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 color-picker button — conic-gradient ring with an inset swatch.
///
/// Sourced from `native/components/color-pickers.css`
/// (`.ios26-colorpickers-picker-button`). Renders a 36 or 28pt circle with
/// a hue conic gradient and the chosen [color] inset 5pt.
final class LiqColorPickerButton extends StatelessWidget {
  /// Creates a color-picker button.
  const LiqColorPickerButton({
    required this.color,
    this.onPressed,
    this.size = LiqColorPickerButtonSize.large,
    super.key,
  });

  /// Currently chosen color (rendered inset).
  final Color color;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Visual size.
  final LiqColorPickerButtonSize size;

  @override
  Widget build(BuildContext context) {
    final dim = size == LiqColorPickerButtonSize.large ? 36.0 : 28.0;
    final inner = size == LiqColorPickerButtonSize.large ? 26.0 : 18.0;
    return Semantics(
      button: true,
      label: 'Color',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(
          width: dim,
          height: dim,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: dim,
                height: dim,
                child: CustomPaint(painter: _ColorWheelPainter()),
              ),
              Container(
                width: inner,
                height: inner,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
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
      ..add(ColorProperty('color', color))
      ..add(EnumProperty<LiqColorPickerButtonSize>('size', size));
  }
}

/// Visual size for [LiqColorPickerButton].
enum LiqColorPickerButtonSize {
  /// 36pt outer / 26pt inset.
  large,

  /// 28pt outer / 18pt inset.
  small,
}

class _ColorWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const SweepGradient(
        startAngle: 1.5708,
        endAngle: 1.5708 + 6.2832,
        colors: <Color>[
          Color(0xFFE7E040),
          Color(0xFFEEAA3C),
          Color(0xFFE8403B),
          Color(0xFFB33ED5),
          Color(0xFF694AE8),
          Color(0xFF3CCAE7),
          Color(0xFF3CE885),
          Color(0xFF89E743),
          Color(0xFFE7E040),
        ],
      ).createShader(rect);
    canvas.drawCircle(
      rect.center,
      size.width / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 30pt circular color dot — used in palettes with an optional selection ring.
final class LiqColorDot extends StatelessWidget {
  /// Creates a color dot.
  const LiqColorDot({
    required this.color,
    this.selected = false,
    this.onPressed,
    super.key,
  });

  /// Fill color.
  final Color color;

  /// When true, draws a 2pt white selection ring inside the dot.
  final bool selected;

  /// Tap callback.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onPressed != null,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: selected
              ? Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFFFFFFF), width: 2),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(FlagProperty('selected', value: selected, ifTrue: 'selected'));
  }
}

/// 12-column grid of color swatches with selection highlight.
///
/// Sourced from `native/components/color-pickers.css`
/// (`.ios26-colorpickers-grid` + `.ios26-colorpickers-grid-swatch`).
final class LiqColorGrid extends StatelessWidget {
  /// Creates a swatch grid.
  const LiqColorGrid({
    required this.colors,
    this.selectedIndex,
    this.onSelected,
    this.columns = 12,
    this.swatchHeight = 30,
    super.key,
  });

  /// Colors flowing left-to-right, top-to-bottom.
  final List<Color> colors;

  /// Index in [colors] highlighted with the selection ring.
  final int? selectedIndex;

  /// Callback when a swatch is tapped.
  final ValueChanged<int>? onSelected;

  /// Number of columns. Defaults to 12.
  final int columns;

  /// Height of each swatch row.
  final double swatchHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth / columns;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var r = 0; r * columns < colors.length; r++)
                Row(
                  children: <Widget>[
                    for (var c = 0; c < columns; c++)
                      if (r * columns + c < colors.length)
                        SizedBox(
                          width: w,
                          height: swatchHeight,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: onSelected == null
                                ? null
                                : () => onSelected!(r * columns + c),
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: ColoredBox(
                                    color: colors[r * columns + c],
                                  ),
                                ),
                                if (selectedIndex == r * columns + c)
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFFFFFFF),
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      else
                        SizedBox(width: w, height: swatchHeight),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
