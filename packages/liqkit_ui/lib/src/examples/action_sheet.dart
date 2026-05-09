/// Canonical action-sheet variants — single source of truth for the
/// showcase app and the liqkit.com previews.
///
/// Faithful 1:1 reproductions of every `_Section(...)` from
/// `apps/showcase_app/lib/screens/demos/action_sheet_demo_screen.dart`.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/action_sheets/liq_action_sheet.dart';
import 'package:liqkit_ui/src/components/alerts/liq_alert.dart';
import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/toasts/liq_toast.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

LiqAlertAction _cancel(BuildContext context) => LiqAlertAction(
      label: 'Cancel',
      onPressed: () => Navigator.of(context).pop(),
    );

void _pop(BuildContext context, String message,
    {LiqToastVariant variant = LiqToastVariant.info}) {
  Navigator.of(context).pop();
  LiqToastOverlay.show(context, message, variant: variant);
}

/// "Save to Photos / Share / Copy" with no title — the most common form.
final class ActionSheetStandardExample extends StatelessWidget {
  const ActionSheetStandardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqButton(
      label: 'Show Standard Action Sheet',
      onPressed: () => LiqActionSheet.show<void>(
        context: context,
        actions: <LiqAlertAction>[
          LiqAlertAction(
            label: 'Save to Photos',
            onPressed: () => _pop(context, 'Saved to Photos'),
          ),
          LiqAlertAction(
            label: 'Share',
            onPressed: () => _pop(context, 'Share action'),
          ),
          LiqAlertAction(
            label: 'Copy',
            onPressed: () => _pop(context, 'Copied'),
          ),
        ],
        cancelAction: _cancel(context),
      ),
    );
  }
}

/// Action sheet with a title + description above the actions.
final class ActionSheetWithTitleExample extends StatelessWidget {
  const ActionSheetWithTitleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqButton(
      label: 'Show Action Sheet with Title',
      onPressed: () => LiqActionSheet.show<void>(
        context: context,
        title: 'Choose an Action',
        description: 'Select what you would like to do with this item',
        actions: <LiqAlertAction>[
          LiqAlertAction(
            label: 'Edit',
            onPressed: () => _pop(context, 'Edit action'),
          ),
          LiqAlertAction(
            label: 'Duplicate',
            onPressed: () => _pop(context, 'Duplicate action'),
          ),
          LiqAlertAction(
            label: 'Move',
            onPressed: () => _pop(context, 'Move action'),
          ),
        ],
        cancelAction: _cancel(context),
      ),
    );
  }
}

/// Destructive primary action with an "Archive Instead" alternative.
final class ActionSheetDestructiveExample extends StatelessWidget {
  const ActionSheetDestructiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqButton(
      label: 'Show Destructive Action Sheet',
      destructive: true,
      onPressed: () => LiqActionSheet.show<void>(
        context: context,
        title: 'Delete Item?',
        description: 'This action cannot be undone',
        actions: <LiqAlertAction>[
          LiqAlertAction(
            label: 'Delete',
            style: LiqAlertActionStyle.destructive,
            onPressed: () => _pop(
              context,
              'Item deleted',
              variant: LiqToastVariant.error,
            ),
          ),
          LiqAlertAction(
            label: 'Archive Instead',
            style: LiqAlertActionStyle.filled,
            onPressed: () => _pop(context, 'Item archived'),
          ),
        ],
        cancelAction: _cancel(context),
      ),
    );
  }
}

/// Each action gets a leading glyph (Message / Mail / AirDrop / Copy Link).
final class ActionSheetWithIconsExample extends StatelessWidget {
  const ActionSheetWithIconsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqButton(
      label: 'Show Action Sheet with Icons',
      onPressed: () => LiqActionSheet.show<void>(
        context: context,
        title: 'Share',
        actions: <LiqAlertAction>[
          LiqAlertAction(
            label: 'Message',
            icon: LiqMaterialIcons.chatBubble,
            onPressed: () => _pop(context, 'Share via Message'),
          ),
          LiqAlertAction(
            label: 'Mail',
            icon: LiqIcons.mail,
            onPressed: () => _pop(context, 'Share via Mail'),
          ),
          LiqAlertAction(
            label: 'AirDrop',
            icon: LiqMaterialIcons.radiowavesLeft,
            onPressed: () => _pop(context, 'Share via AirDrop'),
          ),
          LiqAlertAction(
            label: 'Copy Link',
            icon: LiqIcons.link,
            onPressed: () => _pop(context, 'Link copied'),
          ),
        ],
        cancelAction: _cancel(context),
      ),
    );
  }
}

/// 10-row sheet to demonstrate the internal scroll behavior.
final class ActionSheetScrollableExample extends StatelessWidget {
  const ActionSheetScrollableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqButton(
      label: 'Show Scrollable Action Sheet',
      onPressed: () => LiqActionSheet.show<void>(
        context: context,
        title: 'Export Options',
        actions: List<LiqAlertAction>.generate(
          10,
          (index) => LiqAlertAction(
            label: 'Export Option ${index + 1}',
            onPressed: () => _pop(context, 'Selected Option ${index + 1}'),
          ),
        ),
        cancelAction: _cancel(context),
      ),
    );
  }
}

/// Compact variant — three quick actions, one filled, no cancel button.
final class ActionSheetCompactExample extends StatelessWidget {
  const ActionSheetCompactExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqButton(
      label: 'Show Compact Action Sheet',
      onPressed: () => LiqActionSheet.show<void>(
        context: context,
        actions: <LiqAlertAction>[
          LiqAlertAction(
            label: 'Quick Action 1',
            icon: LiqMaterialIcons.bolt,
            onPressed: () => _pop(context, 'Quick Action 1'),
          ),
          LiqAlertAction(
            label: 'Quick Action 2',
            icon: LiqIcons.star,
            onPressed: () => _pop(context, 'Quick Action 2'),
          ),
          LiqAlertAction(
            label: 'Quick Action 3',
            icon: LiqIcons.heart,
            style: LiqAlertActionStyle.filled,
            onPressed: () => _pop(context, 'Quick Action 3'),
          ),
        ],
      ),
    );
  }
}
