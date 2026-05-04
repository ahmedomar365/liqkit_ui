import 'dart:convert';
import 'dart:typed_data';

import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

final Uint8List _avatarBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAG0lEQVR42mP8z8Dwn4ECwESJ5lEDRgYGAFe7AhEOVoAbAAAAAElFTkSuQmCC',
);

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget avatarImageBuilder(BuildContext context) {
  return SnippetFrame(
    // {@highlight}
    child: LiqAvatar(image: MemoryImage(_avatarBytes), initials: 'AB'),
    // {@endhighlight}
  );
}
