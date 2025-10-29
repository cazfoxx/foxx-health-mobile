import 'dart:developer';

import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';

class DenProfileRepositoty {
    final ApiClient _apiClient = ApiClient();

    // get UserPosts

    Future<FeedModel> getUserFeedByUserName({required String userName, Map<String, dynamic> ? queryParms}) async {
      try {
      final response = await _apiClient.get('/api/v1/community-den/posts/search/username/$userName', queryParameters: queryParms);

      if (response.statusCode == 200) {
        return FeedModel.fromJson(response.data);
      }

      final errorMsg =
          response.data?["message"] ?? "Failed to load posts";
      throw Exception(errorMsg);
    } catch (e, stack) {
      log(' Error fetching user post by username $userName: $e', stackTrace: stack);
      throw Exception(
          "Unable to fetch fetching user post by username $userName. Please try again later.");
    }
    }
}
