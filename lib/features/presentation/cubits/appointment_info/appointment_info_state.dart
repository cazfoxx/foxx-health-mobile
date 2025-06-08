part of 'appointment_info_cubit.dart';

abstract class AppointmentInfoState {
  const AppointmentInfoState();
}

class AppointmentInfoInitial extends AppointmentInfoState {
  const AppointmentInfoInitial() : super();
}

class AppointmentInfoLoading extends AppointmentInfoState {
  const AppointmentInfoLoading() : super();
}

class AppointmentInfoLoaded extends AppointmentInfoState {
  final List<AppointmentInfoModel> appointments;
  const AppointmentInfoLoaded(this.appointments) : super();
}

class AppointmentInfoSuccess extends AppointmentInfoState {
  final Map<String, dynamic> data;
  const AppointmentInfoSuccess(this.data) : super();
}

class AppointmentInfoError extends AppointmentInfoState {
  final String message;
  const AppointmentInfoError(this.message) : super();
} 