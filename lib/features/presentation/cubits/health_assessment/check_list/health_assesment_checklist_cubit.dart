import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'health_assesment_checklist_state.dart';

class ChecklistItem {
  final String text;
  String? note;

  ChecklistItem({required this.text, this.note});
}

class HealthAssessmentChecklistCubit extends Cubit<HealthAssessmentChecklistState> {
 
  ApiClient _apiClient = ApiClient();
  List<ChecklistItem> _informationToPrepare = [];
  List<ChecklistItem> _questionsForDoctor = [];
  List<ChecklistItem> _testsToDiscuss = [];

  String checklistTitle = '';
  int? appointmentTypeId;

  HealthAssessmentChecklistCubit() : super(HealthAssessmentChecklistInitial());

  // Getters
  List<ChecklistItem> get informationToPrepare => _informationToPrepare;
  List<ChecklistItem> get questionsForDoctor => _questionsForDoctor;
  List<ChecklistItem> get testsToDiscuss => _testsToDiscuss;

  // Methods for Information to Prepare
  void addInformationToPrepare(String info) {
    if (!_informationToPrepare.any((item) => item.text == info)) {
      _informationToPrepare = [..._informationToPrepare, ChecklistItem(text: info)];
      emit(HealthAssessmentChecklistLoaded());
    }
  }

  void setChecklistTitle(String title) {
    checklistTitle = title;
    emit(HealthAssessmentChecklistLoaded());
  }

  void removeInformationToPrepare(String info) {
    _informationToPrepare = _informationToPrepare.where((item) => item.text != info).toList();
    emit(HealthAssessmentChecklistLoaded());
  }

  // Methods for Questions for Doctor
  void addQuestionForDoctor(String question) {
    if (!_questionsForDoctor.any((item) => item.text == question)) {
      _questionsForDoctor = [..._questionsForDoctor, ChecklistItem(text: question)];
      emit(HealthAssessmentChecklistLoaded());
    }
  }

  void removeQuestionForDoctor(String question) {
    _questionsForDoctor = _questionsForDoctor.where((item) => item.text != question).toList();
    emit(HealthAssessmentChecklistLoaded());
  }

  // Methods for Tests to Discuss
  void addTestToDiscuss(String test) {
    if (!_testsToDiscuss.any((item) => item.text == test)) {
      _testsToDiscuss = [..._testsToDiscuss, ChecklistItem(text: test)];
      emit(HealthAssessmentChecklistLoaded());
    }
  }

  void removeTestToDiscuss(String test) {
    _testsToDiscuss = _testsToDiscuss.where((item) => item.text != test).toList();
    emit(HealthAssessmentChecklistLoaded());
  }

  // Note handling methods
  void updateNote(String itemText, String note, String section) {
    List<ChecklistItem> targetList;
    switch (section) {
      case 'Information to prepare':
        targetList = _informationToPrepare;
        break;
      case 'Questions for Doctor':
        targetList = _questionsForDoctor;
        break;
      case 'Tests to discuss':
        targetList = _testsToDiscuss;
        break;
      default:
        return;
    }

    final itemIndex = targetList.indexWhere((item) => item.text == itemText);
    if (itemIndex != -1) {
      switch (section) {
        case 'Information to prepare':
          _informationToPrepare = List.from(_informationToPrepare);
          _informationToPrepare[itemIndex].note = note;
          break;
        case 'Questions for Doctor':
          _questionsForDoctor = List.from(_questionsForDoctor);
          _questionsForDoctor[itemIndex].note = note;
          break;
        case 'Tests to discuss':
          _testsToDiscuss = List.from(_testsToDiscuss);
          _testsToDiscuss[itemIndex].note = note;
          break;
      }
      emit(HealthAssessmentChecklistLoaded());
    }
  }

  // Method to populate data from assessment results
  void populateFromAssessmentResults(Map<String, dynamic> guideView) {
    try {
      emit(HealthAssessmentChecklistLoading());

      // Clear existing lists
      _informationToPrepare = [];
      _questionsForDoctor = [];
      _testsToDiscuss = [];

      // Populate information to prepare
      for (var info in guideView['information_to_prepare_details']) {
        _informationToPrepare.add(ChecklistItem(text: info['information']));
      }

      // Populate questions for doctor
      for (var question in guideView['questions_for_doctor_details']) {
        _questionsForDoctor.add(ChecklistItem(text: question['question_text']));
      }

      // Populate tests to discuss
      for (var test in guideView['medical_test_details']) {
        _testsToDiscuss.add(ChecklistItem(text: test['test_name']));
      }

      emit(HealthAssessmentChecklistLoaded());
    } catch (e) {
      emit(HealthAssessmentChecklistError('Failed to populate data: $e'));
    }
  }

  Future<void> clearData() async {
    try {
      _informationToPrepare = [];
      _questionsForDoctor = [];
      _testsToDiscuss = [];
      emit(HealthAssessmentChecklistLoaded());
    } catch (e) {
      emit(HealthAssessmentChecklistError('Failed to clear data: $e'));
    }
  }

  Future<void> saveChecklist() async {
    try {
      emit(HealthAssessmentChecklistLoading());
      log('Starting saveChecklist...');
      log('Getting SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getInt('accountId') ?? 0;
      log('Account ID: $accountId');

      final data = {
        "name": checklistTitle + ' PHG checklist',
        "appointment_type_id": appointmentTypeId,
        "curated_question_ids": [], // If you have curated questions, add their IDs here
        "custom_questions": _questionsForDoctor.map((q) => q.text).toList(),
        "prescription_and_supplements": [], // If you have prescriptions, add them here
        "is_active": true,
        "is_deleted": false,
        "account_id": accountId
      };

      log('Request data: ${data.toString()}');
      log('Making API call...');

      final response = await _apiClient.post(
        '/api/v1/checklists/',
        data: data,
      );

      log('API Response: ${response.toString()}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        log('API call successful');
        emit(HealthAssessmentChecklistLoaded());
      } else {
        log('API call failed with status: ${response.statusCode}');
        emit(HealthAssessmentChecklistError('Failed to save checklist: ${response.data}'));
      }
    } catch (e, stackTrace) {
      log('Error saving checklist', error: e, stackTrace: stackTrace);
      emit(HealthAssessmentChecklistError('Error saving checklist: $e'));
    }
  }

  void setAppointmentTypeId(int id) {
    appointmentTypeId = id;
    emit(HealthAssessmentChecklistLoaded());
  }
}
