import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/repositories/den_profile_repositoty.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den_user_profile/community_den_profile__event.dart';

import 'community_den_profile_state.dart';

class DenProfilePostBloc extends Bloc<DenProfileEvent, DenProfilePostState> {
  final DenProfileRepositoty _repository;
  static const int _limit = 1;
  int _skip = 0;
  bool _isFetching = false;

  DenProfilePostBloc({required DenProfileRepositoty repo})
      : _repository = repo,
        super(IntialLoad()) {
    on<LoadPosts>(_onLoadPosts);
    on<LoadMorePosts>(_onLoadMorePosts);
    on<RefeshPosts>(_onRefreshPosts);
  }

  Future<void> _onLoadPosts(
      LoadPosts event, Emitter<DenProfilePostState> emit) async {
    emit(Loading());
    _skip = 0;

    try {
      final feed = await _repository.getUserFeedByUserName(
          userName: event.userName,
          queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;
      emit(Loaded(
        feed: feed,
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<void> _onLoadMorePosts(
      LoadMorePosts event, Emitter<DenProfilePostState> emit) async {
    if (_isFetching || state is! Loaded) return;
    final currentState = state as Loaded;
    if (!currentState.hasMore) return;

    _isFetching = true;

    try {
      final feed = await _repository.getUserFeedByUserName(
          userName: event.userName,
          queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;
      final updatedFeed = currentState.feed.copyWith(
        posts: [...currentState.feed.posts, ...feed.posts],
      );
      emit(currentState.copyWith(
        feed: updatedFeed,
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(Error(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onRefreshPosts(
      RefeshPosts event, Emitter<DenProfilePostState> emit) async {
    _skip = 0;
    try {
      final feed = await _repository.getUserFeedByUserName(
          userName: event.userName,
          queryParms: {"skip": _skip, "limit": _limit});
      _skip += feed.posts.length;

      emit(Loaded(
        feed: feed,
        hasMore: feed.hasMore,
        // totalCount: feed.totalCount,
      ));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
