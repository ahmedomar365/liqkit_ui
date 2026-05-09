import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class PopupButtonDemoScreenV2 extends ConsumerStatefulWidget {
  const PopupButtonDemoScreenV2({super.key});

  @override
  ConsumerState<PopupButtonDemoScreenV2> createState() =>
      _PopupButtonDemoScreenV2State();
}

class _PopupButtonDemoScreenV2State
    extends ConsumerState<PopupButtonDemoScreenV2> {
  @override
  Widget build(BuildContext context) {
    return const LiqScaffold(
      appBar: LiqAppBar(title: Text('Popup Buttons')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: PopupButtonDemoBody(),
      ),
    );
  }
}

/// Body-only widget rendering every popup-button variant section.
/// Used standalone via [PopupButtonDemoScreenV2] and inside the
/// combined `ButtonsAllInOneScreen`.
class PopupButtonDemoBody extends ConsumerWidget {
  const PopupButtonDemoBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        // ─────────────────── Popup Button ───────────────────
        _Section(
          title: 'Popup Button — Styles',
          description: 'Every `LiqButtonStyle` rendered as a Popup Button.',
          child: PopupButtonStylesExample(),
        ),
        _Section(
          title: 'Popup Button — Sizes',
          description: 'All three `LiqButtonSize` values.',
          child: PopupButtonSizesExample(),
        ),
        _Section(
          title: 'Popup Button — Full Width',
          description: 'Set `fullWidth: true` to stretch to the parent.',
          child: PopupButtonFullWidthExample(),
        ),
        _Section(
          title: 'Popup Button — With Item Icons',
          description:
              'Items can carry leading icons that render in the menu '
              'and reflect the selected option.',
          child: PopupButtonWithItemIconsExample(),
        ),
        _Section(
          title: 'Popup Button — Without Item Icons',
          description: 'Plain label-only items.',
          child: PopupButtonWithoutItemIconsExample(),
        ),
        _Section(
          title: 'Popup Button — Disabled',
          description:
              'Pass a null `onChanged` to render the button non-interactive.',
          child: PopupButtonDisabledExample(),
        ),
        _Section(
          title: 'Popup Button — Pre-Selected',
          description: 'Provide a non-null `value` to start with a choice.',
          child: PopupButtonPreSelectedExample(),
        ),

        // ─────────────────── Pull Down Button ───────────────────
        _Section(
          title: 'Pull Down Button — Styles',
          description:
              'All `LiqButtonStyle` values applied to a Pull Down trigger.',
          child: PullDownButtonStylesExample(),
        ),
        _Section(
          title: 'Pull Down Button — Sizes',
          description: 'Small / Medium / Large.',
          child: PullDownButtonSizesExample(),
        ),
        _Section(
          title: 'Pull Down Button — With Leading Icon',
          description: 'Pass `leadingIcon` to add a glyph beside the title.',
          child: PullDownButtonWithLeadingIconExample(),
        ),
        _Section(
          title: 'Pull Down Button — Without Icon',
          description: 'Plain title-only trigger.',
          child: PullDownButtonWithoutIconExample(),
        ),
        _Section(
          title: 'Pull Down Button — Full Width',
          description: 'Stretches to the parent constraint.',
          child: PullDownButtonFullWidthExample(),
        ),
        _Section(
          title: 'Pull Down Button — Disabled',
          description: 'Pass `enabled: false` to deactivate the trigger.',
          child: PullDownButtonDisabledExample(),
        ),

        // ─────────────────── Split Button ───────────────────
        _Section(
          title: 'Split Button — Styles',
          description:
              'Primary action plus a chevron that opens a related menu.',
          child: SplitButtonStylesExample(),
        ),
        _Section(
          title: 'Split Button — Sizes',
          description: 'Small / Medium / Large variants.',
          child: SplitButtonSizesExample(),
        ),
        _Section(
          title: 'Split Button — With Leading Icon',
          description: 'Show a glyph on the primary half.',
          child: SplitButtonWithLeadingIconExample(),
        ),
        _Section(
          title: 'Split Button — Without Leading Icon',
          description: 'Label-only primary action.',
          child: SplitButtonWithoutLeadingIconExample(),
        ),
        _Section(
          title: 'Split Button — Disabled Primary, Active Menu',
          description:
              'Pass `onPressed: null` to disable the primary half '
              'while keeping the chevron menu functional.',
          child: SplitButtonDisabledPrimaryExample(),
        ),

        // ─────────────────── Real-world examples ───────────────────
        _Section(
          title: 'Common Use Cases',
          description:
              'Patterns lifted from real iOS apps — selection, '
              'language, file actions, export.',
          child: PopupButtonCommonUseCasesExample(),
        ),
      ],
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
