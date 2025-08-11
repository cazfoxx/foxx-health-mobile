import 'appointment_type_model.dart';
import 'checklist_model.dart';
import 'symptom_model.dart';

class AppointmentInfoModel {
  final String titleText;
  final DateTime visitDate;
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  // New fields for nested API response
  final AppointmentTypeModel? appointmentType;
  final List<ChecklistModel>? checklists;
  final List<Symptom>? symptoms;

  AppointmentInfoModel({
    required this.titleText,
    required this.visitDate,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.appointmentType,
    this.checklists,
    this.symptoms,
  });

  factory AppointmentInfoModel.fromJson(Map<String, dynamic> json) {
    return AppointmentInfoModel(
      titleText: json['titleText'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      appointmentType: json['appointmentType'] != null
          ? AppointmentTypeModel.fromJson(json['appointmentType'] as Map<String, dynamic>)
          : null,
      checklists: json['checklists'] != null
          ? (json['checklists'] as List)
              .map((e) => ChecklistModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      symptoms: json['symptoms'] != null
          ? (json['symptoms'] as List)
              .map((e) => Symptom.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'titleText': titleText,
    'visitDate': visitDate.toIso8601String(),
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'appointmentType': appointmentType?.toJson(),
    'checklists': checklists?.map((e) => e.toJson()).toList(),
    'symptoms': symptoms?.map((e) => e.toJson()).toList(),
  };
} 