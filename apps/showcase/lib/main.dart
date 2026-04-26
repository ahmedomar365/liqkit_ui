import 'package:flutter/widgets.dart';
import 'package:liqkit_ui_assets/liqkit_ui_assets.dart';
import 'package:showcase/src/ready.dart';
import 'package:showcase/src/routes.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiqFontLoader.loadAll();
  runApp(const ShowcaseApp());
}

/// Root app for the liqkit_ui showcase.
class ShowcaseApp extends StatelessWidget {
  /// Creates the showcase app.
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'liqkit_ui showcase',
      color: const Color(0xFF000000),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (c, _, _) => builder(c),
      ),
      onGenerateRoute: (settings) {
        final builder = showcaseRoutes[settings.name ?? '/'];
        if (builder == null) return null;
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (context, _, _) => ShowcaseReadinessGate(
            child: Builder(builder: builder),
          ),
        );
      },
      builder: (context, child) => child ?? const SizedBox.shrink(),
    );
  }
}

/// Marker text rendered when no route matches.
const String showcaseFallbackMarker = 'liqkit_ui-showcase-empty';
