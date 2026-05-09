import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/social_providers.dart';
import '../widgets/post_card.dart';
import '../widgets/story_bar.dart';
import 'messages_screen.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final stories = ref.watch(storiesProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          'Liquid Social',
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(icon: LiqMaterialIcons.addBoxOutlined,
            onPressed: () {},
          ),
          LiqIconButton(icon: LiqMaterialIcons.sendOutlined,
            onPressed: () {
              Navigator.push(
                context,
                LiqPageRoute<void>(
                  builder: (context) => const MessagesScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LiqRefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: StoryBar(stories: stories),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= posts.length) return null;
                  return PostCard(post: posts[index]);
                },
                childCount: posts.length,
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}
