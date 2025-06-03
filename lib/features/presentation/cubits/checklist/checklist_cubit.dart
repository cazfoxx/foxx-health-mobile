import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/checklist_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_enums.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/suggested_questions_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/pescription_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/create_checklist_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/completion_screen.dart';

part 'checklist_state.dart';

class ChecklistCubit extends Cubit<ChecklistState> {
  final _apiClient = ApiClient();
  final _storage = GetStorage();
  static const String _storageKey = 'checklist_data';
  ChecklistScreen lastScreen = ChecklistScreen.initial;

  ChecklistCubit() : super(ChecklistInitial()) {
    if (hasStoredData()) {
      loadSavedData();
    }
  }

  List<String> suggestedQuestion = [];
  List<String> customQuestion = [];
  List<String> prescription = [];
  int appointmentTypeId = 0;
  String checkListName = '';
  int? checklistId;

  // Save data to storage
  Future<void> saveData({required ChecklistScreen screen}) async {
    try {
      final data = {
        'screen': screen.toString(),
        'suggestedQuestion': suggestedQuestion,
        'customQuestion': customQuestion,
        'prescription': prescription,
        'appointmentTypeId': appointmentTypeId,
        'checkListName': checkListName,
        'checklistId': checklistId,
      };

      await _storage.write(_storageKey, data);
      lastScreen = screen;
      emit(ChecklistDataSaved());
    } catch (e) {
      print('Error saving checklist data: $e');
      emit(ChecklistError('Error saving data: $e'));
    }
  }

  // Load saved data
  Future<void> loadSavedData() async {
    try {
      final data = _storage.read(_storageKey);
      if (data != null) {
        lastScreen = ChecklistScreen.values.firstWhere(
          (e) => e.toString() == data['screen'],
          orElse: () => ChecklistScreen.initial,
        );
        
        suggestedQuestion = List<String>.from(data['suggestedQuestion'] ?? []);
        customQuestion = List<String>.from(data['customQuestion'] ?? []);
        prescription = List<String>.from(data['prescription'] ?? []);
        appointmentTypeId = data['appointmentTypeId'] ?? 0;
        checkListName = data['checkListName'] ?? '';
        checklistId = data['checklistId'];
        
        emit(ChecklistDataLoaded());
      }
    } catch (e) {
      print('Error loading checklist data: $e');
      emit(ChecklistError('Error loading saved data: $e'));
    }
  }

  // Clear saved data
  Future<void> clearSavedData() async {
    try {
      await _storage.remove(_storageKey);
      suggestedQuestion = [];
      customQuestion = [];
      prescription = [];
      appointmentTypeId = 0;
      checkListName = '';
      checklistId = null;
      lastScreen = ChecklistScreen.initial;
      emit(ChecklistInitial());
    } catch (e) {
      print('Error clearing saved data: $e');
      emit(ChecklistError('Error clearing data: $e'));
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

  // Navigate to screen with proper data handling
  void navigateToScreen(BuildContext context, ChecklistScreen screen) {
    Widget targetScreen;
    
    switch (screen) {
      case ChecklistScreen.initial:
      case ChecklistScreen.appointmentType:
        targetScreen = const AppointmentTypeScreen();
        break;
      case ChecklistScreen.suggestedQuestions:
        targetScreen = const SuggestedQuestionsScreen(appointmentType: '',);
        break;
      case ChecklistScreen.customQuestions:
        targetScreen = const CreateChecklistScreen();
        break;
      case ChecklistScreen.prescriptionSupplements:
        targetScreen = const PrescriptionScreen();
        break;
      case ChecklistScreen.review:
        targetScreen = const CompletionScreen();
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
        final screenEnum = ChecklistScreen.values.firstWhere(
          (e) => e.toString() == data['screen'].toString(),
          orElse: () => ChecklistScreen.initial,
        );
        navigateToScreen(context, screenEnum);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateChecklistScreen()),
        );
      }
    } catch (e) {
      print('Error navigating to last screen: $e');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateChecklistScreen()),
      );
    }
  }

  // Setters with storage updates
  void setCheckListName(String name) {
    checkListName = '$name checklist';
    saveData(screen: lastScreen);
  }

  void setAppointmentTypeId(int typeId) {
    appointmentTypeId = typeId;
    saveData(screen: lastScreen);
    log('appointmentTypeId: $appointmentTypeId');
  }

  void setSuggestedQuestion(List<String> questions) {
    suggestedQuestion = questions;
    saveData(screen: lastScreen);
    log('suggested: $suggestedQuestion');
  }

  void setCustomQuestion(List<String> questions) {
    customQuestion = questions;
    saveData(screen: lastScreen);
    log('customQuestion: $customQuestion');
  }

  void setPrescription(List<String> prescriptions) {
    prescription = prescriptions;
    saveData(screen: lastScreen);
    log('prescription: $prescription');
  }

  // API Methods
  Future<void> createChecklist() async {
    try {
      emit(ChecklistLoading());

      final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getInt('accountId') ?? 0;

      ChecklistModel checklist = ChecklistModel(
        name: checkListName,
        appointmentTypeId: appointmentTypeId,
        curatedQuestionIds: [0],
        customQuestions: customQuestion,
        prescriptionAndSupplements: prescription,
        isActive: true,
        isDeleted: false,
        accountId: accountId
      );

      final response = await _apiClient.post(
        '/api/v1/checklists/',
        data: checklist.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = Map<String, dynamic>.from(response.data);
        final createdChecklist = ChecklistModel.fromJson(responseData);
        checklistId = createdChecklist.id;
        await clearSavedData(); // Clear saved data after successful creation
        emit(ChecklistCreated(createdChecklist));
      } else {
        emit(ChecklistError('Failed to create checklist: ${response.data}'));
      }
    } catch (e) {
      emit(ChecklistError('Error creating checklist: $e'));
    }
  }

  // Fetch checklists
  Future<void> getChecklists() async {
    try {
      emit(ChecklistLoading());

      final response = await _apiClient.get(
        '/api/v1/checklists/me',
        queryParameters: {
          'skip': 0,
          'limit': 100,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> checklistsData = response.data;
        final checklists = checklistsData
            .map((data) => ChecklistModel.fromJson(data))
            .toList();
        emit(ChecklistsLoaded(checklists));
      } else {
        emit(ChecklistError('Failed to fetch checklists: ${response.data}'));
      }
    } catch (e) {
      emit(ChecklistError('Error fetching checklists: $e'));
    }
  }

  // Edit an existing checklist
  Future<void> editChecklist() async {
    try {
      emit(ChecklistLoading());

      final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getInt('accountId') ?? 0;

      final data = {
        'name': checkListName,
        'appointment_type_id': appointmentTypeId,
        'curated_question_ids': [0],
        'custom_questions': customQuestion,
        'prescription_and_supplements': prescription,
        'is_active': true,
        'is_deleted': false,
        'account_id': accountId
      };

      final response = await _apiClient.put(
        '/api/v1/checklists/$checklistId',
        data: data,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        final updatedChecklist = ChecklistModel.fromJson(responseData);
        emit(ChecklistUpdated(updatedChecklist));
      } else {
        emit(ChecklistError('Failed to update checklist: ${response.data}'));
      }
    } catch (e) {
      emit(ChecklistError('Error updating checklist: $e'));
    }
  }

  // Delete a checklist
  Future<void> deleteChecklist(int checklistId) async {
    try {
      emit(ChecklistLoading());

      final response = await _apiClient.delete(
        '/api/v1/checklists/$checklistId',
      );

      if (response.statusCode == 200) {
        emit(ChecklistDeleted(checklistId));
      } else {
        emit(ChecklistError('Failed to delete checklist: ${response.data}'));
      }
    } catch (e) {
      emit(ChecklistError('Error deleting checklist: $e'));
    }
  }

  void logalldata() {
    log('suggestedQuestion: $suggestedQuestion');
    log('customQuestion: $customQuestion');
    log('prescription: $prescription');
  }
}
