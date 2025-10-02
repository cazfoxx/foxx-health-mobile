class CommunityReport {
  final int id;
  final int reporterAccountId;
  final int postId;
  final int commentId;
  final String reportReason;
  final String additionalDetails;
  final String status;
  final bool isActive;
  final DateTime createdAt;
  final DateTime reviewedAt;

  CommunityReport({
    required this.id,
    required this.reporterAccountId,
    required this.postId,
    required this.commentId,
    required this.reportReason,
    required this.additionalDetails,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.reviewedAt,
  });

  factory CommunityReport.fromJson(Map<String, dynamic> json) {
    return CommunityReport(
      id: json['id'] ?? 0,
      reporterAccountId: json['reporter_account_id'] ?? 0,
      postId: json['post_id'] ?? 0,
      commentId: json['comment_id'] ?? 0,
      reportReason: json['report_reason'] ?? '',
      additionalDetails: json['additional_details'] ?? '',
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      reviewedAt: DateTime.parse(json['reviewed_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter_account_id': reporterAccountId,
      'post_id': postId,
      'comment_id': commentId,
      'report_reason': reportReason,
      'additional_details': additionalDetails,
      'status': status,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'reviewed_at': reviewedAt.toIso8601String(),
    };
  }
}

class CommunityReportRequest {
  final int postId;
  final int commentId;
  final String reportReason;
  final String additionalDetails;

  CommunityReportRequest({
    required this.postId,
    required this.commentId,
    required this.reportReason,
    required this.additionalDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'comment_id': commentId,
      'report_reason': reportReason,
      'additional_details': additionalDetails,
    };
  }
}

