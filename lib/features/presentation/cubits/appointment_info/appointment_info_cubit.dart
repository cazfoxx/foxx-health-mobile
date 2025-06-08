import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/appointment_info_model.dart';

part 'appointment_info_state.dart';

class AppointmentInfoCubit extends Cubit<AppointmentInfoState> {
  final ApiClient _apiClient = ApiClient();

  // Variables to store appointment info
  String? _titleText;
  DateTime? _visitDate;
  int? _appointmentTypeId;
  List<int>? _checklistIds;
  List<int>? _symptomIds;

  AppointmentInfoCubit() : super(const AppointmentInfoInitial());

  // Setters
  void setTitleText(String value) {
    _titleText = value;
  }

  void setVisitDate(DateTime value) {
    _visitDate = value;
  }

  void setAppointmentTypeId(int value) {
    _appointmentTypeId = value;
  }

  void setChecklistIds(List<int> value) {
    _checklistIds = value;
  }

  void setSymptomIds(List<int> value) {
    _symptomIds = value;
  }

  Future<void> getAppointmentInfo() async {
    try {
      emit(AppointmentInfoLoading());

      final response = await _apiClient.get('/api/v1/appointment-info/me');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final appointments = data.map((json) {
          try {
            return AppointmentInfoModel.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing appointment info: $e');
            return null;
          }
        }).whereType<AppointmentInfoModel>().toList();

        if (appointments.isEmpty) {
          emit(AppointmentInfoError('No appointments found'));
        } else {
          emit(AppointmentInfoLoaded(appointments));
        }
      } else {
        emit(AppointmentInfoError('Failed to load appointments'));
      }
    } catch (e) {
      print('Error loading appointments: $e');
      emit(AppointmentInfoError('Error loading appointments'));
    }
  }

  Future<void> createAppointmentInfo() async {
    try {
      // Validate required fields
      if (_titleText == null || _titleText!.isEmpty) {
        throw Exception('Title text is required');
      }
      if (_visitDate == null) {
        throw Exception('Visit date is required');
      }
      if (_appointmentTypeId == null) {
        throw Exception('Appointment type is required');
      }
      if (_checklistIds == null || _checklistIds!.isEmpty) {
        throw Exception('Checklist IDs are required');
      }
      if (_symptomIds == null || _symptomIds!.isEmpty) {
        throw Exception('Symptom IDs are required');
      }

      emit(AppointmentInfoLoading());

      final response = await _apiClient.post(
        '/api/v1/appointment-info/',
        data: {
          'titleText': _titleText,
          'visitDate': _visitDate!.toIso8601String(),
          'appointmentTypeId': _appointmentTypeId,
          'checklistIds': _checklistIds,
          'symptomIds': _symptomIds,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AppointmentInfoSuccess(response.data));
        // Clear the data after successful creation
        _clearData();
      } else {
        emit(AppointmentInfoError('Failed to create appointment'));
      }
    } catch (e) {
      emit(AppointmentInfoError(e.toString()));
    }
  }

  void _clearData() {
    _titleText = null;
    _visitDate = null;
    _appointmentTypeId = null;
    _checklistIds = null;
    _symptomIds = null;
  }
}
