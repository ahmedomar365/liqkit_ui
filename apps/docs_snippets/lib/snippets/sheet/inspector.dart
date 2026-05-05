import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget sheetInspectorBuilder(BuildContext context) {
  return const _SheetInspectorDemo();
}

class _SheetInspectorDemo extends StatefulWidget {
  const _SheetInspectorDemo();

  @override
  State<_SheetInspectorDemo> createState() => _SheetInspectorDemoState();
}

class _SheetInspectorDemoState extends State<_SheetInspectorDemo> {
  bool _presented = true;

  @override
  Widget build(BuildContext context) {
    return SnippetFrame(
      maxWidth: 430,
      height: 540,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      surface: SnippetFrameSurface.liquidLight,
      surfacePadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _InspectorCanvas(onPressed: () => setState(() => _presented = true)),
          AnimatedSlide(
            offset: _presented ? Offset.zero : const Offset(0, 1.1),
            duration: LiqMotion.normal,
            curve: LiqMotion.snappy,
            child: AnimatedOpacity(
              opacity: _presented ? 1 : 0,
              duration: LiqMotion.fast,
              child:
              // {@highlight}
              LiqSheet(
                title: 'Inspector',
                variant: LiqSheetVariant.inspector,
                leading: LiqSheetTopButton(
                  semanticsLabel: 'Close',
                  onPressed: () => setState(() => _presented = false),
                  child: const Text('x'),
                ),
                trailing: LiqSheetTopButton(
                  style: LiqSheetTopButtonStyle.primary,
                  semanticsLabel: 'Apply',
                  onPressed: () => setState(() => _presented = false),
                  child: const Text('OK'),
                ),
                child: const _InspectorSheetBody(),
              ),
              // {@endhighlight}
            ),
          ),
        ],
      ),
    );
  }
}

class _InspectorCanvas extends StatelessWidget {
  const _InspectorCanvas({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Photo',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
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
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Color(0x22000000), blurRadius: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          LiqButton(label: 'Show inspector', onPressed: onPressed),
        ],
      ),
    );
  }
}

class _InspectorSheetBody extends StatelessWidget {
  const _InspectorSheetBody();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 4, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _InspectorControl(label: 'Exposure', value: '+0.4'),
          _InspectorControl(label: 'Contrast', value: '18%'),
          _InspectorControl(label: 'Warmth', value: 'Neutral'),
          SizedBox(height: 12),
          Text(
            'Inspector sheets float over the content they adjust, using a '
            'glass surface so the edited object remains visible.',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Color(0xFF6E6E73),
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _InspectorControl extends StatelessWidget {
  const _InspectorControl({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0x4DFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Text(
            value,
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
