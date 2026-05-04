import 'package:docs_snippets/src/height_post.dart';
import 'package:docs_snippets/src/routes.g.dart';
import 'package:docs_snippets/src/theme_query.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Root app — looks up `?theme=` once, picks the LiqTheme, and routes
/// path -> WidgetBuilder via the generated `snippetRoutes` map.
class SnippetsApp extends StatelessWidget {
  /// Creates the snippets app.
  const SnippetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = readThemeQueryParam();
    final data = theme == 'dark' ? LiqThemeData.dark : LiqThemeData.light;
    return WidgetsApp(
      title: 'liqkit_ui — snippet',
      color: const Color(0xFF000000),
      initialRoute: _initialRoute(),
      pageRouteBuilder:
          <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (c, _, _) => builder(c),
          ),
      onGenerateRoute: (settings) {
        final builder = snippetRoutes[settings.name ?? '/'] ?? _fallback;
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder:
              (c, _, _) => LiqHeightReporter(child: Builder(builder: builder)),
        );
      },
      builder:
          (context, child) => LiqTheme(
            data: data,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ColoredBox(
                    color: data.surfaceColor.resolve(data.brightness),
                  ),
                ),
                child ?? const SizedBox.shrink(),
              ],
            ),
          ),
    );
  }
}

String _initialRoute() {
  final fragment = Uri.base.fragment;
  if (fragment.isEmpty) return '/';
  return fragment.startsWith('/') ? fragment : '/$fragment';
}

Widget _fallback(BuildContext context) => const ColoredBox(
  color: Color(0xFFFFFFFF),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: Text(
        'liqkit-snippets-empty',
        style: TextStyle(color: Color(0xFF777777), fontSize: 14),
      ),
    ),
  ),
);
