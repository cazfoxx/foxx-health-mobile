import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
abstract class PostFeedState extends Equatable {
  const PostFeedState();

  @override
  List<Object?> get props => [];
}

class PostDenInitial extends PostFeedState {}

class PostDenLoading extends PostFeedState {}

class PostDenSuccess extends PostFeedState {
  final Post post;
  const PostDenSuccess(this.post);

  @override
  List<Object?> get props => [post];
}

class PostDenFailure extends PostFeedState {
  final String message;
  const PostDenFailure(this.message);

  @override
  List<Object?> get props => [message];
}
