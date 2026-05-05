import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:showcase/src/ready.dart';
import 'package:showcase/src/routes.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      pageRouteBuilder:
          <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (c, _, _) => builder(c),
          ),
      onGenerateRoute: (settings) {
        final builder =
            showcaseRoutes[settings.name ?? '/'] ?? _fallbackRouteBuilder;
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder:
              (context, _, _) =>
                  ShowcaseReadinessGate(child: Builder(builder: builder)),
        );
      },
      // Install a default LiqTheme above every route so component
      // routes can read theme tokens via LiqTheme.of(context). The
      // active theme is selected via MediaQuery.platformBrightnessOf
      // so the Playwright fidelity loop can flip it via emulation.
      builder: (context, child) {
        final brightness = MediaQuery.platformBrightnessOf(context);
        final data =
            brightness == Brightness.dark
                ? LiqThemeData.dark
                : LiqThemeData.light;
        return LiqTheme(data: data, child: child ?? const SizedBox.shrink());
      },
    );
  }
}

Widget _fallbackRouteBuilder(BuildContext context) => const ColoredBox(
  color: Color(0xFFFFFFFF),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: Text(
        showcaseFallbackMarker,
        style: TextStyle(color: Color(0xFF777777), fontSize: 14),
      ),
    ),
  ),
);

/// Marker text rendered when no route matches.
const String showcaseFallbackMarker = 'liqkit_ui-showcase-empty';
