class BannerResponse {
  final BannerData? upsell;
  final BannerData? marketing;
  final BannerData? product;

  BannerResponse({
    this.upsell,
    this.marketing,
    this.product,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      upsell: json['upsell'] != null ? BannerData.fromJson(json['upsell']) : null,
      marketing: json['marketing'] != null ? BannerData.fromJson(json['marketing']) : null,
      product: json['product'] != null ? BannerData.fromJson(json['product']) : null,
    );
  }

  List<BannerData> get allBanners {
    final List<BannerData> banners = [];
    if (upsell != null) banners.add(upsell!);
    if (marketing != null) banners.add(marketing!);
    if (product != null) banners.add(product!);
    
    // Sort by priority (lower number = higher priority)
    banners.sort((a, b) => a.priority.compareTo(b.priority));
    return banners;
  }
}

class BannerData {
  final String type;
  final String? id;
  final String title;
  final String subtitle;
  final String? message;
  final String? questionText;
  final AnswerOptions? answers;
  final int priority;

  BannerData({
    required this.type,
    this.id,
    required this.title,
    required this.subtitle,
    this.message,
    this.questionText,
    this.answers,
    required this.priority,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      type: json['type'] ?? '',
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      message: json['message'],
      questionText: json['question_text'],
      answers: json['answers'] != null ? AnswerOptions.fromJson(json['answers']) : null,
      priority: json['priority'] ?? 999,
    );
  }
}

class AnswerOptions {
  final String answerType;
  final List<AnswerOption> answerOptions;

  AnswerOptions({
    required this.answerType,
    required this.answerOptions,
  });

  factory AnswerOptions.fromJson(Map<String, dynamic> json) {
    return AnswerOptions(
      answerType: json['answer_type'] ?? '',
      answerOptions: (json['answer_options'] as List<dynamic>?)
          ?.map((option) => AnswerOption.fromJson(option))
          .toList() ?? [],
    );
  }
}

class AnswerOption {
  final String optionId;
  final String optionText;

  AnswerOption({
    required this.optionId,
    required this.optionText,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      optionId: json['option_id'] ?? '',
      optionText: json['option_text'] ?? '',
    );
  }
} 