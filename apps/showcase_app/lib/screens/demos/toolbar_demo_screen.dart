import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


enum _TextFormatAction {
  bold,
  italic,
  underline,
  alignLeft,
  alignCenter,
  alignRight,
}

class ToolbarDemoScreen extends ConsumerStatefulWidget {
  const ToolbarDemoScreen({super.key});

  @override
  ConsumerState<ToolbarDemoScreen> createState() => _ToolbarDemoScreenState();
}

class _ToolbarDemoScreenState extends ConsumerState<ToolbarDemoScreen> {
  int _selectedToolbarItem = 0;
  int _selectedGroupItem = 0;
  final Set<_TextFormatAction> _activeFormats = <_TextFormatAction>{
    _TextFormatAction.bold,
    _TextFormatAction.alignLeft,
  };
  Color _textColor = const Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Toolbars')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _section(
            title: 'Standard Toolbar',
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.appleColors.gray.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  ColoredBox(
                    color: context.appleColors.gray.withValues(alpha: 0.1),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LiqIconBar(
                      items: <Widget>[
                        LiqIconBarItem(
                          icon: LiqIcons.home,
                          label: 'Home',
                          isSelected: _selectedToolbarItem == 0,
                          onTap: () =>
                              setState(() => _selectedToolbarItem = 0),
                        ),
                        LiqIconBarItem(
                          icon: LiqIcons.search,
                          label: 'Search',
                          isSelected: _selectedToolbarItem == 1,
                          onTap: () =>
                              setState(() => _selectedToolbarItem = 1),
                        ),
                        LiqIconBarItem(
                          icon: LiqMaterialIcons.addBox,
                          label: 'Create',
                          isSelected: _selectedToolbarItem == 2,
                          onTap: () =>
                              setState(() => _selectedToolbarItem = 2),
                        ),
                        LiqIconBarItem(
                          icon: LiqMaterialIcons.notifications,
                          label: 'Alerts',
                          badge: '3',
                          isSelected: _selectedToolbarItem == 3,
                          onTap: () =>
                              setState(() => _selectedToolbarItem = 3),
                        ),
                        LiqIconBarItem(
                          icon: LiqMaterialIcons.person,
                          label: 'Profile',
                          isSelected: _selectedToolbarItem == 4,
                          onTap: () =>
                              setState(() => _selectedToolbarItem = 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _section(
            title: 'Toolbar with Dividers',
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.appleColors.gray.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: LiqIconBar(
                showDividers: true,
                items: <Widget>[
                  LiqIconButton(
                    icon: LiqMaterialIcons.arrowBack,
                    style: LiqIconButtonStyle.borderless,
                    size: 36,
                    onPressed: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Document Title',
                      style: context.textStyles.headline.copyWith(
                        fontWeight: LiqAppleTypography.semibold,
                      ),
                    ),
                  ),
                  LiqIconButton(
                    icon: LiqIcons.share,
                    style: LiqIconButtonStyle.borderless,
                    size: 36,
                    onPressed: () {},
                  ),
                  LiqIconButton(
                    icon: LiqMaterialIcons.moreVert,
                    style: LiqIconButtonStyle.borderless,
                    size: 36,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          _section(
            title: 'Toolbar Button Groups',
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.appleColors.gray.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: <Widget>[
                  LiqIconButtonGroup(
                    selectedIndex: _selectedGroupItem,
                    onItemSelected: (i) =>
                        setState(() => _selectedGroupItem = i),
                    items: const <LiqIconBarItem>[
                      LiqIconBarItem(
                        icon: LiqMaterialIcons.viewList,
                        semanticLabel: 'List View',
                      ),
                      LiqIconBarItem(
                        icon: LiqMaterialIcons.viewModule,
                        semanticLabel: 'Grid View',
                      ),
                      LiqIconBarItem(
                        icon: LiqMaterialIcons.viewColumn,
                        semanticLabel: 'Column View',
                      ),
                    ],
                  ),
                  const Spacer(),
                  LiqButton(
                    label: 'Action',
                    size: LiqButtonSize.small,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          _section(
            title: 'Floating Toolbar',
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: context.appleColors.gray.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      'Content Area',
                      style: context.textStyles.title2,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: LiqFloatingToolbar(
                        items: <Widget>[
                          LiqIconButton(
                            icon: LiqIcons.edit,
                            style: LiqIconButtonStyle.borderless,
                            size: 36,
                            onPressed: () {},
                          ),
                          LiqIconButton(
                            icon: LiqMaterialIcons.contentCopy,
                            style: LiqIconButtonStyle.borderless,
                            size: 36,
                            onPressed: () {},
                          ),
                          LiqIconButton(
                            icon: LiqMaterialIcons.contentPaste,
                            style: LiqIconButtonStyle.borderless,
                            size: 36,
                            onPressed: () {},
                          ),
                          LiqIconButton(
                            icon: LiqMaterialIcons.delete,
                            style: LiqIconButtonStyle.borderless,
                            size: 36,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _section(
            title: 'Text Formatting Toolbar',
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.appleColors.gray.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: <Widget>[
                      _formatButton(_TextFormatAction.bold, LiqMaterialIcons.formatBold),
                      _formatButton(
                          _TextFormatAction.italic, LiqMaterialIcons.formatItalic),
                      _formatButton(
                          _TextFormatAction.underline, LiqMaterialIcons.formatUnderlined),
                      Container(
                        width: 1,
                        height: 24,
                        color: context.appleColors.separator,
                      ),
                      _formatButton(
                          _TextFormatAction.alignLeft, LiqMaterialIcons.formatAlignLeft),
                      _formatButton(_TextFormatAction.alignCenter,
                          LiqMaterialIcons.formatAlignCenter),
                      _formatButton(_TextFormatAction.alignRight,
                          LiqMaterialIcons.formatAlignRight),
                      Container(
                        width: 1,
                        height: 24,
                        color: context.appleColors.separator,
                      ),
                      for (final color in <Color>[
                        const Color(0xFF000000),
                        context.appleColors.red,
                        context.appleColors.blue,
                        context.appleColors.green,
                      ])
                        GestureDetector(
                          onTap: () => setState(() => _textColor = color),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _textColor == color
                                    ? context.appleColors.blue
                                    : context.appleColors.separator,
                                width: _textColor == color ? 2 : 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.appleColors.gray.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Sample text with formatting',
                    style: TextStyle(
                      color: _textColor,
                      fontWeight:
                          _activeFormats.contains(_TextFormatAction.bold)
                              ? FontWeight.bold
                              : FontWeight.normal,
                      fontStyle:
                          _activeFormats.contains(_TextFormatAction.italic)
                              ? FontStyle.italic
                              : FontStyle.normal,
                      decoration:
                          _activeFormats.contains(_TextFormatAction.underline)
                              ? TextDecoration.underline
                              : TextDecoration.none,
                    ),
                    textAlign: _activeFormats
                            .contains(_TextFormatAction.alignCenter)
                        ? TextAlign.center
                        : _activeFormats
                                .contains(_TextFormatAction.alignRight)
                            ? TextAlign.right
                            : TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'Custom Toolbar Items',
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.appleColors.gray.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: LiqIconBar(
                items: <Widget>[
                  LiqIconBarItem(
                    icon: LiqIcons.folder,
                    selectedColor: context.appleColors.orange,
                    isSelected: true,
                    onTap: () {},
                  ),
                  LiqIconBarItem(
                    icon: LiqIcons.star,
                    selectedColor: context.appleColors.yellow,
                    onTap: () {},
                  ),
                  LiqIconBarItem(
                    icon: LiqIcons.download,
                    selectedColor: context.appleColors.green,
                    badge: '12',
                    onTap: () {},
                  ),
                  LiqIconBarItem(
                    icon: LiqMaterialIcons.cloudUpload,
                    selectedColor: context.appleColors.blue,
                    onTap: () {},
                  ),
                  LiqIconBarItem(
                    icon: LiqIcons.settings,
                    disabled: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formatButton(_TextFormatAction action, IconData icon) {
    final isActive = _activeFormats.contains(action);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isActive) {
            _activeFormats.remove(action);
          } else {
            // Alignment is mutually exclusive
            if (action == _TextFormatAction.alignLeft ||
                action == _TextFormatAction.alignCenter ||
                action == _TextFormatAction.alignRight) {
              _activeFormats.removeWhere((a) =>
                  a == _TextFormatAction.alignLeft ||
                  a == _TextFormatAction.alignCenter ||
                  a == _TextFormatAction.alignRight);
            }
            _activeFormats.add(action);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive
              ? context.appleColors.blue.withValues(alpha: 0.15)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive
              ? context.appleColors.blue
              : context.appleColors.label,
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title2.copyWith(
              fontWeight: LiqAppleTypography.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
