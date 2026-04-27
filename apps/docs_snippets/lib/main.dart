import 'package:docs_snippets/src/app.dart';
import 'package:docs_snippets/src/ready.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui_assets/liqkit_ui_assets.dart';

/// Entry point for the docs_snippets Flutter Web app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiqFontLoader.loadAll();
  setReadyFlag();
  runApp(const SnippetsApp());
}
