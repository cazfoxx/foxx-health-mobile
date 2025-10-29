import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/repositories/den_comments_repository.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;

  CommentBloc(this.repository) : super(const CommentState()) {
    on<FetchComments>(_onFetchComments);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
    on<AddCommentSuccess>(_onAddCommentSuccess);
    on<AddCommentFailure>(_onAddCommentFailure);
    on<DeleteCommentSuccess>(_onDeleteCommentSuccess);
    on<DeleteCommentFailure>(_onDeleteCommentFailure);
  }

  Future<void> _onFetchComments(
    FetchComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(isLoadingComments: true, error: null));
    try {
      final comments = await repository.fetchComments(event.postId);

      log("Comments for user post ${comments.length}");
      emit(state.copyWith(
        postId: event.postId,
        comments: comments,
        isLoadingComments: false,
      ));
    } catch (e, s) {
      log("Comments for user post  error $e");
      emit(state.copyWith(
        error: e.toString(),
        isLoadingComments: false,
      ));
      throw Exception("Error fetching comments $e, \n stacktrace: $s");
    }
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(postId: event.comment.postId, isPostingComment: true, error: null));

    // Immediately update UI locally
    final updatedComments = [...state.comments, event.comment];

    emit(state.copyWith(comments: updatedComments));

    try {
      await repository.addComment(comment: event.comment);
      add(AddCommentSuccess(postId:  event.comment.postId!, comment:  event.comment));
    } catch (e) {
      add(AddCommentFailure(e.toString()));
    }
  }

  void _onAddCommentSuccess(
    AddCommentSuccess event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(postId: event.comment.postId, isPostingComment: false));
  }

  void _onAddCommentFailure(
    AddCommentFailure event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(isPostingComment: false, error: event.error));
  }

// Delete comment
  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      print("delete comment from id ${event.commentId}");
      bool successDelete =
          await repository.deleteComment(commentID: event.commentId);
      if (successDelete) {
        // Optimistically remove from UI
        final updatedComments =
            state.comments.where((c) => c.id != event.commentId).toList();
        emit(state.copyWith(postId: event.commentId, comments: updatedComments));
        add(DeleteCommentSuccess(event.commentId));
      }
    } catch (e) {
      add(DeleteCommentFailure(e.toString()));
    }
  }

  void _onDeleteCommentSuccess(
    DeleteCommentSuccess event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(isDeletingComment: false));
  }

  void _onDeleteCommentFailure(
    DeleteCommentFailure event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(isDeletingComment: false, error: event.error));
  }
}
