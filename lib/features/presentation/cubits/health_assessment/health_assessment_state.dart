part of 'health_assessment_cubit.dart';

abstract class HealthAssessmentState extends Equatable {
  const HealthAssessmentState();

  @override
  List<Object> get props => [];
}

class HealthAssessmentInitial extends HealthAssessmentState {}

class HealthAssessmentLoading extends HealthAssessmentState {}

class HealthAssessmentSuccess extends HealthAssessmentState {
  final Map<String, dynamic> data;

  const HealthAssessmentSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class HealthAssessmentSymptomsFetched extends HealthAssessmentState {
  final List<Symptom> symptoms;

  const HealthAssessmentSymptomsFetched(this.symptoms);

  @override
  List<Object> get props => [symptoms];
}

class HealthAssessmentError extends HealthAssessmentState {
  final String message;

  const HealthAssessmentError(this.message);

  @override
  List<Object> get props => [message];
}

// Add new state class
class HealthAssessmentStatesFetched extends HealthAssessmentState {
  final List<State> states;

  const HealthAssessmentStatesFetched(this.states);

  @override
  List<Object> get props => [states];
}

// Add new state class
class HealthAssessmentIncomeRangesFetched extends HealthAssessmentState {
  final List<IncomeRange> incomeRanges;

  const HealthAssessmentIncomeRangesFetched(this.incomeRanges);

  @override
  List<Object> get props => [incomeRanges];
}

class HealthAssessmentAreasOfConcernFetched extends HealthAssessmentState {
  final List<AreaOfConcern> areasOfConcern;

  const HealthAssessmentAreasOfConcernFetched(this.areasOfConcern);

  @override
  List<Object> get props => [areasOfConcern];
}

class HealthAssessmentGuideViewFetched extends HealthAssessmentState {
  final Map<String, dynamic> guideData;

  const HealthAssessmentGuideViewFetched(this.guideData);

  @override
  List<Object> get props => [guideData];
}