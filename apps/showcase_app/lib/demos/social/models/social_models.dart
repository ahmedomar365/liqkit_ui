// User model
class User {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final bool isVerified;
  final bool isFollowing;
  final List<String> recentPhotos;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    this.bio = '',
    this.followers = 0,
    this.following = 0,
    this.posts = 0,
    this.isVerified = false,
    this.isFollowing = false,
    this.recentPhotos = const [],
  });

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? bio,
    int? followers,
    int? following,
    int? posts,
    bool? isVerified,
    bool? isFollowing,
    List<String>? recentPhotos,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      recentPhotos: recentPhotos ?? this.recentPhotos,
    );
  }
}

// Post model
class Post {
  final String id;
  final User author;
  final List<String> images;
  final String caption;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isSaved;
  final List<User> likedBy;
  final List<Comment> topComments;
  final PostType type;

  const Post({
    required this.id,
    required this.author,
    required this.images,
    required this.caption,
    required this.timestamp,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.likedBy = const [],
    this.topComments = const [],
    this.type = PostType.photo,
  });

  Post copyWith({
    String? id,
    User? author,
    List<String>? images,
    String? caption,
    DateTime? timestamp,
    int? likes,
    int? comments,
    bool? isLiked,
    bool? isSaved,
    List<User>? likedBy,
    List<Comment>? topComments,
    PostType? type,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      images: images ?? this.images,
      caption: caption ?? this.caption,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      likedBy: likedBy ?? this.likedBy,
      topComments: topComments ?? this.topComments,
      type: type ?? this.type,
    );
  }
}

// Comment model
class Comment {
  final String id;
  final User author;
  final String text;
  final DateTime timestamp;
  final int likes;
  final bool isLiked;
  final List<Comment> replies;

  const Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.timestamp,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
  });
}

// Story model
class Story {
  final String id;
  final User user;
  final List<StoryItem> items;
  final bool hasUnwatched;
  final bool isOwn;

  const Story({
    required this.id,
    required this.user,
    required this.items,
    this.hasUnwatched = true,
    this.isOwn = false,
  });
}

// Story item model
class StoryItem {
  final String id;
  final String mediaUrl;
  final StoryMediaType type;
  final DateTime timestamp;
  final Duration duration;
  final bool isWatched;

  const StoryItem({
    required this.id,
    required this.mediaUrl,
    required this.type,
    required this.timestamp,
    this.duration = const Duration(seconds: 5),
    this.isWatched = false,
  });
}

// Message model
class Message {
  final String id;
  final User sender;
  final String text;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageType type;
  final String? mediaUrl;
  final bool isOwn;

  const Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.status,
    this.type = MessageType.text,
    this.mediaUrl,
    this.isOwn = false,
  });
}

// Chat model
class Chat {
  final String id;
  final List<User> participants;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;
  final bool isMuted;

  const Chat({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    required this.lastActivity,
    this.isMuted = false,
  });
}

// Notification model
class SocialNotification {
  final String id;
  final User from;
  final NotificationType type;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? postId;
  final String? commentId;

  const SocialNotification({
    required this.id,
    required this.from,
    required this.type,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.postId,
    this.commentId,
  });
}

// Enums
enum PostType { photo, video, carousel, reel }
enum StoryMediaType { photo, video }
enum MessageStatus { sending, sent, delivered, read }
enum MessageType { text, photo, video, voice, sticker }
enum NotificationType { like, comment, follow, mention, message, story }

// Sample data generators
class SocialSampleData {
  static final currentUser = User(
    id: 'current',
    username: 'johndoe',
    displayName: 'John Doe',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    bio: 'Flutter developer | UI/UX enthusiast | Coffee lover',
    followers: 1234,
    following: 567,
    posts: 42,
    isVerified: true,
    recentPhotos: [
      'https://picsum.photos/200/200?random=1',
      'https://picsum.photos/200/200?random=2',
      'https://picsum.photos/200/200?random=3',
    ],
  );

  static final List<User> users = [
    const User(
      id: '1',
      username: 'sarah_designs',
      displayName: 'Sarah Chen',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      bio: 'Designer | Illustrator | Creative mind',
      followers: 5678,
      following: 432,
      posts: 156,
      isVerified: true,
      isFollowing: true,
    ),
    const User(
      id: '2',
      username: 'tech_mike',
      displayName: 'Mike Johnson',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
      bio: 'Tech enthusiast | Gadget reviewer | YouTuber',
      followers: 12543,
      following: 234,
      posts: 789,
      isVerified: false,
      isFollowing: false,
    ),
    const User(
      id: '3',
      username: 'foodie_emma',
      displayName: 'Emma Williams',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      bio: 'Food blogger | Recipe creator | Culinary explorer',
      followers: 8901,
      following: 678,
      posts: 234,
      isVerified: true,
      isFollowing: true,
    ),
  ];

  static List<Post> generatePosts() {
    return [
      Post(
        id: '1',
        author: users[0],
        images: ['https://picsum.photos/400/400?random=10'],
        caption: 'Working on a new design concept for a mobile app. What do you think? #uidesign #flutter',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 234,
        comments: 12,
        isLiked: true,
        likedBy: [users[1], users[2]],
        topComments: [
          Comment(
            id: 'c1',
            author: users[1],
            text: 'Looks amazing! Love the color palette',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            likes: 5,
            isLiked: true,
          ),
        ],
      ),
      Post(
        id: '2',
        author: users[1],
        images: [
          'https://picsum.photos/400/600?random=11',
          'https://picsum.photos/400/600?random=12',
          'https://picsum.photos/400/600?random=13',
        ],
        caption: 'New tech unboxing! Check out the latest gadgets in my collection. Swipe for more!',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 567,
        comments: 34,
        type: PostType.carousel,
      ),
      Post(
        id: '3',
        author: users[2],
        images: ['https://picsum.photos/400/500?random=14'],
        caption: 'Sunday brunch vibes. Recipe link in bio!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likes: 890,
        comments: 56,
        isLiked: true,
        isSaved: true,
      ),
    ];
  }

  static List<Story> generateStories() {
    return [
      Story(
        id: 'own',
        user: currentUser,
        items: [
          StoryItem(
            id: 's1',
            mediaUrl: 'https://picsum.photos/400/700?random=20',
            type: StoryMediaType.photo,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
        isOwn: true,
        hasUnwatched: false,
      ),
      ...users.map((user) => Story(
        id: user.id,
        user: user,
        items: [
          StoryItem(
            id: 's${user.id}',
            mediaUrl: 'https://picsum.photos/400/700?random=${user.id}0',
            type: StoryMediaType.photo,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ],
      )),
    ];
  }

  static List<Chat> generateChats() {
    return users.map((user) => Chat(
      id: user.id,
      participants: [user],
      lastMessage: Message(
        id: 'm${user.id}',
        sender: user,
        text: 'Hey! How are you doing?',
        timestamp: DateTime.now().subtract(Duration(hours: int.parse(user.id))),
        status: MessageStatus.delivered,
      ),
      unreadCount: int.parse(user.id) % 2 == 0 ? 2 : 0,
      lastActivity: DateTime.now().subtract(Duration(hours: int.parse(user.id))),
    )).toList();
  }

  static List<SocialNotification> generateNotifications() {
    return [
      SocialNotification(
        id: 'n1',
        from: users[0],
        type: NotificationType.like,
        message: 'liked your post',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        postId: '1',
      ),
      SocialNotification(
        id: 'n2',
        from: users[1],
        type: NotificationType.follow,
        message: 'started following you',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      SocialNotification(
        id: 'n3',
        from: users[2],
        type: NotificationType.comment,
        message: 'commented on your post: "Great work!"',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        postId: '2',
        isRead: true,
      ),
    ];
  }
}