class AppointmentTypeModel {
  final int id;
  final String name;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  AppointmentTypeModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentTypeModel.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}