import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Visual variant of a [LiqSheet].
///
/// Sourced from `native/components/sheets.css`:
///   - [fullScreen]   single sheet, white bg, drop shadow, 38pt top radius.
///   - [stacked]      sheet stacked over a dimmed "background page" preview
///                    (10pt inset; useful when an app presents a sheet on
///                    top of an already-modal screen).
///   - [inspector]    bottom inspector with translucent glass background,
///                    34pt corner radius, white inset rim.
enum LiqSheetVariant {
  /// Modal sheet on a white surface.
  fullScreen,

  /// Modal sheet stacked over a dimmed background page preview.
  stacked,

  /// Bottom inspector with translucent glass background.
  inspector,
}

/// iOS 26 modal sheet container.
///
/// Renders the sheet surface (grabber + controls row + body) for the
/// chosen [variant]. The host application is responsible for animating
/// presentation, dimming the parent scrim, and constraining the size.
final class LiqSheet extends StatelessWidget {
  /// Creates a sheet.
  const LiqSheet({
    required this.title,
    this.variant = LiqSheetVariant.fullScreen,
    this.leading,
    this.trailing,
    this.child,
    this.width = 402,
    this.height = 360,
    super.key,
  });

  /// Centered title rendered in the controls row.
  final String title;

  /// Visual variant.
  final LiqSheetVariant variant;

  /// Optional leading top button (defaults to a close glyph button).
  final Widget? leading;

  /// Optional trailing top button (defaults to a primary check glyph button).
  final Widget? trailing;

  /// Optional sheet body (rendered below the controls row).
  final Widget? child;

  /// Preferred sheet width. Defaults to the iOS modal width used by the
  /// design reference and shrinks when the parent provides narrower
  /// constraints.
  final double width;

  /// Total sheet height. Defaults to 360pt.
  final double height;

  static const double _sheetTopRadius = 38;
  static const double _inspectorRadius = 34;
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _shadow18 = Color(0x2E000000);
  static const Color _glass60 = Color(0x99F5F5F5);
  static const Color _rim35 = Color(0x59FFFFFF);
  static const Color _scrim10 = Color(0x1A000000);

  @override
  Widget build(BuildContext context) {
    final controls = _SheetTopBar(
      title: title,
      leading: leading ?? const _LiqSheetCloseButton(),
      trailing: trailing ?? const _LiqSheetConfirmButton(),
    );
    final isInspector = variant == LiqSheetVariant.inspector;
    final radius =
        isInspector
            ? const BorderRadius.all(Radius.circular(_inspectorRadius))
            : const BorderRadius.only(
              topLeft: Radius.circular(_sheetTopRadius),
              topRight: Radius.circular(_sheetTopRadius),
            );

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedWidth =
            constraints.maxWidth.isFinite && constraints.maxWidth < width
                ? constraints.maxWidth
                : width;

        return SizedBox(
          width: resolvedWidth,
          height: height,
          child:
              variant == LiqSheetVariant.stacked
                  ? Stack(
                    children: <Widget>[
                      const Positioned(
                        left: 16,
                        right: 16,
                        top: 0,
                        bottom: 0,
                        child: _BackgroundPage(),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 10,
                        bottom: 0,
                        child: _SheetSurface(
                          radius: radius,
                          background: _white,
                          rim: null,
                          body: child,
                          child: controls,
                        ),
                      ),
                    ],
                  )
                  : _SheetSurface(
                    radius: radius,
                    background: isInspector ? _glass60 : _white,
                    rim: isInspector ? _rim35 : null,
                    body: child,
                    child: controls,
                  ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(EnumProperty<LiqSheetVariant>('variant', variant))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height));
  }
}

class _SheetSurface extends StatelessWidget {
  const _SheetSurface({
    required this.radius,
    required this.background,
    required this.rim,
    required this.child,
    required this.body,
  });

  final BorderRadius radius;
  final Color background;
  final Color? rim;
  final Widget child;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        border:
            rim == null ? null : Border.fromBorderSide(BorderSide(color: rim!)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: LiqSheet._shadow18,
            offset: Offset(0, 15),
            blurRadius: 75,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[child, if (body != null) Expanded(child: body!)],
        ),
      ),
    );
  }
}

class _BackgroundPage extends StatelessWidget {
  const _BackgroundPage();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: LiqSheet._white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(LiqSheet._sheetTopRadius),
                topRight: Radius.circular(LiqSheet._sheetTopRadius),
              ),
            ),
          ),
        ),
        Positioned.fill(child: ColoredBox(color: LiqSheet._scrim10)),
      ],
    );
  }
}

class _SheetTopBar extends StatelessWidget {
  const _SheetTopBar({
    required this.title,
    required this.leading,
    required this.trailing,
  });

  final String title;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 16,
            child: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.topCenter,
                child: LiqSheetGrabber(),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  leading,
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                          fontSize: 17,
                          height: 22 / 17,
                          letterSpacing: -0.43,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  trailing,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 36×5pt grabber pill displayed at the top of a [LiqSheet].
final class LiqSheetGrabber extends StatelessWidget {
  /// Creates a grabber.
  const LiqSheetGrabber({super.key});

  static const Color _color = Color(0xFFCCCCCC);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 36,
      height: 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
    );
  }
}

/// Visual style for [LiqSheetTopButton].
enum LiqSheetTopButtonStyle {
  /// Gray translucent fill, dark glyph.
  standard,

  /// iOS 26 system blue gradient with colored shadow.
  primary,
}

/// 44×44pt circular top-bar button used inside a [LiqSheet] controls row.
final class LiqSheetTopButton extends StatefulWidget {
  /// Creates a top button.
  const LiqSheetTopButton({
    required this.child,
    this.onPressed,
    this.style = LiqSheetTopButtonStyle.standard,
    this.semanticsLabel,
    super.key,
  });

  /// Glyph (typically a small SVG/Text widget) rendered centered.
  final Widget child;

  /// Tap callback. When null, the button is disabled.
  final VoidCallback? onPressed;

  /// Visual style.
  final LiqSheetTopButtonStyle style;

  /// Accessible label for screen readers.
  final String? semanticsLabel;

  static const Color _standardTop = Color(0xE6F5F5F5);
  static const Color _standardBottom = Color(0xD9E6E6E6);
  static const Color _standardFg = Color(0xFF727272);
  static const Color _standardRim = Color(0x73FFFFFF);
  static const Color _primaryTop = Color(0xFF32A2FF);
  static const Color _primaryBottom = Color(0xFF0079FF);
  static const Color _primaryFg = Color(0xFFFFFFFF);
  static const Color _primaryShadow = Color(0x610079FF);

  @override
  State<LiqSheetTopButton> createState() => _LiqSheetTopButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqSheetTopButtonStyle>('style', style))
      ..add(StringProperty('semanticsLabel', semanticsLabel))
      ..add(
        FlagProperty(
          'enabled',
          value: onPressed != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}

class _LiqSheetTopButtonState extends State<LiqSheetTopButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.style == LiqSheetTopButtonStyle.primary;
    final disabled = widget.onPressed == null;
    final motionDuration = context.liqMotionDuration(LiqMotion.fast);

    final glyph = DefaultTextStyle.merge(
      style: TextStyle(
        color:
            isPrimary
                ? LiqSheetTopButton._primaryFg
                : LiqSheetTopButton._standardFg,
        fontFamily: 'SF Pro Text',
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
      child: widget.child,
    );

    return Semantics(
      button: true,
      enabled: !disabled,
      label: widget.semanticsLabel,
      child: LiqPointerCursor(
        enabled: !disabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: disabled ? null : (_) => _setPressed(true),
          onTapCancel: disabled ? null : () => _setPressed(false),
          onTapUp: disabled ? null : (_) => _setPressed(false),
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: _pressed ? 0.92 : 1,
            duration: motionDuration,
            curve: LiqMotion.snappy,
            child: AnimatedOpacity(
              opacity: disabled ? 0.5 : (_pressed ? 0.78 : 1),
              duration: motionDuration,
              curve: LiqMotion.standard,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(296)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        isPrimary
                            ? const <Color>[
                              LiqSheetTopButton._primaryTop,
                              LiqSheetTopButton._primaryBottom,
                            ]
                            : const <Color>[
                              LiqSheetTopButton._standardTop,
                              LiqSheetTopButton._standardBottom,
                            ],
                  ),
                  border:
                      isPrimary
                          ? null
                          : const Border.fromBorderSide(
                            BorderSide(color: LiqSheetTopButton._standardRim),
                          ),
                  boxShadow:
                      isPrimary
                          ? const <BoxShadow>[
                            BoxShadow(
                              color: LiqSheetTopButton._primaryShadow,
                              offset: Offset(0, 1),
                              blurRadius: 8,
                            ),
                          ]
                          : null,
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: Center(child: glyph),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiqSheetCloseButton extends StatelessWidget {
  const _LiqSheetCloseButton();

  @override
  Widget build(BuildContext context) {
    return const LiqSheetTopButton(
      semanticsLabel: 'Close',
      child: _SheetCloseGlyph(),
    );
  }
}

class _LiqSheetConfirmButton extends StatelessWidget {
  const _LiqSheetConfirmButton();

  @override
  Widget build(BuildContext context) {
    return const LiqSheetTopButton(
      style: LiqSheetTopButtonStyle.primary,
      semanticsLabel: 'Confirm',
      child: _SheetCheckGlyph(),
    );
  }
}

class _SheetCloseGlyph extends StatelessWidget {
  const _SheetCloseGlyph();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(
        painter: _GlyphPainter(
          _GlyphKind.close,
          DefaultTextStyle.of(context).style.color ?? const Color(0xFF727272),
        ),
      ),
    );
  }
}

class _SheetCheckGlyph extends StatelessWidget {
  const _SheetCheckGlyph();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(
        painter: _GlyphPainter(
          _GlyphKind.check,
          DefaultTextStyle.of(context).style.color ?? const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}

enum _GlyphKind { close, check }

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.kind, this.color);
  final _GlyphKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.9
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;
    final s = size.width / 20;
    if (kind == _GlyphKind.close) {
      canvas
        ..drawLine(Offset(6 * s, 6 * s), Offset(14 * s, 14 * s), paint)
        ..drawLine(Offset(14 * s, 6 * s), Offset(6 * s, 14 * s), paint);
    } else {
      final path =
          Path()
            ..moveTo(5 * s, 10.2 * s)
            ..lineTo(8.7 * s, 13.6 * s)
            ..lineTo(15 * s, 7.4 * s);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.color != color;
}
