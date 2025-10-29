import 'dart:convert';
import 'dart:developer';

import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/explore_den_screen.dart';

class CommunityDenRepository {
  final ApiClient _apiClient = ApiClient();

// fectch list of dens
  Future<List<CommunityDenModel>> getCommunityDens() async {
    try {
      final response = await _apiClient.get('/api/v1/community-den');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // log('Community Dens API Response Data: ${jsonEncode(data)}');

        // return data
        //     .map((item) => CommunityDenModel.fromJson(item))
        //     .toList();

        /// map the fetched dens to include svgPath from allTopics
        final dens =
            data.map((item) => CommunityDenModel.fromJson(item)).map((den) {
          final matchedTopic = allTopics.firstWhere(
            (topic) => topic.title.toLowerCase() == den.name.toLowerCase(),
            orElse: () => DenTopic(title: den.name, svgPath: DenIcons.foxx),
          );
          return den.copyWith(svgPath: matchedTopic.svgPath);
        }).toList();

        return dens;
      } else {
        final message =
            response.data?['message'] ?? 'Failed to load community dens';
        log('Failed to fetch dens (Status: ${response.statusCode}): $message');
        throw Exception(message);
      }
    } catch (e, stack) {
      log('Error fetching community dens: $e', stackTrace: stack);
      throw Exception('Unable to load community dens. Please try again later.');
    }
  }

  // Get community den details by ID
  Future<CommunityDenModel> getCommunityDenDetails(int id) async {
    try {
      final response = await _apiClient.get('/api/v1/community-den/$id');

      if (response.statusCode == 200) {
        return CommunityDenModel.fromJson(response.data);
      }

      final errorMsg =
          response.data?["message"] ?? "Failed to load community den details";
      throw Exception(errorMsg);
    } catch (e, stack) {
      log(' Error fetching community den details: $e', stackTrace: stack);
      throw Exception(
          "Unable to fetch community den details. Please try again later.");
    }
  }

  // join den
  Future<bool> joinDen(int id) async {
    try {
      final response = await _apiClient.post(
        '/api/v1/community-den/$id/join',
        data: {
          "role": "member",
        },
      );

      if (response.statusCode == 200) {
        log('Joined den successfully: ${jsonEncode(response.data)}');
        return true;
      }

      final errorMsg = response.data?["message"] ?? "Failed to join den";
      log('Join den failed: $errorMsg (Status: ${response.statusCode})');
      return false;
    } catch (e, stack) {
      log('Error while joining den: $e', stackTrace: stack);
      return false;
    }
  }

// join multiple dens
  Future<bool> bulkJoinDen(List<int> ids) async {
    try {
      final response = await _apiClient.post(
        '/api/v1/community-den/bulk-join',
        data: {"den_ids": ids},
      );
      if (response.statusCode == 200) {
        log('Joined den successfully: ${jsonEncode(response.data)}');
        return true;
      }

      final errorMsg = response.data?["message"] ?? "Failed to join den";
      log('Join den failed: $errorMsg (Status: ${response.statusCode})');
      return false;
    } catch (e, stack) {
      log('Error while joining den: $e', stackTrace: stack);
      throw Exception("'Failed to save topics. Please try again.");
    }
  }

// leave den
  Future<String?> leaveDen(int id) async {
    try {
      final response = await _apiClient.post(
        '/api/v1/community-den/$id/leave',
        data: {},
      );

      if (response.statusCode == 200) {
        log('Leave den success: ${jsonEncode(response.data)}');
        return response.data["message"] ?? "Left den successfully";
      }

      final errorMsg = response.data?["message"] ?? "Failed to leave den";
      log('Leave den failed: $errorMsg (Status: ${response.statusCode})');
      throw Exception(errorMsg);
    } catch (e, stack) {
      log(' Error while leaving den: $e', stackTrace: stack);
      throw Exception(
          'Unable to process your request right now. Please try again.');
    }
  }

// delete den
  Future<bool> deleteDen(int id) async {
    try {
      final response = await _apiClient.delete('/api/v1/community-den/$id');

      if (response.statusCode == 200) {
        log('Leave den success: ${jsonEncode(response.data)}');
        return true;
      }

      log(' Leave den failed with status: ${response.statusCode}');
      return false;
    } catch (e, stack) {
      log(' Error leaving den: $e', stackTrace: stack);
      return false;
    }
  }

  // get own den
  Future<List<CommunityDenModel>> getMydens() async {
    try {
      final response = await _apiClient.get('/api/v1/community-den/my-dens');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // return data
        //     .map((item) => CommunityDenModel.fromJson(item))
        //     .toList();

        /// map the fetched dens to include svgPath from allTopics
        final dens =
            data.map((item) => CommunityDenModel.fromJson(item)).map((den) {
          final matchedTopic = allTopics.firstWhere(
            (topic) => topic.title.toLowerCase() == den.name.toLowerCase(),
            orElse: () => DenTopic(title: den.name, svgPath: DenIcons.foxx),
          );
          return den.copyWith(svgPath: matchedTopic.svgPath, isJoined:  true );
        }).toList();

        return dens;
      } else {
        final message =
            response.data?['message'] ?? 'Failed to load community dens';
        throw Exception(message);
      }
    } catch (e, stack) {
      log(' Error fetching my dens: $e', stackTrace: stack);
      throw Exception('Unable to load your dens. Please try again later.');
    }
  }

// get feed of particular den
  Future<FeedModel> getDenFeeds(
      {Map<String, dynamic>? queryParms, required int denId}) async {
    try {
      final response = await _apiClient.get(
          '/api/v1/community-den/posts/den/$denId',
          queryParameters: queryParms);

      if (response.statusCode == 200) {
        return FeedModel.fromJson(response.data);
      }

      final errorMsg =
          response.data?["message"] ?? "Failed to load community den details";
      throw Exception(errorMsg);
    } catch (e, stack) {
      log(' Error fetching community den details: $e', stackTrace: stack);
      throw Exception(
          "Unable to fetch community den details. Please try again later.");
    }
  }

  // get own feeds
  Future<FeedModel> getFeeds({Map<String, dynamic>? queryParms}) async {
    try {
      final response = await _apiClient.get('/api/v1/community-den/posts/feed',
          queryParameters: queryParms);

      if (response.statusCode == 200) {
        return FeedModel.fromJson(response.data);
      }

      final errorMsg =
          response.data?["message"] ?? "Failed to load community den details";
      throw Exception(errorMsg);
    } catch (e, stack) {
      log(' Error fetching community den details: $e', stackTrace: stack);
      throw Exception(
          "Unable to fetch community den details. Please try again later.");
    }
  }

  //My bookmark  - get saved dens
  Future<FeedModel> getMyBookmark({Map<String, dynamic>? queryParms}) async {
    try {
      final response = await _apiClient.get('/api/v1/community-den/posts/saved',
          queryParameters: queryParms);

      if (response.statusCode == 200) {
        return FeedModel.fromJson(response.data);
      }

      final errorMsg =
          response.data?["message"] ?? "Failed to load community den details";
      throw Exception(errorMsg);
    } catch (e, stack) {
      log(' Error fetching community den details: $e', stackTrace: stack);
      throw Exception(
          "Unable to fetch community den details. Please try again later.");
    }
  }

  // Request den
  requestDen() async {
    try {
      final response =
          await _apiClient.post('/api/v1/community-den/posts/feed', data: {});

      if (response.statusCode == 200) {
        log("request den successfull");
      }

      final errorMsg =
          response.data?["message"] ?? "Failed to load community den details";
      throw Exception(errorMsg);
    } catch (e, stack) {
      log(' Error fetching community den details: $e', stackTrace: stack);
      throw Exception(
          "Unable to fetch community den details. Please try again later.");
    }
  }

// search den
  Future<List<CommunityDenModel>> searchDens(
      {required String search, int skip = 0, int limit = 20}) async {
    try {
      final response = await _apiClient.get('/api/v1/community-den/search',
          queryParameters: {"q": search, "skip": skip, "limit": limit});

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["dens"];

        // return data
        //     .map((item) => CommunityDenModel.fromJson(item))
        //     .toList();

        /// map the fetched dens to include svgPath from allTopics
        final dens =
            data.map((item) => CommunityDenModel.fromJson(item)).map((den) {
          final matchedTopic = allTopics.firstWhere(
            (topic) => topic.title.toLowerCase() == den.name.toLowerCase(),
            orElse: () => DenTopic(title: den.name, svgPath: DenIcons.foxx),
          );
          return den.copyWith(svgPath: matchedTopic.svgPath);
        }).toList();

        return dens;
      } else {
        final message =
            response.data?['message'] ?? 'Failed to load community dens';
        throw Exception(message);
      }
    } catch (e, stack) {
      log(' Error fetching my dens: $e', stackTrace: stack);
      throw Exception('Unable to load your dens. Please try again later.');
    }
  }

  // Like post

  Future<bool> likePost({required int postID}) async {
    try {
      final response = await _apiClient.post(
        '/api/v1/community-den/engagement/posts/$postID/like',
      );

      if (response.statusCode == 200) {
        log('Like post success: ${jsonEncode(response.data)}');
        return true;
      }

      log('Like failed with status: ${response.statusCode}');
      return false;
    } catch (e, stack) {
      log(' Error leaving den: $e', stackTrace: stack);
      return false;
    }
  }
}
