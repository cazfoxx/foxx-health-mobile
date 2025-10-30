import 'package:foxxhealth/features/data/managers/feed_manager.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/base_feed_bloc.dart';

// class MyFeedBloc extends Bloc<MyFeedEvent, FeedState> {
//   final CommunityDenRepository _repository;
//   static const int _limit = 1;
//   int _skip = 0;
//   bool _isFetching = false;

//   MyFeedBloc({required CommunityDenRepository feedRepository})
//       : _repository = feedRepository,
//         super(FeedInitial()) {
//     on<LoadMyFeeds>(_onLoadFeeds);
//     on<LoadMoreFeeds>(_onLoadMoreFeeds);
//     on<RefreshMyFeeds>(_onRefreshFeeds);
//     on<UpdateLikes>(_onLiked);
//     on<UpdatedComments>(_onCommentsPosted);
//   }
// // Load own feed for den screen
//   Future<void> _onLoadFeeds(LoadMyFeeds event, Emitter<FeedState> emit) async {
//     emit(FeedLoading());
//     _skip = 0;

//     try {
//       final feed = await _repository
//           .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
//       _skip += feed.posts.length;
//       emit(FeedLoaded(
//         posts: feed.posts,
//         hasMore: feed.hasMore,
//         // totalCount: feed.totalCount,
//       ));
//     } catch (e) {
//       emit(FeedError(e.toString()));
//     }
//   }

//   Future<void> _onLoadMoreFeeds(
//       LoadMoreFeeds event, Emitter<FeedState> emit) async {
//     if (_isFetching || state is! FeedLoaded) return;
//     final currentState = state as FeedLoaded;
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
//       emit(FeedError(e.toString()));
//     } finally {
//       _isFetching = false;
//     }
//   }

//   Future<void> _onRefreshFeeds(
//       RefreshMyFeeds event, Emitter<FeedState> emit) async {
//     _skip = 0;
//     try {
//       final feed = await _repository
//           .getFeeds(queryParms: {"skip": _skip, "limit": _limit});
//       _skip += feed.posts.length;

//       emit(FeedLoaded(
//         posts: feed.posts,
//         hasMore: feed.hasMore,
//         // totalCount: feed.totalCount,
//       ));
//     } catch (e) {
//       emit(FeedError(e.toString()));
//     }
//   }

//   Future<void> _onLiked(UpdateLikes event, Emitter<FeedState> emit) async {
//     if (state is! FeedLoaded) return;

//     final currentState = state as FeedLoaded;
//     debugPrint(
//         '🔘 Like event received for postId: ${event.postId} | isLiked: ${event.isLiked}');

//     try {
//       // Wait for API confirmation before updating state
//       final success = await _repository.likePost(postID: event.postId);

//       if (!success) {
//         debugPrint(' Like API failed for postId: ${event.postId}');
//         return;
//       }

//       debugPrint(' Like API success for postId: ${event.postId}');

//       final updatedPosts = currentState.posts.map((post) {
//         if (post.id == event.postId) {
//           final newLikesCount = event.isLiked
//               ? (post.likesCount + 1)
//               : (post.likesCount - 1).clamp(0, double.infinity).toInt();

//           debugPrint(
//             ' Updating postId: ${post.id} | OldLikes: ${post.likesCount} → NewLikes: $newLikesCount | '
//             'OldUserLiked: ${post.userLiked} → NewUserLiked: ${event.isLiked}',
//           );

//           return post.copyWith(
//             likesCount: newLikesCount,
//             userLiked: event.isLiked,
//           );
//         }
//         return post;
//       }).toList();

//       emit(currentState.copyWith(posts: updatedPosts));
//       debugPrint('📢 Feed state updated with new like count.');
//     } catch (e, s) {
//       debugPrint('🔥 Error liking post ${event.postId}: $e');
//       debugPrint('Stacktrace: $s');
//     }
//   }

//   void _onCommentsPosted(UpdatedComments event, Emitter<FeedState> emit) {
//     if (state is! FeedLoaded) return;

//     final currentState = state as FeedLoaded;

//     debugPrint(
//         "🟣 UpdatedComments called for postId: ${event.postId}, newCount: ${event.commentLength}");

//     final updatedPosts = currentState.posts.map((post) {
//       final isTarget = post.id == event.postId;
//       if (isTarget) {
//         debugPrint(
//             "✅ Updating post ${post.id} → new count: ${event.commentLength}");
//         return post.copyWith(commentsCount: event.commentLength);
//       } else {
//         debugPrint("🚫 Skipping post ${post.id}");
//       }
//       return post;
//     }).toList();

//     emit(currentState.copyWith(posts: updatedPosts));
//   }
// }

class MyFeedBloc extends BaseFeedBloc {
  final CommunityDenRepository repository;
  

  MyFeedBloc(this.repository, FeedManagerCubit postManagerCubit) : super(postManagerCubit: postManagerCubit);

  @override
  Future<FeedModel> fetchFeeds(
      {required int skip, required int limit, int? id}) {
    return repository.getFeeds(queryParms: {"skip": skip, "limit": limit});
  }

  @override
  Future<bool> likePost(int postId) {
    return repository.likePost(postID: postId);
  }

  @override
  Future<bool> bookMarkPost(int postId) {
    return repository.bookmarkPost(postID: postId);
  }
}
