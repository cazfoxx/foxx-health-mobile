import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_response.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/start_date_screen.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/select_symptoms_screen.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/describe_symptoms_screen.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/review_symptoms_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_enums.dart';
part 'symptom_tracker_state.dart';

class SymptomTrackerCubit extends Cubit<SymptomTrackerState> {
  final ApiClient _apiClient = ApiClient();
  final _storage = GetStorage();
  static const String _storageKey = 'symptom_tracker_data';
  SymptomScreen lastScreen = SymptomScreen.initial;

  SymptomTrackerCubit() : super(SymptomTrackerInitial()) {
    if (hasStoredData()) {
      loadSavedData();
    }
  }

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  String _symptomDescription = '';
  List<SymptomId> _symptomIds = [];

  // Save data to storage
  Future<void> saveData({required SymptomScreen screen}) async {
    try {
      final data = {
        'screen': screen.toString(),
        'fromDate': _fromDate.toIso8601String(),
        'toDate': _toDate.toIso8601String(),
        'symptomDescription': _symptomDescription,
        'symptomIds': _symptomIds.map((s) => s.toJson()).toList(),
      };

      await _storage.write(_storageKey, data);
      lastScreen = screen;
      emit(SymptomTrackerDataLoaded());
    } catch (e) {
      print('Error saving symptom tracker data: $e');
      emit(SymptomTrackerError('Error saving data: $e'));
    }
  }

  // Load saved data
  Future<void> loadSavedData() async {
    try {
      final data = _storage.read(_storageKey);
      if (data != null) {
        lastScreen = SymptomScreen.values.firstWhere(
          (e) => e.toString() == data['screen'],
          orElse: () => SymptomScreen.initial,
        );
        
        _fromDate = DateTime.parse(data['fromDate']);
        _toDate = DateTime.parse(data['toDate']);
        _symptomDescription = data['symptomDescription'] ?? '';
        
        if (data['symptomIds'] != null) {
          _symptomIds = List<SymptomId>.from(
            data['symptomIds'].map((x) => SymptomId.fromJson(x))
          );
        }
        
        emit(SymptomTrackerDataLoaded());
      }
    } catch (e) {
      print('Error loading symptom tracker data: $e');
      emit(SymptomTrackerError('Error loading saved data: $e'));
    }
  }

  // Check if data exists in storage
  bool hasStoredData() {
    try {
      final data = _storage.read(_storageKey);
      return data != null;
    } catch (e) {
      print('Error checking stored data: $e');
      return false;
    }
  }

  // Clear saved data
  Future<void> clearSavedData() async {
    try {
      await _storage.remove(_storageKey);
      _fromDate = DateTime.now();
      _toDate = DateTime.now();
      _symptomDescription = '';
      _symptomIds = [];
      lastScreen = SymptomScreen.initial;
      emit(SymptomTrackerInitial());
    } catch (e) {
      print('Error clearing saved data: $e');
      emit(SymptomTrackerError('Error clearing data: $e'));
    }
  }

  // Navigate to screen with proper data handling
  void navigateToScreen(BuildContext context, SymptomScreen screen) {
    Widget targetScreen;
    
    switch (screen) {
      case SymptomScreen.initial:
      case SymptomScreen.dateRange:
        targetScreen = const StartDateScreen();
        break;
      case SymptomScreen.selectSymptoms:
        targetScreen = const SelectSymptomsScreen();
        break;
      case SymptomScreen.description:
        targetScreen = const DescribeSymptomsScreen();
        break;
      case SymptomScreen.review:
        targetScreen = ReviewSymptomsScreen(descriptions: _symptomDescription);
        break;
    }

    saveData(screen: screen).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    });
  }

  // Check stored data and navigate to last screen
  void checkAndNavigateToLastScreen(BuildContext context) {
    try {
      final data = _storage.read(_storageKey);
      if (data != null && data['screen'] != null) {
        final screenEnum = SymptomScreen.values.firstWhere(
          (e) => e.toString() == data['screen'].toString(),
          orElse: () => SymptomScreen.initial,
        );
        navigateToScreen(context, screenEnum);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StartDateScreen()),
        );
      }
    } catch (e) {
      print('Error navigating to last screen: $e');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StartDateScreen()),
      );
    }
  }

  // Getters
  DateTime get fromDate => _fromDate;
  DateTime get toDate => _toDate;
  String get symptomDescription => _symptomDescription;
  List<SymptomId> get symptomIds => _symptomIds;

  // Setters with storage updates
  void setFromDate(DateTime date) {
    _fromDate = date;
    saveData(screen: lastScreen);
  }

  void setToDate(DateTime date) {
    _toDate = date;
    saveData(screen: lastScreen);
  }

  void setSymptomDescription(String description) {
    _symptomDescription = description;
    saveData(screen: lastScreen);
  }

  void setSymptomIds(List<SymptomId> symptoms) {
    if (symptoms.isNotEmpty) {
      final newType = symptoms.first.symptomType;
      _symptomIds.removeWhere((s) => s.symptomType == newType);
    }
    _symptomIds.addAll(symptoms);
    saveData(screen: lastScreen);
  }

  void addSymptom(SymptomId symptom) {
    _symptomIds.add(symptom);
    saveData(screen: lastScreen);
  }

  void removeSymptom(int index) {
    if (index >= 0 && index < _symptomIds.length) {
      _symptomIds.removeAt(index);
      saveData(screen: lastScreen);
    }
  }

  void clearSymptoms() {
    _symptomIds.clear();
    saveData(screen: lastScreen);
  }

  // API Methods
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
        await clearSavedData();
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
            .map((item) => SymptomTrackerResponse.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(SymptomTrackersLoaded(symptomTrackers));
      } else {
        emit(SymptomTrackerError('Failed to fetch symptom trackers'));
      }
    } catch (e) {
      emit(SymptomTrackerError(e.toString()));
    }
  }

  // Debug method
  void loggerall() {
    print('fromDate: $_fromDate');
    print('toDate: $_toDate');
    print('symptomDescription: $_symptomDescription');
    if (_symptomIds.isNotEmpty) {
      print('symptomIds: ${_symptomIds.first.symptomType}');
    }
  }

  // Clear all data
  void clear() {
    clearSavedData();
  }
}
