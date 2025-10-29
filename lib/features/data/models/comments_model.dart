// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/data/models/userprofile_model.dart';

List<Comment> commentsFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentsToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
    int? id;
    int? postId;
    int? parentCommentId;
    String? content;
    int? accountId;
    bool? isActive;
    DateTime? createdAt;
    int? likesCount;
    UserModel? userProfile;
    bool? isReported;
    String? reportStatus;

    Comment({
        this.id,
        this.postId,
        this.parentCommentId,
        this.content,
        this.accountId,
        this.isActive,
        this.createdAt,
        this.likesCount,
        this.userProfile,
        this.isReported,
        this.reportStatus,
    });

    Comment copyWith({
        int? id,
        int? postId,
        int? parentCommentId,
        String? content,
        int? accountId,
        bool? isActive,
        DateTime? createdAt,
        int? likesCount,
        UserModel? userProfile,
        bool? isReported,
        String? reportStatus,
    }) => 
        Comment(
            id: id ?? this.id,
            postId: postId ?? this.postId,
            parentCommentId: parentCommentId ?? this.parentCommentId,
            content: content ?? this.content,
            accountId: accountId ?? this.accountId,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
            likesCount: likesCount ?? this.likesCount,
            userProfile: userProfile ?? this.userProfile,
            isReported: isReported ?? this.isReported,
            reportStatus: reportStatus ?? this.reportStatus,
        );

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        postId: json["post_id"],
        parentCommentId: json["parent_comment_id"],
        content: json["content"],
        accountId: json["account_id"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        likesCount: json["likes_count"],
        userProfile: json["user_profile"] == null ? null : UserModel.fromJson(json["user_profile"]),
        isReported: json["is_reported"],
        reportStatus: json["report_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "parent_comment_id": parentCommentId,
        "content": content,
        "account_id": accountId,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "likes_count": likesCount,
        "user_profile": userProfile?.toJson(),
        "is_reported": isReported,
        "report_status": reportStatus,
    };
}


