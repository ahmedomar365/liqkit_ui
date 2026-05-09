import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class SidebarDemoScreenV2 extends ConsumerStatefulWidget {
  const SidebarDemoScreenV2({super.key});

  @override
  ConsumerState<SidebarDemoScreenV2> createState() =>
      _SidebarDemoScreenV2State();
}

class _SidebarDemoScreenV2State extends ConsumerState<SidebarDemoScreenV2> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Sidebars')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'Standard Sidebar',
              description:
                  'Header, search, section, navigation rows, and footer.',
              child: SidebarStandardExample(),
            ),
            _Section(
              title: 'Mini Sidebar',
              description:
                  'Compact icon-only sidebar with badge dots for unread state.',
              child: SidebarMiniExample(),
            ),
            _Section(
              title: 'Custom Styled Sidebar',
              description: 'Sidebar with a gradient header card and footer profile.',
              child: SidebarCustomStyledExample(),
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
