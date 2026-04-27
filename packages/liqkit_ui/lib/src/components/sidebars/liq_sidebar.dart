import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// iOS 26 sidebar surface — translucent rounded panel, padded.
///
/// Sourced from `native/components/sidebars.css` (`.ios26-sidebar-panel`):
/// 320pt wide (configurable), 34pt corner radius, padding 11/16/10,
/// translucent `rgba(250,250,250,0.7)`, inner white rim, drop shadow.
final class LiqSidebar extends StatelessWidget {
  /// Creates a sidebar.
  const LiqSidebar({required this.children, this.width = 320, super.key});

  /// Children — typically [LiqSidebarSearch], [LiqSidebarSectionHeader], and
  /// [LiqSidebarRow]s.
  final List<Widget> children;

  /// Panel width.
  final double width;

  static const Color _bg = Color(0xB3FAFAFA);
  static const Color _rim = Color(0x80FFFFFF);
  static const Color _shadow = Color(0x2E000000);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(34)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.all(Radius.circular(34)),
            border: Border.fromBorderSide(BorderSide(color: _rim)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: _shadow, offset: Offset(0, 16), blurRadius: 48),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 11, 16, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
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
      ..add(DoubleProperty('width', width))
      ..add(IntProperty('childrenCount', children.length));
  }
}

/// Static (non-interactive) search field rendered at the top of a [LiqSidebar].
final class LiqSidebarSearch extends StatelessWidget {
  /// Creates a search bar.
  const LiqSidebarSearch({this.placeholder = 'Search', super.key});

  /// Placeholder text.
  final String placeholder;

  static const Color _bg = Color(0x29787880);
  static const Color _fg = Color(0xFF727272);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 18,
                height: 18,
                child: CustomPaint(painter: _SearchGlyphPainter()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  placeholder,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                    fontSize: 17,
                    height: 22 / 17,
                    letterSpacing: -0.08,
                    fontWeight: FontWeight.w400,
                    color: _fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF727272)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1.6;
    final cx = size.width * 0.42;
    final cy = size.height * 0.42;
    final r = size.width * 0.30;
    canvas
      ..drawCircle(Offset(cx, cy), r, paint)
      ..drawLine(
        Offset(cx + r * 0.7, cy + r * 0.7),
        Offset(size.width * 0.95, size.height * 0.95),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Single row inside a [LiqSidebar].
final class LiqSidebarRow extends StatelessWidget {
  /// Creates a row.
  const LiqSidebarRow({
    required this.title,
    this.icon,
    this.detail,
    this.selected = false,
    this.nested = false,
    this.onPressed,
    super.key,
  });

  /// Row title.
  final String title;

  /// Optional leading 20×20 icon.
  final Widget? icon;

  /// Optional trailing detail text (e.g. unread count).
  final String? detail;

  /// When true, the row is highlighted with the selected background.
  final bool selected;

  /// When true, indents the row to indicate a nested folder.
  final bool nested;

  /// Tap callback.
  final VoidCallback? onPressed;

  static const Color _selectedBg = Color(0xFFEDEDED);
  static const Color _titleColor = Color(0xFF000000);
  static const Color _detailColor = Color(0xFF727272);
  static const Color _iconColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onPressed != null,
      label: title,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: EdgeInsets.fromLTRB(nested ? 30 : 10, 0, 8, 0),
          decoration: BoxDecoration(
            color: selected ? _selectedBg : null,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 34,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: IconTheme(
                    data: const IconThemeData(color: _iconColor),
                    child: icon ?? const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                    fontSize: 17,
                    height: 22 / 17,
                    letterSpacing: -0.43,
                    fontWeight: FontWeight.w400,
                    color: _titleColor,
                  ),
                ),
              ),
              if (detail != null)
                Text(
                  detail!,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 17,
                    height: 22 / 17,
                    letterSpacing: -0.43,
                    fontWeight: FontWeight.w400,
                    color: _detailColor,
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
      ..add(StringProperty('title', title))
      ..add(StringProperty('detail', detail))
      ..add(FlagProperty('selected', value: selected, ifTrue: 'selected'))
      ..add(FlagProperty('nested', value: nested, ifTrue: 'nested'));
  }
}

/// Section header rendered above a group of [LiqSidebarRow]s.
final class LiqSidebarSectionHeader extends StatelessWidget {
  /// Creates a section header.
  const LiqSidebarSectionHeader({required this.title, this.detail, super.key});

  /// Title.
  final String title;

  /// Optional trailing detail.
  final String? detail;

  static const Color _fg = Color(0x993C3C43);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 17,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  fontWeight: FontWeight.w400,
                  color: _fg,
                ),
              ),
            ),
            if (detail != null)
              Text(
                detail!,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 17,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  fontWeight: FontWeight.w400,
                  color: _fg,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
