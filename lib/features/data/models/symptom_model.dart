class Symptom {
  final String symptomName;
  final String symptomCategoryName;
  final int id;
  final String createdAt;
  final String updatedAt;

  Symptom({
    required this.symptomName,
    required this.symptomCategoryName,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      symptomName: json['symptom_name'],
      symptomCategoryName: json['symptom_category_name'],
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symptom_name': symptomName,
      'symptom_category_name': symptomCategoryName,
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}