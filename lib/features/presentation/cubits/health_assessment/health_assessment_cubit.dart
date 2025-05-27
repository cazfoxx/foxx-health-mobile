import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/area_of_concern_model.dart';
import 'package:foxxhealth/features/data/models/income_range_model.dart';
import 'package:foxxhealth/features/data/models/state_model.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_response.dart';

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
  List<SymptomTrackerResponse> _symptoms = [];
  List<Symptom> _seletedSymptom = [];

  List<State> _states = [];
  State? _selectedState;
  List<IncomeRange> _incomeRanges = [];
  IncomeRange? _seletedIncomeRange;
  List<AreaOfConcern> _areasOfConcern = [];
  List<AreaOfConcern>? _selectedAreaOfConcern;
  int? healthAssessmentId;

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
  List<SymptomTrackerResponse> get symptoms => _symptoms;
  List<Symptom> get selectedSymptom => _seletedSymptom;
  State? get selectedState => _selectedState;
  List<State> get states => _states;
  List<IncomeRange> get incomeRanges => _incomeRanges;
  List<AreaOfConcern> get areasOfConcern => _areasOfConcern;

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

  void setLocation(String newLocation) {
    _location = newLocation;
  }

  void setSpecificHealthConcerns(String concerns) {
    _specificHealthConcerns = concerns;
  }

  void setSpecificHealthGoals(String goals) {
    _specificHealthGoals = goals;
  }

  void setIncomeRange(String income) {
    _incomeRange = income;
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

  void setSymptoms(SymptomTrackerResponse newSymptoms) {
    _symptoms.add(newSymptoms);
  }

  void setSelectedSymptom(Symptom symptom) {
    _seletedSymptom.add(symptom);
  }

  void setSelectedState(State state) {
    _selectedState = state;
    _location = state.stateName;
  }

  void setSelectedIncomeRange(IncomeRange incomeRange) {
    _seletedIncomeRange = incomeRange;
    _incomeRange = incomeRange.incomeRange;
  }

  void setSelectedAreaOfConcern(List<AreaOfConcern> areasOfConcern) {
    _selectedAreaOfConcern = areasOfConcern;
  }

  HealthAssessmentCubit() : super(HealthAssessmentInitial());

  Future<void> fetchAreasOfConcern() async {
    try {
      emit(HealthAssessmentLoading());

      final response = await _apiClient.get(
        '/api/v1/areas-of-concern/',
        queryParameters: {
          'skip': 0,
          'limit': 100,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> areasJson = response.data;
        _areasOfConcern =
            areasJson.map((json) => AreaOfConcern.fromJson(json)).toList();
        emit(HealthAssessmentAreasOfConcernFetched(_areasOfConcern));
      } else {
        emit(HealthAssessmentError(
            'Failed to fetch areas of concern: ${response.statusCode}'));
      }
    } catch (e) {
      emit(HealthAssessmentError('Error fetching areas of concern: $e'));
    }
  }

  Future<void> fetchIncomeRanges() async {
    try {
      emit(HealthAssessmentLoading());

      final response = await _apiClient.get(
        '/api/v1/income-ranges/',
      );

      if (response.statusCode == 200) {
        final List<dynamic> incomeRangesJson = response.data;
        _incomeRanges =
            incomeRangesJson.map((json) => IncomeRange.fromJson(json)).toList();
        emit(HealthAssessmentIncomeRangesFetched(_incomeRanges));
      } else {
        emit(HealthAssessmentError(
            'Failed to fetch income ranges: ${response.statusCode}'));
      }
    } catch (e) {
      emit(HealthAssessmentError('Error fetching income ranges: $e'));
    }
  }

  Future<void> fetchStates() async {
    try {
      emit(HealthAssessmentLoading());

      final response = await _apiClient.get(
        '/api/v1/states/',
      );

      if (response.statusCode == 200) {
        final List<dynamic> statesJson = response.data;
        _states = statesJson.map((json) => State.fromJson(json)).toList();
        emit(HealthAssessmentStatesFetched(_states));
      } else {
        emit(HealthAssessmentError(
            'Failed to fetch states: ${response.statusCode}'));
      }
    } catch (e) {
      emit(HealthAssessmentError('Error fetching states: $e'));
    }
  }

  // Future<void> fetchSymptoms() async {
  //   try {
  //     emit(HealthAssessmentLoading());

  //     final response = await _apiClient.get(
  //       '/api/v1/symptom/',
  //       queryParameters: {
  //         'skip': 0,
  //         'limit': 100,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic> symptomsJson = response.data;
  //       _symptoms = symptomsJson.map((json) => Symptom.fromJson(json)).toList();
  //       emit(HealthAssessmentSymptomsFetched(_symptoms));
  //     } else {
  //       emit(HealthAssessmentError(
  //           'Failed to fetch symptoms: ${response.statusCode}'));
  //     }
  //   } catch (e) {
  //     emit(HealthAssessmentError('Error fetching symptoms: $e'));
  //   }
  // }

  Future<void> submitHealthAssessment() async {
    try {
      emit(HealthAssessmentLoading());

      final data = {
        'heightInInches': _heightInInches,
        'userWeight': _userWeight,
        'age': _age,
        'incomeRangeId': _seletedIncomeRange?.id,
        'stateId': _selectedState?.id,
        'ethnicities': _ethnicities,
        'preExistingConditionText': _preExistingConditionText,
        'specificHealthConcerns': _specificHealthConcerns,
        'specificHealthGoals': _specificHealthGoals,
        'areaOfConcernIds':
            _selectedAreaOfConcern?.map((area) => area.id).toList() ?? [],
        'symptomIds': _seletedSymptom.map((s) => s.id).toList(),
        'isActive': _isActive,
        'isDeleted': _isDeleted,
        'appointmentTypeId': _appointmentTypeId,
      };

      final response = await _apiClient.post(
        '/api/v1/personal-health-guides/',
        data: data,
      );

      // Add this variable at class level

      // In your API call
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Inside 201 block');

        healthAssessmentId = response.data['id'];
        print('health assessment id is $healthAssessmentId');
        try {
          // Only emit success after guide view is fetched
          fetchHealthGuideView(healthAssessmentId!);
          emit(HealthAssessmentSuccess(response.data));
        } catch (e) {
          emit(HealthAssessmentError('Error fetching guide view: $e'));
        }
      } else {
        print('Response not 201: ${response.statusCode}');
        emit(HealthAssessmentError(
            'Failed to submit health assessment: ${response.data}'));
      }
    } catch (e) {
      emit(HealthAssessmentError('Error submitting health assessment: $e'));
    }
  }

  Future<void> fetchHealthGuideView(int guideId) async {
    try {
      emit(HealthAssessmentLoading());

      final response = await _apiClient.get(
        '/api/v1/personal-health-guide-views/$guideId',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> guideView = response.data;
        emit(HealthAssessmentGuideViewFetched(guideView));
      } else {
        emit(HealthAssessmentError(
            'Failed to fetch health guide view: ${response.data}'));
      }
    } catch (e) {
      emit(HealthAssessmentError('Error fetching health guide view: $e'));
    }
  }

  Future<void> updateHealthAssessment(
      {int? feet, int? inches, int? age, int? weight}) async {
    try {
      emit(HealthAssessmentLoading());

      final data = {
        'heightInInches': feet ?? _heightInInches,
        'userWeight': weight ?? _userWeight,
        'age': age ?? _age,
        'incomeRangeId': _seletedIncomeRange?.id,
        'stateId': _selectedState?.id,
        'ethnicities': _ethnicities,
        'preExistingConditionText': _preExistingConditionText,
        'specificHealthConcerns': _specificHealthConcerns,
        'specificHealthGoals': _specificHealthGoals,
        'areaOfConcernIds':
            _selectedAreaOfConcern?.map((area) => area.id).toList() ?? [],
        'symptomIds': _seletedSymptom.map((s) => s.id).toList(),
        'isActive': _isActive,
        'isDeleted': _isDeleted,
        'appointmentTypeId': _appointmentTypeId,
      };

      final response = await _apiClient.put(
        '/api/v1/personal-health-guides/$healthAssessmentId',
        data: data,
      );

      if (response.statusCode == 200) {
        try {
          // Fetch updated guide view after successful update

          emit(HealthAssessmentSuccess(response.data));
        } catch (e) {
          emit(HealthAssessmentError('Error fetching updated guide view: $e'));
        }
      } else {
        emit(HealthAssessmentError(
            'Failed to update health assessment: ${response.data}'));
      }
    } catch (e) {
      emit(HealthAssessmentError('Error updating health assessment: $e'));
    }
  }
}
