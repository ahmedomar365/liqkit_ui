import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class ActivityViewDemoScreen extends ConsumerWidget {
  const ActivityViewDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const LiqScaffold(
      appBar: LiqAppBar(title: Text('Activity Views')),
      body: SingleChildScrollView(child: ActivityViewDemoBody()),
    );
  }
}

/// Body-only widget rendering every activity-view variant section.
/// Used standalone via [ActivityViewDemoScreen] and inside the combined
/// `ActivityIndicatorsAllInOneDemoScreen`.
class ActivityViewDemoBody extends ConsumerWidget {
  const ActivityViewDemoBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          _section(
            context: context,
            title: 'Share Sheet',
            child: LiqButton(
              label: 'Show Share Sheet',
              onPressed: () => _showShareSheet(context),
            ),
          ),
          _section(
            context: context,
            title: 'Share Sheet with Message',
            child: LiqButton(
              label: 'Share with Message',
              onPressed: () => _showShareSheetWithMessage(context),
            ),
          ),
          _section(
            context: context,
            title: 'Custom Activities',
            child: LiqButton(
              label: 'Show Custom Activities',
              onPressed: () => _showCustomActivities(context),
            ),
          ),
          _section(
            context: context,
            title: 'Activity Indicator',
            child: LiqButton(
              label: 'Show Loading',
              style: LiqButtonStyle.borderedSecondary,
              onPressed: () => _showActivityIndicator(context),
            ),
          ),
          _section(
            context: context,
            title: 'Progress Indicator',
            child: LiqButton(
              label: 'Show Progress',
              style: LiqButtonStyle.borderedSecondary,
              onPressed: () => _showProgressIndicator(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required BuildContext context, required String title, required Widget child}) {
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

  void _showShareSheet(BuildContext context) {
    LiqShareSheet.show(
      context: context,
      systemActivities: <LiqShareActivity>[
        LiqShareActivity(
          title: 'Message',
          icon: LiqMaterialIcons.chatBubbleFill,
          color: LiqAppleColors.systemGreen,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Opening Messages');
          },
        ),
        LiqShareActivity(
          title: 'Mail',
          icon: LiqMaterialIcons.mailSolid,
          color: LiqAppleColors.systemBlue,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Opening Mail');
          },
        ),
        LiqShareActivity(
          title: 'AirDrop',
          icon: LiqMaterialIcons.radiowavesLeft,
          color: LiqAppleColors.systemBlue,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'AirDrop ready');
          },
        ),
        LiqShareActivity(
          title: 'Copy',
          icon: LiqMaterialIcons.docOnClipboard,
          color: LiqAppleColors.systemGray,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Copied to clipboard');
          },
        ),
        LiqShareActivity(
          title: 'Print',
          icon: LiqMaterialIcons.printer,
          color: LiqAppleColors.systemGray,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Opening print dialog');
          },
        ),
      ],
      applicationActivities: <LiqShareActivity>[
        LiqShareActivity(
          title: 'Save to Photos',
          icon: LiqMaterialIcons.photo,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Saved to Photos');
          },
        ),
        LiqShareActivity(
          title: 'Add to Reading List',
          icon: LiqMaterialIcons.book,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Added to Reading List');
          },
        ),
        LiqShareActivity(
          title: 'Add Bookmark',
          icon: LiqIcons.bookmark,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Bookmark added');
          },
        ),
      ],
    );
  }

  void _showShareSheetWithMessage(BuildContext context) {
    LiqShareSheet.show(
      context: context,
      title: 'Share this document',
      message: 'Choose how you want to share this PDF document',
      systemActivities: <LiqShareActivity>[
        LiqShareActivity(
          title: 'Share',
          icon: LiqIcons.share,
          color: LiqAppleColors.systemBlue,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Share action');
          },
        ),
      ],
      applicationActivities: <LiqShareActivity>[
        LiqShareActivity(
          title: 'Save PDF',
          icon: LiqMaterialIcons.docFill,
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'PDF saved');
          },
        ),
      ],
    );
  }

  void _showCustomActivities(BuildContext context) {
    LiqShareSheet.show(
      context: context,
      systemActivities: <LiqShareActivity>[
        LiqShareActivity(
          title: 'Twitter',
          icon: LiqMaterialIcons.flutterDash,
          color: const Color(0xFF1DA1F2),
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Share to Twitter');
          },
        ),
        LiqShareActivity(
          title: 'Instagram',
          icon: LiqMaterialIcons.camera,
          color: const Color(0xFFE1306C),
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Share to Instagram');
          },
        ),
        LiqShareActivity(
          title: 'WhatsApp',
          icon: LiqMaterialIcons.chatBubbleFill,
          color: const Color(0xFF25D366),
          onTap: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Share to WhatsApp');
          },
        ),
      ],
    );
  }

  Future<void> _showActivityIndicator(BuildContext context) async {
    LiqActivityIndicatorView.show(
      context: context,
      message: 'Loading content...',
    );
    await Future<void>.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.of(context).pop();
      LiqToastOverlay.show(context, 'Loading complete');
    }
  }

  void _showProgressIndicator(BuildContext context) {
    showProgressDialog(context);
  }
}

void showProgressDialog(BuildContext context) {
  Navigator.of(context).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: const Color(0x66000000),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, animation, secondary) {
        return _ProgressDialogBody();
      },
    ),
  );
}

class _ProgressDialogBody extends StatefulWidget {
  @override
  State<_ProgressDialogBody> createState() => _ProgressDialogBodyState();
}

class _ProgressDialogBodyState extends State<_ProgressDialogBody> {
  double _progress = 0;
  late final Stream<int> _ticks;

  @override
  void initState() {
    super.initState();
    _ticks = Stream<int>.periodic(
      const Duration(milliseconds: 250),
      (i) => i,
    ).take(10);
    _ticks.listen((tick) {
      if (!mounted) return;
      setState(() => _progress = (tick + 1) / 10);
      if (tick == 9) {
        Future<void>.delayed(const Duration(milliseconds: 400), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LiqActivityIndicatorView(
        message: 'Uploading... ${(_progress * 100).toInt()}%',
        showProgress: true,
        progress: _progress,
      ),
    );
  }
}
