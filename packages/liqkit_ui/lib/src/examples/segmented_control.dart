/// Canonical segmented-control variants — single source of truth for the
/// showcase app and the liqkit.com previews.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/segmented/liq_segmented_control.dart';
import 'package:liqkit_ui/src/components/segmented/liq_segmented_variants.dart';
import 'package:liqkit_ui/src/foundation/liq_apple_colors.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

/// iOS-style segmented control with sliding selection indicator.
final class SegmentedControlStandardExample extends StatefulWidget {
  const SegmentedControlStandardExample({super.key});

  @override
  State<SegmentedControlStandardExample> createState() =>
      _SegmentedControlStandardExampleState();
}

class _SegmentedControlStandardExampleState
    extends State<SegmentedControlStandardExample> {
  String _v = 'First';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: LiqSegmentedControl<String>(
        value: _v,
        segments: const <({String value, String label})>[
          (value: 'First', label: 'First'),
          (value: 'Second', label: 'Second'),
        ],
        onChanged: (v) => setState(() => _v = v),
      ),
    );
  }
}

/// Tab-style segments with leading icons.
final class SegmentedControlWithIconsExample extends StatefulWidget {
  const SegmentedControlWithIconsExample({super.key});

  @override
  State<SegmentedControlWithIconsExample> createState() =>
      _SegmentedControlWithIconsExampleState();
}

class _SegmentedControlWithIconsExampleState
    extends State<SegmentedControlWithIconsExample> {
  String _v = 'list';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: LiqTabSegmentedControl<String>(
        value: _v,
        segments: const <LiqSegmentItem<String>>[
          LiqSegmentItem(value: 'list', label: 'List', icon: LiqIcons.list),
          LiqSegmentItem(
            value: 'grid',
            label: 'Grid',
            icon: LiqMaterialIcons.gridView,
          ),
          LiqSegmentItem(
            value: 'map',
            label: 'Map',
            icon: LiqMaterialIcons.map,
          ),
        ],
        onChanged: (v) => setState(() => _v = v),
      ),
    );
  }
}

/// Tab-based navigation with underline indicator.
final class SegmentedControlTabStyleExample extends StatefulWidget {
  const SegmentedControlTabStyleExample({super.key});

  @override
  State<SegmentedControlTabStyleExample> createState() =>
      _SegmentedControlTabStyleExampleState();
}

class _SegmentedControlTabStyleExampleState
    extends State<SegmentedControlTabStyleExample> {
  String _v = 'Overview';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: LiqTabSegmentedControl<String>(
        value: _v,
        segments: const <LiqSegmentItem<String>>[
          LiqSegmentItem(value: 'Overview', label: 'Overview'),
          LiqSegmentItem(value: 'Details', label: 'Details'),
          LiqSegmentItem(value: 'Reviews', label: 'Reviews'),
          LiqSegmentItem(value: 'Related', label: 'Related'),
        ],
        onChanged: (v) => setState(() => _v = v),
      ),
    );
  }
}

/// Vertical layout — useful for sidebar navigation.
final class SegmentedControlVerticalExample extends StatefulWidget {
  const SegmentedControlVerticalExample({super.key});

  @override
  State<SegmentedControlVerticalExample> createState() =>
      _SegmentedControlVerticalExampleState();
}

class _SegmentedControlVerticalExampleState
    extends State<SegmentedControlVerticalExample> {
  String _v = 'General';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: LiqVerticalSegmentedControl<String>(
        value: _v,
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
        onChanged: (v) => setState(() => _v = v),
      ),
    );
  }
}

/// Tab segmented control with a custom indicator color.
final class SegmentedControlCustomIndicatorColorExample extends StatefulWidget {
  const SegmentedControlCustomIndicatorColorExample({super.key});

  @override
  State<SegmentedControlCustomIndicatorColorExample> createState() =>
      _SegmentedControlCustomIndicatorColorExampleState();
}

class _SegmentedControlCustomIndicatorColorExampleState
    extends State<SegmentedControlCustomIndicatorColorExample> {
  String _v = 'First';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: LiqTabSegmentedControl<String>(
        value: _v,
        indicatorColor: context.appleColors.green,
        segments: const <LiqSegmentItem<String>>[
          LiqSegmentItem(value: 'First', label: 'First'),
          LiqSegmentItem(value: 'Second', label: 'Second'),
          LiqSegmentItem(value: 'Third', label: 'Third'),
        ],
        onChanged: (v) => setState(() => _v = v),
      ),
    );
  }
}

/// Vertical segmented control with a custom selected color.
final class SegmentedControlCustomVerticalColorExample extends StatefulWidget {
  const SegmentedControlCustomVerticalColorExample({super.key});

  @override
  State<SegmentedControlCustomVerticalColorExample> createState() =>
      _SegmentedControlCustomVerticalColorExampleState();
}

class _SegmentedControlCustomVerticalColorExampleState
    extends State<SegmentedControlCustomVerticalColorExample> {
  String _v = 'First';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: LiqVerticalSegmentedControl<String>(
        value: _v,
        selectedColor: context.appleColors.purple,
        segments: const <LiqSegmentItem<String>>[
          LiqSegmentItem(
            value: 'First',
            label: 'First',
            icon: LiqMaterialIcons.firstPage,
          ),
          LiqSegmentItem(value: 'Second', label: 'Second', icon: LiqIcons.tag),
          LiqSegmentItem(
            value: 'Third',
            label: 'Third',
            icon: LiqMaterialIcons.lastPage,
          ),
        ],
        onChanged: (v) => setState(() => _v = v),
      ),
    );
  }
}

/// A disabled segmented control reads through but does not respond.
final class SegmentedControlDisabledExample extends StatelessWidget {
  const SegmentedControlDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 370,
      child: LiqSegmentedControl<String>(
        value: 'First',
        segments: <({String value, String label})>[
          (value: 'First', label: 'First'),
          (value: 'Second', label: 'Second'),
          (value: 'Third', label: 'Third'),
        ],
        onChanged: null,
      ),
    );
  }
}
