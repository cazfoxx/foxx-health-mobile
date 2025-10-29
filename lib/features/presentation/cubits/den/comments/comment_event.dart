import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/comments_model.dart';


abstract class CommentEvent extends Equatable {
  const CommentEvent();
  @override
  List<Object?> get props => [];
}

class FetchComments extends CommentEvent {
  final int postId;
  const FetchComments(this.postId);
}

class AddComment extends CommentEvent {
  final Comment comment;
  const AddComment(this.comment);
}

class AddCommentSuccess extends CommentEvent {
  final Comment comment;
  const AddCommentSuccess(this.comment);
}

class AddCommentFailure extends CommentEvent {
  final String error;
  const AddCommentFailure(this.error);
}

// New events for deleting comment
class DeleteComment extends CommentEvent {
  final int commentId;
 const DeleteComment(this.commentId);
}

class DeleteCommentSuccess extends CommentEvent {
  final int commentId;
 const DeleteCommentSuccess(this.commentId);
}

class DeleteCommentFailure extends CommentEvent {
  final String error;
 const DeleteCommentFailure(this.error);
}
