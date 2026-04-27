import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// macOS-style window card — 34pt rounded white surface with a soft
/// drop-shadow, an optional toolbar, and content rendered below.
///
/// Sourced from `native/components/windows.css`. Default proportions
/// (1018×620) are configurable via [size].
final class LiqWindow extends StatelessWidget {
  /// Creates a window.
  const LiqWindow({
    this.size = const Size(1018, 620),
    this.toolbar,
    this.child,
    super.key,
  });

  /// Outer dimensions.
  final Size size;

  /// Optional 64pt toolbar pinned to the top.
  final Widget? toolbar;

  /// Optional content rendered below the toolbar.
  final Widget? child;

  static const Color _shadow = Color(0x33000000);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(34)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: _shadow, offset: Offset(0, 20), blurRadius: 76),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(34)),
          child: Column(
            children: <Widget>[
              if (toolbar != null) SizedBox(height: 64, child: toolbar),
              if (child != null) Expanded(child: child!),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Size>('size', size));
  }
}

/// 64pt window toolbar with leading + center title + trailing slots.
final class LiqWindowToolbar extends StatelessWidget {
  /// Creates a window toolbar.
  const LiqWindowToolbar({
    this.leading = const <Widget>[],
    this.title,
    this.subtitle,
    this.trailing = const <Widget>[],
    super.key,
  });

  /// Leading-edge children rendered in a 12pt-spaced row.
  final List<Widget> leading;

  /// Centered title text rendered in SF Pro Text 590 15/18.
  final String? title;

  /// Centered subtitle below the title in 500 12/14 #727272.
  final String? subtitle;

  /// Trailing-edge children rendered in a 12pt-spaced row.
  final List<Widget> trailing;

  static const Color _titleColor = Color(0xFF1A1A1A);
  static const Color _subtitleColor = Color(0xFF727272);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          if (leading.isNotEmpty)
            _WindowToolbarGroup(children: leading),
          Expanded(
            child: Center(
              child: title == null
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title!,
                          style: const TextStyle(
                            color: _titleColor,
                            fontFamily: 'SF Pro Text',
                            fontSize: 15,
                            height: 18 / 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              color: _subtitleColor,
                              fontFamily: 'SF Pro Text',
                              fontSize: 12,
                              height: 14 / 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          if (trailing.isNotEmpty)
            _WindowToolbarGroup(children: trailing),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle))
      ..add(IntProperty('leading.length', leading.length))
      ..add(IntProperty('trailing.length', trailing.length));
  }
}

class _WindowToolbarGroup extends StatelessWidget {
  const _WindowToolbarGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 12),
          children[i],
        ],
      ],
    );
  }
}

/// 44pt high glass button — soft #F7F7F7 fill with white-rim inset.
final class LiqWindowGlassButton extends StatelessWidget {
  /// Creates a glass button.
  const LiqWindowGlassButton({
    required this.child,
    this.onPressed,
    this.minWidth = 44,
    super.key,
  });

  /// Button content.
  final Widget child;

  /// Pressed callback. When null the button still renders but does
  /// nothing.
  final VoidCallback? onPressed;

  /// Minimum width — defaults to 44pt for symbol buttons; pass a wider
  /// value for label buttons (e.g. 78 for a Back button).
  final double minWidth;

  static const Color _bg = Color(0xFFF7F7F7);
  static const Color _innerHighlight = Color(0xD9FFFFFF);
  static const Color _label = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth, minHeight: 44),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.all(Radius.circular(296)),
            border: Border.fromBorderSide(
              BorderSide(color: _innerHighlight),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: _label,
                fontFamily: 'SF Pro Text',
                fontSize: 17,
                height: 22 / 17,
                fontWeight: FontWeight.w500,
              ),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: child,
              ),
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
      ..add(DoubleProperty('minWidth', minWidth))
      ..add(FlagProperty('enabled',
          value: onPressed != null, ifFalse: 'disabled'));
  }
}

/// macOS traffic-light close/minimise/maximise dots.
final class LiqWindowControls extends StatelessWidget {
  /// Creates traffic-light controls.
  const LiqWindowControls({this.active = true, super.key});

  /// When false, dots are dimmed to 0.34 opacity.
  final bool active;

  static const Color _red = Color(0xFFFF605C);
  static const Color _yellow = Color(0xFFFFBD44);
  static const Color _green = Color(0xFF00CA4E);
  static const Color _innerStroke = Color(0x52000000);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: active ? 1 : 0.34,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _Dot(color: _red),
          SizedBox(width: 6),
          _Dot(color: _yellow),
          SizedBox(width: 6),
          _Dot(color: _green),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('active', value: active, ifFalse: 'inactive'));
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: LiqWindowControls._innerStroke, width: 0.5),
      ),
    );
  }
}
