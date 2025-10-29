import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';

abstract class MyBookmarkState extends Equatable {
  const MyBookmarkState();

  @override
  List<Object?> get props => [];
}

class Initial extends MyBookmarkState {}

class BookmarkLoading extends MyBookmarkState {}

class BookmarkLoaded extends MyBookmarkState {
  final List<Post> posts;
  final bool hasMore;
  const BookmarkLoaded({required this.posts, required this.hasMore});

  BookmarkLoaded copyWith({
    List<Post>? posts,
    bool? hasMore,
  }) {
    return BookmarkLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [posts, hasMore];
}

class BookmarkError extends MyBookmarkState {
  final String message;
  const BookmarkError(this.message);

  @override
  List<Object?> get props => [message];
}
