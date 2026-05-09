/// Canonical popup-button family variants — popup (`LiqDropdownButton`),
/// pull-down (`LiqPullDownButton`), and split (`LiqSplitButton`) — single
/// source of truth for the showcase app and the liqkit.com previews.
///
/// Faithful 1:1 reproductions of every `_Section(...)` from
/// `apps/showcase_app/lib/screens/demos/popup_button_demo_screen_v2.dart`.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/buttons/liq_button.dart';
import 'package:liqkit_ui/src/components/menu/liq_menu.dart';
import 'package:liqkit_ui/src/components/popup_buttons/liq_dropdown.dart';
import 'package:liqkit_ui/src/components/toasts/liq_toast.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

// ─── Shared item lists ──────────────────────────────────────────────────────

const List<LiqDropdownItem<String>> _kFruits = <LiqDropdownItem<String>>[
  LiqDropdownItem(value: 'apple', label: 'Apple'),
  LiqDropdownItem(value: 'banana', label: 'Banana'),
  LiqDropdownItem(value: 'orange', label: 'Orange'),
  LiqDropdownItem(value: 'grape', label: 'Grape'),
  LiqDropdownItem(value: 'strawberry', label: 'Strawberry'),
];

String _styleLabel(LiqButtonStyle style) => switch (style) {
      LiqButtonStyle.borderedProminent => 'Prominent',
      LiqButtonStyle.bordered => 'Bordered',
      LiqButtonStyle.borderedSecondary => 'Secondary',
      LiqButtonStyle.borderless => 'Borderless',
      LiqButtonStyle.liquid => 'Liquid',
    };

void _toast(BuildContext context, String message) =>
    LiqToastOverlay.show(context, message);

List<LiqMenuItem> _fileMenu(BuildContext context) => <LiqMenuItem>[
      LiqMenuItem(
        label: 'New File',
        icon: const Icon(LiqMaterialIcons.addBox),
        trailing: const Text('⌘N'),
        onPressed: () => _toast(context, 'New file'),
      ),
      LiqMenuItem(
        label: 'Open File',
        icon: const Icon(LiqMaterialIcons.folderOpen),
        trailing: const Text('⌘O'),
        onPressed: () => _toast(context, 'Open'),
      ),
      LiqMenuItem(
        label: 'Save',
        icon: const Icon(LiqMaterialIcons.save),
        trailing: const Text('⌘S'),
        onPressed: () => _toast(context, 'Save'),
      ),
      LiqMenuItem(
        label: 'Delete',
        icon: const Icon(LiqMaterialIcons.delete),
        style: LiqMenuItemStyle.destructive,
        onPressed: () => _toast(context, 'Delete'),
      ),
    ];

List<LiqMenuItem> _editMenu(BuildContext context) => <LiqMenuItem>[
      LiqMenuItem(
        label: 'Cut',
        icon: const Icon(LiqMaterialIcons.cut),
        trailing: const Text('⌘X'),
        onPressed: () => _toast(context, 'Cut'),
      ),
      LiqMenuItem(
        label: 'Copy',
        icon: const Icon(LiqMaterialIcons.contentCopy),
        trailing: const Text('⌘C'),
        onPressed: () => _toast(context, 'Copy'),
      ),
      LiqMenuItem(
        label: 'Paste',
        icon: const Icon(LiqMaterialIcons.paste),
        trailing: const Text('⌘V'),
        onPressed: () => _toast(context, 'Paste'),
      ),
      LiqMenuItem(
        label: 'Undo',
        icon: const Icon(LiqMaterialIcons.restore),
        trailing: const Text('⌘Z'),
        onPressed: () => _toast(context, 'Undo'),
      ),
    ];

List<LiqMenuItem> _runMenu(BuildContext context) => <LiqMenuItem>[
      LiqMenuItem(
        label: 'Run with Debugging',
        icon: const Icon(LiqMaterialIcons.bugReport),
        subtitle: 'F5',
        onPressed: () => _toast(context, 'Run debug'),
      ),
      LiqMenuItem(
        label: 'Run without Debugging',
        icon: const Icon(LiqMaterialIcons.playCircleOutline),
        subtitle: 'Ctrl+F5',
        onPressed: () => _toast(context, 'Run'),
      ),
      LiqMenuItem(
        label: 'Profile',
        icon: const Icon(LiqMaterialIcons.speed),
        subtitle: 'Performance analysis',
        onPressed: () => _toast(context, 'Profile'),
      ),
      LiqMenuItem(
        label: 'Stop',
        icon: const Icon(LiqMaterialIcons.stop),
        style: LiqMenuItemStyle.destructive,
        onPressed: () => _toast(context, 'Stop'),
      ),
    ];

// ─── Popup Button (LiqDropdownButton) variants ──────────────────────────────

final class PopupButtonStylesExample extends StatefulWidget {
  const PopupButtonStylesExample({super.key});

  @override
  State<PopupButtonStylesExample> createState() =>
      _PopupButtonStylesExampleState();
}

class _PopupButtonStylesExampleState extends State<PopupButtonStylesExample> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final style in LiqButtonStyle.values)
          LiqDropdownButton<String>(
            value: _value,
            placeholder: _styleLabel(style),
            style: style,
            items: _kFruits,
            onChanged: (v) => setState(() => _value = v),
          ),
      ],
    );
  }
}

final class PopupButtonSizesExample extends StatefulWidget {
  const PopupButtonSizesExample({super.key});

  @override
  State<PopupButtonSizesExample> createState() =>
      _PopupButtonSizesExampleState();
}

class _PopupButtonSizesExampleState extends State<PopupButtonSizesExample> {
  String? _s;
  String? _m;
  String? _l;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        LiqDropdownButton<String>(
          value: _s,
          placeholder: 'Small',
          size: LiqButtonSize.small,
          items: _kFruits,
          onChanged: (v) => setState(() => _s = v),
        ),
        LiqDropdownButton<String>(
          value: _m,
          placeholder: 'Medium',
          items: _kFruits,
          onChanged: (v) => setState(() => _m = v),
        ),
        LiqDropdownButton<String>(
          value: _l,
          placeholder: 'Large',
          size: LiqButtonSize.large,
          items: _kFruits,
          onChanged: (v) => setState(() => _l = v),
        ),
      ],
    );
  }
}

final class PopupButtonFullWidthExample extends StatefulWidget {
  const PopupButtonFullWidthExample({super.key});

  @override
  State<PopupButtonFullWidthExample> createState() =>
      _PopupButtonFullWidthExampleState();
}

class _PopupButtonFullWidthExampleState
    extends State<PopupButtonFullWidthExample> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return LiqDropdownButton<String>(
      value: _value,
      placeholder: 'Pick a country',
      fullWidth: true,
      items: const <LiqDropdownItem<String>>[
        LiqDropdownItem(value: 'us', label: 'United States'),
        LiqDropdownItem(value: 'gb', label: 'United Kingdom'),
        LiqDropdownItem(value: 'fr', label: 'France'),
        LiqDropdownItem(value: 'de', label: 'Germany'),
        LiqDropdownItem(value: 'jp', label: 'Japan'),
      ],
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

final class PopupButtonWithItemIconsExample extends StatefulWidget {
  const PopupButtonWithItemIconsExample({super.key});

  @override
  State<PopupButtonWithItemIconsExample> createState() =>
      _PopupButtonWithItemIconsExampleState();
}

class _PopupButtonWithItemIconsExampleState
    extends State<PopupButtonWithItemIconsExample> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return LiqDropdownButton<String>(
      value: _value,
      placeholder: 'Pick a color',
      items: const <LiqDropdownItem<String>>[
        LiqDropdownItem(
          value: 'red',
          label: 'Red',
          icon: LiqMaterialIcons.favorite,
        ),
        LiqDropdownItem(value: 'star', label: 'Star', icon: LiqIcons.star),
        LiqDropdownItem(value: 'home', label: 'Home', icon: LiqIcons.home),
        LiqDropdownItem(
          value: 'settings',
          label: 'Settings',
          icon: LiqIcons.settings,
        ),
      ],
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

final class PopupButtonWithoutItemIconsExample extends StatefulWidget {
  const PopupButtonWithoutItemIconsExample({super.key});

  @override
  State<PopupButtonWithoutItemIconsExample> createState() =>
      _PopupButtonWithoutItemIconsExampleState();
}

class _PopupButtonWithoutItemIconsExampleState
    extends State<PopupButtonWithoutItemIconsExample> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return LiqDropdownButton<String>(
      value: _value,
      placeholder: 'Pick an animal',
      items: const <LiqDropdownItem<String>>[
        LiqDropdownItem(value: 'cat', label: 'Cat'),
        LiqDropdownItem(value: 'dog', label: 'Dog'),
        LiqDropdownItem(value: 'fish', label: 'Fish'),
        LiqDropdownItem(value: 'bird', label: 'Bird'),
      ],
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

final class PopupButtonDisabledExample extends StatelessWidget {
  const PopupButtonDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const LiqDropdownButton<String>(
      value: null,
      placeholder: 'Locked menu',
      items: _kFruits,
      onChanged: null,
    );
  }
}

final class PopupButtonPreSelectedExample extends StatefulWidget {
  const PopupButtonPreSelectedExample({super.key});

  @override
  State<PopupButtonPreSelectedExample> createState() =>
      _PopupButtonPreSelectedExampleState();
}

class _PopupButtonPreSelectedExampleState
    extends State<PopupButtonPreSelectedExample> {
  String? _value = 'banana';

  @override
  Widget build(BuildContext context) {
    return LiqDropdownButton<String>(
      value: _value,
      placeholder: 'Select fruit',
      items: _kFruits,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

// ─── Pull Down Button (LiqPullDownButton) variants ──────────────────────────

final class PullDownButtonStylesExample extends StatelessWidget {
  const PullDownButtonStylesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final style in LiqButtonStyle.values)
          LiqPullDownButton(
            title: _styleLabel(style),
            style: style,
            items: _fileMenu(context),
          ),
      ],
    );
  }
}

final class PullDownButtonSizesExample extends StatelessWidget {
  const PullDownButtonSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        LiqPullDownButton(
          title: 'Small',
          size: LiqButtonSize.small,
          items: _fileMenu(context),
        ),
        LiqPullDownButton(title: 'Medium', items: _fileMenu(context)),
        LiqPullDownButton(
          title: 'Large',
          size: LiqButtonSize.large,
          items: _fileMenu(context),
        ),
      ],
    );
  }
}

final class PullDownButtonWithLeadingIconExample extends StatelessWidget {
  const PullDownButtonWithLeadingIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqPullDownButton(
      title: 'File Operations',
      leadingIcon: LiqIcons.folder,
      style: LiqButtonStyle.bordered,
      items: _fileMenu(context),
    );
  }
}

final class PullDownButtonWithoutIconExample extends StatelessWidget {
  const PullDownButtonWithoutIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqPullDownButton(
      title: 'Language',
      style: LiqButtonStyle.borderedSecondary,
      items: <LiqMenuItem>[
        LiqMenuItem(
          label: 'English',
          subtitle: 'Default',
          onPressed: () => _toast(context, 'Language: English'),
        ),
        LiqMenuItem(
          label: 'Español',
          onPressed: () => _toast(context, 'Language: Spanish'),
        ),
        LiqMenuItem(
          label: 'Français',
          onPressed: () => _toast(context, 'Language: French'),
        ),
        LiqMenuItem(
          label: '中文',
          onPressed: () => _toast(context, 'Language: Chinese'),
        ),
      ],
    );
  }
}

final class PullDownButtonFullWidthExample extends StatelessWidget {
  const PullDownButtonFullWidthExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqPullDownButton(
      title: 'Edit Document',
      leadingIcon: LiqIcons.edit,
      fullWidth: true,
      items: _editMenu(context),
    );
  }
}

final class PullDownButtonDisabledExample extends StatelessWidget {
  const PullDownButtonDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqPullDownButton(
      title: 'Locked Actions',
      enabled: false,
      items: _fileMenu(context),
    );
  }
}

// ─── Split Button (LiqSplitButton) variants ─────────────────────────────────

final class SplitButtonStylesExample extends StatelessWidget {
  const SplitButtonStylesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final style in LiqButtonStyle.values)
          LiqSplitButton(
            label: _styleLabel(style),
            style: style,
            onPressed: () => _toast(context, 'Run primary'),
            menuItems: _runMenu(context),
          ),
      ],
    );
  }
}

final class SplitButtonSizesExample extends StatelessWidget {
  const SplitButtonSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        LiqSplitButton(
          label: 'Small',
          size: LiqButtonSize.small,
          onPressed: () => _toast(context, 'Run small'),
          menuItems: _runMenu(context),
        ),
        LiqSplitButton(
          label: 'Medium',
          onPressed: () => _toast(context, 'Run medium'),
          menuItems: _runMenu(context),
        ),
        LiqSplitButton(
          label: 'Large',
          size: LiqButtonSize.large,
          onPressed: () => _toast(context, 'Run large'),
          menuItems: _runMenu(context),
        ),
      ],
    );
  }
}

final class SplitButtonWithLeadingIconExample extends StatelessWidget {
  const SplitButtonWithLeadingIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqSplitButton(
      label: 'Run',
      leadingIcon: LiqMaterialIcons.playArrow,
      onPressed: () => _toast(context, 'Running default'),
      menuItems: _runMenu(context),
    );
  }
}

final class SplitButtonWithoutLeadingIconExample extends StatelessWidget {
  const SplitButtonWithoutLeadingIconExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqSplitButton(
      label: 'Export',
      style: LiqButtonStyle.borderedSecondary,
      onPressed: () => _toast(context, 'Export PDF'),
      menuItems: <LiqMenuItem>[
        LiqMenuItem(
          label: 'PDF',
          icon: const Icon(LiqMaterialIcons.pictureAsPdf),
          onPressed: () => _toast(context, 'PDF'),
        ),
        LiqMenuItem(
          label: 'PNG',
          icon: const Icon(LiqIcons.image),
          onPressed: () => _toast(context, 'PNG'),
        ),
        LiqMenuItem(
          label: 'SVG',
          icon: const Icon(LiqMaterialIcons.code),
          onPressed: () => _toast(context, 'SVG'),
        ),
      ],
    );
  }
}

final class SplitButtonDisabledPrimaryExample extends StatelessWidget {
  const SplitButtonDisabledPrimaryExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LiqSplitButton(
      label: 'Run',
      leadingIcon: LiqMaterialIcons.playArrow,
      onPressed: null,
      menuItems: _runMenu(context),
    );
  }
}

// ─── Common use cases ───────────────────────────────────────────────────────

final class PopupButtonCommonUseCasesExample extends StatefulWidget {
  const PopupButtonCommonUseCasesExample({super.key});

  @override
  State<PopupButtonCommonUseCasesExample> createState() =>
      _PopupButtonCommonUseCasesExampleState();
}

class _PopupButtonCommonUseCasesExampleState
    extends State<PopupButtonCommonUseCasesExample> {
  String? _sortBy;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        LiqDropdownButton<String>(
          value: _sortBy,
          placeholder: 'Sort by',
          items: const <LiqDropdownItem<String>>[
            LiqDropdownItem(value: 'name', label: 'Name'),
            LiqDropdownItem(value: 'date', label: 'Date'),
            LiqDropdownItem(value: 'size', label: 'Size'),
            LiqDropdownItem(value: 'kind', label: 'Kind'),
          ],
          onChanged: (v) => setState(() => _sortBy = v),
        ),
        LiqPullDownButton(
          title: 'View',
          leadingIcon: LiqMaterialIcons.gridView,
          items: <LiqMenuItem>[
            LiqMenuItem(
              label: 'List',
              icon: const Icon(LiqIcons.list),
              onPressed: () => _toast(context, 'List'),
            ),
            LiqMenuItem(
              label: 'Grid',
              icon: const Icon(LiqMaterialIcons.gridView),
              onPressed: () => _toast(context, 'Grid'),
            ),
            LiqMenuItem(
              label: 'Columns',
              icon: const Icon(LiqMaterialIcons.viewColumn),
              onPressed: () => _toast(context, 'Columns'),
            ),
          ],
        ),
        LiqSplitButton(
          label: 'Save',
          leadingIcon: LiqMaterialIcons.save,
          onPressed: () => _toast(context, 'Saved'),
          menuItems: <LiqMenuItem>[
            LiqMenuItem(
              label: 'Save As…',
              onPressed: () => _toast(context, 'Save as'),
            ),
            LiqMenuItem(
              label: 'Save All',
              onPressed: () => _toast(context, 'Save all'),
            ),
            LiqMenuItem(
              label: 'Discard',
              style: LiqMenuItemStyle.destructive,
              onPressed: () => _toast(context, 'Discard'),
            ),
          ],
        ),
      ],
    );
  }
}
