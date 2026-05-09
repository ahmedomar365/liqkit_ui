import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

class ActionSheetDemoScreen extends ConsumerWidget {
  const ActionSheetDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const LiqScaffold(
      appBar: LiqAppBar(title: Text('Action Sheets')),
      body: SingleChildScrollView(child: ActionSheetDemoBody()),
    );
  }
}

/// Body-only widget rendering every action-sheet variant section.
/// Used standalone via [ActionSheetDemoScreen] and inside the combined
/// `DialogsSheetsAllInOneDemoScreen`.
class ActionSheetDemoBody extends ConsumerWidget {
  const ActionSheetDemoBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          _Section(
            title: 'Standard Action Sheet',
            child: LiqButton(
              label: 'Show Standard Action Sheet',
              onPressed: () => _showStandardActionSheet(context),
            ),
          ),
          _Section(
            title: 'Action Sheet with Title',
            child: LiqButton(
              label: 'Show Action Sheet with Title',
              onPressed: () => _showActionSheetWithTitle(context),
            ),
          ),
          _Section(
            title: 'Destructive Action Sheet',
            child: LiqButton(
              label: 'Show Destructive Action Sheet',
              destructive: true,
              onPressed: () => _showDestructiveActionSheet(context),
            ),
          ),
          _Section(
            title: 'Action Sheet with Icons',
            child: LiqButton(
              label: 'Show Action Sheet with Icons',
              onPressed: () => _showActionSheetWithIcons(context),
            ),
          ),
          _Section(
            title: 'Scrollable Action Sheet',
            child: LiqButton(
              label: 'Show Scrollable Action Sheet',
              onPressed: () => _showScrollableActionSheet(context),
            ),
          ),
          _Section(
            title: 'Compact Action Sheet',
            child: LiqButton(
              label: 'Show Compact Action Sheet',
              onPressed: () => _showCompactActionSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showStandardActionSheet(BuildContext context) {
    LiqActionSheet.show<void>(
      context: context,
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Save to Photos',
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Saved to Photos');
          },
        ),
        LiqAlertAction(
          label: 'Share',
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Share action');
          },
        ),
        LiqAlertAction(
          label: 'Copy',
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Copied');
          },
        ),
      ],
      cancelAction: LiqAlertAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showActionSheetWithTitle(BuildContext context) {
    LiqActionSheet.show<void>(
      context: context,
      title: 'Choose an Action',
      description: 'Select what you would like to do with this item',
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Edit',
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Edit action');
          },
        ),
        LiqAlertAction(
          label: 'Duplicate',
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Duplicate action');
          },
        ),
        LiqAlertAction(
          label: 'Move',
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Move action');
          },
        ),
      ],
      cancelAction: LiqAlertAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showDestructiveActionSheet(BuildContext context) {
    LiqActionSheet.show<void>(
      context: context,
      title: 'Delete Item?',
      description: 'This action cannot be undone',
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Delete',
          style: LiqAlertActionStyle.destructive,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(
              context,
              'Item deleted',
              variant: LiqToastVariant.error,
            );
          },
        ),
        LiqAlertAction(
          label: 'Archive Instead',
          style: LiqAlertActionStyle.filled,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Item archived');
          },
        ),
      ],
      cancelAction: LiqAlertAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showActionSheetWithIcons(BuildContext context) {
    LiqActionSheet.show<void>(
      context: context,
      title: 'Share',
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Message',
          icon: LiqMaterialIcons.chatBubble,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Share via Message');
          },
        ),
        LiqAlertAction(
          label: 'Mail',
          icon: LiqIcons.mail,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Share via Mail');
          },
        ),
        LiqAlertAction(
          label: 'AirDrop',
          icon: LiqMaterialIcons.radiowavesLeft,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Share via AirDrop');
          },
        ),
        LiqAlertAction(
          label: 'Copy Link',
          icon: LiqIcons.link,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Link copied');
          },
        ),
      ],
      cancelAction: LiqAlertAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showScrollableActionSheet(BuildContext context) {
    LiqActionSheet.show<void>(
      context: context,
      title: 'Export Options',
      actions: List<LiqAlertAction>.generate(10, (index) {
        return LiqAlertAction(
          label: 'Export Option ${index + 1}',
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Selected Option ${index + 1}');
          },
        );
      }),
      cancelAction: LiqAlertAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showCompactActionSheet(BuildContext context) {
    LiqActionSheet.show<void>(
      context: context,
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Quick Action 1',
          icon: LiqMaterialIcons.bolt,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Quick Action 1');
          },
        ),
        LiqAlertAction(
          label: 'Quick Action 2',
          icon: LiqIcons.star,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Quick Action 2');
          },
        ),
        LiqAlertAction(
          label: 'Quick Action 3',
          icon: LiqIcons.heart,
          style: LiqAlertActionStyle.filled,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Quick Action 3');
          },
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
