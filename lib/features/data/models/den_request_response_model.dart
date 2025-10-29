// To parse this JSON data, do
//
//     final requestDenResponse = requestDenResponseFromJson(jsonString);

import 'dart:convert';

RequestDenResponse requestDenResponseFromJson(String str) => RequestDenResponse.fromJson(json.decode(str));

String requestDenResponseToJson(RequestDenResponse data) => json.encode(data.toJson());

class RequestDenResponse {
    int? id;
    int? requesterId;
    String? name;
    String? description;
    String? category;
    String? iconUrl;
    List<String>? imageUrls;
    String? status;
    dynamic adminNotes;
    bool? isActive;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic reviewedAt;
    dynamic reviewedBy;
    dynamic communityDenId;
    String? requesterName;
    String ? reviewerName;

    RequestDenResponse({
        this.id,
        this.requesterId,
        this.name,
        this.description,
        this.category,
        this.iconUrl,
        this.imageUrls,
        this.status,
        this.adminNotes,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.reviewedAt,
        this.reviewedBy,
        this.communityDenId,
        this.requesterName,
        this.reviewerName,
    });

    RequestDenResponse copyWith({
        int? id,
        int? requesterId,
        String? name,
        String? description,
        String? category,
        String? iconUrl,
        List<String>? imageUrls,
        String? status,
        dynamic adminNotes,
        bool? isActive,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic reviewedAt,
        dynamic reviewedBy,
        dynamic communityDenId,
        String? requesterName,
        String? reviewerName,
    }) => 
        RequestDenResponse(
            id: id ?? this.id,
            requesterId: requesterId ?? this.requesterId,
            name: name ?? this.name,
            description: description ?? this.description,
            category: category ?? this.category,
            iconUrl: iconUrl ?? this.iconUrl,
            imageUrls: imageUrls ?? this.imageUrls,
            status: status ?? this.status,
            adminNotes: adminNotes ?? this.adminNotes,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            reviewedAt: reviewedAt ?? this.reviewedAt,
            reviewedBy: reviewedBy ?? this.reviewedBy,
            communityDenId: communityDenId ?? this.communityDenId,
            requesterName: requesterName ?? this.requesterName,
            reviewerName: reviewerName ?? this.reviewerName,
        );

    factory RequestDenResponse.fromJson(Map<String, dynamic> json) => RequestDenResponse(
        id: json["id"],
        requesterId: json["requester_id"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        iconUrl: json["icon_url"],
        imageUrls: json["image_urls"] == null ? [] : List<String>.from(json["image_urls"]!.map((x) => x)),
        status: json["status"],
        adminNotes: json["admin_notes"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        reviewedAt: json["reviewed_at"],
        reviewedBy: json["reviewed_by"],
        communityDenId: json["community_den_id"],
        requesterName: json["requester_name"],
        reviewerName: json["reviewer_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "requester_id": requesterId,
        "name": name,
        "description": description,
        "category": category,
        "icon_url": iconUrl,
        "image_urls": imageUrls == null ? [] : List<dynamic>.from(imageUrls!.map((x) => x)),
        "status": status,
        "admin_notes": adminNotes,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "reviewed_at": reviewedAt,
        "reviewed_by": reviewedBy,
        "community_den_id": communityDenId,
        "requester_name": requesterName,
        "reviewer_name": reviewerName,
    };
}
