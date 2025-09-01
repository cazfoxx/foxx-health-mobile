class AppointmentQuestion {
  final int id;
  final String type;
  final String fieldName;
  final String question;
  final String description;
  final String dataType;
  final String flowType;
  final List<String> choices;
  final bool isActive;
  final bool isPremium;
  final String createdAt;
  final String updatedAt;

  AppointmentQuestion({
    required this.id,
    required this.type,
    required this.fieldName,
    required this.question,
    required this.description,
    required this.dataType,
    required this.flowType,
    required this.choices,
    required this.isActive,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentQuestion.fromJson(Map<String, dynamic> json) {
    return AppointmentQuestion(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      fieldName: json['field_name'] ?? '',
      question: json['question'] ?? '',
      description: json['description'] ?? '',
      dataType: json['data_type'] ?? '',
      flowType: json['flow_type'] ?? '',
      choices: List<String>.from(json['choices'] ?? []),
      isActive: json['is_active'] ?? false,
      isPremium: json['is_premium'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'field_name': fieldName,
      'question': question,
      'description': description,
      'data_type': dataType,
      'flow_type': flowType,
      'choices': choices,
      'is_active': isActive,
      'is_premium': isPremium,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
