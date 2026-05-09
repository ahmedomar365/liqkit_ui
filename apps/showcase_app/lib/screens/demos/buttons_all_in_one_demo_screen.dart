import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import 'button_demo_screen.dart';
import 'popup_button_demo_screen_v2.dart';

/// Combined "Buttons" catalog page — every variant from
/// `ButtonDemoBody` and `PopupButtonDemoBody` rendered in one scroll
/// under group headers, so the catalog tile lands directly on the
/// full demo (no intermediate "pick a component" page).
class ButtonsAllInOneDemoScreen extends ConsumerWidget {
  const ButtonsAllInOneDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Buttons')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _GroupHeader(
              title: 'Buttons',
              description:
                  'Every `LiqButton` variant — primary, secondary, '
                  'destructive, ghost, with icons, sized, and the '
                  'icon-button family.',
            ),
            const ButtonDemoBody(),
            const SizedBox(height: 8),
            _GroupHeader(
              title: 'Popup Buttons',
              description:
                  'Trigger buttons that open a menu — popup (single-value '
                  'selection), pull-down (action menu), and split '
                  '(primary + chevron).',
            ),
            const PopupButtonDemoBody(),
          ],
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title1.copyWith(
              fontWeight: LiqAppleTypography.bold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              description!,
              style: context.textStyles.subheadline.secondary,
            ),
          ],
        ],
      ),
    );
  }
}
