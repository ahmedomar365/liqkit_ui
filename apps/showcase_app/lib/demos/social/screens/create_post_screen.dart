import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class CreatePostScreen extends ConsumerWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'New Post',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              LiqMaterialIcons.addPhotoAlternateOutlined,
              size: 80,
              color: context.appleColors.tertiaryLabel,
            ),
            const SizedBox(height: 24),
            Text(
              'Create a New Post',
              style: context.textStyles.title2.copyWith(
                fontWeight: LiqAppleTypography.semibold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your moments with the world',
              style: context.textStyles.body.secondary,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: LiqButton(
                label: 'Choose Photo',
                fullWidth: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
