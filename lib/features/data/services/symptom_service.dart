import 'package:dio/dio.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';

class SymptomService {

  //please use the existing dio instance to make the api calls
  
  static final ApiClient _apiClient = ApiClient();
  static const String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJURzRZYjAzUXFlZGRDdmRlRkIwZllmSE13akUyIiwiZXhwIjoxNzU1MzMyNDQ5fQ.xIeR1lYGjWMqgR8msEJnO9DCcZ4lU-o8Gs3YQCY';

  static Future<Map<String, dynamic>> getAllSymptoms({
    required int skip,
    required int limit,
  }) async {
    try {
      print('🌐 API Call: getAllSymptoms(skip: $skip, limit: $limit)');
      
      final response = await _apiClient.get(
        '/api/v1/symptom/',
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: ${response.data.length} symptoms');
      
      final List<Symptom> symptoms = (response.data as List)
          .map((json) => Symptom.fromJson(json))
          .toList();

      return {
        'symptoms': symptoms,
        'total': symptoms.length,
        'hasMore': symptoms.length >= limit,
      };
    } catch (e) {
      print('❌ API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getSymptomsByFilter({
    required String filterGroup,
    required int skip,
    required int limit,
  }) async {
    try {
      print('🌐 API Call: getSymptomsByFilter(filterGroup: $filterGroup, skip: $skip, limit: $limit)');
      
      final response = await _apiClient.get(
        '/api/v1/symptom/filter-group/$filterGroup',
        queryParameters: {
          'filter_group': filterGroup,
          'skip': skip,
          'limit': limit,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: ${response.data.length} symptoms');
      
      final List<Symptom> symptoms = (response.data as List)
          .map((json) => Symptom.fromJson(json))
          .toList();

      return {
        'symptoms': symptoms,
        'total': symptoms.length,
        'hasMore': symptoms.length >= limit,
      };
    } catch (e) {
      print('❌ API Error: $e');
      rethrow;
    }
  }

  static List<String> getFilterGroups() {
    return ['All', 'Period', 'Behavioral Changes', 'Body Image'];
  }

  static Future<Map<String, dynamic>?> getSymptomDetails(String symptomId) async {
    try {
      print('🌐 API Call: getSymptomDetails(symptomId: $symptomId)');
      
      final response = await _apiClient.get(
        '/api/v1/symptom/$symptomId',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Symptom details received');
      
      return response.data;
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }
} 