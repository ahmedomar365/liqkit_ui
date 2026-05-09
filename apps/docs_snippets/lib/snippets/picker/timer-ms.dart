// ignore_for_file: file_names
import 'package:docs_snippets/src/snippet_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/examples.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
/// Sources its widget tree from `package:liqkit_ui/examples.dart` so the
/// docs preview stays in lockstep with the showcase app.
Widget pickerTimerMsBuilder(BuildContext context) {
  return const SnippetFrame(maxWidth: 360, height: 220, child: PickerTimerMsExample());
}
