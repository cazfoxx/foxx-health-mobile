import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';

class SymptomTrackerResponse {
  final List<SymptomId>? symptomIds;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? symptomDescription;
  final int? id;
  final int? accountId;
  final DateTime? createdAt;
  final DateTime updatedAt;

  SymptomTrackerResponse({
    required this.symptomIds,
    required this.fromDate,
    required this.toDate,
    required this.symptomDescription,
    required this.id,
    required this.accountId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SymptomTrackerResponse.fromJson(Map<String, dynamic> json) {
    return SymptomTrackerResponse(
      symptomIds: (json['symptom_ids'] as List)
          .map((symptom) => SymptomId.fromJson(symptom))
          .toList(),
      fromDate: DateTime.parse(json['from_date']),
      toDate: DateTime.parse(json['to_date']),
      symptomDescription: json['symptom_description'],
      id: json['id'],
      accountId: json['account_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symptom_ids': symptomIds?.map((symptom) => symptom.toJson()).toList(),
      'from_date': fromDate?.toIso8601String().split('T')[0],
      'to_date': toDate?.toIso8601String().split('T')[0],
      'symptom_description': symptomDescription,
      'id': id,
      'account_id': accountId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}