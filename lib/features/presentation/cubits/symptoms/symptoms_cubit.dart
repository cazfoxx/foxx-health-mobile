import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'symptoms_state.dart';

class SymptomsCubit extends Cubit<SymptomsState> {
 final ApiClient _apiClient = ApiClient();
  
  SymptomsCubit() : super(SymptomsInitial());

  Future<void> fetchSymptomsByCategory(String category) async {
    try {
      emit(SymptomsLoading());
      
      final response = await _apiClient.get(
        '/api/v1/symptom/category/$category',
        queryParameters: {
          'skip': 0,
          'limit': 100,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final symptoms = data.map((json) => Symptom.fromJson(json)).toList();
        emit(SymptomsLoaded(symptoms));
      } else {
        emit(SymptomsError('Failed to fetch symptoms: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SymptomsError('Failed to fetch symptoms: $e'));
    }
  }
} 