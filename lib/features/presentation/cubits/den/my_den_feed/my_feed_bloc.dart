import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'my_feed_event.dart';
import 'my_feed_state.dart';

class MyFeedBloc extends Bloc<MyFeedEvent, FeedState> {
  final CommunityDenRepository _repository;
  static const int _limit = 1;
  int _skip = 0;
  bool _isFetching = false;

  MyFeedBloc({required CommunityDenRepository feedRepository})
      : _repository = feedRepository,
        super(FeedInitial()) {
    on<LoadMyFeeds>(_onLoadFeeds);
    on<LoadMoreFeeds>(_onLoadMoreFeeds);
    on<RefreshMyFeeds>(_onRefreshFeeds);
  
  }
// Load own feed for den screen
  Future<void> _onLoadFeeds(LoadMyFeeds event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    _skip = 0;

    try {
      final feed = await _repository
          .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;
      emit(FeedLoaded(
        posts: feed.posts,
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onLoadMoreFeeds(
      LoadMoreFeeds event, Emitter<FeedState> emit) async {
    if (_isFetching || state is! FeedLoaded) return;
    final currentState = state as FeedLoaded;
    if (!currentState.hasMore) return;

    _isFetching = true;

    try {
      final feed = await _repository
          .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;

      emit(currentState.copyWith(
        posts: [...currentState.posts, ...feed.posts],
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(FeedError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onRefreshFeeds(
      RefreshMyFeeds event, Emitter<FeedState> emit) async {
    _skip = 0;
    try {
      final feed = await _repository
          .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;

      emit(FeedLoaded(
        posts: feed.posts,
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }
}
