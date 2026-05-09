import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class MenuDemoScreenV2 extends ConsumerStatefulWidget {
  const MenuDemoScreenV2({super.key});

  @override
  ConsumerState<MenuDemoScreenV2> createState() => _MenuDemoScreenV2State();
}

class _MenuDemoScreenV2State extends ConsumerState<MenuDemoScreenV2> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Menus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'Dropdown Menu',
              description:
                  'Anchored popup menu shown by tapping a trigger button.',
              child: MenuDropdownExample(),
            ),
            _Section(
              title: 'Context Menu',
              description:
                  'Long-press the surface to open an iOS-style context menu.',
              child: MenuContextExample(),
            ),
            _Section(
              title: 'Menu Bar',
              description:
                  'macOS-style menu bar with multiple top-level entries.',
              child: MenuBarExample(),
            ),
            _Section(
              title: 'Inline Menu',
              description: 'Static menu rendered inline as part of the layout.',
              child: MenuInlineExample(),
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
