import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class EmptyStateDemoScreen extends ConsumerStatefulWidget {
  const EmptyStateDemoScreen({super.key});

  @override
  ConsumerState<EmptyStateDemoScreen> createState() =>
      _EmptyStateDemoScreenState();
}

class _EmptyStateDemoScreenState extends ConsumerState<EmptyStateDemoScreen> {
  void _toast(String message) => LiqToastOverlay.show(context, message);

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Empty States')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Standard — No Data',
              description: 'Default placeholder when a list has no items yet.',
              child: LiqTypedEmptyState.noData(
                title: 'No Data Yet',
                description: 'Start by adding some items to see them here.',
                actionLabel: 'Add Items',
                onAction: () => _toast('Add items'),
              ),
            ),
            _Section(
              title: 'Standard — Error',
              description: 'Generic error state with a retry action.',
              child: LiqTypedEmptyState.error(
                title: 'Oops! Something Went Wrong',
                description:
                    "We couldn't load your content. Please try again.",
                actionLabel: 'Retry',
                onAction: () => _toast('Retry'),
              ),
            ),
            _Section(
              title: 'Standard — No Connection',
              description: 'Surface for offline / no-network states.',
              child: LiqTypedEmptyState.noConnection(
                title: 'No Internet Connection',
                description: 'Please check your connection and try again.',
                actionLabel: 'Try Again',
                onAction: () => _toast('Trying again'),
              ),
            ),
            _Section(
              title: 'Standard — No Results',
              description: 'For empty search / filter results.',
              child: LiqTypedEmptyState.noResults(
                title: 'No Results Found',
                description: 'Try adjusting your search terms or filters.',
                actionLabel: 'Clear Filters',
                onAction: () => _toast('Filters cleared'),
              ),
            ),
            _Section(
              title: 'Standard — Custom',
              description: 'Pick your own icon, copy, and call-to-action.',
              child: LiqTypedEmptyState(
                type: LiqEmptyStateType.custom,
                icon: LiqMaterialIcons.celebrationOutlined,
                iconSize: 100,
                title: 'Custom Empty State',
                description:
                    'This is a custom empty state with your own icon and copy.',
                actionLabel: 'Take Action',
                onAction: () => _toast('Custom action'),
              ),
            ),
            _Section(
              title: 'Compact',
              description:
                  'Small inline placeholders for empty list cells or grids.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: LiqCompactEmptyState(
                      icon: LiqMaterialIcons.folderOpen,
                      text: 'Empty folder',
                      onTap: () => _toast('Empty folder tapped'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: LiqCompactEmptyState(
                      icon: LiqMaterialIcons.imageNotSupported,
                      text: 'No images',
                      onTap: () => _toast('No images tapped'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: LiqCompactEmptyState(
                      icon: LiqMaterialIcons.messageOutlined,
                      text: 'No messages',
                      onTap: () => _toast('No messages tapped'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: LiqCompactEmptyState(
                      icon: LiqMaterialIcons.notificationsNone,
                      text: 'No notifications',
                      onTap: () => _toast('No notifications tapped'),
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Illustrated',
              description:
                  'Larger marketing-style empty state with custom illustration and stacked actions.',
              child: LiqIllustratedEmptyState(
                illustration: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        context.appleColors.blue.withValues(alpha: 0.3),
                        context.appleColors.purple.withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LiqMaterialIcons.rocketLaunchOutlined,
                    size: 80,
                    color: context.appleColors.blue,
                  ),
                ),
                title: 'Ready to Launch?',
                subtitle:
                    "Start your journey by creating your first project. It's easy and takes just a few seconds.",
                actions: <Widget>[
                  LiqButton(
                    label: 'Create Project',
                    onPressed: () => _toast('Create project'),
                  ),
                  const SizedBox(height: 12),
                  LiqButton(
                    label: 'Learn More',
                    style: LiqButtonStyle.borderless,
                    onPressed: () => _toast('Learn more'),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Loading',
              description:
                  'Use while content is being fetched to bridge to the eventual empty/full state.',
              child: const LiqLoadingState(message: 'Loading your content...'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
