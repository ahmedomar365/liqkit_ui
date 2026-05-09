import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class ContextMenuDemoScreen extends ConsumerStatefulWidget {
  const ContextMenuDemoScreen({super.key});

  @override
  ConsumerState<ContextMenuDemoScreen> createState() =>
      _ContextMenuDemoScreenState();
}

class _ContextMenuDemoScreenState
    extends ConsumerState<ContextMenuDemoScreen> {
  String _lastAction = 'No action yet';

  void _record(String message) {
    setState(() => _lastAction = message);
    LiqToastOverlay.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Context Menus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Last action display
            LiqCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Icon(LiqMaterialIcons.infoOutline, color: context.appleColors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Last Action',
                            style: context.textStyles.footnote.secondary),
                        Text(
                          _lastAction,
                          style: context.textStyles.body.copyWith(
                            fontWeight: LiqAppleTypography.semibold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Basic Context Menu
            _section(
              title: 'Basic Context Menu',
              description: 'Long press the tile to show context menu',
              child: LiqContextMenuArea(
                items: <Widget>[
                  LiqMenuItem(
                    label: 'Share',
                    icon: const Icon(LiqIcons.share),
                    onPressed: () => _record('Share tapped'),
                  ),
                  LiqMenuItem(
                    label: 'Save to Photos',
                    icon: const Icon(LiqMaterialIcons.saveAlt),
                    onPressed: () => _record('Save to Photos tapped'),
                  ),
                  LiqMenuItem(
                    label: 'Copy',
                    icon: const Icon(LiqIcons.copy),
                    onPressed: () => _record('Copy tapped'),
                  ),
                  LiqMenuItem(
                    label: 'Delete',
                    icon: const Icon(LiqMaterialIcons.delete),
                    style: LiqMenuItemStyle.destructive,
                    onPressed: () => _record('Delete tapped'),
                  ),
                ],
                child: _imageTile('Long press me', LiqAppleColors.systemBlue,
                    LiqMaterialIcons.photoLibrary),
              ),
            ),

            // With Disabled Items
            _section(
              title: 'Menu with Disabled Items',
              description: 'Some items are disabled',
              child: LiqContextMenuArea(
                items: <Widget>[
                  LiqMenuItem(
                    label: 'Edit',
                    icon: const Icon(LiqIcons.edit),
                    onPressed: () => _record('Edit tapped'),
                  ),
                  LiqMenuItem(
                    label: 'Move',
                    icon: const Icon(LiqMaterialIcons.driveFileMove),
                    onPressed: () => _record('Move tapped'),
                  ),
                  const LiqMenuItem(
                    label: 'Archive',
                    icon: Icon(LiqMaterialIcons.archive),
                    onPressed: null,
                  ),
                  LiqMenuItem(
                    label: 'Delete',
                    icon: const Icon(LiqMaterialIcons.delete),
                    style: LiqMenuItemStyle.destructive,
                    onPressed: () => _record('Delete tapped'),
                  ),
                ],
                child: _imageTile(
                    'Some options disabled',
                    LiqAppleColors.systemPurple,
                    LiqIcons.lock),
              ),
            ),

            // Text Context Menu
            _section(
              title: 'Text Context Menu',
              description: 'Long press the text for text-specific actions',
              child: LiqContextMenuArea(
                items: <Widget>[
                  LiqMenuItem(
                    label: 'Copy',
                    icon: const Icon(LiqIcons.copy),
                    onPressed: () => _record('Copy text'),
                  ),
                  LiqMenuItem(
                    label: 'Select All',
                    icon: const Icon(LiqMaterialIcons.selectAll),
                    onPressed: () => _record('Select all text'),
                  ),
                  LiqMenuItem(
                    label: 'Look Up',
                    icon: const Icon(LiqIcons.search),
                    onPressed: () => _record('Look up text'),
                  ),
                  LiqMenuItem(
                    label: 'Translate',
                    icon: const Icon(LiqMaterialIcons.translate),
                    onPressed: () => _record('Translate text'),
                  ),
                  LiqMenuItem(
                    label: 'Share',
                    icon: const Icon(LiqIcons.share),
                    onPressed: () => _record('Share text'),
                  ),
                ],
                child: LiqCard(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                    'Long press this text to see context menu options.',
                    style: context.textStyles.body,
                  ),
                ),
              ),
            ),

            // List Item Context Menu
            _section(
              title: 'List Item Context Menu',
              description: 'Context menus in list items',
              child: Column(
                children: List<Widget>.generate(3, (index) {
                  final colors = <Color>[
                    LiqAppleColors.systemBlue,
                    LiqAppleColors.systemGreen,
                    LiqAppleColors.systemPurple,
                  ];
                  final icons = <IconData>[
                    LiqMaterialIcons.photo,
                    LiqMaterialIcons.documentScanner,
                    LiqMaterialIcons.musicNote,
                  ];
                  final titles = <String>[
                    'Photo Album',
                    'Document',
                    'Music Playlist',
                  ];
                  final subtitles = <String>['24 items', '3 pages', '15 songs'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: LiqContextMenuArea(
                      items: <Widget>[
                        LiqMenuItem(
                          label: 'Open',
                          icon: const Icon(LiqMaterialIcons.openInNew),
                          onPressed: () => _record('Open ${titles[index]}'),
                        ),
                        LiqMenuItem(
                          label: 'Edit',
                          icon: const Icon(LiqIcons.edit),
                          onPressed: () => _record('Edit ${titles[index]}'),
                        ),
                        LiqMenuItem(
                          label: 'Duplicate',
                          icon: const Icon(LiqMaterialIcons.contentCopy),
                          onPressed: () =>
                              _record('Duplicate ${titles[index]}'),
                        ),
                        LiqMenuItem(
                          label: 'Move to Folder',
                          icon: const Icon(LiqIcons.folder),
                          onPressed: () => _record('Move ${titles[index]}'),
                        ),
                        LiqMenuItem(
                          label: 'Delete',
                          icon: const Icon(LiqMaterialIcons.delete),
                          style: LiqMenuItemStyle.destructive,
                          onPressed: () =>
                              _record('Delete ${titles[index]}'),
                        ),
                      ],
                      child: LiqCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: colors[index],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icons[index], color: LiqColors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    titles[index],
                                    style: context.textStyles.body.copyWith(
                                      fontWeight: LiqAppleTypography.semibold,
                                    ),
                                  ),
                                  Text(
                                    subtitles[index],
                                    style: context.textStyles.caption1.secondary,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              LiqMaterialIcons.moreVert,
                              color: context.appleColors.secondaryLabel,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Programmatic Context Menu
            _section(
              title: 'Programmatic Context Menu',
              description: 'Show context menu on button tap',
              child: Column(
                children: <Widget>[
                  Builder(
                    builder: (ctx) => LiqButton(
                      label: 'Show Menu at Tap Location',
                      onPressed: () => _showProgrammaticMenu(ctx),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (ctx) => LiqButton(
                      label: 'Show Menu with Destructive Action',
                      style: LiqButtonStyle.borderedSecondary,
                      onPressed: () => _showDestructiveMenu(ctx),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showProgrammaticMenu(BuildContext localContext) async {
    final box = localContext.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset.zero);
    final position = origin + Offset(box.size.width / 2, box.size.height);
    await LiqMenu.showPopup<void>(
      context: localContext,
      position: position,
      width: 240,
      children: <Widget>[
        LiqMenuItem(
          label: 'Option 1',
          icon: const Icon(LiqMaterialIcons.looksOne),
          onPressed: () {
            Navigator.of(localContext).pop();
            _record('Option 1 selected');
          },
        ),
        LiqMenuItem(
          label: 'Option 2',
          icon: const Icon(LiqMaterialIcons.looksTwo),
          onPressed: () {
            Navigator.of(localContext).pop();
            _record('Option 2 selected');
          },
        ),
        LiqMenuItem(
          label: 'Option 3',
          icon: const Icon(LiqMaterialIcons.looks3),
          onPressed: () {
            Navigator.of(localContext).pop();
            _record('Option 3 selected');
          },
        ),
      ],
    );
  }

  Future<void> _showDestructiveMenu(BuildContext localContext) async {
    final box = localContext.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset.zero);
    final position = origin + Offset(box.size.width / 2, box.size.height);
    await LiqMenu.showPopup<void>(
      context: localContext,
      position: position,
      width: 240,
      children: <Widget>[
        LiqMenuItem(
          label: 'Save',
          icon: const Icon(LiqMaterialIcons.save),
          onPressed: () {
            Navigator.of(localContext).pop();
            _record('Saved');
          },
        ),
        LiqMenuItem(
          label: 'Export',
          icon: const Icon(LiqMaterialIcons.fileUpload),
          onPressed: () {
            Navigator.of(localContext).pop();
            _record('Exported');
          },
        ),
        LiqMenuItem(
          label: 'Reset',
          icon: const Icon(LiqMaterialIcons.restore),
          style: LiqMenuItemStyle.destructive,
          onPressed: () {
            Navigator.of(localContext).pop();
            _record('Reset');
          },
        ),
      ],
    );
  }

  Widget _imageTile(String label, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Icon(icon, size: 80, color: color),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          const SizedBox(height: 4),
          Text(description, style: context.textStyles.footnote.secondary),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
