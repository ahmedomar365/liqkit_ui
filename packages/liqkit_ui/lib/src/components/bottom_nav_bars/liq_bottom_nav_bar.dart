import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';

/// One tab in [LiqBottomNavBar].
///
/// Each item is a stacked icon + label pair selecting between top-level
/// app sections (e.g. Home, Search, Inbox, Profile).
@immutable
final class LiqBottomNavItem {
  /// Creates a bottom-nav item.
  const LiqBottomNavItem({required this.icon, required this.label});

  /// Icon rendered above [label]. 24x24 in iOS 26 spec.
  final IconData icon;

  /// Caption rendered beneath the icon. SF Pro medium 10pt.
  final String label;
}

/// iOS 26 bottom tab bar — a horizontal row of 2 to 5 stacked icon+label
/// items selecting between top-level app sections.
///
/// Sourced from the iOS 26 native tab-bar spec:
///   - bar background: 95% opaque liquid glass (#FAFAFA at α=0.95)
///   - 0.33pt hairline divider above the bar (#000000 at α=0.16)
///   - 49pt content height + bottom safe-area inset
///   - 24x24 icon, 2pt gap, 10pt SF Pro medium label
///   - active fill iOS blue (#007AFF), inactive grey (#8E8E93)
///   - no tap animation per iOS HIG — selection is instant
///   - whole bar dims to 40% opacity and is non-tappable when
///     [onChanged] is null
final class LiqBottomNavBar extends StatelessWidget {
  /// Creates a bottom navigation bar.
  ///
  /// [items] length must be between 2 and 5 inclusive (iOS HIG).
  const LiqBottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    super.key,
  }) : assert(
         items.length >= 2 && items.length <= 5,
         'bottom nav supports 2 to 5 items',
       );

  /// Tabs to render. Length must be between 2 and 5.
  final List<LiqBottomNavItem> items;

  /// Index of the currently selected tab.
  final int currentIndex;

  /// Called when the user taps a tab. When null the entire bar is
  /// dimmed and non-tappable.
  final ValueChanged<int>? onChanged;

  /// 95% opaque liquid-glass bar fill (#FAFAFA α=0.95).
  static const Color barBackground = Color(0xF2FAFAFA);

  /// 16% opaque black hairline divider above the bar.
  static const Color hairlineColor = Color(0x29000000);

  /// Hairline thickness in logical pixels (0.33pt).
  static const double hairlineThickness = 0.33;

  /// Content height of the bar, excluding the bottom safe-area inset.
  static const double contentHeight = 49;

  /// Icon size — 24x24 per iOS spec.
  static const double iconSize = 24;

  /// Gap between icon and label.
  static const double iconLabelGap = 2;

  /// Tint of the currently selected tab — iOS system blue.
  static const Color activeColor = Color(0xFF007AFF);

  /// Tint of unselected tabs — iOS system grey.
  static const Color inactiveColor = Color(0xFF8E8E93);

  /// Opacity applied to the whole bar when [onChanged] is null.
  static const double disabledOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    final bottomInset = MediaQuery.maybeOf(context)?.padding.bottom ?? 0;

    final bar = LiqGlassSurface(
      elevation: LiqGlassElevation.flat,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: hairlineThickness,
            width: double.infinity,
            child: ColoredBox(color: hairlineColor),
          ),
          SizedBox(
            height: contentHeight,
            child: Row(
              children: <Widget>[
                for (var i = 0; i < items.length; i++)
                  Expanded(child: _buildTab(context, i, disabled: disabled)),
              ],
            ),
          ),
        ],
      ),
    );

    if (disabled) {
      return Opacity(opacity: disabledOpacity, child: bar);
    }
    return bar;
  }

  Widget _buildTab(BuildContext context, int index, {required bool disabled}) {
    final item = items[index];
    final isActive = index == currentIndex;
    final color = isActive ? activeColor : inactiveColor;

    return Semantics(
      button: true,
      enabled: !disabled,
      selected: isActive,
      inMutuallyExclusiveGroup: true,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : () => onChanged!(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(item.icon, size: iconSize, color: color),
            const SizedBox(height: iconLabelGap),
            Text(
              item.label,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                fontSize: 10,
                height: 12 / 10,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
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
      ..add(IntProperty('count', items.length))
      ..add(IntProperty('currentIndex', currentIndex))
      ..add(
        FlagProperty(
          'enabled',
          value: onChanged != null,
          ifTrue: 'enabled',
          ifFalse: 'disabled',
        ),
      );
  }
}
