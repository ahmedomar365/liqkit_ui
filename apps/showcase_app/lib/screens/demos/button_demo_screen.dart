import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class ButtonDemoScreen extends ConsumerStatefulWidget {
  const ButtonDemoScreen({super.key});

  @override
  ConsumerState<ButtonDemoScreen> createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends ConsumerState<ButtonDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return const LiqScaffold(
      appBar: LiqAppBar(title: Text('Buttons')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: ButtonDemoBody(),
      ),
    );
  }
}

/// Body-only widget that renders every button variant section without
/// its own Scaffold or AppBar. Used by `ButtonDemoScreen` standalone
/// and by the combined `ButtonsAllInOneScreen` that stacks multiple
/// button-demo bodies in one scroll.
class ButtonDemoBody extends ConsumerStatefulWidget {
  const ButtonDemoBody({super.key});

  @override
  ConsumerState<ButtonDemoBody> createState() => _ButtonDemoBodyState();
}

class _ButtonDemoBodyState extends ConsumerState<ButtonDemoBody> {
  bool _isLoading = false;
  bool _isDisabled = false;

  void _simulateLoading() {
    setState(() => _isLoading = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  VoidCallback? _press(VoidCallback action) =>
      _isDisabled || _isLoading ? null : action;

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Controls',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  LiqButton(
                    label: _isDisabled ? 'Enable All' : 'Disable All',
                    style: LiqButtonStyle.borderedSecondary,
                    size: LiqButtonSize.small,
                    onPressed: () => setState(() => _isDisabled = !_isDisabled),
                  ),
                  LiqButton(
                    label: 'Simulate Loading',
                    style: LiqButtonStyle.borderedSecondary,
                    size: LiqButtonSize.small,
                    onPressed: _isLoading ? null : _simulateLoading,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Primary Buttons',
              child: Column(
                children: <Widget>[
                  _ButtonRow(<Widget>[
                    LiqButton(
                      label: 'Small',
                      size: LiqButtonSize.small,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Small primary button')),
                    ),
                    LiqButton(
                      label: 'Medium',
                      size: LiqButtonSize.medium,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Medium primary button')),
                    ),
                    LiqButton(
                      label: 'Large',
                      size: LiqButtonSize.large,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Large primary button')),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  LiqButton(
                    label: 'Full Width Primary Button',
                    fullWidth: true,
                    isLoading: _isLoading,
                    onPressed: _press(() => _toast('Full width primary button')),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Secondary Buttons',
              child: _ButtonRow(<Widget>[
                LiqButton(
                  label: 'Small',
                  style: LiqButtonStyle.borderedSecondary,
                  size: LiqButtonSize.small,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Small secondary button')),
                ),
                LiqButton(
                  label: 'Medium',
                  style: LiqButtonStyle.borderedSecondary,
                  size: LiqButtonSize.medium,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Medium secondary button')),
                ),
                LiqButton(
                  label: 'Large',
                  style: LiqButtonStyle.borderedSecondary,
                  size: LiqButtonSize.large,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Large secondary button')),
                ),
              ]),
            ),
            _Section(
              title: 'Destructive Buttons',
              child: _ButtonRow(<Widget>[
                LiqButton(
                  label: 'Small',
                  destructive: true,
                  size: LiqButtonSize.small,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Small destructive button')),
                ),
                LiqButton(
                  label: 'Medium',
                  destructive: true,
                  size: LiqButtonSize.medium,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Medium destructive button')),
                ),
                LiqButton(
                  label: 'Large',
                  destructive: true,
                  size: LiqButtonSize.large,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Large destructive button')),
                ),
              ]),
            ),
            _Section(
              title: 'Ghost Buttons',
              child: _ButtonRow(<Widget>[
                LiqButton(
                  label: 'Small',
                  style: LiqButtonStyle.borderless,
                  size: LiqButtonSize.small,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Small ghost button')),
                ),
                LiqButton(
                  label: 'Medium',
                  style: LiqButtonStyle.borderless,
                  size: LiqButtonSize.medium,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Medium ghost button')),
                ),
                LiqButton(
                  label: 'Large',
                  style: LiqButtonStyle.borderless,
                  size: LiqButtonSize.large,
                  isLoading: _isLoading,
                  onPressed: _press(() => _toast('Large ghost button')),
                ),
              ]),
            ),
            _Section(
              title: 'Buttons with Icons',
              child: Column(
                children: <Widget>[
                  _ButtonRow(<Widget>[
                    LiqButton(
                      label: 'Download',
                      leadingIcon: LiqIcons.download,
                      size: LiqButtonSize.small,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Download button')),
                    ),
                    LiqButton(
                      label: 'Upload',
                      leadingIcon: LiqIcons.upload,
                      size: LiqButtonSize.medium,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Upload button')),
                    ),
                    LiqButton(
                      label: 'Share',
                      leadingIcon: LiqIcons.share,
                      size: LiqButtonSize.large,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Share button')),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _ButtonRow(<Widget>[
                    LiqButton(
                      label: 'Previous',
                      leadingIcon: LiqMaterialIcons.arrowBack,
                      style: LiqButtonStyle.borderedSecondary,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Previous button')),
                    ),
                    LiqButton(
                      label: 'Next',
                      trailingIcon: LiqMaterialIcons.arrowForward,
                      style: LiqButtonStyle.borderedSecondary,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Next button')),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  LiqButton(
                    label: 'Delete',
                    leadingIcon: LiqMaterialIcons.delete,
                    destructive: true,
                    isLoading: _isLoading,
                    onPressed: _press(() => _toast('Delete button')),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Icon Buttons',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  LiqIconButton(
                    icon: LiqMaterialIcons.favorite,
                    semanticLabel: 'Favorite',
                    onPressed: _press(() => _toast('Favorite')),
                  ),
                  LiqIconButton(
                    icon: LiqIcons.bookmark,
                    semanticLabel: 'Bookmark',
                    onPressed: _press(() => _toast('Bookmark')),
                  ),
                  LiqIconButton(
                    icon: LiqIcons.settings,
                    semanticLabel: 'Settings',
                    onPressed: _press(() => _toast('Settings')),
                  ),
                  LiqIconButton(
                    icon: LiqMaterialIcons.moreVert,
                    semanticLabel: 'More options',
                    onPressed: _press(() => _toast('More')),
                  ),
                  const SizedBox(width: 12),
                  LiqIconButton(
                    icon: LiqMaterialIcons.add,
                    size: 32,
                    color: LiqAppleColors.systemBlue,
                    semanticLabel: 'Add',
                    onPressed: _press(() => _toast('Add')),
                  ),
                  LiqIconButton(
                    icon: LiqIcons.edit,
                    size: 44,
                    color: LiqAppleColors.systemGreen,
                    semanticLabel: 'Edit',
                    onPressed: _press(() => _toast('Edit')),
                  ),
                  LiqIconButton(
                    icon: LiqMaterialIcons.delete,
                    size: 56,
                    color: LiqAppleColors.systemRed,
                    semanticLabel: 'Delete',
                    onPressed: _press(() => _toast('Delete')),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Custom Width Buttons',
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: LiqButton(
                      label: 'Fixed Width (200px)',
                      fullWidth: true,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Fixed width button')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 150,
                    child: LiqButton(
                      label: 'Fixed Width (150px)',
                      style: LiqButtonStyle.borderedSecondary,
                      fullWidth: true,
                      isLoading: _isLoading,
                      onPressed: _press(() => _toast('Fixed width button')),
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Long Press Actions',
              child: LiqButton(
                label: 'Long Press Me',
                style: LiqButtonStyle.borderedSecondary,
                isLoading: _isLoading,
                onPressed: _press(() => _toast('Tapped')),
                onLongPress: _isDisabled ? null : () => _toast('Long pressed!'),
              ),
            ),
            _Section(
              title: 'Button States',
              child: Column(
                children: <Widget>[
                  _ButtonRow(<Widget>[
                    LiqButton(
                      label: 'Normal',
                      onPressed: () => _toast('Normal button'),
                    ),
                    LiqButton(
                      label: 'Loading',
                      isLoading: true,
                      onPressed: () {},
                    ),
                    const LiqButton(
                      label: 'Disabled',
                      onPressed: null,
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _ButtonRow(<Widget>[
                    LiqButton(
                      label: 'Normal',
                      style: LiqButtonStyle.borderedSecondary,
                      onPressed: () => _toast('Normal button'),
                    ),
                    LiqButton(
                      label: 'Loading',
                      style: LiqButtonStyle.borderedSecondary,
                      isLoading: true,
                      onPressed: () {},
                    ),
                    const LiqButton(
                      label: 'Disabled',
                      style: LiqButtonStyle.borderedSecondary,
                      onPressed: null,
                    ),
                  ]),
                ],
              ),
            ),
            _Section(
              title: 'Custom Content',
              child: LiqButton(
                label: 'Rate Us',
                leadingIcon: LiqIcons.star,
                trailingIcon: LiqIcons.star,
                isLoading: _isLoading,
                onPressed: _press(() => _toast('Custom content button')),
              ),
            ),
          ],
        );
  }

  void _toast(String message) => LiqToastOverlay.show(context, message);
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow(this.buttons);

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 12, runSpacing: 12, children: buttons);
  }
}
