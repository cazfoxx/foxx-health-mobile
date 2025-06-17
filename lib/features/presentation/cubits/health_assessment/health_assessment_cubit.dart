import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/area_of_concern_model.dart';
import 'package:foxxhealth/features/data/models/income_range_model.dart';
import 'package:foxxhealth/features/data/models/state_model.dart' as state_model;
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/prepping_assessment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/health_assessment_screen.dart' as health_assessment_screen;
import 'package:foxxhealth/features/presentation/screens/health_assessment/privacy_and_security_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/physical_info_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/ethnicity_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/heath_assesment_appointment_screen.dart.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/pre_existing_conditions_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/health_concerns_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/health_goals_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/area_of_concern_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/symptom_tracker_health_assessment_screen.dart.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/prescription_health_assessment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/location_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/household_income_screen.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessement_enums.dart';
part 'health_assessment_state.dart';

class HealthAssessmentCubit extends Cubit<HealthAssessmentState> {
  final _apiClient = ApiClient();
  final _storage = GetStorage();
  static const String _storageKey = 'health_assessment_data';

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
  String _appointmentType = '';
  List<SymptomTrackerResponse> _symptoms = [];
  List<Symptom> _seletedSymptom = [];

  List<state_model.State> _states = [];
  state_model.State? _selectedState;
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
  String get appointmentType => _appointmentType;
  String get preExistingConditionText => _preExistingConditionText;
  String get specificHealthConcerns => _specificHealthConcerns;
  String get specificHealthGoals => _specificHealthGoals;
  bool get isActive => _isActive;
  bool get isDeleted => _isDeleted;
  int get appointmentTypeId => _appointmentTypeId;
  List<SymptomTrackerResponse> get symptoms => _symptoms;
  List<Symptom> get selectedSymptom => _seletedSymptom;
  state_model.State? get selectedState => _selectedState;
  List<state_model.State> get states => _states;
  List<IncomeRange> get incomeRanges => _incomeRanges;
  List<AreaOfConcern> get areasOfConcern => _areasOfConcern;


  HealthAssessmentScreen lastScreen = HealthAssessmentScreen.initial;

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

  void setLocation(String selectedLocation) {
    _location = selectedLocation;
    emit(HealthAssessmentDataLoaded());
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

  void setAppointmentType(String appointmentType) {
    _appointmentType = appointmentType;
  }

  void setSymptoms(SymptomTrackerResponse newSymptoms) {
    _symptoms.add(newSymptoms);
  }

  void setSelectedSymptom(Symptom symptom) {
    _seletedSymptom.add(symptom);
  }

  void setSelectedState(state_model.State state) {
    _selectedState = state;
  }

  void setSelectedIncomeRange(IncomeRange incomeRange) {
    _seletedIncomeRange = incomeRange;
    _incomeRange = incomeRange.incomeRange;
  }

  void setSelectedAreaOfConcern(List<AreaOfConcern> areasOfConcern) {
    _selectedAreaOfConcern = areasOfConcern;
  }

  HealthAssessmentCubit() : super(HealthAssessmentInitial()) {
    if (hasStoredData()) {
      loadSavedData();
    }
  }

  // Save all health assessment data
  Future<void> saveData({required HealthAssessmentScreen screen}) async {
    try{
        final data = {
      'screen': screen,
      'heightInFeet': _heightInFeet,
      'heightInInches': _heightInInches,
      'userWeight': _userWeight,
      'age': _age,
      'ethnicities': _ethnicities,
      'preExistingConditionText': _preExistingConditionText,
      'location': _location,
      'specificHealthConcerns': _specificHealthConcerns,
      'specificHealthGoals': _specificHealthGoals,
      'incomeRange': _incomeRange,
      'isActive': _isActive,
      'isDeleted': _isDeleted,
      'appointmentTypeId': _appointmentTypeId,
      'symptoms': _symptoms.map((s) => s.toJson()).toList(),
      'selectedSymptom': _seletedSymptom.map((s) => s.toJson()).toList(),
      'selectedState': _selectedState?.toJson(),
      'selectedIncomeRange': _seletedIncomeRange?.toJson(),
      'selectedAreaOfConcern': _selectedAreaOfConcern?.map((a) => a.toJson()).toList(),
      'healthAssessmentId': healthAssessmentId,
    };

    await _storage.write(_storageKey, data);
      
    }catch(e){
      print('Error saving data: $e');
      
    }
  
  }

  // Load saved health assessment data
  Future<void> loadSavedData() async {
    try {
      final data = _storage.read(_storageKey);
      if (data != null) {
        lastScreen = data['screen'] ?? HealthAssessmentScreen.initial;
        _heightInFeet = data['heightInFeet'] ?? 0;
        _heightInInches = data['heightInInches'] ?? 0;
        _userWeight = data['userWeight'] ?? 0;
        _age = data['age'] ?? 0;
        _ethnicities = List<String>.from(data['ethnicities'] ?? []);
        _preExistingConditionText = data['preExistingConditionText'] ?? '';
        _location = data['location'] ?? '';
        _specificHealthConcerns = data['specificHealthConcerns'] ?? '';
        _specificHealthGoals = data['specificHealthGoals'] ?? '';
        _incomeRange = data['incomeRange'] ?? '';
        _isActive = data['isActive'] ?? true;
        _isDeleted = data['isDeleted'] ?? false;
        _appointmentTypeId = data['appointmentTypeId'] ?? 0;
        
        if (data['symptoms'] != null) {
          _symptoms = List<SymptomTrackerResponse>.from(
            data['symptoms'].map((x) => SymptomTrackerResponse.fromJson(x))
          );
        }
        
        if (data['selectedSymptom'] != null) {
          _seletedSymptom = List<Symptom>.from(
            data['selectedSymptom'].map((x) => Symptom.fromJson(x))
          );
        }
        
        if (data['selectedState'] != null) {
          _selectedState = state_model.State.fromJson(data['selectedState']);
        }
        
        if (data['selectedIncomeRange'] != null) {
          _seletedIncomeRange = IncomeRange.fromJson(data['selectedIncomeRange']);
        }
        
        if (data['selectedAreaOfConcern'] != null) {
          _selectedAreaOfConcern = List<AreaOfConcern>.from(
            data['selectedAreaOfConcern'].map((x) => AreaOfConcern.fromJson(x))
          );
        }
        
        healthAssessmentId = data['healthAssessmentId'];
        
        // Emit state to notify UI of loaded data
        emit(HealthAssessmentDataLoaded());
      }
    } catch (e) {
      emit(HealthAssessmentError('Error loading saved data: $e'));
    }
  }

  // Clear saved data
  Future<void> clearSavedData() async {
    await _storage.remove(_storageKey);
    // Reset all variables to default values
    _heightInFeet = 0;
    _heightInInches = 0;
    _userWeight = 0;
    _age = 0;
    _ethnicities = [];
    _preExistingConditionText = '';
    _location = '';
    _specificHealthConcerns = '';
    _specificHealthGoals = '';
    _incomeRange = '';
    _isActive = true;
    _isDeleted = false;
    _appointmentTypeId = 0;
    _symptoms = [];
    _seletedSymptom = [];
    _selectedState = null;
    _seletedIncomeRange = null;
    _selectedAreaOfConcern = null;
    healthAssessmentId = null;
    
    emit(HealthAssessmentInitial());
  }

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
        _states = statesJson.map((json) => state_model.State.fromJson(json)).toList();
        emit(HealthAssessmentStatesFetched(_states.cast<state_model.State>()));
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
        // 'stateId': _selectedState?.id,
        'state': _location,
        'ethnicities': _ethnicities,
        'preExistingConditionText': _preExistingConditionText,
        'specificHealthConcerns': _specificHealthConcerns,
        'specificHealthGoals': _specificHealthGoals,
        'areaOfConcernIds':
            _selectedAreaOfConcern?.map((area) => area.id).toList() ?? [],
        'symptomIds': _symptoms.map((s) => s.id).toList(),
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
        // clearSavedData();
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

  // Navigate to specific screen based on enum
  void navigateToScreen(BuildContext context, HealthAssessmentScreen screen) {
    late final Widget targetScreen;
    
    switch (screen) {
      case HealthAssessmentScreen.initial:
        targetScreen = const health_assessment_screen.HealthAssessmentScreen();
        break;

      case HealthAssessmentScreen.location:
        targetScreen = const LocationScreen();
        break;
      case HealthAssessmentScreen.income:
        targetScreen = const HouseholdIncomeScreen();
        break;
      case HealthAssessmentScreen.privacyAndSecurity:
        targetScreen =  PrivacyAndSecurityScreen();
        break;
      case HealthAssessmentScreen.physicalInfo:
        targetScreen = const PhysicalInfoScreen();
        break;
      case HealthAssessmentScreen.ethnicity:
        targetScreen = const EthnicityScreen();
        break;
      case HealthAssessmentScreen.appointmentType:
        targetScreen = const HealthAssessmentAppointTypeScreen();
        break;
      case HealthAssessmentScreen.preExistingConditions:
        targetScreen = const PreExistingConditionsScreen();
        break;
      case HealthAssessmentScreen.healthConcerns:
        targetScreen = const HealthConcernsScreen();
        break;
      case HealthAssessmentScreen.healthGoals:
        targetScreen = const HealthGoalsScreen();
        break;
      case HealthAssessmentScreen.areaOfConcern:
        targetScreen = const AreaOfConcernScreen();
        break;
      case HealthAssessmentScreen.symptomTracker:
        targetScreen = const SymptomTrackerHealthAssessmentScreen();
        break;
      case HealthAssessmentScreen.prescriptionAndSupplements:
        targetScreen = const PrescriptionHealthAssessmentScreen();
        break;
      case HealthAssessmentScreen.preppingAssessment:
        targetScreen = const PreppingAssessmentScreen();
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  // Check if health assessment data exists in storage
  bool hasStoredData() {
    final data = _storage.read(_storageKey);
    return data != null;
  }

  // Check stored data and navigate to last screen if exists
  void checkAndNavigateToLastScreen(BuildContext context) {

      final data = _storage.read(_storageKey);
      if (data != null && data['screen'] != null) {
        final screenEnum = HealthAssessmentScreen.values.firstWhere(
          (e) => e.toString() == data['screen'].toString(),
          orElse: () => HealthAssessmentScreen.initial,
        );
        navigateToScreen(context, screenEnum);
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const health_assessment_screen.HealthAssessmentScreen()),
        );
      }
    }

}
