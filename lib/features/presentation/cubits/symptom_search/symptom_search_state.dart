part of 'symptom_search_cubit.dart';

abstract class SymptomSearchState extends Equatable {
  const SymptomSearchState();

  @override
  List<Object?> get props => [];
}

class SymptomSearchInitial extends SymptomSearchState {}

class SymptomSearchLoading extends SymptomSearchState {}

class SymptomSearchLoadingMore extends SymptomSearchState {
  final List<Symptom> symptoms;
  final Set<Symptom> selectedSymptoms;

  const SymptomSearchLoadingMore(this.symptoms, this.selectedSymptoms);

  @override
  List<Object?> get props => [symptoms, selectedSymptoms.toList()];
}

class SymptomSearchLoaded extends SymptomSearchState {
  final List<Symptom> symptoms;
  final Set<Symptom> selectedSymptoms;

  const SymptomSearchLoaded(this.symptoms, this.selectedSymptoms);

  @override
  List<Object?> get props => [symptoms, selectedSymptoms.toList()];
}

class SymptomSearchError extends SymptomSearchState {
  final String message;

  const SymptomSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
