import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// Tonal style for [LiqBanner] (and the legacy
/// `LiquidNotificationStyle` it replaces).
enum LiqBannerStyle {
  /// Neutral / informational tint (system blue).
  info,

  /// Positive confirmation (system green).
  success,

  /// Caution (system orange).
  warning,

  /// Error / destructive (system red).
  error,

  /// Caller-provided color via [LiqBanner.tintColor].
  custom,
}

/// Resolved icon glyph + color pair for a banner style.
@immutable
class _LiqBannerPalette {
  const _LiqBannerPalette({
    required this.tint,
    required this.icon,
  });

  final Color tint;
  final IconData icon;
}

/// Icon glyphs used by the four predefined [LiqBannerStyle] values.
/// These are the Cupertino glyph code points; consumers can override
/// per-banner via [LiqBanner.icon].
const IconData _infoIcon = IconData(0xf44c, fontFamily: 'CupertinoIcons',
    fontPackage: 'cupertino_icons');
const IconData _successIcon = IconData(0xf3fe,
    fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');
const IconData _warningIcon = IconData(0xf42d,
    fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');
const IconData _errorIcon = IconData(0xf36b,
    fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');

/// Inline dismissable banner used to surface contextual info above
/// content. Renders a tinted left strip + icon + title/body, with
/// optional close affordance and trailing actions.
final class LiqBanner extends StatelessWidget with Diagnosticable {
  /// Creates a banner.
  const LiqBanner({
    required this.title,
    this.body,
    this.style = LiqBannerStyle.info,
    this.tintColor,
    this.icon,
    this.actions = const <Widget>[],
    this.onClose,
    super.key,
  });

  final String title;
  final String? body;
  final LiqBannerStyle style;

  /// Required when [style] is [LiqBannerStyle.custom].
  final Color? tintColor;

  /// Optional icon override. Defaults vary by [style].
  final IconData? icon;

  /// Optional trailing action widgets (typically `LiqButton`s with
  /// `style: LiqButtonStyle.borderless`).
  final List<Widget> actions;

  /// When provided, renders an X glyph that calls this on tap.
  final VoidCallback? onClose;

  _LiqBannerPalette _resolve(BuildContext context) {
    switch (style) {
      case LiqBannerStyle.info:
        return _LiqBannerPalette(
          tint: tintColor ?? LiqAppleColors.systemBlue,
          icon: icon ?? _infoIcon,
        );
      case LiqBannerStyle.success:
        return _LiqBannerPalette(
          tint: tintColor ?? LiqAppleColors.systemGreen,
          icon: icon ?? _successIcon,
        );
      case LiqBannerStyle.warning:
        return _LiqBannerPalette(
          tint: tintColor ?? LiqAppleColors.systemOrange,
          icon: icon ?? _warningIcon,
        );
      case LiqBannerStyle.error:
        return _LiqBannerPalette(
          tint: tintColor ?? LiqAppleColors.systemRed,
          icon: icon ?? _errorIcon,
        );
      case LiqBannerStyle.custom:
        return _LiqBannerPalette(
          tint: tintColor ?? LiqAppleColors.systemBlue,
          icon: icon ?? _infoIcon,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _resolve(context);
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final titleColor =
        isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
    final bodyColor = isDark
        ? const Color(0x99EBEBF5)
        : const Color(0x993C3C43);
    final bg = palette.tint.withValues(alpha: isDark ? 0.18 : 0.12);
    final titleStyle = LiqAppleTypography.body(brightness).copyWith(
      color: titleColor,
      fontWeight: LiqAppleTypography.semibold,
    );
    final bodyStyle = LiqAppleTypography.subheadline(brightness).copyWith(
      color: bodyColor,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        border: Border(
          left: BorderSide(color: palette.tint, width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(palette.icon, color: palette.tint, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(title, style: titleStyle),
                  if (body != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(body!, style: bodyStyle),
                  ],
                  if (actions.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: actions,
                    ),
                  ],
                ],
              ),
            ),
            if (onClose != null)
              GestureDetector(
                onTap: onClose,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CustomPaint(
                      painter: _CloseGlyphPainter(
                        color: bodyColor,
                        strokeWidth: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqBannerStyle>('style', style))
      ..add(StringProperty('title', title))
      ..add(FlagProperty('hasBody', value: body != null, ifTrue: 'has body'));
  }
}

class _CloseGlyphPainter extends CustomPainter {
  const _CloseGlyphPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    final inset = size.width * 0.28;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CloseGlyphPainter old) =>
      color != old.color || strokeWidth != old.strokeWidth;
}
