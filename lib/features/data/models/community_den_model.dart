class CommunityDenModel {
  final String name;
  final String description;
  final String iconUrl;
  final List<String> imageUrls;
  final List<Faq> faqs;
  final int id;
  final int memberCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final isJoined;

  final String? svgPath; // map the icon from asset 

  CommunityDenModel({
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.imageUrls,
    required this.faqs,
    required this.id,
    required this.memberCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.svgPath,
    this.isJoined = false
  });

  factory CommunityDenModel.fromJson(Map<String, dynamic> json) {
    return CommunityDenModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      faqs: (json['faqs'] as List<dynamic>?)
              ?.map((e) => Faq.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      id: json['id'] ?? 0,
      memberCount: json['member_count'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }


  CommunityDenModel copyWith({String? svgPath, bool ? isJoined}) {
    return CommunityDenModel(
      name: name,
      description: description,
      iconUrl: iconUrl,
      imageUrls: imageUrls,
      faqs: faqs,
      id: id,
      memberCount: memberCount,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      svgPath: svgPath ?? this.svgPath,
      isJoined: isJoined ?? this.isJoined
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'image_urls': imageUrls,
      'faqs': faqs.map((e) => e.toJson()).toList(),
      'id': id,
      'member_count': memberCount,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
