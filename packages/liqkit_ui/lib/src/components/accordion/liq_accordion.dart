import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Behavior of [LiqAccordion] when expanding multiple items.
enum LiqAccordionType {
  /// Only one item can be expanded at a time. Expanding a new item
  /// collapses the previously expanded one.
  single,

  /// Any number of items can be expanded simultaneously.
  multiple,
}

/// A single panel inside a [LiqAccordion].
final class LiqAccordionItem {
  /// Creates an accordion item.
  const LiqAccordionItem({
    required this.title,
    required this.child,
    this.subtitle,
  });

  /// Header title shown at all times.
  final String title;

  /// Optional smaller subtitle rendered beneath [title].
  final String? subtitle;

  /// Body revealed when the item is expanded.
  final Widget child;
}

/// iOS 26 vertical expandable-panel control in Liquid Glass styling.
///
/// Wraps a list of [LiqAccordionItem]s in a rounded surface with a hairline
/// border and 0.33pt dividers. Tapping a header toggles its expansion;
/// when [type] is [LiqAccordionType.single] (the default) opening a new
/// panel collapses the previously open one.
final class LiqAccordion extends StatefulWidget {
  /// Creates an accordion.
  const LiqAccordion({
    required this.items,
    this.type = LiqAccordionType.single,
    this.initialExpanded = const <int>{},
    super.key,
  });

  /// Items rendered top-to-bottom.
  final List<LiqAccordionItem> items;

  /// Single- vs multiple-expansion behavior.
  final LiqAccordionType type;

  /// Indices that should start expanded on first build.
  final Set<int> initialExpanded;

  static const double _radius = 16;
  static const Color _divider = Color(0x29000000);
  static const Color _dividerDark = Color(0x29FFFFFF);
  static const double _dividerThickness = 0.33;
  static const double _dividerInset = 16;
  static const double _headerMinHeight = 56;
  static const double _headerHPad = 16;
  static const double _bodyPad = 16;
  static const Color _chevronColor = Color(0xFF8E8E93);
  static const Color _chevronColorDark = Color(0xB2EBEBF5);
  static const double _chevronSize = 13;
  static const Duration _rotateDuration = LiqMotion.fast;
  static const Duration _expandDuration = LiqMotion.normal;
  static const Curve _curve = LiqMotion.standard;

  @override
  State<LiqAccordion> createState() => _LiqAccordionState();
}

class _LiqAccordionState extends State<LiqAccordion> {
  late Set<int> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = <int>{...widget.initialExpanded};
  }

  void _onHeaderTap(int index) {
    setState(() {
      final isOpen = _expanded.contains(index);
      if (isOpen) {
        _expanded.remove(index);
      } else {
        if (widget.type == LiqAccordionType.single) {
          _expanded
            ..clear()
            ..add(index);
        } else {
          _expanded.add(index);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = context.liqBrightness;
    final dividerColor =
        brightness == Brightness.dark
            ? LiqAccordion._dividerDark
            : LiqAccordion._divider;
    final children = <Widget>[];
    for (var i = 0; i < widget.items.length; i++) {
      if (i > 0) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(left: LiqAccordion._dividerInset),
            child: SizedBox(
              height: LiqAccordion._dividerThickness,
              child: DecoratedBox(
                decoration: BoxDecoration(color: dividerColor),
              ),
            ),
          ),
        );
      }
      children.add(_buildItem(i, widget.items[i]));
    }
    return LiqGlassSurface(
      tint:
          brightness == Brightness.dark
              ? LiqGlassTint.dark
              : LiqGlassTint.opaque,
      elevation: LiqGlassElevation.flat,
      borderRadius: const BorderRadius.all(
        Radius.circular(LiqAccordion._radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildItem(int index, LiqAccordionItem item) {
    final expanded = _expanded.contains(index);
    final brightness = context.liqBrightness;
    final titleColor = context.liqLabelColor;
    final subtitleColor = context.liqSecondaryLabelColor;
    final chevronColor =
        brightness == Brightness.dark
            ? LiqAccordion._chevronColorDark
            : LiqAccordion._chevronColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LiqPointerCursor(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _onHeaderTap(index),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: LiqAccordion._headerMinHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: LiqAccordion._headerHPad,
                  vertical: 8,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.title,
                            style: TextStyle(fontSize: 16, color: titleColor),
                          ),
                          if (item.subtitle != null) ...<Widget>[
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle!,
                              style: TextStyle(
                                fontSize: 13,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      duration: LiqAccordion._rotateDuration,
                      curve: LiqAccordion._curve,
                      turns: expanded ? 0.25 : 0,
                      child: SizedBox(
                        width: LiqAccordion._chevronSize,
                        height: LiqAccordion._chevronSize,
                        child: CustomPaint(
                          painter: _ChevronPainter(color: chevronColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: LiqAccordion._expandDuration,
          curve: LiqAccordion._curve,
          alignment: Alignment.topCenter,
          child:
              expanded
                  ? Padding(
                    padding: const EdgeInsets.all(LiqAccordion._bodyPad),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: titleColor),
                        child: item.child,
                      ),
                    ),
                  )
                  : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqAccordionType>('type', widget.type))
      ..add(IntProperty('expandedCount', _expanded.length));
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    final w = size.width;
    final h = size.height;
    // A right-pointing ">" glyph: two strokes meeting at the right-mid.
    final path =
        Path()
          ..moveTo(w * 0.30, h * 0.15)
          ..lineTo(w * 0.72, h * 0.50)
          ..lineTo(w * 0.30, h * 0.85);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ChevronPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
