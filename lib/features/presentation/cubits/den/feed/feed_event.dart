import 'package:equatable/equatable.dart';

// abstract class MyFeedEvent extends Equatable {
//   const MyFeedEvent();

//   @override
//   List<Object?> get props => [];
// }

// class LoadMyFeeds extends MyFeedEvent {}

// class RefreshMyFeeds extends MyFeedEvent {}

// class LoadMoreFeeds extends MyFeedEvent {}

// class UpdateLikes extends MyFeedEvent {
//   final int postId;
//   final bool isLiked;

//   const UpdateLikes({required this.postId, required this.isLiked});
// }

// class UpdatedComments extends MyFeedEvent {
//   final int postId;
//   final int commentLength;
//   const UpdatedComments({required this.postId, required this.commentLength});
  
// }


/// Base event class for all feed-related actions.
abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load initial feed data.
class LoadFeeds extends FeedEvent {
  final int? id; // optional id for a specific page/feed

  const LoadFeeds({this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to refresh the feed (pull-to-refresh).
class RefreshFeeds extends FeedEvent {
   final int? id; // optional id for a specific page/feed

  const RefreshFeeds({this.id});
}

/// Event to load more data for pagination (infinite scroll).
class LoadMoreFeeds extends FeedEvent {
   final int? id; // optional id for a specific page/feed

  const LoadMoreFeeds({this.id});
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
