import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/comments_model.dart';

class CommentRepository {
  final ApiClient client = ApiClient();

  /// Fetch all comments for a given post
  Future<List<Comment>> fetchComments(int postId) async {
    final url = "/api/v1/community-den/comments/posts/$postId";

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      final comments = jsonList.map((e) => Comment.fromJson(e)).toList();
      return comments;
    } else {
      throw Exception(
        'Failed to fetch comments (status: ${response.statusCode})',
      );
    }
  }

  /// Add a new comment to a post
  Future<Comment> addComment({required Comment comment}) async {
    final url = "/api/v1/community-den/comments/posts/${comment.postId}";

    final response = await client.post(url, data: {
      "parent_comment_id": comment.parentCommentId,
      "content": comment.content
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;
      return Comment.fromJson(data);
    } else {
      throw Exception(
        'Failed to add comment (status: ${response.statusCode})',
      );
    }
  }

  /// delete a new comment to a post
  Future<bool> deleteComment({required int commentID}) async {
    final url = "/api/v1/community-den/comments/$commentID";

    try {
      final response = await client.delete(url);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Failed to add comment (status: ${response.statusCode})',
        );
      }
    } catch (e, _) {
      rethrow;
    }
  }
}
