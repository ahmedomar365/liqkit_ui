/// Canonical menu variants — single source of truth for the showcase
/// app and the liqkit.com previews.
///
/// Faithful 1:1 reproductions of every `_Section(...)` from
/// `apps/showcase_app/lib/screens/demos/menu_demo_screen_v2.dart`.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/badges/liq_badge.dart';
import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/context_menu/liq_context_menu_area.dart';
import 'package:liqkit_ui/src/components/menu/liq_menu.dart';
import 'package:liqkit_ui/src/components/menu/liq_menu_bar.dart';
import 'package:liqkit_ui/src/components/toasts/liq_toast.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui/src/foundation/liq_colors.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

void _toast(BuildContext ctx, String msg,
    {LiqToastVariant variant = LiqToastVariant.info}) =>
    LiqToastOverlay.show(ctx, msg, variant: variant);

List<Widget> _fileMenuRows(BuildContext ctx) => <Widget>[
      LiqMenuItem(
        label: 'New File',
        subtitle: 'Create a new document',
        icon: const Icon(LiqMaterialIcons.insertDriveFile),
        trailing: const Text('⌘N', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, 'New File');
        },
      ),
      LiqMenuItem(
        label: 'Open',
        subtitle: 'Open existing file',
        icon: const Icon(LiqMaterialIcons.folderOpen),
        trailing: const Text('⌘O', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, 'Open');
        },
      ),
      LiqMenuItem(
        label: 'Save',
        icon: const Icon(LiqMaterialIcons.save),
        trailing: const Text('⌘S', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, 'Save');
        },
      ),
      const LiqMenuItem(
        label: 'Export',
        icon: Icon(LiqIcons.upload),
        onPressed: null,
      ),
      LiqMenuItem(
        label: 'Print',
        icon: const Icon(LiqMaterialIcons.print),
        trailing: const Text('⌘P', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, 'Print');
        },
      ),
      LiqMenuItem(
        label: 'Delete',
        icon: const Icon(LiqMaterialIcons.delete),
        style: LiqMenuItemStyle.destructive,
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, 'Delete', variant: LiqToastVariant.error);
        },
      ),
    ];

List<Widget> _editMenuRows(BuildContext ctx) {
  const shortcuts = <(String, IconData, String)>[
    ('Undo', LiqMaterialIcons.undo, '⌘Z'),
    ('Redo', LiqMaterialIcons.redo, '⇧⌘Z'),
    ('Cut', LiqMaterialIcons.cut, '⌘X'),
    ('Copy', LiqIcons.copy, '⌘C'),
    ('Paste', LiqMaterialIcons.paste, '⌘V'),
    ('Select All', LiqMaterialIcons.selectAll, '⌘A'),
  ];
  return <Widget>[
    for (final (label, icon, shortcut) in shortcuts)
      LiqMenuItem(
        label: label,
        icon: Icon(icon),
        trailing: Text(shortcut, style: const TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, label);
        },
      ),
  ];
}

List<Widget> _viewMenuRows(BuildContext ctx) {
  const entries = <(String, String)>[
    ('Zoom In', '⌘+'),
    ('Zoom Out', '⌘-'),
    ('Actual Size', '⌘0'),
    ('Full Screen', '⌃⌘F'),
  ];
  return <Widget>[
    for (final (label, shortcut) in entries)
      LiqMenuItem(
        label: label,
        trailing: Text(shortcut, style: const TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, label);
        },
      ),
  ];
}

List<Widget> _windowMenuRows(BuildContext ctx) => <Widget>[
      LiqMenuItem(
        label: 'Minimize',
        trailing: const Text('⌘M', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, 'Minimize');
        },
      ),
      LiqMenuItem(
        label: 'Zoom',
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, 'Zoom');
        },
      ),
      LiqMenuItem(
        label: 'Bring All to Front',
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, 'Bring All to Front');
        },
      ),
    ];

List<Widget> _helpMenuRows(BuildContext ctx) {
  const entries = <(String, IconData)>[
    ('Documentation', LiqMaterialIcons.book),
    ('Release Notes', LiqMaterialIcons.newReleases),
    ('Report Issue', LiqMaterialIcons.bugReport),
    ('About', LiqIcons.info),
  ];
  return <Widget>[
    for (final (label, icon) in entries)
      LiqMenuItem(
        label: label,
        icon: Icon(icon),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast(ctx, label);
        },
      ),
  ];
}

List<Widget> _settingsMenuRows(BuildContext ctx) => <Widget>[
      LiqMenuItem(
        label: 'Profile',
        subtitle: 'John Doe',
        icon: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: ctx.appleColors.blue,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'JD',
            style: TextStyle(color: LiqColors.white, fontSize: 11),
          ),
        ),
        onPressed: () => _toast(ctx, 'Profile'),
      ),
      LiqMenuItem(
        label: 'Preferences',
        subtitle: 'App settings',
        icon: const Icon(LiqIcons.settings),
        onPressed: () => _toast(ctx, 'Preferences'),
      ),
      LiqMenuItem(
        label: 'Notifications',
        icon: const Icon(LiqMaterialIcons.notifications),
        trailing:
            const LiqBadge(label: '3', variant: LiqBadgeVariant.destructive),
        onPressed: () => _toast(ctx, 'Notifications'),
      ),
      LiqMenuItem(
        label: 'Language',
        subtitle: 'English',
        icon: const Icon(LiqMaterialIcons.language),
        onPressed: () => _toast(ctx, 'Language'),
      ),
      LiqMenuItem(
        label: 'Sign Out',
        icon: const Icon(LiqMaterialIcons.logout),
        style: LiqMenuItemStyle.destructive,
        onPressed: () =>
            _toast(ctx, 'Sign Out', variant: LiqToastVariant.error),
      ),
    ];

/// Anchored popup menu shown by tapping a trigger button.
final class MenuDropdownExample extends StatelessWidget {
  const MenuDropdownExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => LiqButton(
        label: 'Open File Menu',
        leadingIcon: LiqIcons.folder,
        onPressed: () async {
          final box = ctx.findRenderObject()! as RenderBox;
          final origin = box.localToGlobal(Offset.zero);
          final pos =
              origin + Offset(box.size.width / 2, box.size.height + 4);
          await LiqMenu.showPopup<void>(
            context: ctx,
            position: pos,
            width: 300,
            children: _fileMenuRows(ctx),
          );
        },
      ),
    );
  }
}

/// Long-press the surface to open an iOS-style context menu.
final class MenuContextExample extends StatelessWidget {
  const MenuContextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqContextMenuArea(
      menuWidth: 300,
      items: _fileMenuRows(context),
      child: Container(
        width: 220,
        height: 140,
        decoration: BoxDecoration(
          color: context.appleColors.blue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              LiqMaterialIcons.touchApp,
              size: 36,
              color: context.appleColors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              'Long press here',
              style: context.textStyles.body.copyWith(
                color: context.appleColors.blue,
                fontWeight: LiqAppleTypography.semibold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// macOS-style menu bar with multiple top-level entries.
final class MenuBarExample extends StatelessWidget {
  const MenuBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.appleColors.separator),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          LiqMenuBar(
            menuWidth: 300,
            items: <LiqMenuBarItem>[
              LiqMenuBarItem(title: 'File', items: _fileMenuRows(context)),
              LiqMenuBarItem(title: 'Edit', items: _editMenuRows(context)),
              LiqMenuBarItem(title: 'View', items: _viewMenuRows(context)),
              LiqMenuBarItem(
                  title: 'Window', items: _windowMenuRows(context)),
              LiqMenuBarItem(title: 'Help', items: _helpMenuRows(context)),
            ],
          ),
          Container(
            height: 200,
            color: context.appleColors.systemGroupedBackground,
            alignment: Alignment.center,
            child: Text(
              'Application Content Area',
              style: context.textStyles.body.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Static menu rendered inline as part of the layout.
final class MenuInlineExample extends StatelessWidget {
  const MenuInlineExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: LiqMenu(children: _settingsMenuRows(context)),
    );
  }
}
