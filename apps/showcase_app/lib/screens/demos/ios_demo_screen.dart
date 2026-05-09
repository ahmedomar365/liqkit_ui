import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';


class IOSDemoScreen extends ConsumerStatefulWidget {
  const IOSDemoScreen({super.key});

  @override
  ConsumerState<IOSDemoScreen> createState() => _IOSDemoScreenState();
}

class _IOSDemoScreenState extends ConsumerState<IOSDemoScreen> {
  int _selectedSegment = 0;
  double _sliderValue = 0.5;
  bool _switchValue = true;
  int _selectedPickerIndex = 0;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toast(String message) => LiqToastOverlay.show(context, message);

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('iOS Platform Components')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _section(
            title: 'iOS Navigation Bar',
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: context.appleColors.gray.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  const LiqAppBar(
                    title: Text('iOS Navigation'),
                    actions: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(LiqIcons.search, size: 22),
                      ),
                    ],
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('Content with iOS navigation bar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _section(
            title: 'iOS Activity Indicator',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                LiqSpinner(size: LiqSpinnerSize.small),
                LiqSpinner(),
                LiqSpinner(),
              ],
            ),
          ),
          _section(
            title: 'iOS Switch',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Enable Feature', style: context.textStyles.body),
                LiqToggle(
                  value: _switchValue,
                  onChanged: (v) => setState(() => _switchValue = v),
                ),
              ],
            ),
          ),
          _section(
            title: 'iOS Slider',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Value: ${(_sliderValue * 100).toInt()}%',
                  style: context.textStyles.caption1,
                ),
                const SizedBox(height: 8),
                LiqSlider(
                  value: _sliderValue,
                  onChanged: (v) => setState(() => _sliderValue = v),
                ),
              ],
            ),
          ),
          _section(
            title: 'iOS Segmented Control',
            child: LiqSegmentedControl<int>(
              value: _selectedSegment,
              segments: const <({int value, String label})>[
                (value: 0, label: 'First'),
                (value: 1, label: 'Second'),
                (value: 2, label: 'Third'),
              ],
              onChanged: (v) => setState(() => _selectedSegment = v),
            ),
          ),
          _section(
            title: 'iOS Button',
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
              ],
            ),
          ),
          _section(
            title: 'iOS Context Menu',
            child: LiqContextMenuArea(
              items: <Widget>[
                LiqMenuItem(
                  label: 'Copy',
                  icon: const Icon(LiqMaterialIcons.docOnClipboardFill),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _toast('Copy action');
                  },
                ),
                LiqMenuItem(
                  label: 'Share',
                  icon: const Icon(LiqIcons.share),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _toast('Share action');
                  },
                ),
                LiqMenuItem(
                  label: 'Delete',
                  icon: const Icon(LiqMaterialIcons.delete),
                  style: LiqMenuItemStyle.destructive,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _toast('Delete action');
                  },
                ),
              ],
              child: LiqCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Long press for context menu',
                    style: context.textStyles.body,
                  ),
                ),
              ),
            ),
          ),
          _section(
            title: 'iOS Date Picker',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Selected: ${_selectedDate.toString().split(' ')[0]}',
                  style: context.textStyles.caption1,
                ),
                const SizedBox(height: 8),
                LiqWheelDatePicker(
                  mode: LiqWheelDatePickerMode.date,
                  initialDate: _selectedDate,
                  onDateChanged: (d) => setState(() => _selectedDate = d),
                ),
              ],
            ),
          ),
          _section(
            title: 'iOS Picker',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Selected: Item ${_selectedPickerIndex + 1}',
                  style: context.textStyles.caption1,
                ),
                const SizedBox(height: 8),
                LiqWheelPicker<int>(
                  height: 180,
                  itemExtent: 32,
                  selectedValue: _selectedPickerIndex,
                  items: <LiqWheelPickerItem<int>>[
                    for (var i = 0; i < 10; i++)
                      LiqWheelPickerItem<int>(
                        value: i,
                        label: 'Item ${i + 1}',
                      ),
                  ],
                  onValueChanged: (v) =>
                      setState(() => _selectedPickerIndex = v),
                ),
              ],
            ),
          ),
          _section(
            title: 'iOS Search Field',
            child: LiqSearchField(
              controller: _searchController,
              placeholder: 'Search...',
            ),
          ),
          _section(
            title: 'iOS Text Field',
            child: LiqTextField(
              controller: _textController,
              placeholder: 'Enter text...',
              prefixIcon: const Icon(
                LiqMaterialIcons.personFill,
                color: Color(0xFF8E8E93),
              ),
            ),
          ),
          _section(
            title: 'iOS Gestures',
            child: Column(
              children: <Widget>[
                LiqSwipeDetector(
                  onSwipeLeft: () => _toast('Swiped left'),
                  onSwipeRight: () => _toast('Swiped right'),
                  child: LiqCard(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Swipe left or right',
                        style: context.textStyles.body,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                LiqContextMenuArea(
                  items: <Widget>[
                    LiqMenuItem(
                      label: 'Action 1',
                      onPressed: () {
                        Navigator.of(context).pop();
                        _toast('Action 1');
                      },
                    ),
                    LiqMenuItem(
                      label: 'Action 2',
                      onPressed: () {
                        Navigator.of(context).pop();
                        _toast('Action 2');
                      },
                    ),
                  ],
                  child: LiqCard(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Long press for action sheet',
                        style: context.textStyles.body,
                      ),
                    ),
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
