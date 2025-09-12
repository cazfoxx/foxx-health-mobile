class SymptomId {
  final String? symptomType;
  final String symptomName;
  final String symptomCategory;
  final String severity;

  SymptomId({
    this.symptomType,// Default value for symptomType if not provided in the constructor or fromJson
    required this.symptomName,
    required this.symptomCategory,
    required this.severity,
  });

  factory SymptomId.fromJson(Map<String, dynamic> json) {
    return SymptomId(
      symptomName: json['symptom_name'] as String,
      symptomCategory: json['symptom_category'] as String,
      severity: json['severity'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symptom_name': symptomName,
      'symptom_category': symptomCategory,
      'severity': severity,
    };
  }
}

class SymptomTrackerRequest {
  final List<SymptomId> symptomIds;
  final DateTime fromDate;
  final DateTime toDate;
  final String symptomDescription;
  final int accountId;

  SymptomTrackerRequest({
    required this.symptomIds,
    required this.fromDate,
    required this.toDate,
    required this.symptomDescription,
    required this.accountId,
  });

  factory SymptomTrackerRequest.fromJson(Map<String, dynamic> json) {
    return SymptomTrackerRequest(
      symptomIds: (json['symptom_ids'] as List)
          .map((e) => SymptomId.fromJson(e as Map<String, dynamic>))
          .toList(),
      fromDate: DateTime.parse(json['from_date']),
      toDate: DateTime.parse(json['to_date']),
      symptomDescription: json['symptom_description'] as String,
      accountId: json['account_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symptom_ids': symptomIds.map((e) => e.toJson()).toList(),
      'from_date': fromDate.toIso8601String().split('T')[0],
      'to_date': toDate.toIso8601String().split('T')[0],
      'symptom_description': symptomDescription,
      'account_id': accountId,
    };
  }
}
