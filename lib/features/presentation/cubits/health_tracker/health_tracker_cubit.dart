import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';

part 'health_tracker_state.dart';

class HealthTrackerCubit extends Cubit<HealthTrackerState> {
  final ApiClient _apiClient = ApiClient();

  List<Symptom> _selectedSymptoms = [];
  DateTime _selectedDate = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isDateRangeMode = false;

  HealthTrackerCubit() : super(HealthTrackerInitial());

  List<Symptom> get selectedSymptoms => _selectedSymptoms;
  DateTime get selectedDate => _selectedDate;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isDateRangeMode => _isDateRangeMode;

  void setSelectedSymptoms(List<Symptom> symptoms) {
    _selectedSymptoms = symptoms;
    emit(HealthTrackerSymptomsUpdated(_selectedSymptoms));
  }

  void addSymptom(Symptom symptom) {
    log('Adding symptom: ');
    if (!_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.add(symptom);
      emit(HealthTrackerSymptomsUpdated(_selectedSymptoms));
    }
  }

  void removeSymptom(Symptom symptom) {
    _selectedSymptoms.remove(symptom);
    emit(HealthTrackerSymptomsUpdated(_selectedSymptoms));
  }

  void clearSymptoms() {
    _selectedSymptoms.clear();
    emit(HealthTrackerSymptomsUpdated(_selectedSymptoms));
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    emit(HealthTrackerDateUpdated(_selectedDate));
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    emit(HealthTrackerDateRangeUpdated(_startDate, _endDate));
  }

  void toggleDateRangeMode() {
    _isDateRangeMode = !_isDateRangeMode;
    if (!_isDateRangeMode) {
      // Reset date range when switching back to single date mode
      _startDate = null;
      _endDate = null;
    }
    emit(HealthTrackerModeChanged(_isDateRangeMode));
  }

  void setDateRangeMode(bool isRangeMode) {
    _isDateRangeMode = isRangeMode;
    if (!_isDateRangeMode) {
      // Reset date range when switching back to single date mode
      _startDate = null;
      _endDate = null;
    }
    emit(HealthTrackerModeChanged(_isDateRangeMode));
  }

  Future<void> fetchSymptomsByDate(DateTime date) async {
    try {
      emit(HealthTrackerLoading());

      final response = await _apiClient.dio.get(
        '/api/v1/health-trackers/me',
        options: Options(headers: {"accept": "application/json"}),
      );

      final List<dynamic> data = response.data;
      final String targetDate = date.toIso8601String().split("T").first;

      final List<Symptom> symptomsForDate = [];

      for (final record in data) {
        final String fromDate = record['from_date'];
        final String toDate = record['to_date'];

        // Check if targetDate is between from_date and to_date
        if (targetDate.compareTo(fromDate) >= 0 &&
            targetDate.compareTo(toDate) <= 0) {
          final List<dynamic> selected = record['selected_symptoms'] ?? [];
          symptomsForDate.addAll(
            selected.map((s) => Symptom.fromJson(s)).toList(),
          );
        }
      }

      emit(HealthTrackerSymptomsUpdated(symptomsForDate));
    } catch (e) {
      print("❌ Error fetching symptoms: $e");
      emit(const HealthTrackerSymptomsUpdated([])); // fallback: empty list
    }
  }
}
