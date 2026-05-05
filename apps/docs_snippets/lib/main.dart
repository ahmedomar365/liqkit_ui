import 'package:docs_snippets/src/app.dart';
import 'package:docs_snippets/src/ready.dart';
import 'package:flutter/widgets.dart';

/// Entry point for the docs_snippets Flutter Web app.
///
/// We use Flutter Web's default hash URL strategy. The iframe origin
/// in apps/docs/components/liq-preview.tsx constructs URLs like
/// `${SNIPPETS_URL}/?theme=light#/button/regular`. The hash fragment
/// becomes the Navigator initial route, so the snippets app routes
/// without depending on the serving origin doing SPA-fallback.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setReadyFlag();
  runApp(const SnippetsApp());
}
