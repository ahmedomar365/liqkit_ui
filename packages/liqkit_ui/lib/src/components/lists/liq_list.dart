import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A grouped iOS 26 list — rounded card on a card surface.
///
/// Sourced from `native/components/lists.css`. Children are
/// [LiqListRow]s; the group inserts hairline separators between them.
final class LiqListGroup extends StatelessWidget {
  /// Creates a list group.
  const LiqListGroup({
    required this.rows,
    this.brightness = Brightness.light,
    super.key,
  });

  /// Rows to render inside the group.
  final List<LiqListRow> rows;

  /// Surface brightness.
  final Brightness brightness;

  static const double _radius = 26;
  static const Color _bgLight = Color(0xFFFFFFFF);
  static const Color _bgDark = Color(0xFF1C1C1E);
  static const Color _borderLight = Color(0xFFE6E6E6);
  static const Color _borderDark = Color(0xFF2C2C2E);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? _bgDark : _bgLight;
    final border = isDark ? _borderDark : _borderLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(_radius)),
        border: Border.all(color: border),
      ),
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
      ..add(EnumProperty<Brightness>('brightness', brightness));
  }
}

/// A single row inside a [LiqListGroup].
final class LiqListRow extends StatelessWidget {
  /// Creates a list row.
  const LiqListRow({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.detail,
    this.showChevron = false,
    this.onTap,
    this.brightness = Brightness.light,
    super.key,
  });

  /// Primary title text.
  final String title;

  /// Optional secondary text shown beneath the title.
  final String? subtitle;

  /// Optional leading widget (icon, avatar, etc.).
  final Widget? leading;

  /// Optional trailing widget (toggle, icon, etc.). Mutually exclusive
  /// with [detail] visually but both can render side-by-side.
  final Widget? trailing;

  /// Optional right-aligned detail text (e.g. value, badge).
  final String? detail;

  /// When true, shows the iOS 26 chevron at the row's far right.
  final bool showChevron;

  /// Tap callback. When null, the row is non-interactive.
  final VoidCallback? onTap;

  /// Surface brightness.
  final Brightness brightness;

  static const Color _titleLight = Color(0xFF000000);
  static const Color _titleDark = Color(0xFFFFFFFF);
  static const Color _subtitleLight = Color(0x993C3C43);
  static const Color _subtitleDark = Color(0x99EBEBF5);
  static const Color _chevron = Color(0x4D3C3C43);

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final tall = subtitle != null;
    final titleColor = isDark ? _titleDark : _titleLight;
    final subtitleColor = isDark ? _subtitleDark : _subtitleLight;

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
    final detailStyle = titleStyle.copyWith(color: subtitleColor);

    return Semantics(
      button: onTap != null,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: tall ? 68 : 52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Text(
                      title,
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!,
                          style: subtitleStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
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
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('subtitle', subtitle, defaultValue: null))
      ..add(StringProperty('detail', detail, defaultValue: null))
      ..add(FlagProperty('showChevron', value: showChevron, ifTrue: 'chevron'))
      ..add(EnumProperty<Brightness>('brightness', brightness))
      ..add(
        FlagProperty(
          'tappable',
          value: onTap != null,
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
