part of 'symptom_tracker_cubit.dart';

abstract class SymptomTrackerState {}

class SymptomTrackerInitial extends SymptomTrackerState {}

class SymptomTrackerLoading extends SymptomTrackerState {}

class SymptomTrackerSuccess extends SymptomTrackerState {
  final String message;
  
  SymptomTrackerSuccess(this.message);
}

class SymptomTrackerError extends SymptomTrackerState {
  final String message;
  
  SymptomTrackerError(this.message);
}

// Add the missing state class
class SymptomTrackersLoaded extends SymptomTrackerState {
  final List<SymptomTrackerResponse> symptomTrackers;
  
  SymptomTrackersLoaded(this.symptomTrackers);
}