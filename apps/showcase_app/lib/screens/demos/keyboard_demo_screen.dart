import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class KeyboardDemoScreen extends ConsumerStatefulWidget {
  const KeyboardDemoScreen({super.key});

  @override
  ConsumerState<KeyboardDemoScreen> createState() =>
      _KeyboardDemoScreenState();
}

class _KeyboardDemoScreenState extends ConsumerState<KeyboardDemoScreen> {
  final TextEditingController _textController = TextEditingController();

  static const List<String> _predictions = <String>[
    'Hello',
    'World',
    'Flutter',
    'Keyboard',
  ];

  static const List<({LiqKeyboardLayout value, String label})> _layouts =
      <({LiqKeyboardLayout value, String label})>[
    (value: LiqKeyboardLayout.alphabetic, label: 'Alphabetic'),
    (value: LiqKeyboardLayout.numeric, label: 'Numeric'),
    (value: LiqKeyboardLayout.decimal, label: 'Decimal'),
    (value: LiqKeyboardLayout.phone, label: 'Phone'),
    (value: LiqKeyboardLayout.email, label: 'Email'),
    (value: LiqKeyboardLayout.url, label: 'URL'),
    (value: LiqKeyboardLayout.emoji, label: 'Emoji'),
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Keyboards')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Live Text Field with Suggestion Bar',
              description:
                  'Type into the field above the keyboard. Tap a '
                  'suggestion to insert it.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: _textController,
                    placeholder: 'Type here…',
                    maxLines: 4,
                    minLines: 2,
                  ),
                  const SizedBox(height: 12),
                  LiqKeyboardSuggestionBar(
                    suggestions: _predictions,
                    onSelect: (word) {
                      setState(() {
                        _textController.text =
                            '${_textController.text} $word'.trim();
                      });
                    },
                  ),
                ],
              ),
            ),
            for (final layout in _layouts)
              _Section(
                title: '${layout.label} Layout',
                description: '`LiqKeyboardLayout.${layout.value.name}` — '
                    'auto appearance, with prediction suggestions.',
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 402),
                    child: LiqLayoutKeyboard(
                      layout: layout.value,
                      suggestions: _predictions,
                    ),
                  ),
                ),
              ),
            _Section(
              title: 'Appearance — Light',
              description: '`LiqKeyboardAppearance.light` forces the light '
                  'keyboard regardless of system theme.',
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 402),
                  child: const LiqLayoutKeyboard(
                    appearance: LiqKeyboardAppearance.light,
                    suggestions: _predictions,
                  ),
                ),
              ),
            ),
            _Section(
              title: 'Appearance — Dark',
              description: '`LiqKeyboardAppearance.dark` forces the dark '
                  'keyboard regardless of system theme.',
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 402),
                  child: const LiqLayoutKeyboard(
                    appearance: LiqKeyboardAppearance.dark,
                    suggestions: _predictions,
                  ),
                ),
              ),
            ),
            _Section(
              title: 'Appearance — Auto',
              description: '`LiqKeyboardAppearance.auto` follows the '
                  'enclosing LiqTheme brightness.',
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 402),
                  child: const LiqLayoutKeyboard(
                    suggestions: _predictions,
                  ),
                ),
              ),
            ),
            _Section(
              title: 'No Predictions',
              description: 'Pass an empty `suggestions` list to hide the '
                  'prediction bar.',
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 402),
                  child: const LiqLayoutKeyboard(
                    suggestions: <String>[],
                  ),
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
            Text(description!,
                style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
