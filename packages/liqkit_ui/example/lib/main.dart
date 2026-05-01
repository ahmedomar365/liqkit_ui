import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

void main() => runApp(const _ExampleApp());

class _ExampleApp extends StatelessWidget {
  const _ExampleApp();

  @override
  Widget build(BuildContext context) {
    return const LiqApp(
      light: LiqThemeData.light,
      dark: LiqThemeData.dark,
      home: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 80,
        child: LiqMaterialSurface(
          material: LiqMaterial.regular,
          child: Center(
            child: Text(
              'liqkit_ui',
              style: LiqTheme.of(context).bodyText.toTextStyle(),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
  }
}
