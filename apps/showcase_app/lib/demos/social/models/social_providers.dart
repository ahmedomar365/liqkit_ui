import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'social_models.dart';

// Current user provider
final currentUserProvider = StateProvider<User>((ref) => SocialSampleData.currentUser);

// Posts provider
final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>((ref) {
  return PostsNotifier();
});

class PostsNotifier extends StateNotifier<List<Post>> {
  PostsNotifier() : super(SocialSampleData.generatePosts());

  void toggleLike(String postId) {
    state = state.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        );
      }
      return post;
    }).toList();
  }

  void toggleSave(String postId) {
    state = state.map((post) {
      if (post.id == postId) {
        return post.copyWith(isSaved: !post.isSaved);
      }
      return post;
    }).toList();
  }

  void addPost(Post post) {
    state = [post, ...state];
  }

  void deletePost(String postId) {
    state = state.where((post) => post.id != postId).toList();
  }
}

// Stories provider
final storiesProvider = StateNotifierProvider<StoriesNotifier, List<Story>>((ref) {
  return StoriesNotifier();
});

class StoriesNotifier extends StateNotifier<List<Story>> {
  StoriesNotifier() : super(SocialSampleData.generateStories());

  void markAsWatched(String storyId) {
    state = state.map((story) {
      if (story.id == storyId) {
        return Story(
          id: story.id,
          user: story.user,
          items: story.items.map((item) => StoryItem(
            id: item.id,
            mediaUrl: item.mediaUrl,
            type: item.type,
            timestamp: item.timestamp,
            duration: item.duration,
            isWatched: true,
          )).toList(),
          hasUnwatched: false,
          isOwn: story.isOwn,
        );
      }
      return story;
    }).toList();
  }
}

// Chats provider
final chatsProvider = StateNotifierProvider<ChatsNotifier, List<Chat>>((ref) {
  return ChatsNotifier();
});

class ChatsNotifier extends StateNotifier<List<Chat>> {
  ChatsNotifier() : super(SocialSampleData.generateChats());

  void markAsRead(String chatId) {
    state = state.map((chat) {
      if (chat.id == chatId) {
        return Chat(
          id: chat.id,
          participants: chat.participants,
          lastMessage: chat.lastMessage,
          unreadCount: 0,
          lastActivity: chat.lastActivity,
          isMuted: chat.isMuted,
        );
      }
      return chat;
    }).toList();
  }

  void toggleMute(String chatId) {
    state = state.map((chat) {
      if (chat.id == chatId) {
        return Chat(
          id: chat.id,
          participants: chat.participants,
          lastMessage: chat.lastMessage,
          unreadCount: chat.unreadCount,
          lastActivity: chat.lastActivity,
          isMuted: !chat.isMuted,
        );
      }
      return chat;
    }).toList();
  }
}

// Notifications provider
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<SocialNotification>>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<List<SocialNotification>> {
  NotificationsNotifier() : super(SocialSampleData.generateNotifications());

  void markAsRead(String notificationId) {
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return SocialNotification(
          id: notification.id,
          from: notification.from,
          type: notification.type,
          message: notification.message,
          timestamp: notification.timestamp,
          isRead: true,
          postId: notification.postId,
          commentId: notification.commentId,
        );
      }
      return notification;
    }).toList();
  }

  void markAllAsRead() {
    state = state.map((notification) => SocialNotification(
      id: notification.id,
      from: notification.from,
      type: notification.type,
      message: notification.message,
      timestamp: notification.timestamp,
      isRead: true,
      postId: notification.postId,
      commentId: notification.commentId,
    )).toList();
  }

  void clearAll() {
    state = [];
  }
}

// Following status provider
final followingProvider = StateNotifierProvider<FollowingNotifier, Map<String, bool>>((ref) {
  return FollowingNotifier();
});

class FollowingNotifier extends StateNotifier<Map<String, bool>> {
  FollowingNotifier() : super({
    '1': true,  // sarah_designs
    '2': false, // tech_mike
    '3': true,  // foodie_emma
  });

  void toggleFollow(String userId) {
    state = {...state, userId: !(state[userId] ?? false)};
  }

  bool isFollowing(String userId) {
    return state[userId] ?? false;
  }
}

// Tab index provider for navigation
final socialTabIndexProvider = StateProvider<int>((ref) => 0);

// Selected filter provider for feed
final feedFilterProvider = StateProvider<FeedFilter>((ref) => FeedFilter.all);

enum FeedFilter { all, following, popular, recent }