class AppointmentTypeModel {
  final String name;
  final bool isActive;
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentTypeModel({
    required this.name,
    required this.isActive,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentTypeModel.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeModel(
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'is_active': isActive,
    'id': id,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}