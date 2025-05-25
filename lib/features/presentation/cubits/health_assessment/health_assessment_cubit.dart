import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
part 'health_assessment_state.dart';

class HealthAssessmentCubit extends Cubit<HealthAssessmentState> {
  final _apiClient = ApiClient();

  // Variables for health assessment
  int _heightInFeet = 0;
  int _heightInInches = 0;
  int _userWeight = 0;
  int _age = 0;
  List<String> _ethnicities = [];
  String _preExistingConditionText = '';
  String _location = '';
  String _specificHealthConcerns = '';
  String _specificHealthGoals = '';
  String _incomeRange = '';
  bool _isActive = true;
  bool _isDeleted = false;
  int _appointmentTypeId = 0;
  String symptoms = '';

  // Getters
  int get heightInInches => _heightInInches;
  int get heightInFeet => _heightInFeet;
  String get income => _incomeRange;
  String get location => _location;
  int get userWeight => _userWeight;
  int get age => _age;
  List<String> get ethnicities => _ethnicities;
  String get preExistingConditionText => _preExistingConditionText;
  String get specificHealthConcerns => _specificHealthConcerns;
  String get specificHealthGoals => _specificHealthGoals;
  bool get isActive => _isActive;
  bool get isDeleted => _isDeleted;
  int get appointmentTypeId => _appointmentTypeId;

  // Setters
  void setHeightInInches(int height) {
    _heightInInches = height;
  }
   void setHeightInFeet(int height) {
    _heightInFeet = height;
  }


  void setUserWeight(int weight) {
    _userWeight = weight;
  }

  void setAge(int newAge) {
    _age = newAge;
  }

  void setEthnicities(List<String> newEthnicities) {
    _ethnicities = newEthnicities;
  }

  void setPreExistingConditionText(String condition) {
    _preExistingConditionText = condition;
  }

  void setLocation(String location) {
    _location = location;
  }

  void setSpecificHealthConcerns(String concerns) {
    _specificHealthConcerns = concerns;
  }

  void setSpecificHealthGoals(String goals) {
    _specificHealthGoals = goals;
  }

  void setIsActive(bool active) {
    _isActive = active;
  }

  void setIsDeleted(bool deleted) {
    _isDeleted = deleted;
  }

  void setAppointmentTypeId(int id) {
    _appointmentTypeId = id;
  }

   void setSymptoms(String symptoms) {
    symptoms = symptoms;
  }

  HealthAssessmentCubit() : super(HealthAssessmentInitial());

  Future<void> submitHealthAssessment() async {
    try {
      emit(HealthAssessmentLoading());

      final data = {
        'heightInInches': _heightInInches,
        'userWeight': _userWeight,
        'age': _age,
        'ethnicities': _ethnicities,
        'preExistingConditionText': _preExistingConditionText,
        'specificHealthConcerns': _specificHealthConcerns,
        'specificHealthGoals': _specificHealthGoals,
        'isActive': _isActive,
        'isDeleted': _isDeleted,
        'appointmentTypeId': _appointmentTypeId,
      };

      final response = await _apiClient.post(
        '/api/v1/personal-health-guide/personal-health-guide',
        data: data,
      );

      if (response.statusCode == 201) {
        emit(HealthAssessmentSuccess(response.data));
      } else {
        emit(HealthAssessmentError('Failed to submit health assessment: ${response.data}'));
      }
    } catch (e) {
      emit(HealthAssessmentError('Error submitting health assessment: $e'));
    }
  }
}