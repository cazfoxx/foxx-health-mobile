class Symptom {
  final String id;
  final String name;
  final List<String> filterGrouping;
  final List<String> bodyParts;
  final List<String> tags;
  final List<String> visualInsights;
  final List<Map<String, dynamic>> questionMap;
  final String notes;
  final bool needHelpPopup;

  Symptom({
    required this.id,
    required this.name,
    required this.filterGrouping,
    required this.bodyParts,
    required this.tags,
    required this.visualInsights,
    required this.questionMap,
    required this.notes,
    required this.needHelpPopup,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Symptom && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Symptom.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>;
    return Symptom(
      id: json['id'] as String,
      name: info['name'] as String,
      filterGrouping: List<String>.from(info['filter_grouping'] ?? []),
      bodyParts: List<String>.from(info['body_parts'] ?? []),
      tags: List<String>.from(info['tags'] ?? []),
      visualInsights: List<String>.from(info['visual_insights'] ?? []),
      questionMap: List<Map<String, dynamic>>.from(info['question_map'] ?? []),
      notes: info['notes'] as String? ?? '',
      needHelpPopup: info['need_help_popup'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'info': {
        'name': name,
        'filter_grouping': filterGrouping,
        'body_parts': bodyParts,
        'tags': tags,
        'visual_insights': visualInsights,
        'question_map': questionMap,
        'notes': notes,
        'need_help_popup': needHelpPopup,
      },
    };
  }
}