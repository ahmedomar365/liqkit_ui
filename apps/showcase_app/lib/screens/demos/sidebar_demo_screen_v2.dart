import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class SidebarDemoScreenV2 extends ConsumerStatefulWidget {
  const SidebarDemoScreenV2({super.key});

  @override
  ConsumerState<SidebarDemoScreenV2> createState() =>
      _SidebarDemoScreenV2State();
}

class _SidebarDemoScreenV2State extends ConsumerState<SidebarDemoScreenV2> {
  int _selectedIndex = 0;

  static const List<({String label, IconData icon, String? badge})> _navItems =
      <({String label, IconData icon, String? badge})>[
    (label: 'Dashboard', icon: LiqMaterialIcons.dashboard, badge: null),
    (label: 'Projects', icon: LiqIcons.folder, badge: '3'),
    (label: 'Team', icon: LiqMaterialIcons.people, badge: null),
    (label: 'Calendar', icon: LiqMaterialIcons.calendarToday, badge: null),
    (label: 'Messages', icon: LiqIcons.mail, badge: '12'),
    (label: 'Settings', icon: LiqIcons.settings, badge: null),
  ];

  void _selectItem(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Sidebars')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Standard Sidebar',
              description:
                  'Header, search, section, navigation rows, and footer.',
              child: _DemoFrame(
                child: _ResponsiveSidebarPreview(
                  sidebarBuilder: (width) => LiqSidebar(
                    width: width,
                    children: <Widget>[
                      _header(context),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: LiqSidebarSearch(),
                      ),
                      const LiqSidebarSectionHeader(title: 'Workspace'),
                      for (var i = 0; i < _navItems.length; i++)
                        LiqSidebarRow(
                          title: _navItems[i].label,
                          icon: Icon(_navItems[i].icon),
                          detail: _navItems[i].badge,
                          selected: _selectedIndex == i,
                          onPressed: () => _selectItem(i),
                        ),
                      const Spacer(),
                      _footer(context),
                    ],
                  ),
                  defaultWidth: 320,
                  contentBuilder: _contentArea,
                ),
              ),
            ),
            _Section(
              title: 'Mini Sidebar',
              description:
                  'Compact icon-only sidebar with badge dots for unread state.',
              child: _DemoFrame(
                child: _ResponsiveSidebarPreview(
                  defaultWidth: 76,
                  alwaysCompact: true,
                  contentBuilder: _contentArea,
                  sidebarBuilder: (width) => LiqSidebar(
                    width: width,
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: context.appleColors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        for (var i = 0; i < _navItems.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: GestureDetector(
                              onTap: () => _selectItem(i),
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: _selectedIndex == i
                                      ? context.appleColors.blue
                                          .withValues(alpha: 0.15)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        _navItems[i].icon,
                                        color: _selectedIndex == i
                                            ? context.appleColors.blue
                                            : context.appleColors.label,
                                      ),
                                    ),
                                    if (_navItems[i].badge != null)
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: LiqBadge(
                                          label: _navItems[i].badge,
                                          variant:
                                              LiqBadgeVariant.destructive,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            _Section(
              title: 'Custom Styled Sidebar',
              description: 'Sidebar with a gradient header card and footer profile.',
              child: _DemoFrame(
                child: _ResponsiveSidebarPreview(
                  defaultWidth: 320,
                  contentBuilder: _contentArea,
                  sidebarBuilder: (width) => LiqSidebar(
                    width: width,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              context.appleColors.purple,
                              context.appleColors.pink,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(LiqMaterialIcons.workspaces,
                                color: Color(0xFFFFFFFF), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Premium',
                              style: context.textStyles.body.copyWith(
                                color: const Color(0xFFFFFFFF),
                                fontWeight: LiqAppleTypography.semibold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const LiqSidebarSectionHeader(title: 'Spaces'),
                      for (var i = 0; i < _navItems.length; i++)
                        LiqSidebarRow(
                          title: _navItems[i].label,
                          icon: Icon(_navItems[i].icon),
                          detail: _navItems[i].badge,
                          selected: _selectedIndex == i,
                          onPressed: () => _selectItem(i),
                        ),
                      const Spacer(),
                      _footer(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.appleColors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Acme Inc',
                  style: context.textStyles.body.copyWith(
                    fontWeight: LiqAppleTypography.semibold,
                  ),
                ),
                Text(
                  'Workspace',
                  style: context.textStyles.caption1.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.appleColors.green,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'JD',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'John Doe',
              style: context.textStyles.footnote.copyWith(
                fontWeight: LiqAppleTypography.semibold,
              ),
            ),
          ),
          Icon(LiqMaterialIcons.moreHoriz,
              size: 18, color: context.appleColors.secondaryLabel),
        ],
      ),
    );
  }

  Widget _contentArea(BuildContext context) {
    return ColoredBox(
      color: context.appleColors.systemGroupedBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _navItems[_selectedIndex.clamp(0, _navItems.length - 1)].icon,
              size: 64,
              color: context.appleColors.gray,
            ),
            const SizedBox(height: 16),
            Text(
              _navItems[_selectedIndex.clamp(0, _navItems.length - 1)].label,
              style: context.textStyles.title2.copyWith(
                fontWeight: LiqAppleTypography.semibold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected sidebar destination',
              style: context.textStyles.body.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Lays out a sidebar + content-area preview side-by-side on wide
/// viewports, and collapses to a sidebar-only fullscreen view on
/// narrow ones (phones). The sidebar's intrinsic width is overridden
/// to fit the available space when collapsed.
class _ResponsiveSidebarPreview extends StatelessWidget {
  const _ResponsiveSidebarPreview({
    required this.sidebarBuilder,
    required this.contentBuilder,
    required this.defaultWidth,
    this.alwaysCompact = false,
  });

  /// Builds the sidebar at a given width.
  final Widget Function(double width) sidebarBuilder;

  /// Builds the right-side content area shown on wide viewports.
  final Widget Function(BuildContext context) contentBuilder;

  /// Native sidebar width when there is room for the side-by-side layout.
  final double defaultWidth;

  /// When true, never expand: the sidebar always stays at [defaultWidth]
  /// and a content area sits beside it (used for the mini icon sidebar).
  final bool alwaysCompact;

  static const double _wideBreakpoint = 520;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mini sidebar (alwaysCompact): keep its tight icon-only width
        // and put the content area beside it. On a phone this still
        // fits — 76 + content ≈ frame width.
        if (alwaysCompact) {
          return Row(
            children: <Widget>[
              sidebarBuilder(defaultWidth),
              Expanded(child: contentBuilder(context)),
            ],
          );
        }
        // Standard / custom sidebars: on narrow viewports, drop the
        // squeezed content panel and let the sidebar fill the frame.
        if (constraints.maxWidth < _wideBreakpoint) {
          return sidebarBuilder(constraints.maxWidth);
        }
        return Row(
          children: <Widget>[
            sidebarBuilder(defaultWidth),
            Expanded(child: contentBuilder(context)),
          ],
        );
      },
    );
  }
}

class _DemoFrame extends StatelessWidget {
  const _DemoFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      decoration: BoxDecoration(
        border: Border.all(color: context.appleColors.separator),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
