import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';

// post manager keep track/stores the feed over the app and updates the state over the app for instant changes
// on ui for like status, count, comments count and book mark

// Enum for multiple feed sections
enum FeedType { feed, bookmark, den }

class FeedGroup {
  final List<Post> posts;
  final bool hasMore; // note this can be removed

  FeedGroup({this.posts = const [], this.hasMore = false});

  FeedGroup copyWith({List<Post>? posts, bool? hasMore}) {
    return FeedGroup(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class FeedManagerState {
  final Map<FeedType, FeedGroup> feedMap;
  final Map<FeedType, bool> loadingMap;
  final Map<FeedType, String> errorMap;
  final Map<FeedType, bool> hasMoreMap;

  FeedManagerState(
      {Map<FeedType, FeedGroup>? feedMap,
      Map<FeedType, bool>? loadingMap,
      Map<FeedType, String>? errorMap,
      Map<FeedType, bool>? hasMoreMap,
      bool? hasMore})
      : feedMap = feedMap ?? {},
        loadingMap = loadingMap ?? {},
        hasMoreMap = hasMoreMap ?? {},
        errorMap = errorMap ?? {};

  FeedManagerState copyWith(
      {Map<FeedType, FeedGroup>? feedMap,
      Map<FeedType, bool>? loadingMap,
      Map<FeedType, String>? errorMap,
      Map<FeedType, bool>? hasMoreMap}) {
    return FeedManagerState(
        feedMap: feedMap ?? this.feedMap,
        loadingMap: loadingMap ?? this.loadingMap,
        hasMoreMap: hasMoreMap ?? this.hasMoreMap,
        errorMap: errorMap ?? this.errorMap);
  }

  bool isLoading(FeedType type) => loadingMap[type] ?? false;
  String hasError(FeedType type) => errorMap[type] ?? "";
}

class FeedManagerCubit extends Cubit<FeedManagerState> {
  FeedManagerCubit() : super(FeedManagerState());

  /// set value for loading state according to the type
  void setLoading(FeedType type, bool isLoading) {
    final updatedLoading = Map<FeedType, bool>.from(state.loadingMap)
      ..[type] = isLoading;

    emit(state.copyWith(loadingMap: updatedLoading));
  }

  /// set error if any error occurs
  void setErrors(FeedType type, String error) {
    final updatedError = Map<FeedType, String>.from(state.errorMap)
      ..[type] = error;

    emit(state.copyWith(errorMap: updatedError));
  }

  /// Set posts for a particular feed type (replace)
  void setFeeds(FeedType type, FeedModel newFeed) {
    // Create a new map from the existing state
    final updatedMap = Map<FeedType, FeedGroup>.from(state.feedMap);

    // Replace the posts for this feed type
    updatedMap[type] = FeedGroup(
      posts: newFeed.posts.map((p) => p.copyWith(feedType: type)).toList(),
      hasMore: newFeed.hasMore,
    );

    // Create a new hasMoreMap
    final updatedHasMoreMap = Map<FeedType, bool>.from(state.hasMoreMap);
    updatedHasMoreMap[type] = newFeed.hasMore;

    // Emit a new state
    emit(state.copyWith(feedMap: updatedMap, hasMoreMap: updatedHasMoreMap));
  }

  /// Add posts for pagination (append to existing posts)
  void addFeeds(FeedType type, FeedModel moreFeeds) {
    // Get the current group for this feed type
    final currentGroup = state.feedMap[type] ?? FeedGroup();

    // Merge existing posts with new posts
    final updatedPosts = [
      ...currentGroup.posts,
      ...moreFeeds.posts.map((p) => p.copyWith(feedType: type)),
    ];

    // Create a new map for feedMap
    final updatedMap = Map<FeedType, FeedGroup>.from(state.feedMap);
    updatedMap[type] = currentGroup.copyWith(
      posts: updatedPosts,
      hasMore: moreFeeds.hasMore,
    );

    // Create a new hasMoreMap
    final updatedHasMoreMap = Map<FeedType, bool>.from(state.hasMoreMap);
    updatedHasMoreMap[type] = moreFeeds.hasMore;

    // Emit new state
    emit(state.copyWith(feedMap: updatedMap, hasMoreMap: updatedHasMoreMap));
  }

  /// add  user posted feed locally, assuming user can only post in dens from den page.
  void addPostToden({FeedType feedType = FeedType.den, required Post post}) {
  // Get current feed group for this type, or empty if null
  final currentGroup = state.feedMap[feedType] ?? FeedGroup();

  // Create a new list with the new post at the start (so newest shows first)
  final updatedPosts = [
    post.copyWith(feedType: feedType),
    ...currentGroup.posts,
  ];

  // Update feed map
  final updatedMap = Map<FeedType, FeedGroup>.from(state.feedMap);
  updatedMap[feedType] = currentGroup.copyWith(
    posts: updatedPosts,
    hasMore: currentGroup.hasMore,
  );

  // Emit updated state
  emit(state.copyWith(feedMap: updatedMap));
}

  /// Update post globally across all feeds (feed/bookmark/den)
  void _updateEverywhere(Post Function(Post) updater) {
    final updatedMap = state.feedMap.map((type, group) {
      final newPosts = group.posts.map(updater).toList();
      return MapEntry(type, group.copyWith(posts: newPosts));
    });
    emit(state.copyWith(feedMap: updatedMap));
  }

  /// Toggle like across all feeds
  void toggleLike(int postId, bool isLiked) {
    _updateEverywhere((p) {
      if (p.id == postId) {
        final newLikes = isLiked
            ? (p.likesCount ?? 0) + 1
            : ((p.likesCount ?? 0) - 1).clamp(0, double.infinity).toInt();
        return p.copyWith(likesCount: newLikes, userLiked: isLiked);
      }
      return p;
    });
  }

  /// Toggle bookmark across all feeds
  void toggleBookmark(int postId, bool isBookmarked) {
    _updateEverywhere((p) {
      if (p.id == postId) {
        return p.copyWith(userSaved: isBookmarked);
      }
      return p;
    });
  }

  /// Update comment count globally
  void updateCommentCount(int postId, {bool isAdd = true}) {
    _updateEverywhere((p) {
      if (p.id == postId) {
        final oldCount = p.commentsCount;
        final newCount = isAdd
            ? (oldCount ?? 0) + 1
            : ((oldCount ?? 0) - 1).clamp(0, double.infinity).toInt();

        final updatedPost = p.copyWith(commentsCount: newCount);
        return updatedPost;
      }
      return p;
    });
  }

  /// Get posts for a particular feed
  List<Post> getPostsForFeed(FeedType type) {
    final group = state.feedMap[type];
    return group?.posts ?? [];
  }

  bool hasMore(FeedType type) => state.feedMap[type]?.hasMore ?? false;

  /// Clear specific feed
  void clearFeed(FeedType type) {
    final updatedMap = Map<FeedType, FeedGroup>.from(state.feedMap);
    updatedMap.remove(type);
    emit(state.copyWith(feedMap: updatedMap));
  }

  /// Clear all feeds
  void clearAll() {
    emit(FeedManagerState());
  }
}
