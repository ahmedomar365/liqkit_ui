import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/glass/liq_glass_surface.dart';
import 'package:liqkit_ui/src/components/shared/liq_pointer_cursor.dart';
import 'package:liqkit_ui/src/components/shared/liq_scrubbable_index_surface.dart';
import 'package:liqkit_ui/src/foundation/liq_motion.dart';
import 'package:liqkit_ui/src/theme/liq_theme_resolver.dart';

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

/// iOS 26 bottom tab bar — a horizontal row of 2 to 5 stacked icon + label
/// items selecting between top-level app sections.
///
/// Sourced from the local iOS 26 tab-bar Figma/native artifact:
/// inset from the screen edge, rounded Liquid Glass button group,
/// 20pt backdrop blur, 49pt tab content, 18pt symbol, 10pt label,
/// and a rounded selected-tab fill.
final class LiqBottomNavBar extends StatefulWidget {
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

  /// Content height of the bar, excluding the bottom safe-area inset.
  static const double contentHeight = 49;

  /// Icon size — rendered in the 28pt symbol line from the iOS 26 artifact.
  static const double iconSize = 23;

  /// Gap between icon and label.
  static const double iconLabelGap = 0.5;

  /// Tint of the currently selected tab — iOS system blue.
  static const Color activeColor = Color(0xFF007AFF);

  /// Tint of unselected tabs — iOS system grey.
  static const Color inactiveColor = Color(0xFF8E8E93);

  /// Opacity applied to the whole bar when [onChanged] is null.
  static const double disabledOpacity = 0.4;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(999));
  static const EdgeInsets _outerPadding = EdgeInsets.fromLTRB(25, 16, 25, 25);
  static const EdgeInsets _surfacePadding = EdgeInsets.fromLTRB(2, 0, 10, 0);

  @override
  State<LiqBottomNavBar> createState() => _LiqBottomNavBarState();

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

final class _LiqBottomNavBarState extends State<LiqBottomNavBar> {
  int? _previewIndex;

  @override
  void didUpdateWidget(covariant LiqBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    final isDisabled = widget.onChanged == null;
    final itemCountChanged = widget.items.length != oldWidget.items.length;
    final previewOutOfRange =
        _previewIndex != null && _previewIndex! >= widget.items.length;

    if (isDisabled || itemCountChanged || previewOutOfRange) {
      _previewIndex = null;
    }
  }

  int get _clampedCurrentIndex {
    final currentIndex = widget.currentIndex;
    if (currentIndex < 0) {
      return 0;
    }
    if (currentIndex >= widget.items.length) {
      return widget.items.length - 1;
    }
    return currentIndex;
  }

  void _preview(int index) {
    if (_previewIndex == index) {
      return;
    }
    setState(() => _previewIndex = index);
  }

  void _commit(int index) {
    setState(() => _previewIndex = null);
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final palette = _BottomNavPalette.resolve(context);
    final disabled = widget.onChanged == null;
    final bottomInset = MediaQuery.maybeOf(context)?.padding.bottom ?? 0;
    final selectedIndex = _previewIndex ?? _clampedCurrentIndex;
    final duration = context.liqMotionDuration(LiqMotion.normal);

    final bar = Padding(
      padding: LiqBottomNavBar._outerPadding.add(
        EdgeInsets.only(bottom: bottomInset),
      ),
      child: LiqGlassSurface(
        elevation: LiqGlassElevation.flat,
        borderRadius: LiqBottomNavBar._radius,
        padding: LiqBottomNavBar._surfacePadding,
        tint: palette.tint,
        baseFill: palette.surface,
        rimColor: palette.rim,
        highlightStart: palette.highlight,
        blurSigma: 20,
        shadows: palette.shadows,
        child: SizedBox(
          height: LiqBottomNavBar.contentHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final tabWidth = width / widget.items.length;
              return LiqScrubbableIndexSurface(
                count: widget.items.length,
                enabled: !disabled,
                onPreview: _preview,
                onCommit: _commit,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: duration,
                      curve: LiqMotion.snappy,
                      left: tabWidth * selectedIndex,
                      top: 0,
                      bottom: 0,
                      width: tabWidth - 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: palette.selection,
                          borderRadius: LiqBottomNavBar._radius,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        for (var i = 0; i < widget.items.length; i++)
                          Expanded(
                            child: _buildTab(
                              context,
                              i,
                              activeIndex: selectedIndex,
                              disabled: disabled,
                              palette: palette,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    final animated = AnimatedOpacity(
      duration: context.liqMotionDuration(LiqMotion.fast),
      curve: LiqMotion.snappy,
      opacity: disabled ? LiqBottomNavBar.disabledOpacity : 1,
      child: bar,
    );

    return SafeArea(top: false, left: false, right: false, child: animated);
  }

  Widget _buildTab(
    BuildContext context,
    int index, {
    required int activeIndex,
    required bool disabled,
    required _BottomNavPalette palette,
  }) {
    final item = widget.items[index];
    final isActive = index == activeIndex;
    final color = isActive ? palette.active : palette.inactive;

    return Semantics(
      button: true,
      enabled: !disabled,
      selected: isActive,
      inMutuallyExclusiveGroup: true,
      label: item.label,
      onTap: disabled ? null : () => widget.onChanged?.call(index),
      child: LiqPointerCursor(
        enabled: !disabled,
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(item.icon, size: LiqBottomNavBar.iconSize, color: color),
              const SizedBox(height: LiqBottomNavBar.iconLabelGap),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontFamilyFallback: const <String>['SF Pro', 'sans-serif'],
                  fontSize: 10,
                  height: 12 / 10,
                  letterSpacing: -0.1,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _BottomNavPalette {
  const _BottomNavPalette({
    required this.active,
    required this.inactive,
    required this.selection,
    required this.surface,
    required this.rim,
    required this.highlight,
    required this.tint,
    required this.shadows,
  });

  factory _BottomNavPalette.resolve(BuildContext context) {
    if (!context.liqIsDark) {
      return const _BottomNavPalette(
        active: LiqBottomNavBar.activeColor,
        inactive: Color(0xFF1A1A1A),
        selection: Color(0xFFEDEDED),
        surface: Color(0xDFF7F7F7),
        rim: Color(0x20FFFFFF),
        highlight: Color(0x22FFFFFF),
        tint: LiqGlassTint.light,
        shadows: <BoxShadow>[
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      );
    }

    return _BottomNavPalette(
      active: context.liqPrimaryColor,
      inactive: const Color(0xE6F5F5F5),
      selection: const Color(0x1AFFFFFF),
      surface: const Color(0xD9141416),
      rim: const Color(0x24FFFFFF),
      highlight: const Color(0x05FFFFFF),
      tint: LiqGlassTint.dark,
      shadows: <BoxShadow>[
        const BoxShadow(
          color: Color(0x66000000),
          offset: Offset(0, 16),
          blurRadius: 34,
        ),
      ],
    );
  }

  final Color active;
  final Color inactive;
  final Color selection;
  final Color surface;
  final Color rim;
  final Color highlight;
  final LiqGlassTint tint;
  final List<BoxShadow> shadows;
}
