import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/badges/liq_badge.dart';
import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

/// One item in a [LiqIconBar] or [LiqIconButtonGroup]. Tab-bar-style:
/// icon over an optional small label, with badge and selected state.
final class LiqIconBarItem extends StatelessWidget with Diagnosticable {
  /// Creates a toolbar/iconbar item.
  const LiqIconBarItem({
    required this.icon,
    this.label,
    this.badge,
    this.isSelected = false,
    this.disabled = false,
    this.selectedColor,
    this.semanticLabel,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String? label;
  final String? badge;
  final bool isSelected;
  final bool disabled;
  final Color? selectedColor;
  final String? semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final accent = selectedColor ?? LiqAppleColors.systemBlue;
    final inactive = isDark
        ? const Color(0xB2EBEBF5)
        : const Color(0xB23C3C43);
    final color = disabled
        ? inactive.withValues(alpha: 0.4)
        : (isSelected ? accent : inactive);
    return Semantics(
      button: true,
      enabled: !disabled,
      label: semanticLabel ?? label ?? 'toolbar item',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Icon(icon, size: 24, color: color),
                  if (badge != null)
                    Positioned(
                      right: -10,
                      top: -6,
                      child: LiqBadge(
                        label: badge,
                        variant: LiqBadgeVariant.destructive,
                      ),
                    ),
                ],
              ),
              if (label != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  label!,
                  style: LiqAppleTypography.caption2(brightness)
                      .copyWith(color: color),
                ),
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
      ..add(StringProperty('label', label))
      ..add(FlagProperty('isSelected', value: isSelected, ifTrue: 'selected'))
      ..add(FlagProperty('disabled', value: disabled, ifTrue: 'disabled'));
  }
}

/// Horizontal bar of [LiqIconBarItem]s with optional dividers between
/// them. Use as a tab-bar-style row above content or pinned to the
/// bottom of a frame.
final class LiqIconBar extends StatelessWidget with Diagnosticable {
  /// Creates a toolbar.
  const LiqIconBar({
    required this.items,
    this.showDividers = false,
    this.background,
    super.key,
  });

  final List<Widget> items;
  final bool showDividers;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final isDark = context.liqIsDark;
    final dividerColor = isDark
        ? const Color(0x33EBEBF5)
        : const Color(0x1A3C3C43);
    final fill = background ??
        (isDark
            ? const Color(0xCC1C1C1E)
            : const Color(0xCCFFFFFF));
    return Container(
      decoration: BoxDecoration(color: fill),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for (var i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0 && showDividers)
              Container(width: 1, height: 32, color: dividerColor),
            Expanded(child: Center(child: items[i])),
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('itemCount', items.length));
  }
}

/// Mutually-exclusive selection group of [LiqIconBarItem]-style icons.
/// Calls [onItemSelected] with the index of the tapped item.
final class LiqIconButtonGroup extends StatelessWidget with Diagnosticable {
  /// Creates an icon button group.
  const LiqIconButtonGroup({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    super.key,
  });

  final List<LiqIconBarItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < items.length; i++)
          LiqIconBarItem(
            icon: items[i].icon,
            label: items[i].label,
            isSelected: i == selectedIndex,
            disabled: items[i].disabled,
            selectedColor: items[i].selectedColor,
            semanticLabel: items[i].semanticLabel,
            onTap: onItemSelected == null ? null : () => onItemSelected!(i),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('selectedIndex', selectedIndex))
      ..add(IntProperty('itemCount', items.length));
  }
}

/// Floating glass toolbar — a horizontal pill of widgets rendered on
/// top of a [LiqGlassSurface]. Typically positioned above content via
/// a [Stack] + Positioned.
final class LiqFloatingToolbar extends StatelessWidget with Diagnosticable {
  /// Creates a floating toolbar.
  const LiqFloatingToolbar({
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    super.key,
  });

  final List<Widget> items;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return LiqGlassSurface(
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 4),
            items[i],
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('itemCount', items.length));
  }
}
