import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class SegmentedControlDemoScreen extends ConsumerStatefulWidget {
  const SegmentedControlDemoScreen({super.key});

  @override
  ConsumerState<SegmentedControlDemoScreen> createState() =>
      _SegmentedControlDemoScreenState();
}

class _SegmentedControlDemoScreenState
    extends ConsumerState<SegmentedControlDemoScreen> {
  String _selectedSegment2 = 'First';
  String _selectedIconSegment = 'list';
  String _selectedTabSegment = 'Overview';
  String _selectedVerticalSegment = 'General';
  String _selectedSegment4 = 'First';

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Segmented Controls')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Standard',
              description:
                  'iOS-style segmented control with sliding selection indicator.',
              child: SizedBox(
                width: 370,
                child: LiqSegmentedControl<String>(
                  value: _selectedSegment2,
                  segments: const <({String value, String label})>[
                    (value: 'First', label: 'First'),
                    (value: 'Second', label: 'Second'),
                  ],
                  onChanged: (v) => setState(() => _selectedSegment2 = v),
                ),
              ),
            ),
            _Section(
              title: 'With Icons',
              description: 'Tab-style segments with leading icons.',
              child: SizedBox(
                width: 370,
                child: LiqTabSegmentedControl<String>(
                  value: _selectedIconSegment,
                  segments: const <LiqSegmentItem<String>>[
                    LiqSegmentItem(
                        value: 'list', label: 'List', icon: LiqIcons.list),
                    LiqSegmentItem(
                        value: 'grid',
                        label: 'Grid',
                        icon: LiqMaterialIcons.gridView),
                    LiqSegmentItem(
                        value: 'map',
                        label: 'Map',
                        icon: LiqMaterialIcons.map),
                  ],
                  onChanged: (v) => setState(() => _selectedIconSegment = v),
                ),
              ),
            ),
            _Section(
              title: 'Tab Style',
              description: 'Tab-based navigation with underline indicator.',
              child: SizedBox(
                width: 500,
                child: LiqTabSegmentedControl<String>(
                  value: _selectedTabSegment,
                  segments: const <LiqSegmentItem<String>>[
                    LiqSegmentItem(value: 'Overview', label: 'Overview'),
                    LiqSegmentItem(value: 'Details', label: 'Details'),
                    LiqSegmentItem(value: 'Reviews', label: 'Reviews'),
                    LiqSegmentItem(value: 'Related', label: 'Related'),
                  ],
                  onChanged: (v) => setState(() => _selectedTabSegment = v),
                ),
              ),
            ),
            _Section(
              title: 'Vertical',
              description: 'Vertical layout — useful for sidebar navigation.',
              child: SizedBox(
                width: 280,
                child: LiqVerticalSegmentedControl<String>(
                  value: _selectedVerticalSegment,
                  segments: const <LiqSegmentItem<String>>[
                    LiqSegmentItem(
                      value: 'General',
                      label: 'General',
                      icon: LiqIcons.settings,
                    ),
                    LiqSegmentItem(
                      value: 'Privacy',
                      label: 'Privacy',
                      icon: LiqIcons.lock,
                    ),
                    LiqSegmentItem(
                      value: 'Notifications',
                      label: 'Notifications',
                      icon: LiqMaterialIcons.notifications,
                    ),
                    LiqSegmentItem(
                      value: 'Account',
                      label: 'Account',
                      icon: LiqMaterialIcons.person,
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _selectedVerticalSegment = v),
                ),
              ),
            ),
            _Section(
              title: 'Custom Indicator Color',
              description:
                  'Tab segmented control with a custom indicator color.',
              child: SizedBox(
                width: 370,
                child: LiqTabSegmentedControl<String>(
                  value: _selectedSegment4,
                  indicatorColor: context.appleColors.green,
                  segments: const <LiqSegmentItem<String>>[
                    LiqSegmentItem(value: 'First', label: 'First'),
                    LiqSegmentItem(value: 'Second', label: 'Second'),
                    LiqSegmentItem(value: 'Third', label: 'Third'),
                  ],
                  onChanged: (v) => setState(() => _selectedSegment4 = v),
                ),
              ),
            ),
            _Section(
              title: 'Custom Vertical Color',
              description:
                  'Vertical segmented control with a custom selected color.',
              child: SizedBox(
                width: 280,
                child: LiqVerticalSegmentedControl<String>(
                  value: _selectedSegment4,
                  selectedColor: context.appleColors.purple,
                  segments: const <LiqSegmentItem<String>>[
                    LiqSegmentItem(
                      value: 'First',
                      label: 'First',
                      icon: LiqMaterialIcons.firstPage,
                    ),
                    LiqSegmentItem(
                      value: 'Second',
                      label: 'Second',
                      icon: LiqIcons.tag,
                    ),
                    LiqSegmentItem(
                      value: 'Third',
                      label: 'Third',
                      icon: LiqMaterialIcons.lastPage,
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedSegment4 = v),
                ),
              ),
            ),
            _Section(
              title: 'Disabled',
              description: 'A disabled segmented control reads through but does not respond.',
              child: SizedBox(
                width: 370,
                child: LiqSegmentedControl<String>(
                  value: 'First',
                  segments: const <({String value, String label})>[
                    (value: 'First', label: 'First'),
                    (value: 'Second', label: 'Second'),
                    (value: 'Third', label: 'Third'),
                  ],
                  onChanged: null,
                ),
              ),
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
