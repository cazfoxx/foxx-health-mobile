class AppointmentInfoModel {
  final String titleText;
  final DateTime visitDate;
  final int appointmentTypeId;
  final List<int> checklistIds;
  final List<int> symptomIds;
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentInfoModel({
    required this.titleText,
    required this.visitDate,
    required this.appointmentTypeId,
    required this.checklistIds,
    required this.symptomIds,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentInfoModel.fromJson(Map<String, dynamic> json) {
    return AppointmentInfoModel(
      titleText: json['titleText'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      appointmentTypeId: json['appointmentTypeId'] as int,
      checklistIds: List<int>.from(json['checklistIds'] as List),
      symptomIds: List<int>.from(json['symptomIds'] as List),
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'titleText': titleText,
    'visitDate': visitDate.toIso8601String(),
    'appointmentTypeId': appointmentTypeId,
    'checklistIds': checklistIds,
    'symptomIds': symptomIds,
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
} 