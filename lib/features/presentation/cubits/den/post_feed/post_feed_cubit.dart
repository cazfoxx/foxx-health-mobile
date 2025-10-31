import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/managers/feed_manager.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/post_feed/post_feed_state.dart';

class PostFeedCubit extends Cubit<PostFeedState> {
  final CommunityDenRepository _repository;
  final FeedManagerCubit postManagerCubit;

  PostFeedCubit(this._repository, this.postManagerCubit)
      : super(PostDenInitial());

  Future<void> postFeedToDen(Post post) async {
    emit(PostDenLoading());
    try {
      final createdPost = await _repository.postFeedToDen(post);
      postManagerCubit.addPostToden(post: createdPost);
      emit(PostDenSuccess(createdPost));
    } catch (e) {
      emit(PostDenFailure(e.toString()));
    }
  }
}
