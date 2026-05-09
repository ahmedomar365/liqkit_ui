/// Canonical popover variants — single source of truth for the showcase
/// app and the liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/popovers/liq_popover.dart';
import 'package:liqkit_ui/src/components/tooltips/liq_tooltip.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_typography.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

/// Trigger button that opens a [LiqPopover.show] anchored at its
/// rendered position.
class PopoverTrigger extends StatelessWidget {
  PopoverTrigger({
    required this.label,
    required this.icon,
    required this.contentBuilder,
    required this.side,
    this.width = 220,
    this.contentPadding = const EdgeInsets.all(14),
    super.key,
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

/// Simple popover with title and body anchored to a button.
final class PopoverBasicExample extends StatelessWidget {
  const PopoverBasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return PopoverTrigger(
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
    );
  }
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

/// Popover used as a context menu — list of actions with icons.
final class PopoverMenuExample extends StatelessWidget {
  const PopoverMenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    return PopoverTrigger(
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
          _menuRow(context, LiqMaterialIcons.delete, 'Delete', destructive: true),
        ],
      ),
    );
  }
}

/// Rich popover with icon, title, body, and inline buttons.
final class PopoverInformationExample extends StatelessWidget {
  const PopoverInformationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return PopoverTrigger(
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
    );
  }
}

/// Popovers can host any content — gradients, images, custom layouts.
final class PopoverCustomContentExample extends StatelessWidget {
  const PopoverCustomContentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return PopoverTrigger(
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
    );
  }
}

/// LiqTooltip for quick hover/long-press hints near icon affordances.
final class PopoverTooltipsExample extends StatelessWidget {
  const PopoverTooltipsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

/// Popovers can be anchored on any of four sides relative to the trigger.
final class PopoverDirectionOptionsExample extends StatelessWidget {
  const PopoverDirectionOptionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final entry in const <({String name, LiqPopoverSide side})>[
          (name: 'Top', side: LiqPopoverSide.bottom),
          (name: 'Bottom', side: LiqPopoverSide.top),
          (name: 'Leading', side: LiqPopoverSide.trailing),
          (name: 'Trailing', side: LiqPopoverSide.leading),
        ])
          PopoverTrigger(
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
    );
  }
}
