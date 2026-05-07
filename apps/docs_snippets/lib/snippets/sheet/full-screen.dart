// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget sheetFullScreenBuilder(BuildContext context) {
  return const _SheetFullScreenDemo();
}

class _SheetFullScreenDemo extends StatefulWidget {
  const _SheetFullScreenDemo();

  @override
  State<_SheetFullScreenDemo> createState() => _SheetFullScreenDemoState();
}

class _SheetFullScreenDemoState extends State<_SheetFullScreenDemo> {
  bool _presented = true;

  @override
  Widget build(BuildContext context) {
    return SnippetFrame(
      maxWidth: 430,
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      surface: SnippetFrameSurface.liquidThemed,
      surfacePadding: EdgeInsets.zero,
      surfaceScrimOpacity: 0.18,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _SheetDemoPage(onPressed: () => setState(() => _presented = true)),
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
                title: 'Edit Profile',
                height: 430,
                leading: LiqSheetTopButton(
                  semanticsLabel: 'Close',
                  onPressed: () => setState(() => _presented = false),
                  child: const Text('x'),
                ),
                trailing: LiqSheetTopButton(
                  style: LiqSheetTopButtonStyle.primary,
                  semanticsLabel: 'Done',
                  onPressed: () => setState(() => _presented = false),
                  child: const Text('OK'),
                ),
                child: const _ProfileSheetBody(),
              ),
              // {@endhighlight}
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetDemoPage extends StatelessWidget {
  const _SheetDemoPage({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SnippetLabel(
            'Account',
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          const _DemoRow(label: 'Name', value: 'Ava Chen'),
          const _DemoRow(label: 'Plan', value: 'Pro'),
          const _DemoRow(label: 'Notifications', value: 'On'),
          const Spacer(),
          LiqButton(label: 'Show sheet', onPressed: onPressed),
        ],
      ),
    );
  }
}

class _ProfileSheetBody extends StatelessWidget {
  const _ProfileSheetBody();

  @override
  Widget build(BuildContext context) {
    final isDark = LiqTheme.maybeOf(context)?.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _DemoRow(label: 'Display name', value: 'Ava Chen'),
          const _DemoRow(label: 'Email', value: 'ava@example.com'),
          const _DemoRow(label: 'Status', value: 'Available'),
          const SizedBox(height: 18),
          Text(
            'Full-screen sheets keep focus on one modal task while retaining '
            'the native grabber and control row.',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6E6E73),
              fontSize: 15,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoRow extends StatelessWidget {
  const _DemoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = LiqTheme.maybeOf(context)?.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 15,
                color:
                    isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6E6E73),
              ),
            ),
          ),
          Text(
            value,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: isDark ? const Color(0xFFF5F5F7) : const Color(0xFF1A1A1A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
