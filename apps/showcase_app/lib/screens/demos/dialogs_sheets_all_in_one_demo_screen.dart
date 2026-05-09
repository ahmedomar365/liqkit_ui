import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

import 'action_sheet_demo_screen.dart';
import 'alert_dialog_demo_screen.dart';
import 'sheets_demo_screen.dart';

/// Combined "Dialogs & Sheets" catalog page — every variant from
/// `AlertDialogDemoBody`, `ActionSheetDemoBody`, and `SheetsDemoBody`
/// rendered in one scroll under group headers, so the catalog tile
/// lands directly on the full demo (no intermediate "pick a component"
/// page).
class DialogsSheetsAllInOneDemoScreen extends ConsumerWidget {
  const DialogsSheetsAllInOneDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Dialogs & Sheets')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _GroupHeader(
              title: 'Alert Dialogs',
              description:
                  'iOS-style alert dialogs — simple / two-button / '
                  'three-button / destructive / text-input / password / '
                  'error / long-message / custom-content variants.',
            ),
            const AlertDialogDemoBody(),
            _GroupHeader(
              title: 'Action Sheets',
              description:
                  'Bottom-anchored action sheets for quick actions — '
                  'standard / titled / destructive / icon-rich / '
                  'scrollable / compact variants.',
            ),
            const ActionSheetDemoBody(),
            _GroupHeader(
              title: 'Sheets',
              description:
                  'Modal sheet container — bottom / full-screen / action '
                  '/ compact / custom-content variants, plus the '
                  'non-dismissible and destructive specials.',
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SheetsDemoBody(),
            ),
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
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
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
