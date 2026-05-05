// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget actionSheetWithCancelBuilder(BuildContext context) {
  return const _ActionSheetWithCancelDemo();
}

class _ActionSheetWithCancelDemo extends StatefulWidget {
  const _ActionSheetWithCancelDemo();

  @override
  State<_ActionSheetWithCancelDemo> createState() =>
      _ActionSheetWithCancelDemoState();
}

class _ActionSheetWithCancelDemoState
    extends State<_ActionSheetWithCancelDemo> {
  bool _presented = true;

  @override
  Widget build(BuildContext context) {
    return SnippetFrame(
      maxWidth: 420,
      height: 410,
      surface: SnippetFrameSurface.liquidLight,
      surfacePadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _PhotoSource(onPressed: () => setState(() => _presented = true)),
          AnimatedSlide(
            offset: _presented ? Offset.zero : const Offset(0, 1.08),
            duration: LiqMotion.normal,
            curve: LiqMotion.snappy,
            child: AnimatedOpacity(
              opacity: _presented ? 1 : 0,
              duration: LiqMotion.fast,
              child:
              // {@highlight}
              LiqActionSheet(
                title: 'Share',
                actions: <LiqAlertAction>[
                  LiqAlertAction(
                    label: 'Copy Link',
                    onPressed: () => setState(() => _presented = false),
                  ),
                  LiqAlertAction(
                    label: 'Save to Files',
                    onPressed: () => setState(() => _presented = false),
                  ),
                ],
                cancelAction: LiqAlertAction(
                  label: 'Cancel',
                  onPressed: () => setState(() => _presented = false),
                ),
              ),
              // {@endhighlight}
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSource extends StatelessWidget {
  const _PhotoSource({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Photo',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFFFF6B8A),
                    Color(0xFF2F8DFF),
                    Color(0xFF58D68D),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          LiqButton(label: 'Open actions', onPressed: onPressed),
        ],
      ),
    );
  }
}
