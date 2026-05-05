// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget actionSheetDefaultBuilder(BuildContext context) {
  return const _ActionSheetDefaultDemo();
}

class _ActionSheetDefaultDemo extends StatefulWidget {
  const _ActionSheetDefaultDemo();

  @override
  State<_ActionSheetDefaultDemo> createState() =>
      _ActionSheetDefaultDemoState();
}

class _ActionSheetDefaultDemoState extends State<_ActionSheetDefaultDemo> {
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
          _ShareSource(onPressed: () => setState(() => _presented = true)),
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
                title: 'AirDrop',
                description: 'Share “Design Notes” with nearby people.',
                actions: <LiqAlertAction>[
                  LiqAlertAction(
                    label: 'Share via AirDrop',
                    onPressed: () => setState(() => _presented = false),
                  ),
                  LiqAlertAction(
                    label: 'Copy Link',
                    onPressed: () => setState(() => _presented = false),
                  ),
                  LiqAlertAction(
                    label: 'Add to Reading List',
                    onPressed: () => setState(() => _presented = false),
                  ),
                ],
              ),
              // {@endhighlight}
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareSource extends StatelessWidget {
  const _ShareSource({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Design Notes',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xCCFFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'A short document preview stays visible underneath the '
                  'action sheet.',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color(0xFF6E6E73),
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          LiqButton(label: 'Share', onPressed: onPressed),
        ],
      ),
    );
  }
}
