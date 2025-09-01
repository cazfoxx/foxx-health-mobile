import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:dio/dio.dart';

part 'symptom_search_state.dart';

class SymptomSearchCubit extends Cubit<SymptomSearchState> {
  final ApiClient _apiClient = ApiClient();
  static const String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJURzRZYjAzUXFlZGRDdmRlRkIwZllmSE13akUyIiwiZXhwIjoxNzU2ODI2NDExfQ.kV39srpzqDPRpuxrxIlWhVzIB-cIF-dCfr5OU94JzU0';
  
  List<Symptom> _allSymptoms = [];
  List<Symptom> _filteredSymptoms = [];
  Set<Symptom> _selectedSymptoms = {};
  String _selectedFilter = '';
  String _searchQuery = '';
  bool _hasMore = true;
  int _currentSkip = 0;
  static const int _limit = 10;
  SymptomSearchCubit() : super(SymptomSearchInitial());

  List<Symptom> get allSymptoms => _allSymptoms;
  List<Symptom> get filteredSymptoms => _filteredSymptoms;
  Set<Symptom> get selectedSymptoms => _selectedSymptoms;
  List<Symptom> get selectedSymptomsList => _selectedSymptoms.toList();
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  bool get hasMore => _hasMore;
  List<String> get filterOptions => ['All', 'Period', 'Behavioral Changes', 'Body Image'];

  Future<void> loadInitialSymptoms() async {
    try {
      print('🔄 Loading initial symptoms...');
      emit(SymptomSearchLoading());
      
      final result = await _getAllSymptoms(skip: 0, limit: _limit);
      
      _allSymptoms = result['symptoms'];
      _hasMore = result['hasMore'];
      _currentSkip = _limit;
      
      print('✅ Loaded ${_allSymptoms.length} symptoms');
      
      _applySearchAndFilter();
      emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    } catch (e) {
      print('❌ Error loading symptoms: $e');
      emit(SymptomSearchError(e.toString()));
    }
  }

  Future<void> loadMoreSymptoms() async {
    if (!_hasMore || state is SymptomSearchLoading) return;

    try {
      emit(SymptomSearchLoadingMore());
      
      final result = await _getAllSymptoms(
        skip: _currentSkip,
        limit: _limit,
      );
      
      _allSymptoms.addAll(result['symptoms']);
      _hasMore = result['hasMore'];
      _currentSkip += _limit;
      
      _applySearchAndFilter();
      emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    } catch (e) {
      emit(SymptomSearchError(e.toString()));
    }
  }

  Future<void> loadSymptomsByFilter(String filterGroup) async {
    try {
      emit(SymptomSearchLoading());
      
      _selectedFilter = filterGroup;
      _allSymptoms.clear();
      _currentSkip = 0;
      _hasMore = true;
      
      final result = await _getSymptomsByFilter(
        filterGroup: filterGroup,
        skip: 0,
        limit: _limit,
      );
      
      _allSymptoms = result['symptoms'];
      _hasMore = result['hasMore'];
      _currentSkip = _limit;
      
      _applySearchAndFilter();
      emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    } catch (e) {
      emit(SymptomSearchError(e.toString()));
    }
  }

  Future<void> clearFilter() async {
    try {
      emit(SymptomSearchLoading());
      
      _selectedFilter = '';
      _allSymptoms.clear();
      _currentSkip = 0;
      _hasMore = true;
      
      final result = await _getAllSymptoms(
        skip: 0,
        limit: _limit,
      );
      
      _allSymptoms = result['symptoms'];
      _hasMore = result['hasMore'];
      _currentSkip = _limit;
      
      _applySearchAndFilter();
      emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    } catch (e) {
      emit(SymptomSearchError(e.toString()));
    }
  }

  Future<void> loadMoreSymptomsByFilter() async {
    if (!_hasMore || state is SymptomSearchLoading) return;

    try {
      emit(SymptomSearchLoadingMore());
      
      final result = await _getSymptomsByFilter(
        filterGroup: _selectedFilter,
        skip: _currentSkip,
        limit: _limit,
      );
      
      _allSymptoms.addAll(result['symptoms']);
      _hasMore = result['hasMore'];
      _currentSkip += _limit;
      
      _applySearchAndFilter();
      emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    } catch (e) {
      emit(SymptomSearchError(e.toString()));
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applySearchAndFilter();
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  }

  void _applySearchAndFilter() {
    if (_searchQuery.isEmpty) {
      _filteredSymptoms = List.from(_allSymptoms);
    } else {
      _filteredSymptoms = _allSymptoms
          .where((symptom) => symptom.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void resetSearch() {
    _searchQuery = '';
    _applySearchAndFilter();
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  }

  void toggleSymptomSelection(Symptom symptom) {
    emit(SymptomSearchLoading());
    if (_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.remove(symptom);
    } else {
      _selectedSymptoms.add(symptom);
    }

    log('selected symptoms: ${_selectedSymptoms.length}');
    
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  }
  void refreshSymptoms() {
    emit(SymptomSearchLoading());
    log('selected symptoms: ${_selectedSymptoms.length}');
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    log('selected symptoms: ${_selectedSymptoms.length}');
  }

  void clearSelectedSymptoms() {
    _selectedSymptoms.clear();
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  }

  // void clearError() {
  //   if (state is SymptomSearchError) {
  //     emit(SymptomSearchInitial());
  //   }
  // }

  // Service functions moved from SymptomService
  Future<Map<String, dynamic>> _getAllSymptoms({
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

  Future<Map<String, dynamic>> _getSymptomsByFilter({
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

  // Additional service methods needed by other parts of the app
  Future<Map<String, dynamic>?> getSymptomDetails(String symptomId) async {
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

  Future<Map<String, dynamic>?> createHealthTracker(Map<String, dynamic> data) async {
    try {
      print('🌐 API Call: createHealthTracker');
      
      final response = await _apiClient.post(
        '/api/v1/health-trackers',
        data: data,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Health tracker created');
      return response.data;
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getHealthTrackersByDate(DateTime date) async {
    try {
      print('🌐 API Call: getHealthTrackersByDate(date: $date)');
      
      final response = await _apiClient.get(
        '/api/v1/health-trackers/by-date',
        queryParameters: {
          'date': date.toIso8601String(),
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Health trackers by date received');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ API Error: $e');
      return [];
    }
  }

  Future<String?> uploadProfileIcon(String filePath) async {
    try {
      print('🌐 API Call: uploadProfileIcon');
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      
      final response = await _apiClient.post(
        '/api/v1/profile/upload-icon',
        data: formData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Profile icon uploaded');
      return response.data['url'];
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  Future<String?> getProfileIcon() async {
    try {
      print('🌐 API Call: getProfileIcon');
      
      final response = await _apiClient.get(
        '/api/v1/profile/icon',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Profile icon received');
      return response.data['url'];
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getGetToKnowMeQuestions() async {
    try {
      print('🌐 API Call: getGetToKnowMeQuestions');
      
      final response = await _apiClient.get(
        '/api/v1/questions/get-to-know-me',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Get to know me questions received');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ API Error: $e');
      return [];
    }
  }

  // Create appointment companion
  Future<Map<String, dynamic>?> createAppointmentCompanion(Map<String, dynamic> requestData) async {
    try {
      print('🌐 API Call: createAppointmentCompanion');
      
      final response = await _apiClient.post(
        '/api/v1/appointment-companions',
        data: requestData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Appointment companion created');
      return response.data;
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  // Get appointment questions
  Future<List<Map<String, dynamic>>> getAppointmentQuestions() async {
    try {
      print('🌐 API Call: getAppointmentQuestions');
      
      final response = await _apiClient.get(
        '/api/v1/appointment-questions',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      print('✅ API Response: Appointment questions received');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ API Error: $e');
      return [];
    }
  }
}
