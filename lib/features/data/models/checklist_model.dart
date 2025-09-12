class ChecklistModel {
  final String name;
  final int appointmentTypeId;
  final List<int> curatedQuestionIds;
  final List<String> customQuestions;
  final List<String> prescriptionAndSupplements;
  final bool isActive;
  final bool isDeleted;
  final int accountId;
  final int? id;

  ChecklistModel({
    required this.name,
    required this.appointmentTypeId,
    required this.curatedQuestionIds,
    required this.customQuestions,
    required this.prescriptionAndSupplements,
    required this.isActive,
    this.isDeleted = false,
    required this.accountId,
     this.id,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'appointment_type_id': appointmentTypeId,
        'curated_question_ids': curatedQuestionIds,
        'custom_questions': customQuestions,
        'prescription_and_supplements': prescriptionAndSupplements,
        'is_active': isActive,
        'is_deleted': isDeleted,
        'account_id': accountId,
      };

  factory ChecklistModel.fromJson(Map<String, dynamic> json) => ChecklistModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        appointmentTypeId: json['appointment_type_id'] ?? 0,
        curatedQuestionIds: List<int>.from(json['curated_question_ids'] ?? []),
        customQuestions: List<String>.from(json['custom_questions'] ?? []),
        prescriptionAndSupplements:
            List<String>.from(json['prescription_and_supplements'] ?? []),
        isActive: json['is_active'] ?? true,
        isDeleted: json['is_deleted'] ?? false,
        accountId: json['account_id'] ?? 0,
      );
}
