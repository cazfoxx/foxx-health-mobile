import 'package:equatable/equatable.dart';

class Symptom extends Equatable {
  final String symptomName;
  final String symptomCategoryName;
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Symptom({
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  List<Object?> get props => [id, symptomName, symptomCategoryName, createdAt, updatedAt];
}

abstract class SymptomsState extends Equatable {
  const SymptomsState();

  @override
  List<Object?> get props => [];
}

class SymptomsInitial extends SymptomsState {}

class SymptomsLoading extends SymptomsState {}

class SymptomsLoaded extends SymptomsState {
  final List<Symptom> symptoms;

  const SymptomsLoaded(this.symptoms);

  @override
  List<Object?> get props => [symptoms];
}

class SymptomsError extends SymptomsState {
  final String message;

  const SymptomsError(this.message);

  @override
  List<Object?> get props => [message];
} 