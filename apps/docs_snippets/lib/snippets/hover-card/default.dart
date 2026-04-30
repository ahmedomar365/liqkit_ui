// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

const TextStyle _nameStyle = TextStyle(
  fontFamily: 'SF Pro Text',
  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
  fontSize: 17,
  fontWeight: FontWeight.w600,
);

const TextStyle _bioStyle = TextStyle(
  fontFamily: 'SF Pro Text',
  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
  fontSize: 13,
  color: Color(0xFF8E8E93),
);

const TextStyle _linkStyle = TextStyle(
  fontFamily: 'SF Pro Text',
  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
  color: Color(0xFF007AFF),
  fontSize: 15,
  decoration: TextDecoration.underline,
);

const TextStyle _hintStyle = TextStyle(
  fontFamily: 'SF Pro Text',
  fontFamilyFallback: <String>['SF Pro', 'sans-serif'],
  color: Color(0xFF8E8E93),
  fontSize: 13,
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
          Text('Jane Doe', textDirection: TextDirection.ltr, style: _nameStyle),
        ],
      ),
      SizedBox(height: 8),
      Text(
        'Senior engineer at liqkit. Lives in San Francisco.',
        textDirection: TextDirection.ltr,
        style: _bioStyle,
      ),
    ],
  ),
);

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget hoverCardDefaultBuilder(BuildContext context) {
  return const Align(
    heightFactor: 1,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // {@highlight}
          LiqHoverCard(
            content: _previewContent,
            child: Text(
              '@janedoe',
              textDirection: TextDirection.ltr,
              style: _linkStyle,
            ),
          ),
          // {@endhighlight}
          SizedBox(height: 12),
          Text(
            'Hover the link with a mouse to reveal the card.',
            textDirection: TextDirection.ltr,
            style: _hintStyle,
          ),
        ],
      ),
    ),
  );
}
