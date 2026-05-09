import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

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
class PopupButtonDemoBody extends ConsumerStatefulWidget {
  const PopupButtonDemoBody({super.key});

  @override
  ConsumerState<PopupButtonDemoBody> createState() =>
      _PopupButtonDemoBodyState();
}

class _PopupButtonDemoBodyState extends ConsumerState<PopupButtonDemoBody> {
  // One controller per interactive surface — every variant on the
  // page can be selected independently.
  String? _styleFruit;
  String? _styleColor;
  String? _styleAnimal;
  String? _styleSizeS;
  String? _styleSizeM;
  String? _styleSizeL;
  String? _withIcon;
  String? _withoutIcon;
  String? _fullWidth;
  String? _disabled;

  static const List<LiqDropdownItem<String>> _fruits = <LiqDropdownItem<String>>[
    LiqDropdownItem(value: 'apple', label: 'Apple'),
    LiqDropdownItem(value: 'banana', label: 'Banana'),
    LiqDropdownItem(value: 'orange', label: 'Orange'),
    LiqDropdownItem(value: 'grape', label: 'Grape'),
    LiqDropdownItem(value: 'strawberry', label: 'Strawberry'),
  ];

  void _toast(String m) => LiqToastOverlay.show(context, m);

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ─────────────────── Popup Button ───────────────────
            _Section(
              title: 'Popup Button — Styles',
              description:
                  'Every `LiqButtonStyle` rendered as a Popup Button.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  for (final style in LiqButtonStyle.values)
                    LiqDropdownButton<String>(
                      value: _styleFruit,
                      placeholder: _styleLabel(style),
                      style: style,
                      items: _fruits,
                      onChanged: (v) => setState(() => _styleFruit = v),
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Popup Button — Sizes',
              description: 'All three `LiqButtonSize` values.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  LiqDropdownButton<String>(
                    value: _styleSizeS,
                    placeholder: 'Small',
                    size: LiqButtonSize.small,
                    items: _fruits,
                    onChanged: (v) => setState(() => _styleSizeS = v),
                  ),
                  LiqDropdownButton<String>(
                    value: _styleSizeM,
                    placeholder: 'Medium',
                    size: LiqButtonSize.medium,
                    items: _fruits,
                    onChanged: (v) => setState(() => _styleSizeM = v),
                  ),
                  LiqDropdownButton<String>(
                    value: _styleSizeL,
                    placeholder: 'Large',
                    size: LiqButtonSize.large,
                    items: _fruits,
                    onChanged: (v) => setState(() => _styleSizeL = v),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Popup Button — Full Width',
              description: 'Set `fullWidth: true` to stretch to the parent.',
              child: LiqDropdownButton<String>(
                value: _fullWidth,
                placeholder: 'Pick a country',
                fullWidth: true,
                items: const <LiqDropdownItem<String>>[
                  LiqDropdownItem(value: 'us', label: 'United States'),
                  LiqDropdownItem(value: 'gb', label: 'United Kingdom'),
                  LiqDropdownItem(value: 'fr', label: 'France'),
                  LiqDropdownItem(value: 'de', label: 'Germany'),
                  LiqDropdownItem(value: 'jp', label: 'Japan'),
                ],
                onChanged: (v) => setState(() => _fullWidth = v),
              ),
            ),
            _Section(
              title: 'Popup Button — With Item Icons',
              description:
                  'Items can carry leading icons that render in the menu '
                  'and reflect the selected option.',
              child: LiqDropdownButton<String>(
                value: _withIcon,
                placeholder: 'Pick a color',
                items: const <LiqDropdownItem<String>>[
                  LiqDropdownItem(
                    value: 'red',
                    label: 'Red',
                    icon: LiqMaterialIcons.favorite,
                  ),
                  LiqDropdownItem(
                    value: 'star',
                    label: 'Star',
                    icon: LiqIcons.star,
                  ),
                  LiqDropdownItem(
                    value: 'home',
                    label: 'Home',
                    icon: LiqIcons.home,
                  ),
                  LiqDropdownItem(
                    value: 'settings',
                    label: 'Settings',
                    icon: LiqIcons.settings,
                  ),
                ],
                onChanged: (v) => setState(() => _withIcon = v),
              ),
            ),
            _Section(
              title: 'Popup Button — Without Item Icons',
              description: 'Plain label-only items.',
              child: LiqDropdownButton<String>(
                value: _withoutIcon,
                placeholder: 'Pick an animal',
                items: const <LiqDropdownItem<String>>[
                  LiqDropdownItem(value: 'cat', label: 'Cat'),
                  LiqDropdownItem(value: 'dog', label: 'Dog'),
                  LiqDropdownItem(value: 'fish', label: 'Fish'),
                  LiqDropdownItem(value: 'bird', label: 'Bird'),
                ],
                onChanged: (v) => setState(() => _withoutIcon = v),
              ),
            ),
            _Section(
              title: 'Popup Button — Disabled',
              description:
                  'Pass a null `onChanged` to render the button non-interactive.',
              child: LiqDropdownButton<String>(
                value: _disabled,
                placeholder: 'Locked menu',
                items: _fruits,
                onChanged: null,
              ),
            ),
            _Section(
              title: 'Popup Button — Pre-Selected',
              description: 'Provide a non-null `value` to start with a choice.',
              child: LiqDropdownButton<String>(
                value: _styleColor ?? 'banana',
                placeholder: 'Select fruit',
                items: _fruits,
                onChanged: (v) => setState(() => _styleColor = v),
              ),
            ),

            // ─────────────────── Pull Down Button ───────────────────
            _Section(
              title: 'Pull Down Button — Styles',
              description:
                  'All `LiqButtonStyle` values applied to a Pull Down trigger.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  for (final style in LiqButtonStyle.values)
                    LiqPullDownButton(
                      title: _styleLabel(style),
                      style: style,
                      items: _fileMenu(),
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Pull Down Button — Sizes',
              description: 'Small / Medium / Large.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  LiqPullDownButton(
                    title: 'Small',
                    size: LiqButtonSize.small,
                    items: _fileMenu(),
                  ),
                  LiqPullDownButton(
                    title: 'Medium',
                    size: LiqButtonSize.medium,
                    items: _fileMenu(),
                  ),
                  LiqPullDownButton(
                    title: 'Large',
                    size: LiqButtonSize.large,
                    items: _fileMenu(),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Pull Down Button — With Leading Icon',
              description:
                  'Pass `leadingIcon` to add a glyph beside the title.',
              child: LiqPullDownButton(
                title: 'File Operations',
                leadingIcon: LiqIcons.folder,
                style: LiqButtonStyle.bordered,
                items: _fileMenu(),
              ),
            ),
            _Section(
              title: 'Pull Down Button — Without Icon',
              description: 'Plain title-only trigger.',
              child: LiqPullDownButton(
                title: 'Language',
                style: LiqButtonStyle.borderedSecondary,
                items: <LiqMenuItem>[
                  LiqMenuItem(
                    label: 'English',
                    subtitle: 'Default',
                    onPressed: () => _toast('Language: English'),
                  ),
                  LiqMenuItem(
                    label: 'Español',
                    onPressed: () => _toast('Language: Spanish'),
                  ),
                  LiqMenuItem(
                    label: 'Français',
                    onPressed: () => _toast('Language: French'),
                  ),
                  LiqMenuItem(
                    label: '中文',
                    onPressed: () => _toast('Language: Chinese'),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Pull Down Button — Full Width',
              description: 'Stretches to the parent constraint.',
              child: LiqPullDownButton(
                title: 'Edit Document',
                leadingIcon: LiqIcons.edit,
                fullWidth: true,
                items: _editMenu(),
              ),
            ),
            _Section(
              title: 'Pull Down Button — Disabled',
              description: 'Pass `enabled: false` to deactivate the trigger.',
              child: LiqPullDownButton(
                title: 'Locked Actions',
                enabled: false,
                items: _fileMenu(),
              ),
            ),

            // ─────────────────── Split Button ───────────────────
            _Section(
              title: 'Split Button — Styles',
              description:
                  'Primary action plus a chevron that opens a related menu.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  for (final style in LiqButtonStyle.values)
                    LiqSplitButton(
                      label: _styleLabel(style),
                      style: style,
                      onPressed: () => _toast('Run primary'),
                      menuItems: _runMenu(),
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Split Button — Sizes',
              description: 'Small / Medium / Large variants.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  LiqSplitButton(
                    label: 'Small',
                    size: LiqButtonSize.small,
                    onPressed: () => _toast('Run small'),
                    menuItems: _runMenu(),
                  ),
                  LiqSplitButton(
                    label: 'Medium',
                    size: LiqButtonSize.medium,
                    onPressed: () => _toast('Run medium'),
                    menuItems: _runMenu(),
                  ),
                  LiqSplitButton(
                    label: 'Large',
                    size: LiqButtonSize.large,
                    onPressed: () => _toast('Run large'),
                    menuItems: _runMenu(),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Split Button — With Leading Icon',
              description: 'Show a glyph on the primary half.',
              child: LiqSplitButton(
                label: 'Run',
                leadingIcon: LiqMaterialIcons.playArrow,
                onPressed: () => _toast('Running default'),
                menuItems: _runMenu(),
              ),
            ),
            _Section(
              title: 'Split Button — Without Leading Icon',
              description: 'Label-only primary action.',
              child: LiqSplitButton(
                label: 'Export',
                style: LiqButtonStyle.borderedSecondary,
                onPressed: () => _toast('Export PDF'),
                menuItems: <LiqMenuItem>[
                  LiqMenuItem(
                    label: 'PDF',
                    icon: const Icon(LiqMaterialIcons.pictureAsPdf),
                    onPressed: () => _toast('PDF'),
                  ),
                  LiqMenuItem(
                    label: 'PNG',
                    icon: const Icon(LiqIcons.image),
                    onPressed: () => _toast('PNG'),
                  ),
                  LiqMenuItem(
                    label: 'SVG',
                    icon: const Icon(LiqMaterialIcons.code),
                    onPressed: () => _toast('SVG'),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Split Button — Disabled Primary, Active Menu',
              description:
                  'Pass `onPressed: null` to disable the primary half '
                  'while keeping the chevron menu functional.',
              child: LiqSplitButton(
                label: 'Run',
                leadingIcon: LiqMaterialIcons.playArrow,
                onPressed: null,
                menuItems: _runMenu(),
              ),
            ),

            // ─────────────────── Real-world examples ───────────────────
            _Section(
              title: 'Common Use Cases',
              description:
                  'Patterns lifted from real iOS apps — selection, '
                  'language, file actions, export.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  LiqDropdownButton<String>(
                    value: _styleAnimal,
                    placeholder: 'Sort by',
                    items: const <LiqDropdownItem<String>>[
                      LiqDropdownItem(value: 'name', label: 'Name'),
                      LiqDropdownItem(value: 'date', label: 'Date'),
                      LiqDropdownItem(value: 'size', label: 'Size'),
                      LiqDropdownItem(value: 'kind', label: 'Kind'),
                    ],
                    onChanged: (v) => setState(() => _styleAnimal = v),
                  ),
                  LiqPullDownButton(
                    title: 'View',
                    leadingIcon: LiqMaterialIcons.gridView,
                    items: <LiqMenuItem>[
                      LiqMenuItem(
                        label: 'List',
                        icon: const Icon(LiqIcons.list),
                        onPressed: () => _toast('List'),
                      ),
                      LiqMenuItem(
                        label: 'Grid',
                        icon: const Icon(LiqMaterialIcons.gridView),
                        onPressed: () => _toast('Grid'),
                      ),
                      LiqMenuItem(
                        label: 'Columns',
                        icon: const Icon(LiqMaterialIcons.viewColumn),
                        onPressed: () => _toast('Columns'),
                      ),
                    ],
                  ),
                  LiqSplitButton(
                    label: 'Save',
                    leadingIcon: LiqMaterialIcons.save,
                    onPressed: () => _toast('Saved'),
                    menuItems: <LiqMenuItem>[
                      LiqMenuItem(
                        label: 'Save As…',
                        onPressed: () => _toast('Save as'),
                      ),
                      LiqMenuItem(
                        label: 'Save All',
                        onPressed: () => _toast('Save all'),
                      ),
                      LiqMenuItem(
                        label: 'Discard',
                        style: LiqMenuItemStyle.destructive,
                        onPressed: () => _toast('Discard'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
  }

  String _styleLabel(LiqButtonStyle style) => switch (style) {
        LiqButtonStyle.borderedProminent => 'Prominent',
        LiqButtonStyle.bordered => 'Bordered',
        LiqButtonStyle.borderedSecondary => 'Secondary',
        LiqButtonStyle.borderless => 'Borderless',
        LiqButtonStyle.liquid => 'Liquid',
      };

  List<LiqMenuItem> _fileMenu() => <LiqMenuItem>[
        LiqMenuItem(
          label: 'New File',
          icon: const Icon(LiqMaterialIcons.addBox),
          trailing: const Text('⌘N'),
          onPressed: () => _toast('New file'),
        ),
        LiqMenuItem(
          label: 'Open File',
          icon: const Icon(LiqMaterialIcons.folderOpen),
          trailing: const Text('⌘O'),
          onPressed: () => _toast('Open'),
        ),
        LiqMenuItem(
          label: 'Save',
          icon: const Icon(LiqMaterialIcons.save),
          trailing: const Text('⌘S'),
          onPressed: () => _toast('Save'),
        ),
        LiqMenuItem(
          label: 'Delete',
          icon: const Icon(LiqMaterialIcons.delete),
          style: LiqMenuItemStyle.destructive,
          onPressed: () => _toast('Delete'),
        ),
      ];

  List<LiqMenuItem> _editMenu() => <LiqMenuItem>[
        LiqMenuItem(
          label: 'Cut',
          icon: const Icon(LiqMaterialIcons.cut),
          trailing: const Text('⌘X'),
          onPressed: () => _toast('Cut'),
        ),
        LiqMenuItem(
          label: 'Copy',
          icon: const Icon(LiqMaterialIcons.contentCopy),
          trailing: const Text('⌘C'),
          onPressed: () => _toast('Copy'),
        ),
        LiqMenuItem(
          label: 'Paste',
          icon: const Icon(LiqMaterialIcons.paste),
          trailing: const Text('⌘V'),
          onPressed: () => _toast('Paste'),
        ),
        LiqMenuItem(
          label: 'Undo',
          icon: const Icon(LiqMaterialIcons.restore),
          trailing: const Text('⌘Z'),
          onPressed: () => _toast('Undo'),
        ),
      ];

  List<LiqMenuItem> _runMenu() => <LiqMenuItem>[
        LiqMenuItem(
          label: 'Run with Debugging',
          icon: const Icon(LiqMaterialIcons.bugReport),
          subtitle: 'F5',
          onPressed: () => _toast('Run debug'),
        ),
        LiqMenuItem(
          label: 'Run without Debugging',
          icon: const Icon(LiqMaterialIcons.playCircleOutline),
          subtitle: 'Ctrl+F5',
          onPressed: () => _toast('Run'),
        ),
        LiqMenuItem(
          label: 'Profile',
          icon: const Icon(LiqMaterialIcons.speed),
          subtitle: 'Performance analysis',
          onPressed: () => _toast('Profile'),
        ),
        LiqMenuItem(
          label: 'Stop',
          icon: const Icon(LiqMaterialIcons.stop),
          style: LiqMenuItemStyle.destructive,
          onPressed: () => _toast('Stop'),
        ),
      ];
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
