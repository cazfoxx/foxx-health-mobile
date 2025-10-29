import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  final bool hasMore;
  const FeedLoaded({required this.posts, required this.hasMore});

  FeedLoaded copyWith({
    List<Post>? posts,
    bool? hasMore,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [posts, hasMore];
}

class FeedError extends FeedState {
  final String message;
  const FeedError(this.message);

  @override
  List<Object?> get props => [message];
}
