import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Color pair for a [LiqNotification] icon surface.
///
/// The gradient runs from [top] to [bottom] (180°), with a soft white
/// highlight rendered radially in the upper-left corner.
final class LiqNotificationIconColors with Diagnosticable {
  /// Creates a color pair.
  const LiqNotificationIconColors({required this.top, required this.bottom});

  /// Top color of the icon surface gradient.
  final Color top;

  /// Bottom color of the icon surface gradient.
  final Color bottom;

  /// iOS Mail (blue) icon palette.
  static const LiqNotificationIconColors mail = LiqNotificationIconColors(
    top: Color(0xFF62CCFF),
    bottom: Color(0xFF0A87F5),
  );

  /// iOS Reminders (red) icon palette.
  static const LiqNotificationIconColors reminders = LiqNotificationIconColors(
    top: Color(0xFFFF6F88),
    bottom: Color(0xFFFF2B3F),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('top', top))
      ..add(ColorProperty('bottom', bottom));
  }
}

/// 40×40pt rounded icon surface used in a [LiqNotification].
final class LiqNotificationIcon extends StatelessWidget {
  /// Creates an icon surface.
  const LiqNotificationIcon({
    required this.colors,
    required this.glyph,
    super.key,
  });

  /// Color pair for the gradient surface.
  final LiqNotificationIconColors colors;

  /// Centered glyph (typically 22×22 or 24×24).
  final Widget glyph;

  static const Color _topRim = Color(0x3DFFFFFF);
  static const Color _shadow15 = Color(0x26000000);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      height: 66,
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[colors.top, colors.bottom],
            ),
            border: const Border.fromBorderSide(BorderSide(color: _topRim)),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: _shadow15, offset: Offset(0, 4), blurRadius: 9),
            ],
          ),
          alignment: Alignment.center,
          child: glyph,
        ),
      ),
    );
  }
}

/// iOS 26 banner-style notification card.
///
/// Sourced from `native/components/notifications.css`:
/// 386×64+ glass card, translucent white tint, 24pt corner radius, 66pt
/// icon column followed by a copy column with title + description and an
/// optional trailing time chip in the title row.
final class LiqNotification extends StatelessWidget {
  /// Creates a notification.
  const LiqNotification({
    required this.title,
    required this.body,
    required this.icon,
    this.time,
    this.width = 386,
    this.brightness,
    super.key,
  });

  /// Source / app title.
  final String title;

  /// Notification body.
  final String body;

  /// Trailing time chip (e.g. `now`, `2m ago`, `09:41`).
  final String? time;

  /// Leading icon surface.
  final LiqNotificationIcon icon;

  /// Total card width. Defaults to 386pt.
  final double width;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  ///
  /// Light notifications use dark text on a light glass tint. Dark
  /// notifications use white text on a dark glass tint.
  final Brightness? brightness;

  static const Color _titleLight = Color(0xE6000000);
  static const Color _bodyLight = Color(0xB3000000);
  static const Color _timeLight = Color(0x8F000000);
  static const Color _titleDark = Color(0xF2FFFFFF);
  static const Color _bodyDark = Color(0xD9FFFFFF);
  static const Color _timeDark = Color(0xB8FFFFFF);

  @override
  Widget build(BuildContext context) {
    final isDark = (brightness ?? context.liqBrightness) == Brightness.dark;
    final titleColor = isDark ? _titleDark : _titleLight;
    final bodyColor = isDark ? _bodyDark : _bodyLight;
    final timeColor = isDark ? _timeDark : _timeLight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final cardWidth =
            availableWidth.isFinite && availableWidth < width
                ? availableWidth
                : width;
        return SizedBox(
          width: cardWidth,
          child: LiqGlassSurface(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            padding: const EdgeInsets.fromLTRB(14, 13, 17, 13),
            tint: isDark ? LiqGlassTint.dark : LiqGlassTint.light,
            child: Row(
              children: <Widget>[
                icon,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.ltr,
                              style: const TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontFamilyFallback: <String>[
                                  'SF Pro',
                                  'sans-serif',
                                ],
                                fontSize: 15,
                                height: 17 / 15,
                                letterSpacing: -0.23,
                                fontWeight: FontWeight.w600,
                              ).copyWith(color: titleColor),
                            ),
                          ),
                          if (time != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                time!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  fontSize: 13,
                                  height: 20 / 13,
                                  fontWeight: FontWeight.w400,
                                ).copyWith(color: timeColor),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                          fontSize: 15,
                          height: 18 / 15,
                          letterSpacing: -0.23,
                          fontWeight: FontWeight.w400,
                        ).copyWith(color: bodyColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      ..add(StringProperty('body', body))
      ..add(StringProperty('time', time))
      ..add(DoubleProperty('width', width))
      ..add(EnumProperty<Brightness?>('brightness', brightness));
  }
}
