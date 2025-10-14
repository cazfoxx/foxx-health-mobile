import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:dio/dio.dart';

part 'symptom_search_state.dart';

class SymptomSearchCubit extends Cubit<SymptomSearchState> {
  final ApiClient _apiClient = ApiClient();

  List<Symptom> _allSymptoms = [];
  List<Symptom> _filteredSymptoms = [];
  Set<Symptom> _selectedSymptoms = {};
  Map<String, Map<String, dynamic>> _symptomDetails =
      {}; // Store details for each symptom
  String _selectedFilter = '';
  String _searchQuery = '';
  bool _hasMore = true;
  int _currentSkip = 0;
  static const int _limit = 200;
  SymptomSearchCubit() : super(SymptomSearchInitial());

  List<Symptom> get allSymptoms => _allSymptoms;
  List<Symptom> get filteredSymptoms => _filteredSymptoms;
  Set<Symptom> get selectedSymptoms => _selectedSymptoms;
  List<Symptom> get selectedSymptomsList => _selectedSymptoms.toList();
  Map<String, Map<String, dynamic>> get symptomDetails => _symptomDetails;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  bool get hasMore => _hasMore;
  List<String> get filterOptions =>
      ['All', 'Period', 'Behavioral Changes', 'Body Image'];

  Future<void> loadInitialSymptoms() async {
    try {
      print('🔄 Loading all symptoms in chunks...');
      emit(SymptomSearchLoading());

      _allSymptoms.clear();
      _hasMore = true;
      _currentSkip = 0;

      // Keep fetching until no more data
      while (_hasMore) {
        final result = await _getAllSymptoms(skip: _currentSkip, limit: 200);

        final List<Symptom> newSymptoms = result['symptoms'];
        _allSymptoms.addAll(newSymptoms);
        _hasMore = result['hasMore'];
        _currentSkip += 200;

        print('✅ Loaded ${_allSymptoms.length} symptoms so far...');
      }

      print('🎉 Finished loading all symptoms: ${_allSymptoms.length}');
      _applySearchAndFilter();
      emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    } catch (e, stack) {
      print('❌ Error loading all symptoms: $e');
      print(stack);
      emit(SymptomSearchError(e.toString()));
    }
  }

// Future<void> loadInitialSymptoms() async {
  //   try {
  //     print('🔄 Loading initial symptoms...');
  //     emit(SymptomSearchLoading());

  //     final result = await _getAllSymptoms(skip: 0, limit: _limit);

  //     _allSymptoms = result['symptoms'];
  //     _hasMore = result['hasMore'];
  //     _currentSkip = _limit;

  //     print('✅ Loaded ${_allSymptoms.length} symptoms');

  //     _applySearchAndFilter();
  //     emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  //   } catch (e) {
  //     print('❌ Error loading symptoms: $e');
  //     emit(SymptomSearchError(e.toString()));
  //   // }
  // }

  Future<void> loadMoreSymptoms() async {
    // Prevent loading if already loading, no more items, or searching
    if (!_hasMore ||
        state is SymptomSearchLoading ||
        state is SymptomSearchLoadingMore ||
        _searchQuery.isNotEmpty) return;

    try {
      // Emit a state that keeps the current data visible
      if (state is SymptomSearchLoaded) {
        final currentState = state as SymptomSearchLoaded;
        emit(SymptomSearchLoadingMore(
            currentState.symptoms, currentState.selectedSymptoms));
      }

      // Fetch more data
      final result = await _getAllSymptoms(
        skip: _currentSkip,
        limit: _limit,
      );

      _allSymptoms.addAll(result['symptoms']);
      _hasMore = result['hasMore'];
      _currentSkip += _limit;

      _applySearchAndFilter();

      // Re-emit loaded state with new data
      emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    } catch (e) {
      emit(SymptomSearchError(e.toString()));
    }
    // if (!_hasMore || state is SymptomSearchLoading || _searchQuery.isNotEmpty) return;

    // try {
    //   emit(SymptomSearchLoadingMore());

    //   final result = await _getAllSymptoms(
    //     skip: _currentSkip,
    //     limit: _limit,
    //   );

    //   _allSymptoms.addAll(result['symptoms']);
    //   _hasMore = result['hasMore'];
    //   _currentSkip += _limit;

    //   _applySearchAndFilter();
    //   emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    // } catch (e) {
    //   emit(SymptomSearchError(e.toString()));
    // }
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
    // Prevent redundant or overlapping requests
    if (!_hasMore ||
        state is SymptomSearchLoading ||
        state is SymptomSearchLoadingMore ||
        _searchQuery.isNotEmpty) return;

    try {
      // Preserve current symptoms while loading more
      if (state is SymptomSearchLoaded) {
        final currentState = state as SymptomSearchLoaded;
        emit(SymptomSearchLoadingMore(
            currentState.symptoms, currentState.selectedSymptoms));
      }

      // Fetch next batch based on selected filter
      final result = await _getSymptomsByFilter(
        filterGroup: _selectedFilter,
        skip: _currentSkip,
        limit: _limit,
      );

      _allSymptoms.addAll(result['symptoms']);
      _hasMore = result['hasMore'];
      _currentSkip += _limit;

      _applySearchAndFilter();

      // Emit the updated loaded state
      emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    } catch (e) {
      emit(SymptomSearchError(e.toString()));
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    _hasMore = false; // stop further pagination when searching
    _applySearchAndFilter();
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  }

  void _applySearchAndFilter() {
    if (_searchQuery.isEmpty) {
      _filteredSymptoms = List.from(_allSymptoms);
    } else {
      _filteredSymptoms = _allSymptoms
          .where((symptom) =>
              symptom.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void resetSearch() {
    _searchQuery = '';
    _applySearchAndFilter();
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  }

  void toggleSymptomSelection(Symptom symptom) {
    // emit(SymptomSearchLoading());
    if (_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.remove(symptom);
    } else {
      _selectedSymptoms.add(symptom);
    }

    log('selected symptoms: ${_selectedSymptoms.length}');

    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  }

  void refreshSymptoms() {
    // emit(SymptomSearchLoading());
    log('selected symptoms: ${_selectedSymptoms.length}');
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
    log('selected symptoms: ${_selectedSymptoms.length}');
  }

  void clearSelectedSymptoms() {
    _selectedSymptoms.clear();
    _symptomDetails.clear();
    emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  }

  void addSymptomWithDetails(Symptom symptom, Map<String, dynamic> details) {
    if (!_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.add(symptom);
    }
    // Store the details for this symptom
    _symptomDetails[symptom.id] = details;
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
            'Authorization': 'Bearer ${AppStorage.accessToken}',
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
        'hasMore': symptoms.length == limit,
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
      print(
          '🌐 API Call: getSymptomsByFilter(filterGroup: $filterGroup, skip: $skip, limit: $limit)');

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
            'Authorization': 'Bearer ${AppStorage.accessToken}',
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
        'hasMore': symptoms.length == limit,
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
            'Authorization': 'Bearer ${AppStorage.accessToken}',
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

  Future<Map<String, dynamic>?> createHealthTracker(
      Map<String, dynamic> data) async {
    try {
      print('🌐 API Call: createHealthTracker');

      final response = await _apiClient.post(
        '/api/v1/health-trackers/',
        data: data,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
          validateStatus: (status) => status! < 400,
          followRedirects: true,
        ),
      );

      print('✅ API Response: Health tracker created');
      return response.data;
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getHealthTrackersByDate(
      DateTime date) async {
    try {
      print('🌐 API Call: getHealthTrackersByDate(date: $date)');

      // Format date as YYYY-MM-DD without time component to avoid API validation error
      final dateString =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final response = await _apiClient.get(
        '/api/v1/health-trackers/me',
        queryParameters: {
          'selected_date': dateString,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
          validateStatus: (status) => status! < 400,
          followRedirects: true,
        ),
      );

      print('✅ API Response: Health trackers by date received');

      // Handle the response data properly to avoid type errors
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.data is Map) {
        // If the API returns a single object instead of a list
        return [Map<String, dynamic>.from(response.data)];
      } else {
        print('⚠️ Unexpected response data type: ${response.data.runtimeType}');
        return [];
      }
    } catch (e) {
      print('❌ API Error: $e');
      if (e.toString().contains('422')) {
        print(
            '⚠️ Validation error: Date format issue. Please check the date parameter.');
      }
      return [];
    }
  }
  
  Future<Map<DateTime, List<Symptom>>> getSymptomsByMonth(
      DateTime month) async {
    try {
      final year = month.year;
      final monthNumber = month.month;

      final startDate = DateTime(year, monthNumber, 1);
      final endDate = DateTime(year, monthNumber + 1, 0);

      print("📡 Fetching symptoms from $startDate to $endDate");

      final response = await _apiClient.get(
        '/api/v1/health-trackers/me',
        queryParameters: {
          'from_date': startDate.toIso8601String().split("T").first,
          'to_date': endDate.toIso8601String().split("T").first,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
          validateStatus: (status) => status! < 400,
        ),
      );

      if (response.data is! List) {
        throw Exception("Unexpected response format: ${response.data}");
      }

      final List<dynamic> trackers = response.data;
      final Map<DateTime, List<Symptom>> symptomMap = {};

      for (final tracker in trackers) {
        final fromDate = DateTime.parse(tracker['from_date']);
        final toDate = DateTime.parse(tracker['to_date']);

        // Skip trackers outside the current month
        if (toDate.isBefore(startDate) || fromDate.isAfter(endDate)) continue;

        final List<dynamic> selected = tracker['selected_symptoms'] ?? [];
        final List<Symptom> symptoms =
            selected.map((s) => Symptom.fromJson(s)).toList();

        for (DateTime d = fromDate;
            !d.isAfter(toDate);
            d = d.add(const Duration(days: 1))) {
          if (d.month != monthNumber)
            continue; // filter strictly to current month

          final key = DateTime(d.year, d.month, d.day);
          symptomMap.putIfAbsent(key, () => []);
          symptomMap[key]!.addAll(symptoms);
        }
      }

      print("✅ Returning symptom map: ${symptomMap.keys}");
      return symptomMap;
    } catch (e, st) {
      print("❌ Error fetching symptoms for month: $e\n$st");
      return {};
    }
  }

  Future<List<String>> getAllUserSymptomNames() async {
    try {
      final response = await _apiClient.get(
        '/api/v1/health-trackers/me',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
          validateStatus: (status) => status! < 400,
        ),
      );

      if (response.data is! List) {
        throw Exception("Unexpected response format: ${response.data}");
      }

      final List<dynamic> trackers = response.data;

      // Collect unique symptom names
      final Set<String> symptomNames = {};

      for (final tracker in trackers) {
        final List<dynamic> selected = tracker['selected_symptoms'] ?? [];

        for (final symptomJson in selected) {
          final info = symptomJson['info'];
          if (info != null && info['name'] != null) {
            symptomNames.add(info['name']);
          }
        }
      }

      return symptomNames.toList();
    } catch (e) {
      print("❌ Error fetching symptom names: $e");
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
            'Authorization': 'Bearer ${AppStorage.accessToken}',
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
            'Authorization': 'Bearer ${AppStorage.accessToken}',
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

  Future<void> submitGetToKnowMeAnswers(Map<String, dynamic> answers) async {
    try {
      print('🌐 API Call: submitGetToKnowMeAnswers');

      await _apiClient.post(
        '/api/v1/questions/get-to-know-me',
        data: answers,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: Get to know me answers submitted');
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Failed to submit answers: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHealthGoals() async {
    try {
      print('🌐 API Call: getHealthGoals');

      final response = await _apiClient.get(
        '/api/v1/health-goals',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: Health goals received');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ API Error: $e');
      return [];
    }
  }

  Future<void> submitHealthGoals(List<String> goals) async {
    try {
      print('🌐 API Call: submitHealthGoals');

      await _apiClient.post(
        '/api/v1/health-goals',
        data: {'goals': goals},
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: Health goals submitted');
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Failed to submit health goals: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHealthConcerns() async {
    try {
      print('🌐 API Call: getHealthConcerns');

      final response = await _apiClient.get(
        '/api/v1/health-concerns',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: Health concerns received');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ API Error: $e');
      return [];
    }
  }

  Future<void> submitHealthConcerns(List<String> concerns) async {
    try {
      print('🌐 API Call: submitHealthConcerns');

      await _apiClient.post(
        '/api/v1/health-concerns',
        data: {'concerns': concerns},
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: Health concerns submitted');
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Failed to submit health concerns: $e');
    }
  }

  // Create appointment companion
  Future<Map<String, dynamic>?> createAppointmentCompanion(
      Map<String, dynamic> requestData) async {
    try {
      print('🌐 API Call: createAppointmentCompanion');

      final response = await _apiClient.post(
        '/api/v1/appointment-companions',
        data: requestData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
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
            'Authorization': 'Bearer ${AppStorage.accessToken}',
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

  // Get symptoms by body part
  Future<List<Map<String, dynamic>>> getSymptomsByBodyPart(
      String bodyPart) async {
    try {
      print('🌐 API Call: getSymptomsByBodyPart(bodyPart: $bodyPart)');

      final response = await _apiClient.get(
        '/api/v1/symptom/body-part/$bodyPart',
        queryParameters: {
          'body_part': bodyPart,
          'skip': 0,
          'limit': 100,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: Symptoms by body part received');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ API Error: $e');
      return [];
    }
  }

  // Get health profile questions
  Future<List<Map<String, dynamic>>> getHealthProfileQuestions() async {
    try {
      print('🌐 API Call: getHealthProfileQuestions');

      final response = await _apiClient.get(
        '/api/v1/get-to-know-me/',
        queryParameters: {
          'skip': 0,
          'limit': 100,
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: Health profile questions received');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('❌ API Error: $e');
      return [];
    }
  }

  // Submit health profile answers
  Future<void> submitHealthProfileAnswers(Map<String, dynamic> answers) async {
    try {
      print('🌐 API Call: submitHealthProfileAnswers');

      await _apiClient.post(
        '/api/v1/get-to-know-me/',
        data: answers,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: Health profile answers submitted');
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Failed to submit health profile answers: $e');
    }
  }

  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      print('🌐 API Call: getUserProfile');

      final response = await _apiClient.get(
        '/api/v1/accounts/me',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: User profile received');
      return response.data;
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }

  // Update user profile data
  Future<void> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      print('🌐 API Call: updateUserProfile');

      await _apiClient.put(
        '/api/v1/accounts/me',
        data: profileData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppStorage.accessToken}',
          },
        ),
      );

      print('✅ API Response: User profile updated');
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Failed to update user profile: $e');
    }
  }
}
