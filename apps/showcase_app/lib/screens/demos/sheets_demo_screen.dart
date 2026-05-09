import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

class SheetsDemoScreen extends ConsumerWidget {
  const SheetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const LiqScaffold(
      appBar: LiqAppBar(title: Text('Sheets')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: SheetsDemoBody(),
      ),
    );
  }
}

/// Body-only widget rendering every sheet variant section.
/// Used standalone via [SheetsDemoScreen] and inside the combined
/// `DialogsSheetsAllInOneDemoScreen`.
class SheetsDemoBody extends ConsumerStatefulWidget {
  const SheetsDemoBody({super.key});

  @override
  ConsumerState<SheetsDemoBody> createState() => _SheetsDemoBodyState();
}

class _SheetsDemoBodyState extends ConsumerState<SheetsDemoBody> {
  void _toast(String message) => LiqToastOverlay.show(context, message);

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Bottom Sheet',
              description:
                  'Modal sheet anchored to the bottom of the screen — '
                  '`LiqSheet.show` with `variant: fullScreen`.',
              child: LiqButton(
                label: 'Show Bottom Sheet',
                fullWidth: true,
                onPressed: () => _showBottomSheet(),
              ),
            ),
            _Section(
              title: 'Full Screen Sheet',
              description:
                  'Sheet that takes nearly the full viewport — for forms '
                  'and detail content.',
              child: LiqButton(
                label: 'Show Full Screen Sheet',
                fullWidth: true,
                onPressed: () => _showFullScreen(),
              ),
            ),
            _Section(
              title: 'Action Sheet',
              description:
                  'iOS-style action sheet with title, description, '
                  'multiple actions, optional destructive style, and a '
                  'cancel action.',
              child: LiqButton(
                label: 'Show Action Sheet',
                fullWidth: true,
                onPressed: () => _showActionSheet(),
              ),
            ),
            _Section(
              title: 'Compact Action Sheet',
              description:
                  'Minimal action sheet without a title block — pure '
                  'list of actions.',
              child: LiqButton(
                label: 'Show Compact Sheet',
                fullWidth: true,
                onPressed: () => _showCompactSheet(),
              ),
            ),
            _Section(
              title: 'Custom Content Sheet',
              description:
                  'Bottom sheet with arbitrary scrollable content — '
                  'profile cards, recent activity lists, etc.',
              child: LiqButton(
                label: 'Show Custom Content Sheet',
                fullWidth: true,
                onPressed: () => _showCustomContentSheet(),
              ),
            ),
            _Section(
              title: 'Sheet — Non-Dismissible',
              description:
                  'Pass `barrierDismissible: false` to require an '
                  'explicit choice (the user can\'t tap outside to close).',
              child: LiqButton(
                label: 'Show Non-Dismissible Sheet',
                fullWidth: true,
                onPressed: () => _showNonDismissibleSheet(),
              ),
            ),
            _Section(
              title: 'Action Sheet — Destructive',
              description:
                  'Action sheet with a destructive primary action '
                  '(red label).',
              child: LiqButton(
                label: 'Show Destructive Action Sheet',
                fullWidth: true,
                destructive: true,
                onPressed: () => _showDestructiveActionSheet(),
              ),
            ),
          ],
        );
  }

  void _showBottomSheet() {
    LiqSheet.show<void>(
      context: context,
      title: 'Bottom Sheet',
      variant: LiqSheetVariant.fullScreen,
      height: 480,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          for (var i = 0; i < 10; i++)
            LiqListRow(
              title: 'Item ${i + 1}',
              subtitle: 'Subtitle for item ${i + 1}',
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.appleColors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(LiqIcons.folder,
                    color: context.appleColors.blue),
              ),
              showChevron: true,
              onTap: () {},
            ),
        ],
      ),
    );
  }

  void _showFullScreen() {
    LiqSheet.show<void>(
      context: context,
      title: 'Full Screen Sheet',
      variant: LiqSheetVariant.fullScreen,
      height: 640,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: context.appleColors.gray.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(LiqIcons.image,
                    size: 64, color: context.appleColors.gray),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Full Screen Content',
              style: context.textStyles.largeTitle.copyWith(
                fontWeight: LiqAppleTypography.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A full screen sheet that slides up from the bottom — '
              "useful for detail content or multi-step forms that need "
              'more vertical space.',
              style: context.textStyles.body,
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < 5; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LiqCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Section ${i + 1}',
                        style: context.textStyles.headline.copyWith(
                          fontWeight: LiqAppleTypography.semibold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        style: context.textStyles.body.secondary,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showActionSheet() {
    LiqActionSheet.show<void>(
      context: context,
      title: 'Choose an Action',
      description: 'Select what you want to do with this item',
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Share',
          icon: LiqIcons.share,
          onPressed: () {
            Navigator.of(context).pop();
            _toast('Share');
          },
        ),
        LiqAlertAction(
          label: 'Save to Files',
          icon: LiqIcons.folder,
          onPressed: () {
            Navigator.of(context).pop();
            _toast('Saved to Files');
          },
        ),
        LiqAlertAction(
          label: 'Copy Link',
          icon: LiqIcons.link,
          onPressed: () {
            Navigator.of(context).pop();
            _toast('Link copied');
          },
        ),
        LiqAlertAction(
          label: 'Delete',
          icon: LiqMaterialIcons.delete,
          style: LiqAlertActionStyle.destructive,
          onPressed: () {
            Navigator.of(context).pop();
            _toast('Deleted');
          },
        ),
      ],
      cancelAction: LiqAlertAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showCompactSheet() {
    LiqActionSheet.show<void>(
      context: context,
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Add to Favorites',
          icon: LiqMaterialIcons.favoriteBorder,
          onPressed: () {
            Navigator.of(context).pop();
            _toast('Added to favorites');
          },
        ),
        LiqAlertAction(
          label: 'Download',
          icon: LiqIcons.download,
          onPressed: () {
            Navigator.of(context).pop();
            _toast('Downloading');
          },
        ),
        LiqAlertAction(
          label: 'Report',
          icon: LiqMaterialIcons.flag,
          onPressed: () {
            Navigator.of(context).pop();
            _toast('Reported');
          },
        ),
      ],
    );
  }

  void _showNonDismissibleSheet() {
    LiqSheet.show<void>(
      context: context,
      title: 'Confirm Action',
      variant: LiqSheetVariant.fullScreen,
      height: 320,
      barrierDismissible: false,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(LiqIcons.warning,
                size: 48, color: context.appleColors.orange),
            const SizedBox(height: 16),
            Text(
              'You must choose an option to dismiss this sheet.',
              textAlign: TextAlign.center,
              style: context.textStyles.body,
            ),
            const SizedBox(height: 24),
            LiqButton(
              label: 'OK',
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDestructiveActionSheet() {
    LiqActionSheet.show<void>(
      context: context,
      title: 'Delete Item?',
      description:
          'This will permanently remove the item from your library.',
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Delete',
          icon: LiqMaterialIcons.delete,
          style: LiqAlertActionStyle.destructive,
          onPressed: () {
            Navigator.of(context).pop();
            _toast('Deleted');
          },
        ),
      ],
      cancelAction: LiqAlertAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showCustomContentSheet() {
    LiqSheet.show<void>(
      context: context,
      title: 'Custom Content',
      variant: LiqSheetVariant.fullScreen,
      height: 600,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        context.appleColors.blue,
                        context.appleColors.purple,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    LiqMaterialIcons.accountCircle,
                    color: LiqColors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'John Doe',
                      style: context.textStyles.headline.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: context.textStyles.subheadline.secondary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Recent Activity',
              style: context.textStyles.headline.copyWith(
                fontWeight: LiqAppleTypography.semibold,
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < 5; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LiqCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        i.isEven ? LiqIcons.upload : LiqIcons.download,
                        color: context.appleColors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              i.isEven
                                  ? 'Uploaded file_${i + 1}.pdf'
                                  : 'Downloaded report_${i + 1}.zip',
                              style: context.textStyles.body,
                            ),
                            Text(
                              '${i + 1} hour${i == 0 ? '' : 's'} ago',
                              style:
                                  context.textStyles.caption1.secondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
            Text(description!,
                style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
