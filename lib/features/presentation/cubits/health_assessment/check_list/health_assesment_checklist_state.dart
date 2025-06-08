part of 'health_assesment_checklist_cubit.dart';

abstract class HealthAssessmentChecklistState extends Equatable {
  const HealthAssessmentChecklistState();

  @override
  List<Object> get props => [];
}

class HealthAssessmentChecklistInitial extends HealthAssessmentChecklistState {}

class HealthAssessmentChecklistLoading extends HealthAssessmentChecklistState {}

class HealthAssessmentChecklistLoaded extends HealthAssessmentChecklistState {}

class HealthAssessmentChecklistError extends HealthAssessmentChecklistState {
  final String message;

  const HealthAssessmentChecklistError(this.message);

  @override
  List<Object> get props => [message];
} 