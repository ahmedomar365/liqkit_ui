// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

const TextStyle _slideText = TextStyle(
  color: Color(0xFFFFFFFF),
  fontSize: 24,
  fontWeight: FontWeight.w600,
);

const List<Widget> _items = <Widget>[
  ColoredBox(
    color: Color(0xFF34C759),
    child: Center(child: Text('Slide 1', style: _slideText)),
  ),
  ColoredBox(
    color: Color(0xFF007AFF),
    child: Center(child: Text('Slide 2', style: _slideText)),
  ),
  ColoredBox(
    color: Color(0xFFFF9500),
    child: Center(child: Text('Slide 3', style: _slideText)),
  ),
];

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget carouselNoIndicatorBuilder(BuildContext context) {
  return SnippetFrame(
    maxWidth: 360,
    // {@highlight}
    child: LiqCarousel(height: 180, showIndicator: false, items: _items),
    // {@endhighlight}
  );
}
