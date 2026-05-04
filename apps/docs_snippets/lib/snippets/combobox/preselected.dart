import 'package:docs_snippets/src/demo.dart';
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget comboboxPreselectedBuilder(BuildContext context) {
  return const _ComboboxPreselectedDemo();
}

class _ComboboxPreselectedDemo extends StatefulWidget {
  const _ComboboxPreselectedDemo();

  @override
  State<_ComboboxPreselectedDemo> createState() =>
      _ComboboxPreselectedDemoState();
}

class _ComboboxPreselectedDemoState extends State<_ComboboxPreselectedDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return SnippetFrame(
      maxWidth: 420,
      height: _open ? 314 : null,
      child: Align(
        alignment: Alignment.topCenter,
        child: LiqDemo<String?>(
          initial: 'jp',
          builder:
              (v, set) =>
              // {@highlight}
              LiqCombobox<String>(
                placeholder: 'Choose a country',
                value: v,
                onChanged: set,
                onOpenChanged: (open) => setState(() => _open = open),
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
    );
  }
}
