import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/src/foundation/liq_typography.dart';

/// iOS 26 empty-state placeholder — centered icon + title + description.
///
/// Sourced from `native/components/empty-states.css`. Title is SF Pro Text
/// 590 22/28 #000, description is 500 22/28 rgba(60,60,67,0.6). An optional
/// 50pt circular `iconBackground` (system-blue 15% alpha) is shown behind
/// `icon`. A trailing call-to-action button can be supplied via `cta`.
final class LiqEmptyState extends StatelessWidget {
  /// Creates an empty-state placeholder.
  const LiqEmptyState({
    required this.title,
    this.description,
    this.icon,
    this.iconBackground = false,
    this.cta,
    super.key,
  });

  /// Title.
  final String title;

  /// Optional secondary description.
  final String? description;

  /// Optional icon rendered above the copy (recommended ≤ 50pt).
  final Widget? icon;

  /// When true, wraps [icon] in a 50pt circular blue-tinted disc.
  final bool iconBackground;

  /// Optional CTA widget rendered at the bottom (e.g. [LiqEmptyStateCta]).
  final Widget? cta;

  static const Color _titleColor = Color(0xFF000000);
  static const Color _descColor = Color(0x993C3C43);
  static const Color _iconCircleBg = Color(0x260A84FF);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (icon != null) ...<Widget>[
        SizedBox(
          width: 50,
          height: 50,
          child:
              iconBackground
                  ? DecoratedBox(
                    decoration: const BoxDecoration(
                      color: _iconCircleBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SizedBox(width: 22, height: 22, child: icon),
                    ),
                  )
                  : Center(child: icon),
        ),
        const SizedBox(height: 16),
      ],
      Text(
        title,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          fontFamily: LiqFontFamily.display,
          fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w600,
          color: _titleColor,
        ),
      ),
      if (description != null) ...<Widget>[
        const SizedBox(height: 6),
        Text(
          description!,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            fontFamily: LiqFontFamily.display,
            fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
            fontSize: 22,
            height: 28 / 22,
            fontWeight: FontWeight.w500,
            color: _descColor,
          ),
        ),
      ],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(mainAxisSize: MainAxisSize.min, children: children),
          if (cta != null) ...<Widget>[const SizedBox(height: 24), cta!],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('description', description))
      ..add(
        FlagProperty(
          'iconBackground',
          value: iconBackground,
          ifTrue: 'with circle',
        ),
      );
  }
}

/// Default 48pt full-width CTA used in [LiqEmptyState].
final class LiqEmptyStateCta extends StatelessWidget {
  /// Creates a CTA.
  const LiqEmptyStateCta({required this.label, this.onPressed, super.key});

  /// Label.
  final String label;

  /// Tap callback. When null the button is rendered disabled.
  final VoidCallback? onPressed;

  static const Color _bg = Color(0xFF0091FF);
  static const Color _fg = Color(0xFFFFFFFF);
  static const Color _shadow = Color(0x1F000000);

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Opacity(
          opacity: disabled ? 0.5 : 1,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.all(Radius.circular(1000)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: _shadow, offset: Offset(0, 1), blurRadius: 8),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                fontFamily: 'SF Pro Text',
                fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
                fontSize: 17,
                height: 22 / 17,
                fontWeight: FontWeight.w500,
                color: _fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
