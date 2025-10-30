import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/managers/feed_manager.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load initial feed data.
class LoadFeeds extends FeedEvent {
  final int? id; // optional id for a specific page/feed
  final FeedType feedType;
  const LoadFeeds({this.id, required this.feedType});

  @override
  List<Object?> get props => [id];
}

/// Event to refresh the feed (pull-to-refresh).
class RefreshFeeds extends FeedEvent {
  final int? id; // optional id for a specific page/feed
  final FeedType feedType;
  const RefreshFeeds({this.id, required this.feedType});
}

/// Event to load more data for pagination (infinite scroll).
class LoadMoreFeeds extends FeedEvent {
  final int? id; // optional id for a specific page/feed
  final FeedType feedType;
  const LoadMoreFeeds({this.id, required this.feedType});
}

/// Event to toggle like/unlike on a post.
class UpdateLikes extends FeedEvent {
  final int postId;
  final bool isLiked;

  const UpdateLikes({
    required this.postId,
    required this.isLiked,
  });

  @override
  List<Object?> get props => [postId, isLiked];
}

/// Event to toggle bookmark/unlike on a post.
class UpdateBookmark extends FeedEvent {
  final int postId;
  final bool isBookmarked;

  const UpdateBookmark({
    required this.postId,
    required this.isBookmarked,
  });

  @override
  List<Object?> get props => [postId, isBookmarked];
}

/// Event to update comment count after posting a comment.
class UpdatedComments extends FeedEvent {
  final int postId;
  final int commentLength;

  const UpdatedComments({
    required this.postId,
    required this.commentLength,
  });

  @override
  List<Object?> get props => [postId, commentLength];
}
