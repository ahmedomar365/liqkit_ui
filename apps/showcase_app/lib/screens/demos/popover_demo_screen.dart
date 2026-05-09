import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class PopoverDemoScreen extends ConsumerStatefulWidget {
  const PopoverDemoScreen({super.key});

  @override
  ConsumerState<PopoverDemoScreen> createState() => _PopoverDemoScreenState();
}

class _PopoverDemoScreenState extends ConsumerState<PopoverDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Popovers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Basic',
              description:
                  'Simple popover with a title and body text anchored to a button.',
              child: PopoverBasicExample(),
            ),
            _Section(
              title: 'Menu',
              description:
                  'Popover used as a context menu — list of actions with icons.',
              child: PopoverMenuExample(),
            ),
            _Section(
              title: 'Information',
              description:
                  'Rich popover with icon, title, body, and inline buttons.',
              child: PopoverInformationExample(),
            ),
            _Section(
              title: 'Custom Content',
              description:
                  'Popovers can host any content — gradients, images, custom layouts.',
              child: PopoverCustomContentExample(),
            ),
            _Section(
              title: 'Tooltips',
              description:
                  'LiqTooltip for quick hover/long-press hints near icon affordances.',
              child: PopoverTooltipsExample(),
            ),
            _Section(
              title: 'Direction Options',
              description:
                  'Popovers can be anchored on any of four sides relative to the trigger.',
              child: PopoverDirectionOptionsExample(),
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
