part of 'health_assessment_cubit.dart';

abstract class HealthAssessmentState extends Equatable {
  const HealthAssessmentState();

  @override
  List<Object?> get props => [];
}

class HealthAssessmentInitial extends HealthAssessmentState {}

class HealthAssessmentLoading extends HealthAssessmentState {}

class HealthAssessmentDataLoaded extends HealthAssessmentState {}

class HealthAssessmentSuccess extends HealthAssessmentState {
  final Map<String, dynamic> data;

  const HealthAssessmentSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class HealthAssessmentError extends HealthAssessmentState {
  final String message;

  const HealthAssessmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class HealthAssessmentAreasOfConcernFetched extends HealthAssessmentState {
  final List<AreaOfConcern> areasOfConcern;

  const HealthAssessmentAreasOfConcernFetched(this.areasOfConcern);

  @override
  List<Object?> get props => [areasOfConcern];
}

class HealthAssessmentIncomeRangesFetched extends HealthAssessmentState {
  final List<IncomeRange> incomeRanges;

  const HealthAssessmentIncomeRangesFetched(this.incomeRanges);

  @override
  List<Object?> get props => [incomeRanges];
}

class HealthAssessmentStatesFetched extends HealthAssessmentState {
  final List<state_model.State> states;

  const HealthAssessmentStatesFetched(this.states);

  @override
  List<Object?> get props => [states];
}

class HealthAssessmentSymptomsFetched extends HealthAssessmentState {
  final List<Symptom> symptoms;

  const HealthAssessmentSymptomsFetched(this.symptoms);

  @override
  List<Object?> get props => [symptoms];
}

class HealthAssessmentGuideViewFetched extends HealthAssessmentState {
  final Map<String, dynamic> guideView;

  const HealthAssessmentGuideViewFetched(this.guideView);

  @override
  List<Object?> get props => [guideView];
}