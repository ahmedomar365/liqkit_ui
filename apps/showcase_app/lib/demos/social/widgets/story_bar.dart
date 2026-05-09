import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/social_models.dart';

class StoryBar extends ConsumerWidget {
  final List<Story> stories;
  
  const StoryBar({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _StoryItem(story: story);
      },
    );
  }
}

class _StoryItem extends StatelessWidget {
  final Story story;
  
  const _StoryItem({required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          // Story circle
          GestureDetector(
            onTap: () {
              // Open story viewer
            },
            child: Container(
              width: 72,
              height: 72,
              padding: EdgeInsets.all(story.hasUnwatched ? 3 : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: story.hasUnwatched
                    ? LinearGradient(
                        colors: [
                          context.appleColors.pink,
                          context.appleColors.orange,
                          context.appleColors.yellow,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: story.hasUnwatched
                      ? Border.all(
                          color: LiqTheme.of(context).brightness ==
                                  Brightness.dark
                              ? const Color(0xFF000000)
                              : const Color(0xFFFFFFFF),
                          width: 3,
                        )
                      : null,
                ),
                child: ClipOval(
                  child: Image.network(
                    story.user.avatarUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Username
          SizedBox(
            width: 72,
            child: Text(
              story.isOwn ? 'Your story' : story.user.username,
              style: context.textStyles.caption2.copyWith(
                color: story.hasUnwatched
                    ? context.appleColors.label
                    : context.appleColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}