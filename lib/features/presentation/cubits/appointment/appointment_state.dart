import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentTypesLoaded extends AppointmentState {
  final List<AppointmentTypeModel> appointmentTypes;

  const AppointmentTypesLoaded(this.appointmentTypes);

  @override
  List<Object?> get props => [appointmentTypes];
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}