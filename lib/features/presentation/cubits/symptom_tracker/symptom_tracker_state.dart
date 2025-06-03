part of 'symptom_tracker_cubit.dart';

abstract class SymptomTrackerState extends Equatable {
  const SymptomTrackerState();

  @override
  List<Object> get props => [];
}

class SymptomTrackerInitial extends SymptomTrackerState {}

class SymptomTrackerLoading extends SymptomTrackerState {}

class SymptomTrackerDataSaved extends SymptomTrackerState {}

class SymptomTrackerDataLoaded extends SymptomTrackerState {}

class SymptomTrackerError extends SymptomTrackerState {
  final String message;

  const SymptomTrackerError(this.message);

  @override
  List<Object> get props => [message];
}

class SymptomTrackerSuccess extends SymptomTrackerState {
  final String message;

  const SymptomTrackerSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SymptomTrackersLoaded extends SymptomTrackerState {
  final List<SymptomTrackerResponse> symptomTrackers;

  const SymptomTrackersLoaded(this.symptomTrackers);

  @override
  List<Object> get props => [symptomTrackers];
}
