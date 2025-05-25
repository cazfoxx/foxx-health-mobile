part of 'health_assessment_cubit.dart';

abstract class HealthAssessmentState extends Equatable {
  const HealthAssessmentState();

  @override
  List<Object> get props => [];
}

class HealthAssessmentInitial extends HealthAssessmentState {}

class HealthAssessmentLoading extends HealthAssessmentState {}

class HealthAssessmentSuccess extends HealthAssessmentState {
  final Map<String, dynamic> response;

  const HealthAssessmentSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class HealthAssessmentError extends HealthAssessmentState {
  final String message;

  const HealthAssessmentError(this.message);

  @override
  List<Object> get props => [message];
}