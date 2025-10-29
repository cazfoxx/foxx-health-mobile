import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/comments_model.dart';

class CommentState extends Equatable {
  final int? postId;
  final List<Comment> comments;
  final bool isLoadingComments;
  final bool isPostingComment;
  final bool isDeletingComment;

  final String? error;

  const CommentState({
    this.comments = const [],
     this.postId,
    this.isLoadingComments = false,
    this.isPostingComment = false,
    this.isDeletingComment = false,
    this.error,
  });

  CommentState copyWith({
    List<Comment>? comments,
    bool? isLoadingComments,
    bool? isPostingComment,
    bool? isDeletingComment,
    String? error,
    int? postId,
  }) {
    return CommentState(
      postId: postId ?? this.postId,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isPostingComment: isPostingComment ?? this.isPostingComment,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [comments, isLoadingComments, isPostingComment, error];
}
