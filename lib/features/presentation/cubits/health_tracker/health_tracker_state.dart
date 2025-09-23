part of 'health_tracker_cubit.dart';

abstract class HealthTrackerState extends Equatable {
  const HealthTrackerState();

  @override
  List<Object?> get props => [];
}

class HealthTrackerInitial extends HealthTrackerState {}

class HealthTrackerLoading extends HealthTrackerState {}

class HealthTrackerSymptomsUpdated extends HealthTrackerState {
  final List<Symptom> symptoms;
  const HealthTrackerSymptomsUpdated(this.symptoms);
  @override
  List<Object?> get props => [symptoms];
}

class HealthTrackerDateUpdated extends HealthTrackerState {
  final DateTime date;
  const HealthTrackerDateUpdated(this.date);
  @override
  List<Object?> get props => [date];
}

class HealthTrackerDateRangeUpdated extends HealthTrackerState {
  final DateTime? startDate;
  final DateTime? endDate;
  const HealthTrackerDateRangeUpdated(this.startDate, this.endDate);
  @override
  List<Object?> get props => [startDate, endDate];
}

class HealthTrackerModeChanged extends HealthTrackerState {
  final bool isDateRangeMode;
  const HealthTrackerModeChanged(this.isDateRangeMode);
  @override
  List<Object?> get props => [isDateRangeMode];
}
