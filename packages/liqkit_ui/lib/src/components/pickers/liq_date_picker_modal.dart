import 'package:flutter/widgets.dart';

import 'package:liqkit_ui/src/components/alerts/liq_alert.dart';
import 'package:liqkit_ui/src/components/calendars/liq_calendar.dart';

/// Modal date-picker route helper.
///
/// Drop-in replacement for Material's `showDatePicker` for any iOS 26
/// flow that wants a calendar-grid picker presented as a modal.
///
/// ```dart
/// final picked = await LiqDatePickerModal.show(
///   context: context,
///   initialDate: DateTime.now(),
///   firstDate: DateTime.now(),
///   lastDate: DateTime.now().add(const Duration(days: 365)),
/// );
/// if (picked != null) … // user confirmed
/// ```
///
/// Returns the chosen date (or null when the user dismisses the
/// modal). Internally renders [LiqCalendar] inside [LiqAlert.show]
/// with Cancel + Done actions, matching the iOS modal idiom.
class LiqDatePickerModal {
  const LiqDatePickerModal._();

  /// Open the picker modal and resolve to the chosen date.
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Select date',
    String confirmLabel = 'Done',
    String cancelLabel = 'Cancel',
  }) async {
    final start = initialDate ?? DateTime.now();
    DateTime selected = start;
    DateTime? result;
    await LiqAlert.show<void>(
      context: context,
      title: title,
      content: StatefulBuilder(
        builder: (ctx, setState) => SizedBox(
          width: 320,
          height: 360,
          child: LiqCalendar(
            selectedDate: selected,
            firstDate: firstDate,
            lastDate: lastDate,
            onDateChanged: (date) {
              setState(() {
                selected = date;
              });
            },
          ),
        ),
      ),
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        LiqAlertAction(
          label: confirmLabel,
          style: LiqAlertActionStyle.filled,
          onPressed: () {
            result = selected;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    return result;
  }
}
