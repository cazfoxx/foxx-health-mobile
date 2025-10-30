import 'package:foxxhealth/features/data/managers/feed_manager.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/base_feed_bloc.dart';

class MyBookmarkBloc extends BaseFeedBloc {
  final CommunityDenRepository repository;

  MyBookmarkBloc(this.repository, FeedManagerCubit postManagerCubit)
      : super(postManagerCubit: postManagerCubit);

  @override
  Future<FeedModel> fetchFeeds(
      {required int skip, required int limit, int? id}) {
    return repository
        .getOwnBookmarkedFeeds(queryParms: {"skip": skip, "limit": limit});
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
