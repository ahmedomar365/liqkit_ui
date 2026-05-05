import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget sheetStackedBuilder(BuildContext context) {
  return const _SheetStackedDemo();
}

class _SheetStackedDemo extends StatefulWidget {
  const _SheetStackedDemo();

  @override
  State<_SheetStackedDemo> createState() => _SheetStackedDemoState();
}

class _SheetStackedDemoState extends State<_SheetStackedDemo> {
  bool _presented = true;

  @override
  Widget build(BuildContext context) {
    return SnippetFrame(
      maxWidth: 430,
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      surface: SnippetFrameSurface.light,
      surfacePadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _StackedBackdrop(onPressed: () => setState(() => _presented = true)),
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
                title: 'Payment',
                variant: LiqSheetVariant.stacked,
                height: 430,
                leading: LiqSheetTopButton(
                  semanticsLabel: 'Close',
                  onPressed: () => setState(() => _presented = false),
                  child: const Text('x'),
                ),
                trailing: LiqSheetTopButton(
                  style: LiqSheetTopButtonStyle.primary,
                  semanticsLabel: 'Confirm',
                  onPressed: () => setState(() => _presented = false),
                  child: const Text('OK'),
                ),
                child: const _PaymentSheetBody(),
              ),
              // {@endhighlight}
            ),
          ),
        ],
      ),
    );
  }
}

class _StackedBackdrop extends StatelessWidget {
  const _StackedBackdrop({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Checkout',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const _InvoiceCard(),
          const Spacer(),
          LiqButton(label: 'Show stacked sheet', onPressed: onPressed),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _LineItem(label: 'Liqkit Pro', value: r'$24'),
          _LineItem(label: 'Tax', value: r'$2'),
          _LineItem(label: 'Total', value: r'$26', strong: true),
        ],
      ),
    );
  }
}

class _PaymentSheetBody extends StatelessWidget {
  const _PaymentSheetBody();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 8, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _LineItem(label: 'Card', value: 'Apple Pay', strong: true),
          _LineItem(label: 'Billing cycle', value: 'Monthly'),
          _LineItem(label: 'Due today', value: r'$26', strong: true),
          SizedBox(height: 18),
          Text(
            'Stacked sheets show the previous modal page tucked underneath, '
            'making layered presentation obvious.',
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

class _LineItem extends StatelessWidget {
  const _LineItem({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 15, color: Color(0xFF6E6E73)),
            ),
          ),
          Text(
            value,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 15,
              fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
