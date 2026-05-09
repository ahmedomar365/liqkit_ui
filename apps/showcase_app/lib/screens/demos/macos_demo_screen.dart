import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class MacOSDemoScreen extends ConsumerStatefulWidget {
  const MacOSDemoScreen({super.key});

  @override
  ConsumerState<MacOSDemoScreen> createState() => _MacOSDemoScreenState();
}

class _MacOSDemoScreenState extends ConsumerState<MacOSDemoScreen> {
  int _selectedSidebarIndex = 0;
  String _selectedPopupValue = 'Option 1';
  int _selectedSegment = 0;
  LiqCheckboxState _checkbox = LiqCheckboxState.unchecked;
  double _progressValue = 0.6;
  final TextEditingController _searchController = TextEditingController();

  static const List<({String title, IconData icon, String? badge})>
      _sidebarItems = <({String title, IconData icon, String? badge})>[
    (title: 'General', icon: LiqIcons.settings, badge: null),
    (title: 'Appearance', icon: LiqIcons.palette, badge: null),
    (title: 'Security', icon: LiqMaterialIcons.security, badge: '2'),
    (title: 'Network', icon: LiqIcons.wifi, badge: null),
    (title: 'Advanced', icon: LiqMaterialIcons.settingsApplications, badge: null),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toast(String message) => LiqToastOverlay.show(context, message);

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('macOS Platform Components')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _section(
            title: 'macOS Window',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : 720.0;
                return LiqWindow(
                  size: Size(width, 400),
                  toolbar: const LiqWindowToolbar(
                    leading: <Widget>[LiqWindowControls()],
                    title: 'Preferences',
                  ),
                  child: Row(
                    children: <Widget>[
                      LiqSidebar(
                        width: 220,
                        children: <Widget>[
                          for (var i = 0; i < _sidebarItems.length; i++)
                            LiqSidebarRow(
                              title: _sidebarItems[i].title,
                              icon: Icon(_sidebarItems[i].icon, size: 18),
                              detail: _sidebarItems[i].badge,
                              selected: i == _selectedSidebarIndex,
                              onPressed: () =>
                                  setState(() => _selectedSidebarIndex = i),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _sidebarItems[_selectedSidebarIndex].title,
                                style: context.textStyles.largeTitle,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'This is the ${_sidebarItems[_selectedSidebarIndex].title} settings panel.',
                                style: context.textStyles.body,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _section(
            title: 'macOS Toolbar',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.appleColors.gray.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  LiqIconButton(
                    icon: LiqMaterialIcons.arrowBack,
                    iconSize: 20,
                    size: 36,
                    onPressed: () => _toast('Back'),
                  ),
                  const SizedBox(width: 8),
                  LiqIconButton(
                    icon: LiqMaterialIcons.arrowForward,
                    iconSize: 20,
                    size: 36,
                    onPressed: () => _toast('Forward'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: LiqSearchField(
                      controller: _searchController,
                      placeholder: 'Search...',
                    ),
                  ),
                  const SizedBox(width: 20),
                  LiqIconButton(
                    icon: LiqIcons.settings,
                    iconSize: 20,
                    size: 36,
                    onPressed: () => _toast('Settings'),
                  ),
                ],
              ),
            ),
          ),
          _section(
            title: 'macOS Buttons',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                LiqButton(
                  label: 'Primary',
                  onPressed: () => _toast('Primary button pressed'),
                ),
                LiqButton(
                  label: 'Secondary',
                  style: LiqButtonStyle.borderedSecondary,
                  onPressed: () => _toast('Secondary button pressed'),
                ),
                const LiqButton(
                  label: 'Disabled',
                  style: LiqButtonStyle.borderedSecondary,
                  onPressed: null,
                ),
              ],
            ),
          ),
          _section(
            title: 'macOS Popup Button',
            child: Row(
              children: <Widget>[
                Text('Select option:', style: context.textStyles.body),
                const SizedBox(width: 16),
                LiqDropdownButton<String>(
                  value: _selectedPopupValue,
                  menuWidth: 200,
                  items: const <LiqDropdownItem<String>>[
                    LiqDropdownItem<String>(
                      value: 'Option 1',
                      label: 'Option 1',
                    ),
                    LiqDropdownItem<String>(
                      value: 'Option 2',
                      label: 'Option 2',
                    ),
                    LiqDropdownItem<String>(
                      value: 'Option 3',
                      label: 'Option 3',
                    ),
                  ],
                  onChanged: (v) => setState(
                    () => _selectedPopupValue = v ?? _selectedPopupValue,
                  ),
                ),
              ],
            ),
          ),
          _section(
            title: 'macOS Segmented Control',
            child: Center(
              child: LiqSegmentedControl<int>(
                value: _selectedSegment,
                segments: const <({int value, String label})>[
                  (value: 0, label: 'View 1'),
                  (value: 1, label: 'View 2'),
                  (value: 2, label: 'View 3'),
                ],
                onChanged: (v) => setState(() => _selectedSegment = v),
              ),
            ),
          ),
          _section(
            title: 'macOS Progress Bar',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Progress: ${(_progressValue * 100).toInt()}%',
                  style: context.textStyles.caption1,
                ),
                const SizedBox(height: 8),
                LiqProgressBar(value: _progressValue),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    LiqIconButton(
                      icon: LiqMaterialIcons.remove,
                      iconSize: 16,
                      size: 32,
                      onPressed: () => setState(() {
                        _progressValue =
                            (_progressValue - 0.1).clamp(0.0, 1.0);
                      }),
                    ),
                    const SizedBox(width: 8),
                    LiqIconButton(
                      icon: LiqMaterialIcons.add,
                      iconSize: 16,
                      size: 32,
                      onPressed: () => setState(() {
                        _progressValue =
                            (_progressValue + 0.1).clamp(0.0, 1.0);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _section(
            title: 'macOS Checkbox',
            child: Row(
              children: <Widget>[
                LiqCheckbox(
                  value: _checkbox,
                  onChanged: (next) => setState(() => _checkbox = next),
                ),
                const SizedBox(width: 8),
                Text('Enable feature', style: context.textStyles.body),
              ],
            ),
          ),
          _section(
            title: 'macOS Gestures',
            child: Column(
              children: <Widget>[
                _HoverCard(textStyle: context.textStyles.body),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Draggable<String>(
                      data: 'Draggable Item',
                      feedback: _DragChip(
                        text: 'Dragging…',
                        color: context.appleColors.blue,
                      ),
                      childWhenDragging: _DragChip(
                        text: 'Drag me',
                        color: context.appleColors.gray,
                      ),
                      child: _DragChip(
                        text: 'Drag me',
                        color: context.appleColors.blue,
                      ),
                    ),
                    DragTarget<String>(
                      onAcceptWithDetails: (details) =>
                          _toast('Dropped: ${details.data}'),
                      builder: (context, candidate, rejected) {
                        final active = candidate.isNotEmpty;
                        return Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            color: (active
                                    ? context.appleColors.green
                                    : context.appleColors.gray)
                                .withValues(alpha: active ? 0.2 : 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: active
                                  ? context.appleColors.green
                                  : context.appleColors.gray.withValues(
                                      alpha: 0.3,
                                    ),
                            ),
                          ),
                          child: const Center(child: Text('Drop here')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LiqTooltip(
                  message: 'This is a macOS-style tooltip',
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          context.appleColors.gray.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Hover for tooltip'),
                  ),
                ),
              ],
            ),
          ),
        ],
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

class _HoverCard extends StatefulWidget {
  const _HoverCard({required this.textStyle});

  final TextStyle textStyle;

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appleColors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 100,
        decoration: BoxDecoration(
          color: _hovered
              ? colors.blue.withValues(alpha: 0.1)
              : colors.gray.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered
                ? colors.blue
                : colors.gray.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            _hovered ? 'Hovering!' : 'Hover over me',
            style: widget.textStyle,
          ),
        ),
      ),
    );
  }
}

class _DragChip extends StatelessWidget {
  const _DragChip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(text)),
    );
  }
}
