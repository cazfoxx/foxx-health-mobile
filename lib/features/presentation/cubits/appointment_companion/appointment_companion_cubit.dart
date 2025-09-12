import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/appointment_companion_model.dart';
import 'package:dio/dio.dart';

part 'appointment_companion_state.dart';

class AppointmentCompanionCubit extends Cubit<AppointmentCompanionState> {
  final ApiClient _apiClient = ApiClient();
  static const String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJURzRZYjAzUXFlZGRDdmRlRkIwZllmSE13akUyIiwiZXhwIjoxNzU2ODI2NDExfQ.kV39srpzqDPRpuxrxIlWhVzIB-cIF-dCfr5OU94JzU0';

  AppointmentCompanionCubit() : super(AppointmentCompanionInitial());

  // Service functions moved from AppointmentCompanionService
  Future<AppointmentCompanionResponse> getAppointmentCompanions() async {
    try {
      emit(AppointmentCompanionLoading());
      
      final response = await _apiClient.get('/api/v1/appointment-companions/me');
      
      if (response.statusCode == 200) {
        final result = AppointmentCompanionResponse.fromJson(response.data);
        emit(AppointmentCompanionLoaded(result));
        return result;
      } else {
        throw Exception('Failed to load appointment companions: ${response.statusCode}');
      }
    } catch (e) {
      emit(AppointmentCompanionError(e.toString()));
      throw Exception('Error fetching appointment companions: $e');
    }
  }

  // Update appointment companion with custom questions
  Future<void> updateAppointmentCompanionCustom(int companionId, Map<String, dynamic> requestData) async {
    try {
      emit(AppointmentCompanionLoading());
      
      print('🌐 API Call: updateAppointmentCompanionCustom(companionId: $companionId)');
      print('📄 Request Data: $requestData');
      
      final response = await _apiClient.put(
        '/api/v1/appointment-companions/$companionId/custom',
        data: requestData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Appointment companion updated successfully');
      print('📄 Response Data: ${response.data}');
      
      // Don't try to parse the response if it's null or not the expected format
      // Just emit success state
      emit(AppointmentCompanionSuccess('Appointment companion updated successfully'));
    } catch (e) {
      print('❌ API Error: $e');
      
      // Handle specific error cases
      String errorMessage = 'Error updating appointment companion';
      if (e.toString().contains('422')) {
        errorMessage = 'Invalid data format. Please check your input.';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Authentication failed. Please try again.';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Appointment companion not found.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      emit(AppointmentCompanionError(errorMessage));
      throw Exception(errorMessage);
    }
  }

  // Get appointment companion details
  Future<AppointmentCompanion?> getAppointmentCompanionDetails(int id) async {
    try {
      print('🌐 API Call: getAppointmentCompanionDetails(id: $id)');
      
      final response = await _apiClient.get(
        '/api/v1/appointment-companions/$id',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Appointment companion details received');
      return AppointmentCompanion.fromJson(response.data);
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  // Generate AI response for appointment companion
  Future<Map<String, dynamic>?> generateAIResponse(int companionId) async {
    try {
      print('🌐 API Call: generateAIResponse(companionId: $companionId)');
      
      final response = await _apiClient.post(
        '/api/v1/appointment-companions/$companionId/generate-ai-response',
        data: {}, // Empty body as per the curl example
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: AI response generated successfully');
      return response.data;
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  // Generate more like this AI response for specific section
  Future<Map<String, dynamic>?> generateMoreLikeThis(int companionId) async {
    try {
      print('🌐 API Call: generateMoreLikeThis(companionId: $companionId)');
      
      final response = await _apiClient.post(
        '/api/v1/appointment-companions/$companionId/generate-more-like-this-ai-response',
        data: {}, // Empty body as per the curl example
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: More like this AI response generated successfully');
      return response.data;
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  // Delete appointment companion
  Future<bool> deleteAppointmentCompanion(int companionId) async {
    try {
      print('🌐 API Call: deleteAppointmentCompanion(companionId: $companionId)');
      
      final response = await _apiClient.delete(
        '/api/v1/appointment-companions/$companionId',
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Appointment companion deleted successfully');
      print('📄 Response Status: ${response.statusCode}');
      
      // Return true if deletion was successful (204 status code)
      return response.statusCode == 204;
    } catch (e) {
      print('❌ API Error: $e');
      return false;
    }
  }
}
