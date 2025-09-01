class HealthTrackerRequest {
  final int accountId;
  final List<SelectedSymptom> selectedSymptoms;
  final String fromDate;
  final String toDate;
  final bool isActive;
  final List<String> selectedBodyParts;
  final String selectedFilterGroup;

  HealthTrackerRequest({
    required this.accountId,
    required this.selectedSymptoms,
    required this.fromDate,
    required this.toDate,
    required this.isActive,
    required this.selectedBodyParts,
    required this.selectedFilterGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'selected_symptoms': selectedSymptoms.map((symptom) => symptom.toJson()).toList(),
      'from_date': fromDate,
      'to_date': toDate,
      'is_active': isActive,
      'selected_body_parts': selectedBodyParts,
      'selected_filter_group': selectedFilterGroup,
    };
  }
}

class SelectedSymptom {
  final String id;
  final SymptomInfo info;
  final bool needHelpPopup;
  final String notes;

  SelectedSymptom({
    required this.id,
    required this.info,
    required this.needHelpPopup,
    required this.notes,
  });

  factory SelectedSymptom.fromJson(Map<String, dynamic> json) {
    return SelectedSymptom(
      id: json['id'],
      info: SymptomInfo.fromJson(json['info']),
      needHelpPopup: json['need_help_popup'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'info': info.toJson(),
      'need_help_popup': needHelpPopup,
      'notes': notes,
    };
  }
}

class SymptomInfo {
  final String id;
  final String name;
  final List<String> filterGrouping;
  final List<String> bodyParts;
  final List<String> tags;
  final List<String> visualInsights;
  final List<Map<String, dynamic>> questionMap;

  SymptomInfo({
    required this.id,
    required this.name,
    required this.filterGrouping,
    required this.bodyParts,
    required this.tags,
    required this.visualInsights,
    required this.questionMap,
  });

  factory SymptomInfo.fromJson(Map<String, dynamic> json) {
    return SymptomInfo(
      id: json['id'],
      name: json['name'],
      filterGrouping: List<String>.from(json['filter_grouping']),
      bodyParts: List<String>.from(json['body_parts']),
      tags: List<String>.from(json['tags']),
      visualInsights: List<String>.from(json['visual_insights']),
      questionMap: List<Map<String, dynamic>>.from(json['question_map']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filter_grouping': filterGrouping,
      'body_parts': bodyParts,
      'tags': tags,
      'visual_insights': visualInsights,
      'question_map': questionMap,
    };
  }
}

class HealthTrackerResponse {
  final int id;
  final int accountId;
  final List<SelectedSymptom> selectedSymptoms;
  final String fromDate;
  final String toDate;
  final bool isActive;
  final List<String> selectedBodyParts;
  final String selectedFilterGroup;
  final String createdAt;
  final String updatedAt;

  HealthTrackerResponse({
    required this.id,
    required this.accountId,
    required this.selectedSymptoms,
    required this.fromDate,
    required this.toDate,
    required this.isActive,
    required this.selectedBodyParts,
    required this.selectedFilterGroup,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HealthTrackerResponse.fromJson(Map<String, dynamic> json) {
    return HealthTrackerResponse(
      id: json['id'],
      accountId: json['account_id'],
      selectedSymptoms: (json['selected_symptoms'] as List)
          .map((symptom) => SelectedSymptom.fromJson(symptom))
          .toList(),
      fromDate: json['from_date'],
      toDate: json['to_date'],
      isActive: json['is_active'],
      selectedBodyParts: List<String>.from(json['selected_body_parts']),
      selectedFilterGroup: json['selected_filter_group'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
