import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

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
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          _Section(
            title: 'Standard Action Sheet',
            child: ActionSheetStandardExample(),
          ),
          _Section(
            title: 'Action Sheet with Title',
            child: ActionSheetWithTitleExample(),
          ),
          _Section(
            title: 'Destructive Action Sheet',
            child: ActionSheetDestructiveExample(),
          ),
          _Section(
            title: 'Action Sheet with Icons',
            child: ActionSheetWithIconsExample(),
          ),
          _Section(
            title: 'Scrollable Action Sheet',
            child: ActionSheetScrollableExample(),
          ),
          _Section(
            title: 'Compact Action Sheet',
            child: ActionSheetCompactExample(),
          ),
        ],
      ),
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
