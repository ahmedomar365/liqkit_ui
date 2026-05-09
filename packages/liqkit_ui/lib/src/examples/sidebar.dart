/// Canonical sidebar variants — single source of truth for the showcase
/// app and the liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/badges/liq_badge.dart';
import 'package:liqkit_ui/src/components/sidebars/liq_sidebar.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

const List<({String label, IconData icon, String? badge})> _kNavItems =
    <({String label, IconData icon, String? badge})>[
  (label: 'Dashboard', icon: LiqMaterialIcons.dashboard, badge: null),
  (label: 'Projects', icon: LiqIcons.folder, badge: '3'),
  (label: 'Team', icon: LiqMaterialIcons.people, badge: null),
  (label: 'Calendar', icon: LiqMaterialIcons.calendarToday, badge: null),
  (label: 'Messages', icon: LiqIcons.mail, badge: '12'),
  (label: 'Settings', icon: LiqIcons.settings, badge: null),
];

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
              Text('Workspace', style: context.textStyles.caption1.secondary),
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
        Icon(
          LiqMaterialIcons.moreHoriz,
          size: 18,
          color: context.appleColors.secondaryLabel,
        ),
      ],
    ),
  );
}

/// Header, search, section, navigation rows, and footer.
final class SidebarStandardExample extends StatefulWidget {
  const SidebarStandardExample({super.key});

  @override
  State<SidebarStandardExample> createState() => _SidebarStandardExampleState();
}

class _SidebarStandardExampleState extends State<SidebarStandardExample> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: LiqSidebar(
        children: <Widget>[
          _header(context),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: LiqSidebarSearch(),
          ),
          const LiqSidebarSectionHeader(title: 'Workspace'),
          for (var i = 0; i < _kNavItems.length; i++)
            LiqSidebarRow(
              title: _kNavItems[i].label,
              icon: Icon(_kNavItems[i].icon),
              detail: _kNavItems[i].badge,
              selected: _selected == i,
              onPressed: () => setState(() => _selected = i),
            ),
          const Spacer(),
          _footer(context),
        ],
      ),
    );
  }
}

/// Compact icon-only sidebar with badge dots for unread state.
final class SidebarMiniExample extends StatefulWidget {
  const SidebarMiniExample({super.key});

  @override
  State<SidebarMiniExample> createState() => _SidebarMiniExampleState();
}

class _SidebarMiniExampleState extends State<SidebarMiniExample> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: LiqSidebar(
        width: 76,
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
          for (var i = 0; i < _kNavItems.length; i++)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _selected == i
                        ? context.appleColors.blue.withValues(alpha: 0.15)
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          _kNavItems[i].icon,
                          color: _selected == i
                              ? context.appleColors.blue
                              : context.appleColors.label,
                        ),
                      ),
                      if (_kNavItems[i].badge != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: LiqBadge(
                            label: _kNavItems[i].badge,
                            variant: LiqBadgeVariant.destructive,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Sidebar with a gradient header card and footer profile.
final class SidebarCustomStyledExample extends StatefulWidget {
  const SidebarCustomStyledExample({super.key});

  @override
  State<SidebarCustomStyledExample> createState() =>
      _SidebarCustomStyledExampleState();
}

class _SidebarCustomStyledExampleState
    extends State<SidebarCustomStyledExample> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: LiqSidebar(
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
                const Icon(
                  LiqMaterialIcons.workspaces,
                  color: Color(0xFFFFFFFF),
                  size: 20,
                ),
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
          for (var i = 0; i < _kNavItems.length; i++)
            LiqSidebarRow(
              title: _kNavItems[i].label,
              icon: Icon(_kNavItems[i].icon),
              detail: _kNavItems[i].badge,
              selected: _selected == i,
              onPressed: () => setState(() => _selected = i),
            ),
          const Spacer(),
          _footer(context),
        ],
      ),
    );
  }
}
