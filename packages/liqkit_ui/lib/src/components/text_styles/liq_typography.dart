import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Semantic typography role from iOS 26 Human Interface Guidelines.
///
/// Sourced from `native/components/text-styles.css`.
enum LiqTypeRole {
  /// 34/41 SF Pro Display 700 +0.4.
  largeTitle,

  /// 28/34 SF Pro Display 400 +0.36.
  title1,

  /// 22/28 SF Pro Display 400 +0.35.
  title2,

  /// 20/25 SF Pro Display 400 +0.38.
  title3,

  /// 17/22 SF Pro Text 600 -0.43.
  headline,

  /// 17/22 SF Pro Text 400 -0.43.
  body,

  /// 16/21 SF Pro Text 400 -0.32.
  callout,

  /// 15/20 SF Pro Text 400 -0.24.
  subhead,

  /// 13/18 SF Pro Text 400 -0.08.
  footnote,

  /// 12/16 SF Pro Text 400 0.
  caption1,

  /// 11/13 SF Pro Text 400 +0.06.
  caption2,
}

/// Dynamic-type scale multiplier — applied to size, line-height, and
/// letter-spacing.
enum LiqDynamicTypeScale {
  /// 0.9x — the smallest standard scale.
  xSmall,

  /// 0.95x.
  small,

  /// 0.98x.
  medium,

  /// 1.0x — the system default.
  large,

  /// 1.1x.
  xLarge,

  /// 1.2x.
  xxLarge,

  /// 1.32x.
  xxxLarge,

  /// 1.45x — accessibility size 1.
  ax1,

  /// 1.65x — accessibility size 2.
  ax2,

  /// 1.85x — accessibility size 3.
  ax3,

  /// 2.05x — accessibility size 4.
  ax4,

  /// 2.25x — accessibility size 5 (largest).
  ax5,
}

/// Foreground tone for text.
enum LiqTextTone {
  /// Solid #000000 black.
  primary,

  /// #3C3C43 — the standard secondary label colour.
  secondary,

  /// #3C3C43 at 0.62 opacity.
  tertiary,

  /// #3C3C43 at 0.38 opacity.
  quaternary,
}

/// Returns the dynamic-type multiplier for [scale].
double liqDynamicTypeMultiplier(LiqDynamicTypeScale scale) {
  switch (scale) {
    case LiqDynamicTypeScale.xSmall:
      return 0.9;
    case LiqDynamicTypeScale.small:
      return 0.95;
    case LiqDynamicTypeScale.medium:
      return 0.98;
    case LiqDynamicTypeScale.large:
      return 1;
    case LiqDynamicTypeScale.xLarge:
      return 1.1;
    case LiqDynamicTypeScale.xxLarge:
      return 1.2;
    case LiqDynamicTypeScale.xxxLarge:
      return 1.32;
    case LiqDynamicTypeScale.ax1:
      return 1.45;
    case LiqDynamicTypeScale.ax2:
      return 1.65;
    case LiqDynamicTypeScale.ax3:
      return 1.85;
    case LiqDynamicTypeScale.ax4:
      return 2.05;
    case LiqDynamicTypeScale.ax5:
      return 2.25;
  }
}

({double size, double line, double track, String family, FontWeight weight})
_baseFor(LiqTypeRole role) {
  const display = 'SF Pro Display';
  const text = 'SF Pro Text';
  switch (role) {
    case LiqTypeRole.largeTitle:
      return (
        size: 34,
        line: 41,
        track: 0.4,
        family: display,
        weight: FontWeight.w700,
      );
    case LiqTypeRole.title1:
      return (
        size: 28,
        line: 34,
        track: 0.36,
        family: display,
        weight: FontWeight.w400,
      );
    case LiqTypeRole.title2:
      return (
        size: 22,
        line: 28,
        track: 0.35,
        family: display,
        weight: FontWeight.w400,
      );
    case LiqTypeRole.title3:
      return (
        size: 20,
        line: 25,
        track: 0.38,
        family: display,
        weight: FontWeight.w400,
      );
    case LiqTypeRole.headline:
      return (
        size: 17,
        line: 22,
        track: -0.43,
        family: text,
        weight: FontWeight.w600,
      );
    case LiqTypeRole.body:
      return (
        size: 17,
        line: 22,
        track: -0.43,
        family: text,
        weight: FontWeight.w400,
      );
    case LiqTypeRole.callout:
      return (
        size: 16,
        line: 21,
        track: -0.32,
        family: text,
        weight: FontWeight.w400,
      );
    case LiqTypeRole.subhead:
      return (
        size: 15,
        line: 20,
        track: -0.24,
        family: text,
        weight: FontWeight.w400,
      );
    case LiqTypeRole.footnote:
      return (
        size: 13,
        line: 18,
        track: -0.08,
        family: text,
        weight: FontWeight.w400,
      );
    case LiqTypeRole.caption1:
      return (
        size: 12,
        line: 16,
        track: 0,
        family: text,
        weight: FontWeight.w400,
      );
    case LiqTypeRole.caption2:
      return (
        size: 11,
        line: 13,
        track: 0.06,
        family: text,
        weight: FontWeight.w400,
      );
  }
}

Color _toneColor(LiqTextTone tone) {
  switch (tone) {
    case LiqTextTone.primary:
      return const Color(0xFF000000);
    case LiqTextTone.secondary:
      return const Color(0xFF3C3C43);
    case LiqTextTone.tertiary:
      return const Color(0xFF3C3C43).withValues(alpha: 0.62);
    case LiqTextTone.quaternary:
      return const Color(0xFF3C3C43).withValues(alpha: 0.38);
  }
}

/// Resolves a Flutter [TextStyle] for the given iOS 26 role + scale +
/// tone.
TextStyle liqResolveTextStyle({
  required LiqTypeRole role,
  LiqDynamicTypeScale scale = LiqDynamicTypeScale.large,
  LiqTextTone tone = LiqTextTone.primary,
}) {
  final base = _baseFor(role);
  final m = liqDynamicTypeMultiplier(scale);
  return TextStyle(
    fontFamily: base.family,
    fontFamilyFallback: const <String>['SF Pro Text', '-apple-system'],
    fontSize: base.size * m,
    height: (base.line * m) / (base.size * m),
    letterSpacing: base.track * m,
    fontWeight: base.weight,
    color: _toneColor(tone),
  );
}

/// A single column from the iOS 26 text-styles catalog — header label
/// over a series of role samples laid out vertically.
final class LiqTypeColumn extends StatelessWidget {
  /// Creates a type column.
  const LiqTypeColumn({
    required this.header,
    required this.scale,
    this.tone = LiqTextTone.primary,
    this.roles = const <LiqTypeRole>[
      LiqTypeRole.largeTitle,
      LiqTypeRole.title1,
      LiqTypeRole.title2,
      LiqTypeRole.title3,
      LiqTypeRole.headline,
      LiqTypeRole.body,
      LiqTypeRole.callout,
      LiqTypeRole.subhead,
      LiqTypeRole.footnote,
      LiqTypeRole.caption1,
      LiqTypeRole.caption2,
    ],
    this.sampleText = 'iOS 26',
    super.key,
  });

  /// Column header rendered in 500 12/16 #66666C with a hairline below.
  final String header;

  /// The dynamic-type scale applied to every role in the column.
  final LiqDynamicTypeScale scale;

  /// Tone to apply to every sample.
  final LiqTextTone tone;

  /// The roles to render (top to bottom).
  final List<LiqTypeRole> roles;

  /// Sample string rendered using each role.
  final String sampleText;

  static const Color _headerColor = Color(0xFF66666C);
  static const Color _hairline = Color(0xFFECECF1);
  static const Color _border = Color(0xFFE5E5EA);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(14)),
        border: Border.fromBorderSide(BorderSide(color: _border)),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _hairline)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  header,
                  style: const TextStyle(
                    color: _headerColor,
                    fontFamily: 'SF Pro Text',
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          for (final role in roles) ...<Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                sampleText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: liqResolveTextStyle(
                  role: role,
                  scale: scale,
                  tone: tone,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('header', header))
      ..add(EnumProperty<LiqDynamicTypeScale>('scale', scale))
      ..add(EnumProperty<LiqTextTone>('tone', tone));
  }
}
