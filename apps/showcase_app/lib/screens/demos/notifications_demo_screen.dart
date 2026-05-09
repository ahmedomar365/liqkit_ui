import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class NotificationsDemoScreen extends ConsumerStatefulWidget {
  const NotificationsDemoScreen({super.key});

  @override
  ConsumerState<NotificationsDemoScreen> createState() =>
      _NotificationsDemoScreenState();
}

class _NotificationsDemoScreenState
    extends ConsumerState<NotificationsDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Notifications')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'Banners — All Styles',
              description:
                  'Inline banners shown above page content. One per style with close + actions.',
              child: NotificationBannersAllStylesExample(),
            ),
            _Section(
              title: 'Banner Configurations',
              description:
                  'Same `LiqBanner` with each option axis toggled — close '
                  'button, icon, actions — so the impact of each prop is '
                  'directly comparable.',
              child: NotificationBannerConfigurationsExample(),
            ),
            _Section(
              title: 'Toast — Variants',
              description:
                  'Brief floating messages that auto-dismiss. Tap to surface '
                  'each `LiqToastVariant`.',
              child: NotificationToastVariantsExample(),
            ),
            _Section(
              title: 'Notification Cards',
              description:
                  'Rich in-app notification cards with title, subtitle, body, and inline actions.',
              child: NotificationCardsExample(),
            ),
            _Section(
              title: 'Badges — All Variants',
              description:
                  'Every `LiqBadgeVariant` value rendered with a sample count.',
              child: NotificationBadgesAllVariantsExample(),
            ),
            _Section(
              title: 'Badges — Common Anchors',
              description:
                  'Badges anchored to icons, app tiles, and inline rows.',
              child: NotificationBadgesCommonAnchorsExample(),
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
