import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/examples.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class PickerDemoScreen extends ConsumerStatefulWidget {
  const PickerDemoScreen({super.key});

  @override
  ConsumerState<PickerDemoScreen> createState() => _PickerDemoScreenState();
}

class _PickerDemoScreenState extends ConsumerState<PickerDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Pickers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _Section(
              title: 'Single Column',
              description:
                  'Tap to open a sheet that lets the user pick a single value from a list.',
              child: PickerSingleColumnExample(),
            ),
            _Section(
              title: 'Multi Column',
              description:
                  'Select related values across multiple columns (month / day / year).',
              child: PickerMultiColumnExample(),
            ),
            _Section(
              title: 'Number',
              description:
                  'Stepper-style number picker with configurable min/max/step.',
              child: PickerNumberExample(),
            ),
            _Section(
              title: 'Measurement',
              description:
                  'Decimal-precision pickers for measurements with units.',
              child: PickerMeasurementExample(),
            ),
            _Section(
              title: 'Inline Date Wheel — Date Mode',
              description:
                  'Wheel-style date picker rendered inline (month / day / '
                  'year columns).',
              child: PickerWheelDateExample(),
            ),
            _Section(
              title: 'Inline Date Wheel — Time Mode',
              description: 'Hour / minute (and AM/PM) columns only.',
              child: PickerWheelTimeExample(),
            ),
            _Section(
              title: 'Inline Date Wheel — Date & Time Mode',
              description: 'Combined date columns + hour / minute columns.',
              child: PickerWheelDateTimeExample(),
            ),
            _Section(
              title: 'Inline Date Wheel — Month + Year Mode',
              description:
                  'Month + year only — common for credit-card expiry pickers.',
              child: PickerWheelMonthYearExample(),
            ),
            _Section(
              title: 'Inline Date Wheel — 24-Hour Format',
              description: 'Pass `use24hFormat: true` to drop AM/PM.',
              child: PickerWheelTime24hExample(),
            ),
            _Section(
              title: 'Date / Time / Date+Time Buttons',
              description:
                  'List-row triggers that open a date wheel sheet from the bottom.',
              child: PickerTriggerButtonsExample(),
            ),
            _Section(
              title: 'Date Range',
              description: 'Two coupled date pickers selecting a start and end.',
              child: PickerDateRangeExample(),
            ),
            _Section(
              title: 'Timer — Hours + Minutes + Seconds',
              description:
                  'Countdown duration picker with `LiqTimerPickerMode.hms`.',
              child: PickerTimerHmsExample(),
            ),
            _Section(
              title: 'Timer — Hours + Minutes',
              description:
                  '`LiqTimerPickerMode.hm` — when seconds aren\'t relevant '
                  '(e.g. cooking, focus timers).',
              child: PickerTimerHmExample(),
            ),
            _Section(
              title: 'Timer — Minutes + Seconds',
              description:
                  '`LiqTimerPickerMode.ms` — short stopwatch-style durations.',
              child: PickerTimerMsExample(),
            ),
            _Section(
              title: 'Timer — Custom Minute Interval',
              description:
                  'Pass `minuteInterval: 5` (or 15 / 30) to step minutes.',
              child: PickerTimerIntervalExample(),
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
