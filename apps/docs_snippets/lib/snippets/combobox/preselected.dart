import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget comboboxPreselectedBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<String?>(
        initial: 'jp',
        builder:
            (v, set) => SizedBox(
              width: 320,
              // {@highlight}
              child: LiqCombobox<String>(
                placeholder: 'Choose a country',
                value: v,
                onChanged: set,
                options: const <LiqComboboxOption<String>>[
                  LiqComboboxOption<String>(
                    value: 'us',
                    label: 'United States',
                  ),
                  LiqComboboxOption<String>(value: 'ca', label: 'Canada'),
                  LiqComboboxOption<String>(
                    value: 'uk',
                    label: 'United Kingdom',
                  ),
                  LiqComboboxOption<String>(value: 'au', label: 'Australia'),
                  LiqComboboxOption<String>(value: 'jp', label: 'Japan'),
                  LiqComboboxOption<String>(value: 'de', label: 'Germany'),
                  LiqComboboxOption<String>(value: 'fr', label: 'France'),
                  LiqComboboxOption<String>(value: 'br', label: 'Brazil'),
                ],
              ),
              // {@endhighlight}
            ),
      ),
    ),
  );
}
