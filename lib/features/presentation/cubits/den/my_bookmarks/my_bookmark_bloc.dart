import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'my_bookmark_event.dart';
import 'my_bookmark_state.dart';

class MyBookmarkBloc extends Bloc<MyBookmarkEvent, MyBookmarkState> {
  final CommunityDenRepository _repository;
  static const int _limit = 1;
  int _skip = 0;
  bool _isFetching = false;

  MyBookmarkBloc({required CommunityDenRepository repository})
      : _repository = repository,
        super(Initial()) {
    on<LoadBookmark>(_onLoadBookmark);
    on<LoadMoreBookmark>(_onLoadMoreBookmark);
    on<RefreshBookmark>(_onRefreshBookmark);
  }

  Future<void> _onLoadBookmark(LoadBookmark event, Emitter<MyBookmarkState> emit) async {
    emit(BookmarkLoading());
    _skip = 0;

    try {
      final feed = await _repository
          .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;
      emit(BookmarkLoaded(
        posts: feed.posts,
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> _onLoadMoreBookmark(
      LoadMoreBookmark event, Emitter<MyBookmarkState> emit) async {
    if (_isFetching || state is! BookmarkLoaded) return;
    final currentState = state as BookmarkLoaded;
    if (!currentState.hasMore) return;

    _isFetching = true;

    try {
      final feed = await _repository
          .getMyBookmark(queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;

      emit(currentState.copyWith(
        posts: [...currentState.posts, ...feed.posts],
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onRefreshBookmark(
      RefreshBookmark event, Emitter<MyBookmarkState> emit) async {
    _skip = 0;
    try {
      final feed = await _repository
          .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;

      emit(BookmarkLoaded(
        posts: feed.posts,
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }
}
