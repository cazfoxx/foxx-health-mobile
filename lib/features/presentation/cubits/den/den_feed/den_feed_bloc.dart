// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
// import 'package:foxxhealth/features/presentation/cubits/den/den_feed/den_feed_event.dart';
// import 'package:foxxhealth/features/presentation/cubits/den/den_feed/den_feed_state.dart';

// class DenFeedBloc extends Bloc<DenFeedEvent, DenFeedState> {
//   final CommunityDenRepository _repository;
//   static const int _limit = 3;
//   int _skip = 0;
//   bool _isFetching = false;

//   DenFeedBloc({required CommunityDenRepository feedRepository})
//       : _repository = feedRepository,
//         super(DenFeedInitial()) {
//     on<LoadDenFeeds>(_onLoadFeeds);
//     on<LoadMoreDenFeeds>(_onLoadMoreFeeds);
//     on<RefreshDenFeeds>(_onRefreshFeeds);
  
//   }
// // Load own feed for den screen
//   Future<void> _onLoadFeeds(LoadDenFeeds event, Emitter<DenFeedState> emit) async {
//     emit(DenFeedLoading());
//     _skip = 0;

//     try {
//       final feed = await _repository
//           .getDenFeeds(queryParms: {"skip": _skip, "limit": _limit}, denId: event.denId );
//       _skip += feed.posts.length;
//       emit(DenFeedLoaded(
//         posts: feed.posts,
//         hasMore: feed.hasMore,
//         // totalCount: feed.totalCount,
//       ));
//     } catch (e) {
//       emit(DenFeedError(e.toString()));
//     }
//   }

//   Future<void> _onLoadMoreFeeds(
//       LoadMoreDenFeeds event, Emitter<DenFeedState> emit) async {
//     if (_isFetching || state is! DenFeedLoaded) return;
//     final currentState = state as DenFeedLoaded;
//     if (!currentState.hasMore) return;

//     _isFetching = true;

//     try {
//       final feed = await _repository
//           .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
//       _skip += feed.posts.length;

//       emit(currentState.copyWith(
//         posts: [...currentState.posts, ...feed.posts],
//         hasMore: feed.hasMore,
//         // totalCount: feed.totalCount,
//       ));
//     } catch (e) {
//       emit(DenFeedError(e.toString()));
//     } finally {
//       _isFetching = false;
//     }
//   }

//   Future<void> _onRefreshFeeds(
//       RefreshDenFeeds event, Emitter<DenFeedState> emit) async {
//     _skip = 0;
//     try {
//       final feed = await _repository
//           .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
//       _skip += feed.posts.length;

//       emit(DenFeedLoaded(
//         posts: feed.posts,
//         hasMore: feed.hasMore,
//         // totalCount: feed.totalCount,
//       ));
//     } catch (e) {
//       emit(DenFeedError(e.toString()));
//     }
//   }
// }
