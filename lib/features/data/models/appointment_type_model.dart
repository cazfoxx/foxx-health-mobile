class AppointmentTypeModel {
  final int appointmentTypeId;
  final String createdAtTimestamp;
  final String updatedAtTimestamp;
  final String appointmentTypeCode;
  final String appointmentTypeText;

  AppointmentTypeModel({
    required this.appointmentTypeId,
    required this.createdAtTimestamp,
    required this.updatedAtTimestamp,
    required this.appointmentTypeCode,
    required this.appointmentTypeText,
  });

  factory AppointmentTypeModel.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeModel(
      appointmentTypeId: json['APPOINTMENT_TYPE_ID'] as int,
      createdAtTimestamp: json['CREATED_AT_TIMESTAMP'] as String,
      updatedAtTimestamp: json['UPDATED_AT_TIMESTAMP'] as String,
      appointmentTypeCode: json['APPOINTMENT_TYPE_CODE'] as String,
      appointmentTypeText: json['APPOINTMENT_TYPE_TEXT'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'APPOINTMENT_TYPE_ID': appointmentTypeId,
      'CREATED_AT_TIMESTAMP': createdAtTimestamp,
      'UPDATED_AT_TIMESTAMP': updatedAtTimestamp,
      'APPOINTMENT_TYPE_CODE': appointmentTypeCode,
      'APPOINTMENT_TYPE_TEXT': appointmentTypeText,
    };
  }
}