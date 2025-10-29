import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/feed_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/feed_state.dart';

abstract class BaseFeedBloc extends Bloc<FeedEvent, FeedState> {
  final int _limit = 1;
  int _skip = 0;
  bool _isFetching = false;

  BaseFeedBloc() : super(FeedInitial()) {
    on<LoadFeeds>(_onLoadFeeds);
    on<LoadMoreFeeds>(_onLoadMoreFeeds);
    on<RefreshFeeds>(_onRefreshFeeds);
    on<UpdateLikes>(_onLiked);
    on<UpdatedComments>(_onCommentsPosted);
  }

  // 👇 Abstract API method that each subclass implements
  Future<FeedModel> fetchFeeds({required int skip, required int limit, int ?id});
  Future<bool> likePost(int postId);

  Future<void> _onLoadFeeds(LoadFeeds event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    _skip = 0;
    try {
      final feed = await fetchFeeds(skip: _skip, limit: _limit, id:event.id );
      _skip += feed.posts.length;
      emit(FeedLoaded(posts: feed.posts, hasMore: feed.hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onLoadMoreFeeds(LoadMoreFeeds event, Emitter<FeedState> emit) async {
    if (_isFetching || state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    if (!currentState.hasMore) return;

    _isFetching = true;
    try {
      final feed = await fetchFeeds(skip: _skip, limit: _limit, id: event.id);
      _skip += feed.posts.length;
      emit(currentState.copyWith(
        posts: [...currentState.posts, ...feed.posts],
        hasMore: feed.hasMore,
      ));
    } catch (e) {
      emit(FeedError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onRefreshFeeds(RefreshFeeds event, Emitter<FeedState> emit) async {
    _skip = 0;
    try {
      final feed = await fetchFeeds(skip: _skip, limit: _limit, id: event.id);
      _skip += feed.posts.length;
      emit(FeedLoaded(posts: feed.posts, hasMore: feed.hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onLiked(UpdateLikes event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;

    try {
      final success = await likePost(event.postId);
      if (!success) return;

      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          final newLikesCount = event.isLiked
              ? post.likesCount + 1
              : (post.likesCount - 1).clamp(0, double.infinity).toInt();
          return post.copyWith(
            likesCount: newLikesCount,
            userLiked: event.isLiked,
          );
        }
        return post;
      }).toList();

      emit(currentState.copyWith(posts: updatedPosts));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  void _onCommentsPosted(UpdatedComments event, Emitter<FeedState> emit) {
    if (state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    final updatedPosts = currentState.posts.map((post) {
      return post.id == event.postId
          ? post.copyWith(commentsCount: event.commentLength)
          : post;
    }).toList();
    emit(currentState.copyWith(posts: updatedPosts));
  }
}
