import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/base_feed_bloc.dart';

class DenFeedBloc extends BaseFeedBloc {
  final CommunityDenRepository repository;

  DenFeedBloc(this.repository);

  @override
  Future<FeedModel> fetchFeeds(
      {required int skip, required int limit, int? id}) {
    return repository.getDenFeeds(queryParms: {
      "skip": skip,
      "limit": limit,
    }, denId: id!);
  }

  @override
  Future<bool> likePost(int postId) {
    return repository.likePost(postID: postId);
  }
}
