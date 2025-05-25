import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final ApiClient _apiClient = ApiClient();

  AppointmentCubit() : super(AppointmentInitial());

  Future<void> getAppointmentTypes() async {
    try {
      emit(AppointmentLoading());

      final response = await _apiClient.get(
        '/api/v1/appointment-types/appointment-type/',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final appointmentTypes = data
            .map((json) => AppointmentTypeModel.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(AppointmentTypesLoaded(appointmentTypes));
      } else {
        emit(AppointmentError('Failed to load appointment types'));
      }
    } catch (e) {
      emit(AppointmentError('Error loading appointment types: $e'));
    }
  }

  Future<void> createAppointmentType({
    required String appointmentTypeCode,
    required String appointmentTypeText,
  }) async {
    try {
      emit(AppointmentLoading());

      final response = await _apiClient.post(
        '/api/v1/appointment-types/appointment-type/',
        data: {
          'APPOINTMENT_TYPE_CODE': appointmentTypeCode,
          'APPOINTMENT_TYPE_TEXT': appointmentTypeText,
        },
      );

      if (response.statusCode == 201) {
        // After successful creation, refresh the appointment types list
        await getAppointmentTypes();
      } else {
        emit(AppointmentError('Failed to create appointment type'));
      }
    } catch (e) {
      emit(AppointmentError('Error creating appointment type: $e'));
    }
  }
}