import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/managers/feed_manager.dart';
import 'package:foxxhealth/features/data/repositories/den_comments_repository.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;
  final FeedManagerCubit postManagerCubit;

  CommentBloc(this.repository, this.postManagerCubit)
      : super(const CommentState()) {
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
    emit(state.copyWith(
        postId: event.comment.postId, isPostingComment: true, error: null));

    try {
      final result = await repository.addComment(comment: event.comment);
      if (result.id != null) {
        // add posted comment in list to update
        final updatedComments = [...state.comments, event.comment];

        emit(state.copyWith(comments: updatedComments));
        // update the comment count in  ui internally
        postManagerCubit.updateCommentCount(event.comment.postId!);
        //reset loading state
        emit(state.copyWith(
            postId: event.comment.postId,
            isPostingComment: false,
            error: null));
      }
    } catch (e, s) {
      emit(state.copyWith(
          postId: event.comment.postId,
          isPostingComment: false,
          error: "Failed to comment. Please try again."));

      throw ("error on commenting $e, \n stackTrace: $s");
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
      // Emit state to indicate deletion is in progress
      emit(state.copyWith(
        postId: event.comment.postId,
        isDeletingComment: true,
        error: null,
      ));

      final commentID = event.comment.id;
      // Call the repository to delete the comment
      final successDelete =
          await repository.deleteComment(commentID: commentID!);

      if (successDelete) {
        // Optimistically remove the comment from UI
        final updatedComments =
            state.comments.where((c) => c.id != commentID).toList();

        emit(state.copyWith(
          postId: event.comment.postId,
          isDeletingComment: false,
          comments: updatedComments,
        ));

        // Optionally, update global comment count in PostManagerCubit
        postManagerCubit.updateCommentCount(event.comment.postId!,
            isAdd: false);
      } else {
        // If deletion failed on server, reset loading state and show error
        emit(state.copyWith(
          isDeletingComment: false,
          error: "Failed to delete comment, please try again",
        ));
      }
    } catch (e) {
      // Handle exceptions
      emit(state.copyWith(
        isDeletingComment: false,
        error: "Failed to delete comment, please try again",
      ));
      rethrow;
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
