import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/features/data/services/symptom_service.dart';

part 'symptom_search_state.dart';

class SymptomSearchCubit extends Cubit<SymptomSearchState> {
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
  List<String> get filterOptions => SymptomService.getFilterGroups();

  Future<void> loadInitialSymptoms() async {
    try {
      print('🔄 Loading initial symptoms...');
      emit(SymptomSearchLoading());
      
      final result = await SymptomService.getAllSymptoms(skip: 0, limit: _limit);
      
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
      
      final result = await SymptomService.getAllSymptoms(
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
      
      final result = await SymptomService.getSymptomsByFilter(
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
      
      final result = await SymptomService.getAllSymptoms(
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
      
      final result = await SymptomService.getSymptomsByFilter(
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

  // void clearSelectedSymptoms() {
  //   _selectedSymptoms.clear();
  //   emit(SymptomSearchLoaded(_filteredSymptoms, _selectedSymptoms));
  // }

  // void clearError() {
  //   if (state is SymptomSearchError) {
  //     emit(SymptomSearchInitial());
  //   }
  // }
}
