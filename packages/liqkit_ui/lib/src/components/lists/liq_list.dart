import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// A grouped iOS 26 list — rounded card on a card surface.
///
/// Sourced from `native/components/lists.css`. Children are
/// [LiqListRow]s; the group inserts hairline separators between them.
final class LiqListGroup extends StatelessWidget {
  /// Creates a list group.
  const LiqListGroup({required this.rows, this.brightness, super.key});

  /// Rows to render inside the group.
  final List<LiqListRow> rows;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

  static const double _radius = 26;
  static const Color _bgLight = Color(0xFFFFFFFF);
  static const Color _bgDark = Color(0xFF1C1C1E);
  static const Color _borderLight = Color(0xFFE6E6E6);
  static const Color _borderDark = Color(0xFF2C2C2E);

  @override
  Widget build(BuildContext context) {
    final isDark = (brightness ?? context.liqBrightness) == Brightness.dark;
    final bg = isDark ? _bgDark : _bgLight;
    final border = isDark ? _borderDark : _borderLight;

    return LiqGlassSurface(
      baseFill: bg,
      rimColor: border,
      borderRadius: const BorderRadius.all(Radius.circular(_radius)),
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (var i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0) Container(height: 1, color: border),
            rows[i],
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('rowCount', rows.length))
      ..add(EnumProperty<Brightness?>('brightness', brightness));
  }
}

/// A single row inside a [LiqListGroup].
final class LiqListRow extends StatelessWidget {
  /// Creates a list row.
  ///
  /// Provide either [title] (a string) or [titleWidget] (custom content)
  /// — at least one must be non-null.
  const LiqListRow({
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.leading,
    this.trailing,
    this.detail,
    this.showChevron = false,
    this.onTap,
    this.brightness,
    this.enabled = true,
    this.selected = false,
    this.contentPadding,
    super.key,
  }) : assert(
          title != null || titleWidget != null,
          'Either title or titleWidget must be provided',
        );

  /// Primary title text. Mutually exclusive with [titleWidget].
  final String? title;

  /// Custom widget rendered in the title slot. When provided, [title]
  /// is ignored. Use this for stylized or composed titles.
  final Widget? titleWidget;

  /// Optional secondary text shown beneath the title.
  final String? subtitle;

  /// Custom widget rendered in the subtitle slot. When provided,
  /// [subtitle] is ignored.
  final Widget? subtitleWidget;

  /// Optional leading widget (icon, avatar, etc.).
  final Widget? leading;

  /// Optional trailing widget (toggle, icon, etc.). Mutually exclusive
  /// with [detail] visually but both can render side-by-side.
  final Widget? trailing;

  /// Optional right-aligned detail text (e.g. value, badge).
  final String? detail;

  /// When true, shows the iOS 26 chevron at the row's far right.
  final bool showChevron;

  /// Tap callback. When null (or [enabled] is false), the row is
  /// non-interactive.
  final VoidCallback? onTap;

  /// Surface brightness. Defaults to the nearest liq theme brightness.
  final Brightness? brightness;

  /// When false, dims the title/subtitle text and suppresses [onTap].
  final bool enabled;

  /// When true, renders a highlighted background to indicate selection.
  final bool selected;

  /// Optional padding override. Defaults to the iOS-16-pt horizontal,
  /// 8-pt vertical inset.
  final EdgeInsetsGeometry? contentPadding;

  static const Color _titleLight = Color(0xFF000000);
  static const Color _titleDark = Color(0xFFFFFFFF);
  static const Color _subtitleLight = Color(0x993C3C43);
  static const Color _subtitleDark = Color(0x99EBEBF5);
  static const Color _chevron = Color(0x4D3C3C43);
  static const Color _selectedBgLight = Color(0x140A84FF);
  static const Color _selectedBgDark = Color(0x290A84FF);

  @override
  Widget build(BuildContext context) {
    final isDark = (brightness ?? context.liqBrightness) == Brightness.dark;
    final hasSubtitle = subtitle != null || subtitleWidget != null;
    final tall = hasSubtitle;
    final tappable = onTap != null && enabled;

    final activeTitleColor = isDark ? _titleDark : _titleLight;
    final activeSubtitleColor = isDark ? _subtitleDark : _subtitleLight;
    final disabledColor = isDark ? _subtitleDark : _subtitleLight;
    final titleColor = enabled ? activeTitleColor : disabledColor;
    final subtitleColor = enabled ? activeSubtitleColor : disabledColor;

    final titleStyle = TextStyle(
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
      fontSize: 17,
      height: 22 / 17,
      letterSpacing: -0.43,
      color: titleColor,
    );
    final subtitleStyle = TextStyle(
      fontFamily: 'SF Pro Text',
      fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
      fontSize: 15,
      height: 20 / 15,
      letterSpacing: -0.23,
      color: subtitleColor,
    );
    final detailStyle = titleStyle.copyWith(color: activeSubtitleColor);

    final selectedBg = isDark ? _selectedBgDark : _selectedBgLight;

    final titleSlot = titleWidget ??
        Text(
          title!,
          style: titleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.ltr,
        );

    final subtitleSlot = subtitleWidget ??
        (subtitle != null
            ? Text(
                subtitle!,
                style: subtitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
              )
            : null);

    return Semantics(
      button: tappable,
      enabled: enabled,
      label: title,
      child: LiqPointerCursor(
        enabled: tappable,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: tappable ? onTap : null,
          child: Container(
            constraints: BoxConstraints(minHeight: tall ? 68 : 52),
            color: selected ? selectedBg : null,
            padding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DefaultTextStyle.merge(
                        style: titleStyle,
                        child: titleSlot,
                      ),
                      if (subtitleSlot != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: DefaultTextStyle.merge(
                            style: subtitleStyle,
                            child: subtitleSlot,
                          ),
                        ),
                    ],
                  ),
                ),
                if (detail != null) ...<Widget>[
                  const SizedBox(width: 8),
                  Text(
                    detail!,
                    style: detailStyle,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  ),
                ],
                if (trailing != null) ...<Widget>[
                  const SizedBox(width: 8),
                  trailing!,
                ],
                if (showChevron) ...<Widget>[
                  const SizedBox(width: 8),
                  const _Chevron(),
                ],
              ],
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
      ..add(StringProperty('title', title, defaultValue: null))
      ..add(StringProperty('subtitle', subtitle, defaultValue: null))
      ..add(StringProperty('detail', detail, defaultValue: null))
      ..add(FlagProperty('showChevron', value: showChevron, ifTrue: 'chevron'))
      ..add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'))
      ..add(FlagProperty('selected', value: selected, ifTrue: 'selected'))
      ..add(EnumProperty<Brightness>('brightness', brightness))
      ..add(
        FlagProperty(
          'tappable',
          value: onTap != null && enabled,
          ifTrue: 'tappable',
          ifFalse: 'static',
        ),
      );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();
  @override
  Widget build(BuildContext context) {
    return const Text(
      '›',
      style: TextStyle(
        fontFamily: 'SF Pro Text',
        fontSize: 22,
        height: 1,
        color: LiqListRow._chevron,
        fontWeight: FontWeight.w500,
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
