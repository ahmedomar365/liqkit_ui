import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/foundation/liq_motion.dart';

/// Visual variant of [LiqTabs].
enum LiqTabsVariant {
  /// Underline indicator beneath the active tab. Headers sit on a
  /// transparent surface — typically rendered above content.
  underline,

  /// Pill highlight slides under the active tab — fully glass.
  pill,
}

/// Header descriptor for one tab in a [LiqTabs] strip.
final class LiqTabItem with Diagnosticable {
  /// Creates a tab header. At least one of [label] or [icon] must be
  /// non-null.
  const LiqTabItem({this.label, this.icon})
    : assert(
        label != null || icon != null,
        'LiqTabItem needs a label or an icon',
      );

  /// Text label for the tab. Optional when [icon] is set.
  final String? label;

  /// Leading icon for the tab. Optional when [label] is set.
  final IconData? icon;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<IconData?>('icon', icon));
  }
}

/// iOS 26 page-navigation tab strip.
///
/// Tabs select among views/sections — distinct from
/// `LiqSegmentedControl`, which selects among values inside a setting.
/// The [variant] picks between an underline indicator and a sliding
/// glass pill.
final class LiqTabs extends StatelessWidget with Diagnosticable {
  /// Creates a tab strip.
  const LiqTabs({
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.variant = LiqTabsVariant.underline,
    super.key,
  });

  /// Ordered tab headers.
  final List<LiqTabItem> items;

  /// Index of the currently selected tab.
  final int selectedIndex;

  /// Selection callback. Null disables the strip.
  final ValueChanged<int>? onChanged;

  /// Visual variant — underline or pill.
  final LiqTabsVariant variant;

  /// Header height.
  static const double headerHeight = 44;

  /// Active label/icon color (iOS 26 system blue).
  static const Color activeColor = Color(0xFF007AFF);

  /// Inactive label/icon color.
  static const Color inactiveColor = Color(0xFF8E8E93);

  /// Hairline divider color used at the bottom of the underline bar.
  static const Color hairlineColor = Color(0x29000000);

  /// Pill container background color.
  static const Color pillTrackColor = Color(0x14000000);

  /// Pill highlight color (active background).
  static const Color pillHighlightColor = Color(0xFFFFFFFF);

  /// Active text color when [variant] is [LiqTabsVariant.pill].
  static const Color pillActiveLabelColor = Color(0xFF000000);

  /// Animation duration for the indicator.
  static const Duration animationDuration = LiqMotion.fast;

  /// Animation curve for the indicator.
  static const Curve animationCurve = LiqMotion.standard;

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: switch (variant) {
        LiqTabsVariant.underline => _buildUnderline(),
        LiqTabsVariant.pill => _buildPill(),
      },
    );
  }

  Widget _buildUnderline() {
    final count = items.length;
    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: <Widget>[
          // Hairline divider full-width at the bottom.
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 0.33,
              child: DecoratedBox(
                decoration: BoxDecoration(color: hairlineColor),
              ),
            ),
          ),
          // Tab cells.
          Row(
            children: <Widget>[
              for (var i = 0; i < count; i++)
                Expanded(
                  child: _TabCell(
                    item: items[i],
                    selected: i == selectedIndex,
                    enabled: !(onChanged == null),
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    onTap: onChanged == null ? null : () => onChanged!(i),
                    selectedIndex: selectedIndex,
                    indexInGroup: i,
                  ),
                ),
            ],
          ),
          // Animated underline.
          if (count > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedAlign(
                alignment: Alignment(_alignmentX(selectedIndex, count), 0),
                duration: animationDuration,
                curve: animationCurve,
                child: FractionallySizedBox(
                  widthFactor: 1 / count,
                  child: const SizedBox(
                    height: 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: activeColor),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPill() {
    final count = items.length;
    return SizedBox(
      height: headerHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: pillTrackColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Stack(
            children: <Widget>[
              // Animated active pill background.
              if (count > 0)
                Positioned.fill(
                  child: AnimatedAlign(
                    alignment: Alignment(_alignmentX(selectedIndex, count), 0),
                    duration: animationDuration,
                    curve: animationCurve,
                    child: FractionallySizedBox(
                      widthFactor: 1 / count,
                      heightFactor: 1,
                      child: const _PillHighlight(),
                    ),
                  ),
                ),
              // Tab cells.
              Row(
                children: <Widget>[
                  for (var i = 0; i < count; i++)
                    Expanded(
                      child: _TabCell(
                        item: items[i],
                        selected: i == selectedIndex,
                        enabled: !(onChanged == null),
                        activeColor: pillActiveLabelColor,
                        inactiveColor: inactiveColor,
                        onTap: onChanged == null ? null : () => onChanged!(i),
                        selectedIndex: selectedIndex,
                        indexInGroup: i,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static double _alignmentX(int index, int count) {
    if (count <= 1) return 0;
    // Map index ∈ [0, count-1] → alignment ∈ [-1, 1].
    return (index / (count - 1)) * 2 - 1;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LiqTabsVariant>('variant', variant))
      ..add(IntProperty('selectedIndex', selectedIndex))
      ..add(IntProperty('count', items.length));
  }
}

class _PillHighlight extends StatelessWidget {
  const _PillHighlight();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: LiqTabs.pillHighlightColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _TabCell extends StatelessWidget {
  const _TabCell({
    required this.item,
    required this.selected,
    required this.enabled,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
    required this.selectedIndex,
    required this.indexInGroup,
  });

  final LiqTabItem item;
  final bool selected;
  final bool enabled;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback? onTap;
  final int selectedIndex;
  final int indexInGroup;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;
    final children = <Widget>[];
    if (item.icon != null) {
      children.add(
        Icon(
          item.icon,
          size: 18,
          color: color,
          textDirection: TextDirection.ltr,
        ),
      );
    }
    if (item.label != null) {
      if (children.isNotEmpty) children.add(const SizedBox(width: 6));
      children.add(
        Flexible(
          child: Text(
            item.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      );
    }

    return Semantics(
      selected: selected,
      enabled: enabled,
      button: true,
      inMutuallyExclusiveGroup: true,
      label: item.label ?? 'tab',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
