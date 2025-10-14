class FeedbackModel {
  final List<String> favoritesCode;
  final String feedbackText;
  final bool isDeleted;
  final int accountId;
  final int? feedbackId;
  final String? createdAt;
  final String? updatedAt;

  FeedbackModel({
    required this.favoritesCode,
    required this.feedbackText,
    this.isDeleted = false,
    required this.accountId,
    this.feedbackId,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'favorites_code': favoritesCode,
        'favorite_parts': favoritesCode,
        'feedback_text': feedbackText,
        'usage_reason': feedbackText,
        'is_deleted': isDeleted,
        'account_id': accountId,
      };

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        favoritesCode: List<String>.from(json['favorites_code'] ?? []),
        feedbackText: json['feedback_text'] ?? '',
        isDeleted: json['is_deleted'] ?? false,
        accountId: json['account_id'] ?? 0,
        feedbackId: json['feedback_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
} 