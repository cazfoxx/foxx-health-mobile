import 'dart:convert';
import 'package:foxxhealth/features/data/models/community_den_model.dart';

FeedModel feedModelFromJson(String str) =>
    FeedModel.fromJson(json.decode(str));

String feedModelToJson(FeedModel data) => json.encode(data.toJson());

class FeedModel {
  final List<Post> posts;
  final int totalCount;
  final bool hasMore;
  final String ? userName;

  FeedModel({
    required this.posts,
    required this.totalCount,
    required this.hasMore,
    this.userName
  });

  FeedModel copyWith({
    List<Post>? posts,
    int? totalCount,
    bool? hasMore,
  }) =>
      FeedModel(
        posts: posts ?? this.posts,
        totalCount: totalCount ?? this.totalCount,
        hasMore: hasMore ?? this.hasMore,
      );

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        posts: json["posts"] != null
            ? List<Post>.from(json["posts"].map((x) => Post.fromJson(x)))
            : [],
        totalCount: json["total_count"] ?? 0,
        userName: json["username"],
        hasMore: json["has_more"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "posts": posts.map((x) => x.toJson()).toList(),
        "total_count": totalCount,
        "has_more": hasMore,
      };
}

class Post {
  final int id;
  final int denId;
  final String title;
  final String content;
  final String postType;
  final List<String>? hashtags;
  final List<String>? mediaUrls;
  final int accountId;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final CommunityDenModel? den;
  final UserProfile userProfile;
  final int likesCount;
  final int commentsCount;
  final int savesCount;
  final bool userLiked;
  final bool userSaved;
  final bool isReported;
  final String reportStatus;

  Post({
    required this.id,
    required this.denId,
    required this.title,
    required this.content,
    required this.postType,
    this.hashtags,
    this.mediaUrls,
    required this.accountId,
    required this.isActive,
    // required this.createdAt,
    // required this.updatedAt,
    this.den,
    required this.userProfile,
    required this.likesCount,
    required this.commentsCount,
    required this.savesCount,
    required this.userLiked,
    required this.userSaved,
    required this.isReported,
    required this.reportStatus,
  });

  Post copyWith({
    int? id,
    int? denId,
    String? title,
    String? content,
    String? postType,
    List<String>? hashtags,
    List<String>? mediaUrls,
    int? accountId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    CommunityDenModel? den,
    UserProfile? userProfile,
    int? likesCount,
    int? commentsCount,
    int? savesCount,
    bool? userLiked,
    bool? userSaved,
    bool? isReported,
    String? reportStatus,
  }) =>
      Post(
        id: id ?? this.id,
        denId: denId ?? this.denId,
        title: title ?? this.title,
        content: content ?? this.content,
        postType: postType ?? this.postType,
        hashtags: hashtags ?? this.hashtags,
        mediaUrls: mediaUrls ?? this.mediaUrls,
        accountId: accountId ?? this.accountId,
        isActive: isActive ?? this.isActive,
        // createdAt: createdAt ?? this.createdAt,
        // updatedAt: updatedAt ?? this.updatedAt,
        den: den ?? this.den,
        userProfile: userProfile ?? this.userProfile,
        likesCount: likesCount ?? this.likesCount,
        commentsCount: commentsCount ?? this.commentsCount,
        savesCount: savesCount ?? this.savesCount,
        userLiked: userLiked ?? this.userLiked,
        userSaved: userSaved ?? this.userSaved,
        isReported: isReported ?? this.isReported,
        reportStatus: reportStatus ?? this.reportStatus,
      );

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"] ?? 0,
        denId: json["den_id"] ?? 0,
        title: json["title"] ?? '',
        content: json["content"] ?? '',
        postType: json["post_type"] ?? '',
        hashtags: json["hashtags"] != null
            ? List<String>.from(json["hashtags"].map((x) => x))
            : [],
        mediaUrls: json["media_urls"] != null
            ? List<String>.from(json["media_urls"].map((x) => x))
            : [],
        accountId: json["account_id"] ?? 0,
        isActive: json["is_active"] ?? false,
        // createdAt: json["created_at"] != null
        //     ? DateTime.parse(json["created_at"])
        //     : DateTime.now(),
        // updatedAt: json["updated_at"] != null
        //     ? DateTime.parse(json["updated_at"])
        //     : DateTime.now(),
        den: json["den"] != null
            ? CommunityDenModel.fromJson(json["den"])
            : null,
        userProfile: UserProfile.fromJson(json["user_profile"] ?? {}),
        likesCount: json["likes_count"] ?? 0,
        commentsCount: json["comments_count"] ?? 0,
        savesCount: json["saves_count"] ?? 0,
        userLiked: json["user_liked"] ?? false,
        userSaved: json["user_saved"] ?? false,
        isReported: json["is_reported"] ?? false,
        reportStatus: json["report_status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "den_id": denId,
        "title": title,
        "content": content,
        "post_type": postType,
        "hashtags":
            hashtags != null ? List<dynamic>.from(hashtags!.map((x) => x)) : [],
        "media_urls":
            mediaUrls != null ? List<dynamic>.from(mediaUrls!.map((x) => x)) : [],
        "account_id": accountId,
        "is_active": isActive,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "den": den?.toJson(),
        "user_profile": userProfile.toJson(),
        "likes_count": likesCount,
        "comments_count": commentsCount,
        "saves_count": savesCount,
        "user_liked": userLiked,
        "user_saved": userSaved,
        "is_reported": isReported,
        "report_status": reportStatus,
      };
}

class UserProfile {
  final int id;
  final int accountId;
  final String username;
  final String profilePictureUrl;
  final String pronouns;
  final String bio;
  final bool isPrivate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.accountId,
    required this.username,
    required this.profilePictureUrl,
    required this.pronouns,
    required this.bio,
    required this.isPrivate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    int? id,
    int? accountId,
    String? username,
    String? profilePictureUrl,
    String? pronouns,
    String? bio,
    bool? isPrivate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserProfile(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        username: username ?? this.username,
        profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
        pronouns: pronouns ?? this.pronouns,
        bio: bio ?? this.bio,
        isPrivate: isPrivate ?? this.isPrivate,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["id"] ?? 0,
        accountId: json["account_id"] ?? 0,
        username: json["username"] ?? '',
        profilePictureUrl: json["profile_picture_url"] ?? '',
        pronouns: json["pronouns"] ?? '',
        bio: json["bio"] ?? '',
        isPrivate: json["is_private"] ?? false,
        isActive: json["is_active"] ?? false,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_id": accountId,
        "username": username,
        "profile_picture_url": profilePictureUrl,
        "pronouns": pronouns,
        "bio": bio,
        "is_private": isPrivate,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
