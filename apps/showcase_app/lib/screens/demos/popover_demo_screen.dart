import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              child: _PopoverTrigger(
                label: 'Show Basic Popover',
                icon: LiqIcons.message,
                side: LiqPopoverSide.bottom,
                width: 260,
                contentBuilder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hello from Popover!',
                      style: context.textStyles.headline.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a basic popover with simple text content. It can appear in different directions.',
                      style: context.textStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Menu',
              description:
                  'Popover used as a context menu — list of actions with icons.',
              child: _PopoverTrigger(
                label: 'Show Menu',
                icon: LiqMaterialIcons.moreHoriz,
                side: LiqPopoverSide.bottom,
                width: 220,
                contentPadding: EdgeInsets.zero,
                contentBuilder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _menuRow(context, LiqIcons.copy, 'Copy'),
                    _menuRow(context, LiqMaterialIcons.cut, 'Cut'),
                    _menuRow(context, LiqMaterialIcons.paste, 'Paste'),
                    Container(height: 1, color: context.appleColors.separator),
                    _menuRow(context, LiqMaterialIcons.delete, 'Delete',
                        destructive: true),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Information',
              description: 'Rich popover with icon, title, body, and inline buttons.',
              child: _PopoverTrigger(
                label: 'Show Info',
                icon: LiqMaterialIcons.infoOutline,
                side: LiqPopoverSide.bottom,
                width: 320,
                contentBuilder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: context.appleColors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LiqMaterialIcons.infoOutline,
                            color: Color(0xFFFFFFFF),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Information',
                                style: context.textStyles.headline.copyWith(
                                  fontWeight: LiqAppleTypography.semibold,
                                ),
                              ),
                              Text(
                                'Version 1.0.0',
                                style: context.textStyles.caption1.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Rich content popover with structured layout — icons, text, and actions.',
                      style: context.textStyles.body,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: LiqButton(
                            label: 'Learn More',
                            size: LiqButtonSize.small,
                            style: LiqButtonStyle.borderedSecondary,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LiqButton(
                            label: 'Got It',
                            size: LiqButtonSize.small,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Custom Content',
              description:
                  'Popovers can host any content — gradients, images, custom layouts.',
              child: _PopoverTrigger(
                label: 'Show Custom Popover',
                icon: LiqMaterialIcons.autoAwesome,
                side: LiqPopoverSide.bottom,
                width: 320,
                contentBuilder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            context.appleColors.blue,
                            context.appleColors.purple,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          LiqMaterialIcons.gradient,
                          color: Color(0xFFFFFFFF),
                          size: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Custom Content',
                      style: context.textStyles.headline.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Popovers can contain any custom content including images, gradients, and complex layouts.',
                      style: context.textStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            _Section(
              title: 'Tooltips',
              description:
                  'LiqTooltip for quick hover/long-press hints near icon affordances.',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const LiqTooltip(
                    message: 'Save your work',
                    placement: LiqTooltipPlacement.top,
                    child: _IconAffordance(icon: LiqMaterialIcons.save),
                  ),
                  const SizedBox(width: 16),
                  LiqTooltip(
                    message: 'Delete this item',
                    placement: LiqTooltipPlacement.bottom,
                    child: _IconAffordance(
                      icon: LiqMaterialIcons.delete,
                      color: context.appleColors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const LiqTooltip(
                    message: 'Share with others',
                    placement: LiqTooltipPlacement.top,
                    child: _IconAffordance(icon: LiqIcons.share),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Direction Options',
              description:
                  'Popovers can be anchored on any of four sides relative to the trigger.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  for (final entry in <({String name, LiqPopoverSide side})>[
                    (name: 'Top', side: LiqPopoverSide.bottom),
                    (name: 'Bottom', side: LiqPopoverSide.top),
                    (name: 'Leading', side: LiqPopoverSide.trailing),
                    (name: 'Trailing', side: LiqPopoverSide.leading),
                  ])
                    _PopoverTrigger(
                      label: entry.name,
                      icon: LiqMaterialIcons.navigateNext,
                      side: entry.side,
                      width: 220,
                      contentBuilder: (context) => Text(
                        'Anchored to ${entry.name.toLowerCase()}',
                        style: context.textStyles.body,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuRow(BuildContext context, IconData icon, String title,
      {bool destructive = false}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 20,
              color: destructive
                  ? context.appleColors.red
                  : context.appleColors.label,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: context.textStyles.body.copyWith(
                color: destructive ? context.appleColors.red : null,
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
}

/// Trigger button that opens a [LiqPopover.show] anchored at its
/// rendered position.
class _PopoverTrigger extends StatelessWidget {
  _PopoverTrigger({
    required this.label,
    required this.icon,
    required this.contentBuilder,
    required this.side,
    this.width = 220,
    this.contentPadding = const EdgeInsets.all(14),
  });

  final String label;
  final IconData icon;
  final WidgetBuilder contentBuilder;
  final LiqPopoverSide side;
  final double width;
  final EdgeInsets contentPadding;
  final GlobalKey _key = GlobalKey();

  Future<void> _open(BuildContext context) async {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final overlay = Navigator.of(context).overlay;
    if (overlay == null) return;
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset.zero, ancestor: overlayBox);
    final size = box.size;
    final anchor = switch (side) {
      LiqPopoverSide.top => origin + Offset(size.width / 2, 0),
      LiqPopoverSide.bottom => origin + Offset(size.width / 2, size.height),
      LiqPopoverSide.leading => origin + Offset(0, size.height / 2),
      LiqPopoverSide.trailing =>
        origin + Offset(size.width, size.height / 2),
    };
    await LiqPopover.show<void>(
      context: context,
      anchor: anchor,
      side: side,
      width: width,
      padding: contentPadding,
      child: Builder(builder: contentBuilder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: LiqButton(
        label: label,
        leadingIcon: icon,
        onPressed: () => _open(context),
      ),
    );
  }
}

class _IconAffordance extends StatelessWidget {
  const _IconAffordance({required this.icon, this.color});

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(icon, color: color),
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
