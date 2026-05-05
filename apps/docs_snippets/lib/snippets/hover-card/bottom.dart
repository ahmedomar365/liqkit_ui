// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

const TextStyle _linkStyle = TextStyle(
  fontFamily: 'SF Pro Text',
  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
  color: Color(0xFF007AFF),
  fontSize: 15,
  decoration: TextDecoration.underline,
);

const Widget _previewContent = SizedBox(
  width: 280,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LiqAvatar(initials: 'JD'),
          SizedBox(width: 12),
          SnippetLabel('Jane Doe', fontSize: 17, fontWeight: FontWeight.w600),
        ],
      ),
      SizedBox(height: 8),
      SnippetLabel(
        'Senior engineer at liqkit. Lives in San Francisco.',
        fontSize: 13,
      ),
    ],
  ),
);

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget hoverCardBottomBuilder(BuildContext context) {
  return const SnippetFrame(
    height: 420,
    child: Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 72),
          // {@highlight}
          LiqHoverCard(
            placement: LiqHoverCardPlacement.bottom,
            content: _previewContent,
            child: Text(
              '@janedoe',
              textDirection: TextDirection.ltr,
              style: _linkStyle,
            ),
          ),
          // {@endhighlight}
          SizedBox(height: 12),
          SnippetLabel(
            'Hover the link with a mouse to reveal the card.',
            fontSize: 13,
          ),
        ],
      ),
    ),
  );
}
