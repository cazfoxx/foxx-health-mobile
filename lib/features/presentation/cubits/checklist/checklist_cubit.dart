import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/checklist_model.dart';
part 'checklist_state.dart';

class ChecklistCubit extends Cubit<ChecklistState> {
  final _apiClient = ApiClient();

  ChecklistCubit() : super(ChecklistInitial()) {
    // Fetch checklists when cubit is initialized
    getChecklists();
  }

  List<String> suggestedQuestion = [];
  List<String> customQuestion = [];
  List<String> prescription = [];

  int appointmentTypeId = 0;
  String checkListName = '';
  setCheckListName(String name) {
    checkListName = '$name checklist';
  }

  setAppointmentTypeId(int typeId) {
    appointmentTypeId = typeId;
    log('appointmentTypeId: $appointmentTypeId');
  }

  void logalldata() {
    log('suggestedQuestion: $suggestedQuestion');
    log('customQuestion: $customQuestion');
    log('prescription: $prescription');
  }

  // Setters for updating the lists
  void setSuggestedQuestion(List<String> questions) {
    suggestedQuestion = questions;
    log('suggested: $suggestedQuestion');
  }

  void setCustomQuestion(List<String> questions) {
    customQuestion = questions;
    log('customQuestion: $customQuestion');
  }

  void setPrescription(List<String> prescriptions) {
    prescription = prescriptions;
    log('prescription: $prescription');
  }

  // Create a new checklist
  Future<void> createChecklist() async {
    try {
      emit(ChecklistLoading());

      ChecklistModel checklist = ChecklistModel(
          name: 'checklist $appointmentTypeId',
          appointmentTypeId: appointmentTypeId,
          curatedQuestionIds: [0],
          customQuestions: customQuestion,
          prescriptionAndSupplements: prescription,
          isActive: true,
          isDeleted: false,
          accountId: 0);

      final response = await _apiClient.post(
        '/api/v1/checklists/checklists/',
        data: checklist.toJson(),
      );

      if (response.statusCode == 201) {
        // Cast the response data to Map<String, dynamic>
        final Map<String, dynamic> responseData =
            Map<String, dynamic>.from(response.data);
        // Create checklist model from actual response data
        final createdChecklist = ChecklistModel.fromJson(responseData);
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
        '/api/v1/checklists/checklists/me',
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
}
