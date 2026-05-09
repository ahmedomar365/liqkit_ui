import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class MenuDemoScreenV2 extends ConsumerStatefulWidget {
  const MenuDemoScreenV2({super.key});

  @override
  ConsumerState<MenuDemoScreenV2> createState() => _MenuDemoScreenV2State();
}

class _MenuDemoScreenV2State extends ConsumerState<MenuDemoScreenV2> {
  void _toast(String message) => LiqToastOverlay.show(context, message);

  List<Widget> _fileMenuRows(BuildContext ctx) {
    return <Widget>[
      LiqMenuItem(
        label: 'New File',
        subtitle: 'Create a new document',
        icon: const Icon(LiqMaterialIcons.insertDriveFile),
        trailing: const Text('⌘N', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast('New File');
        },
      ),
      LiqMenuItem(
        label: 'Open',
        subtitle: 'Open existing file',
        icon: const Icon(LiqMaterialIcons.folderOpen),
        trailing: const Text('⌘O', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast('Open');
        },
      ),
      LiqMenuItem(
        label: 'Save',
        icon: const Icon(LiqMaterialIcons.save),
        trailing: const Text('⌘S', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          _toast('Save');
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
          _toast('Print');
        },
      ),
      LiqMenuItem(
        label: 'Delete',
        icon: const Icon(LiqMaterialIcons.delete),
        style: LiqMenuItemStyle.destructive,
        onPressed: () {
          Navigator.of(ctx).pop();
          LiqToastOverlay.show(ctx, 'Delete', variant: LiqToastVariant.error);
        },
      ),
    ];
  }

  List<Widget> _editMenuRows(BuildContext ctx) {
    final shortcuts = <(String, IconData, String)>[
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
            _toast(label);
          },
        ),
    ];
  }

  List<Widget> _viewMenuRows(BuildContext ctx) {
    final entries = <(String, String)>[
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
            _toast(label);
          },
        ),
    ];
  }

  List<Widget> _windowMenuRows(BuildContext ctx) {
    return <Widget>[
      LiqMenuItem(
        label: 'Minimize',
        trailing: const Text('⌘M', style: TextStyle(fontSize: 13)),
        onPressed: () {
          Navigator.of(ctx).pop();
          LiqToastOverlay.show(ctx, 'Minimize');
        },
      ),
      LiqMenuItem(
        label: 'Zoom',
        onPressed: () {
          Navigator.of(ctx).pop();
          LiqToastOverlay.show(ctx, 'Zoom');
        },
      ),
      LiqMenuItem(
        label: 'Bring All to Front',
        onPressed: () {
          Navigator.of(ctx).pop();
          LiqToastOverlay.show(ctx, 'Bring All to Front');
        },
      ),
    ];
  }

  List<Widget> _helpMenuRows(BuildContext ctx) {
    final entries = <(String, IconData)>[
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
            LiqToastOverlay.show(ctx, label);
          },
        ),
    ];
  }

  List<Widget> _settingsMenuRows(BuildContext ctx) {
    return <Widget>[
      LiqMenuItem(
        label: 'Profile',
        subtitle: 'John Doe',
        icon: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: context.appleColors.blue,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'JD',
            style: TextStyle(color: LiqColors.white, fontSize: 11),
          ),
        ),
        onPressed: () => _toast('Profile'),
      ),
      LiqMenuItem(
        label: 'Preferences',
        subtitle: 'App settings',
        icon: const Icon(LiqIcons.settings),
        onPressed: () => _toast('Preferences'),
      ),
      LiqMenuItem(
        label: 'Notifications',
        icon: const Icon(LiqMaterialIcons.notifications),
        trailing:
            const LiqBadge(label: '3', variant: LiqBadgeVariant.destructive),
        onPressed: () => _toast('Notifications'),
      ),
      LiqMenuItem(
        label: 'Language',
        subtitle: 'English',
        icon: const Icon(LiqMaterialIcons.language),
        onPressed: () => _toast('Language'),
      ),
      LiqMenuItem(
        label: 'Sign Out',
        icon: const Icon(LiqMaterialIcons.logout),
        style: LiqMenuItemStyle.destructive,
        onPressed: () => LiqToastOverlay.show(
          ctx,
          'Sign Out',
          variant: LiqToastVariant.error,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Menus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Dropdown Menu',
              description:
                  'Anchored popup menu shown by tapping a trigger button.',
              child: Builder(
                builder: (ctx) => LiqButton(
                  label: 'Open File Menu',
                  leadingIcon: LiqIcons.folder,
                  onPressed: () async {
                    final box = ctx.findRenderObject()! as RenderBox;
                    final origin = box.localToGlobal(Offset.zero);
                    final pos = origin +
                        Offset(box.size.width / 2, box.size.height + 4);
                    await LiqMenu.showPopup<void>(
                      context: ctx,
                      position: pos,
                      width: 300,
                      children: _fileMenuRows(ctx),
                    );
                  },
                ),
              ),
            ),
            _Section(
              title: 'Context Menu',
              description:
                  'Long-press the surface to open an iOS-style context menu.',
              child: LiqContextMenuArea(
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
                      Icon(LiqMaterialIcons.touchApp,
                          size: 36, color: context.appleColors.blue),
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
              ),
            ),
            _Section(
              title: 'Menu Bar',
              description:
                  'macOS-style menu bar with multiple top-level entries.',
              child: Container(
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
                        LiqMenuBarItem(
                            title: 'File', items: _fileMenuRows(context)),
                        LiqMenuBarItem(
                            title: 'Edit', items: _editMenuRows(context)),
                        LiqMenuBarItem(
                            title: 'View', items: _viewMenuRows(context)),
                        LiqMenuBarItem(
                            title: 'Window', items: _windowMenuRows(context)),
                        LiqMenuBarItem(
                            title: 'Help', items: _helpMenuRows(context)),
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
              ),
            ),
            _Section(
              title: 'Inline Menu',
              description: 'Static menu rendered inline as part of the layout.',
              child: SizedBox(
                width: 300,
                child: LiqMenu(children: _settingsMenuRows(context)),
              ),
            ),
          ],
        ),
      ),
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
