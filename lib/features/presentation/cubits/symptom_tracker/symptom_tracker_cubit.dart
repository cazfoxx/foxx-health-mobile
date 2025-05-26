import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_response.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/widgets/symptom_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';

part 'symptom_tracker_state.dart';

class SymptomTrackerCubit extends Cubit<SymptomTrackerState> {
  final ApiClient _apiClient = ApiClient();

  SymptomTrackerCubit() : super(SymptomTrackerInitial());

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  String _symptomDescription = '';
  List<SymptomId> _symptomIds = [];

  List<Category> getSymptoms(title) {
    List<Category> categories = [];
    switch (title) {
      case 'Body':
        categories = [
          Category(
            title: 'Chest & Upper Back',
            symptoms: [
              SymptomItem(name: 'Sharp Pain'),
              SymptomItem(name: 'Dull Pain'),
              SymptomItem(name: 'Throbbing Pain'),
              SymptomItem(name: 'Pressure'),
              SymptomItem(name: 'Tingling or Numbness'),
            ],
          ),
          Category(
            title: 'Abdomen & Lower Back',
            symptoms: [
              SymptomItem(name: 'Sharp Pain'),
              SymptomItem(name: 'Dull Pain'),
              SymptomItem(name: 'Throbbing Pain'),
              SymptomItem(name: 'Pressure'),
              SymptomItem(name: 'Tingling or Numbness'),
            ],
          ),
        ];
        break;

      case 'Mood':
        categories = [
          Category(
            title: 'Emotional State',
            symptoms: [
              SymptomItem(name: 'Anxiety'),
              SymptomItem(name: 'Depression'),
              SymptomItem(name: 'Irritability'),
              SymptomItem(name: 'Mood Swings'),
              SymptomItem(name: 'Stress'),
            ],
          ),
          Category(
            title: 'Emotional Well-being',
            symptoms: [
              SymptomItem(name: 'Low Self-esteem'),
              SymptomItem(name: 'Feeling Overwhelmed'),
              SymptomItem(name: 'Emotional Numbness'),
              SymptomItem(name: 'Loneliness'),
              SymptomItem(name: 'Hopelessness'),
            ],
          ),
        ];
        break;

      case 'Mind':
        categories = [
          Category(
            title: 'Cognitive Function',
            symptoms: [
              SymptomItem(name: 'Poor Concentration'),
              SymptomItem(name: 'Memory Issues'),
              SymptomItem(name: 'Brain Fog'),
              SymptomItem(name: 'Difficulty Making Decisions'),
              SymptomItem(name: 'Mental Fatigue'),
            ],
          ),
          Category(
            title: 'Mental State',
            symptoms: [
              SymptomItem(name: 'Racing Thoughts'),
              SymptomItem(name: 'Confusion'),
              SymptomItem(name: 'Disorientation'),
              SymptomItem(name: 'Poor Problem Solving'),
              SymptomItem(name: 'Lack of Mental Clarity'),
            ],
          ),
        ];
        break;

      case 'Habits':
        categories = [
          Category(
            title: 'Daily Routines',
            symptoms: [
              SymptomItem(name: 'Sleep Changes'),
              SymptomItem(name: 'Appetite Changes'),
              SymptomItem(name: 'Exercise Routine Changes'),
              SymptomItem(name: 'Social Withdrawal'),
              SymptomItem(name: 'Procrastination'),
            ],
          ),
          Category(
            title: 'Behavioral Changes',
            symptoms: [
              SymptomItem(name: 'Increased Irritability'),
              SymptomItem(name: 'Restlessness'),
              SymptomItem(name: 'Compulsive Behaviors'),
              SymptomItem(name: 'Risk-Taking Behavior'),
              SymptomItem(name: 'Substance Use Changes'),
            ],
          ),
        ];
        break;
    }
    return categories; // Add this return statement
  }

  loggerall() {
    print('fromDate: $_fromDate');
    print('toDate: $_toDate');
    print('symptomDescription: $_symptomDescription');
    print('symptomIds: ${_symptomIds.first.symptomType}');
  }

  // Getters
  DateTime get fromDate => _fromDate;
  DateTime get toDate => _toDate;
  String get symptomDescription => _symptomDescription;
  List<SymptomId> get symptomIds => _symptomIds;

  // Setters
  void setFromDate(DateTime date) {
    _fromDate = date;
    emit(SymptomTrackerInitial());
  }

  void setToDate(DateTime date) {
    _toDate = date;
    emit(SymptomTrackerInitial());
  }

  void setSymptomDescription(String description) {
    _symptomDescription = description;
    emit(SymptomTrackerInitial());
  }

  void setSymptomIds(List<SymptomId> symptoms) {
    // Remove existing symptoms of the same type
    if (symptoms.isNotEmpty) {
      final newType = symptoms.first.symptomType;
      _symptomIds.removeWhere((s) => s.symptomType == newType);
    }

    // Add new symptoms
    _symptomIds.addAll(symptoms);
    emit(SymptomTrackerInitial());
  }

  void addSymptom(SymptomId symptom) {
    _symptomIds.add(symptom);
    emit(SymptomTrackerInitial());
  }

  void removeSymptom(int index) {
    if (index >= 0 && index < _symptomIds.length) {
      _symptomIds.removeAt(index);
      emit(SymptomTrackerInitial());
    }
  }

  void clearSymptoms() {
    _symptomIds.clear();
    emit(SymptomTrackerInitial());
  }

  Future<void> createSymptomTracker() async {
    try {
      emit(SymptomTrackerLoading());

      final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getInt('accountId') ?? 0;

      final request = SymptomTrackerRequest(
        symptomIds: symptomIds,
        fromDate: fromDate,
        toDate: toDate,
        symptomDescription: symptomDescription,
        accountId: accountId,
      );

      final response = await _apiClient.post(
        '/api/v1/symptom-trackers/',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        emit(SymptomTrackerSuccess('Symptom tracker created successfully'));
      } else {
        emit(SymptomTrackerError('Failed to create symptom tracker'));
      }
    } catch (e) {
      emit(SymptomTrackerError(e.toString()));
    }
  }

  Future<void> getSymptomTrackers() async {
    try {
      emit(SymptomTrackerLoading());

      final response = await _apiClient.get(
        '/api/v1/symptom-trackers/me',
        queryParameters: {
          'skip': 0,
          'limit': 100,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<SymptomTrackerResponse> symptomTrackers = data
            .map((item) =>
                SymptomTrackerResponse.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(SymptomTrackersLoaded(symptomTrackers));
      } else {
        emit(SymptomTrackerError('Failed to fetch symptom trackers'));
      }
    } catch (e) {
      emit(SymptomTrackerError(e.toString()));
    }
  }
}
