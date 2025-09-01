part of 'appointment_companion_cubit.dart';

abstract class AppointmentCompanionState extends Equatable {
  const AppointmentCompanionState();

  @override
  List<Object> get props => [];
}

class AppointmentCompanionInitial extends AppointmentCompanionState {}

class AppointmentCompanionLoading extends AppointmentCompanionState {}

class AppointmentCompanionLoaded extends AppointmentCompanionState {
  final AppointmentCompanionResponse companions;

  const AppointmentCompanionLoaded(this.companions);

  @override
  List<Object> get props => [companions];
}

class AppointmentCompanionError extends AppointmentCompanionState {
  final String message;

  const AppointmentCompanionError(this.message);

  @override
  List<Object> get props => [message];
}

class AppointmentCompanionSuccess extends AppointmentCompanionState {
  final String message;

  const AppointmentCompanionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

