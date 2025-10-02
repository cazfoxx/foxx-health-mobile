import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foxxhealth/core/network/api_client.dart';

part 'symptom_insights_state.dart';

class SymptomInsightsCubit extends Cubit<SymptomInsightsState> {
  final ApiClient _apiClient = ApiClient();

  SymptomInsightsCubit() : super(SymptomInsightsInitial());

  /// Fetch all symptom records with full details
  Future<void> fetchInsights({
    required DateTime start,
    required DateTime end,
    List<String>? selectedSymptoms,
    List<Map<String, dynamic>>? symptomsData,
  }) async {
    try {
      emit(SymptomInsightsLoading());

      final response = await _apiClient.dio.post(
        '/symptom-insights',
        data: {
          "window": {
            "start": start.toIso8601String().split("T").first,
            "end": end.toIso8601String().split("T").first,
          },
          "selected_symptoms": selectedSymptoms ?? [],
          "symptoms": symptomsData ?? [],
        },
        options: Options(headers: {"accept": "application/json"}),
      );

      final data = response.data as Map<String, dynamic>;

      // Flatten all symptom records into a list
      final List<SymptomRecord> records = [];
      for (final symptom in (data['symptoms'] as List)) {
        final name = symptom['name'] as String;
        for (final record in (symptom['records'] as List)) {
          records.add(SymptomRecord.fromJson(record, name));
        }
      }

      emit(SymptomInsightsLoaded(records: records));
    } catch (e) {
      emit(SymptomInsightsError(message: e.toString()));
    }
  }

  /// Fetch a simple list of symptoms based on date range
  Future<List<Map<String, dynamic>>> getSymptomsByDateRange({
    required DateTime start,
    required DateTime end,
    List<String>? selectedSymptoms,
  }) async {
    try {
      emit(SymptomInsightsLoading());

      final response = await _apiClient.dio.post(
        '/symptom-insights',
        data: {
          "window": {
            "start": start.toIso8601String().split("T").first,
            "end": end.toIso8601String().split("T").first,
          },
          "selected_symptoms": selectedSymptoms ?? [],
          "symptoms": [], // empty to fetch all
        },
        options: Options(headers: {"accept": "application/json"}),
      );

      final data = response.data as Map<String, dynamic>;
      final symptoms = (data["symptoms"] as List).cast<Map<String, dynamic>>();

      emit(SymptomInsightsLoaded(
        records: symptoms
            .expand((symptom) => (symptom['records'] as List)
                .map((r) => SymptomRecord.fromJson(r, symptom['name'])))
            .toList(),
      ));

      return symptoms;
    } catch (e) {
      emit(SymptomInsightsError(message: e.toString()));
      rethrow;
    }
  }
}
