import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

// Onboarding Question Model
class OnboardingQuestion {
  final List<String> choices;
  final bool isActive;
  final String type;
  final String fieldName;
  final bool isPremium;
  final String description;
  final String dataType;
  final String flowType;
  final int id;
  final String createdAt;
  final String updatedAt;
  final String question;

  OnboardingQuestion({
    required this.choices,
    required this.isActive,
    required this.type,
    required this.fieldName,
    required this.isPremium,
    required this.description,
    required this.dataType,
    required this.flowType,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.question,
  });

  factory OnboardingQuestion.fromJson(Map<String, dynamic> json) {
    return OnboardingQuestion(
      choices: List<String>.from(json['choices']),
      isActive: json['is_active'],
      type: json['type'],
      fieldName: json['field_name'],
      isPremium: json['is_premium'],
      description: json['description'] ?? '',
      dataType: json['data_type'],
      flowType: json['flow_type'],
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      question: json['question'] ?? '',
    );
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  final ApiClient _apiClient = ApiClient();

  // Onboarding data fields
  String? _userName;
  String? _gender;
  int? _age;
  double? _weight;
  double? _height;
  String? _ethnicity;
  String? _address;
  String? _householdIncomeRange;
  List<String> _healthConcerns = [];
  List<String> _healthHistory = [];
  String? _medicationsOrSupplementsIndicator;
  List<String> _medicationsOrSupplements = [];
  List<String> _currentStageInLife = [];
  List<String> _moodEnergyCognitiveSupport = [];
  List<String> _gutAndImmuneSupport = [];
  List<String> _overTheCounterMedications = [];
  List<String> _vitaminsAndSupplements = [];
  List<String> _herbalAndAdaptogens = [];
  bool _privacyPolicyAccepted = false;
  bool _sixteenAndOver = true;
  bool _isActive = true;
  List<String> _denPrivacy = [];
  String? _profileIconUrl;

  OnboardingCubit() : super(OnboardingInitial());

  // Setters for onboarding data
  void setUserName(String userName) {
    _userName = userName;
  }

  void setGender(String gender) {
    _gender = gender;
  }

  void setAge(int age) {
    _age = age;
  }

  void setWeight(double weight) {
    _weight = weight;
  }

  void setHeight(double height) {
    _height = height;
  }

  void setEthnicity(String ethnicity) {
    _ethnicity = ethnicity;
  }

  void setAddress(String address) {
    _address = address;
  }

  void setHouseholdIncomeRange(String householdIncomeRange) {
    _householdIncomeRange = householdIncomeRange;
  }

  void setHealthConcerns(List<String> healthConcerns) {
    _healthConcerns = healthConcerns;
  }

  void setHealthHistory(List<String> healthHistory) {
    _healthHistory = healthHistory;
  }

  void setMedicationsOrSupplementsIndicator(String indicator) {
    _medicationsOrSupplementsIndicator = indicator;
  }

  void setMedicationsOrSupplements(List<String> medications) {
    _medicationsOrSupplements = medications;
  }

  void setCurrentStageInLife(List<String> stages) {
    _currentStageInLife = stages;
  }

  void setMoodEnergyCognitiveSupport(List<String> support) {
    _moodEnergyCognitiveSupport = support;
  }

  void setGutAndImmuneSupport(List<String> support) {
    _gutAndImmuneSupport = support;
  }

  void setOverTheCounterMedications(List<String> medications) {
    _overTheCounterMedications = medications;
  }

  void setVitaminsAndSupplements(List<String> supplements) {
    _vitaminsAndSupplements = supplements;
  }

  void setHerbalAndAdaptogens(List<String> adaptogens) {
    _herbalAndAdaptogens = adaptogens;
  }

  void setPrivacyPolicyAccepted(bool accepted) {
    _privacyPolicyAccepted = accepted;
  }

  void setSixteenAndOver(bool sixteenAndOver) {
    _sixteenAndOver = sixteenAndOver;
  }

  void setIsActive(bool isActive) {
    _isActive = isActive;
  }

  void setDenPrivacy(List<String> denPrivacy) {
    _denPrivacy = denPrivacy;
  }

  void setProfileIconUrl(String profileIconUrl) {
    _profileIconUrl = profileIconUrl;
  }

  // Bulk setter for all onboarding data
  void setOnboardingData({
    String? userName,
    String? gender,
    int? age,
    double? weight,
    double? height,
    String? ethnicity,
    String? address,
    String? householdIncomeRange,
    List<String>? healthConcerns,
    List<String>? healthHistory,
    String? medicationsOrSupplementsIndicator,
    List<String>? medicationsOrSupplements,
    List<String>? currentStageInLife,
    List<String>? moodEnergyCognitiveSupport,
    List<String>? gutAndImmuneSupport,
    List<String>? overTheCounterMedications,
    List<String>? vitaminsAndSupplements,
    List<String>? herbalAndAdaptogens,
    bool? privacyPolicyAccepted,
    bool? sixteenAndOver,
    bool? isActive,
    List<String>? denPrivacy,
    String? profileIconUrl,
  }) {
    if (userName != null) _userName = userName;
    if (gender != null) _gender = gender;
    if (age != null) _age = age;
    if (weight != null) _weight = weight;
    if (height != null) _height = height;
    if (ethnicity != null) _ethnicity = ethnicity;
    if (address != null) _address = address;
    if (householdIncomeRange != null) _householdIncomeRange = householdIncomeRange;
    if (healthConcerns != null) _healthConcerns = healthConcerns;
    if (healthHistory != null) _healthHistory = healthHistory;
    if (medicationsOrSupplementsIndicator != null) _medicationsOrSupplementsIndicator = medicationsOrSupplementsIndicator;
    if (medicationsOrSupplements != null) _medicationsOrSupplements = medicationsOrSupplements;
    if (currentStageInLife != null) _currentStageInLife = currentStageInLife;
    if (moodEnergyCognitiveSupport != null) _moodEnergyCognitiveSupport = moodEnergyCognitiveSupport;
    if (gutAndImmuneSupport != null) _gutAndImmuneSupport = gutAndImmuneSupport;
    if (overTheCounterMedications != null) _overTheCounterMedications = overTheCounterMedications;
    if (vitaminsAndSupplements != null) _vitaminsAndSupplements = vitaminsAndSupplements;
    if (herbalAndAdaptogens != null) _herbalAndAdaptogens = herbalAndAdaptogens;
    if (privacyPolicyAccepted != null) _privacyPolicyAccepted = privacyPolicyAccepted;
    if (sixteenAndOver != null) _sixteenAndOver = sixteenAndOver;
    if (isActive != null) _isActive = isActive;
    if (denPrivacy != null) _denPrivacy = denPrivacy;
    if (profileIconUrl != null) _profileIconUrl = profileIconUrl;
  }

  // Submit onboarding data to API
  Future<bool> submitOnboardingData() async {
    try {
      emit(OnboardingLoading());
      
      print('🚀 Starting onboarding API call...');
      
      // Ensure token is loaded from storage and wait a bit for it to be available
      await AppStorage.loadCredentials();
      print('🔍 Current AppStorage token after reload: ${AppStorage.accessToken != null ? "Present (${AppStorage.accessToken!.length} chars)" : "NULL"}');
      
      // If token is still null, try loading from SharedPreferences directly
      if (AppStorage.accessToken == null) {
        print('⚠️ Token still null, trying to load from SharedPreferences directly...');
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null) {
          AppStorage.accessToken = token;
          print('✅ Token loaded directly from SharedPreferences: ${token.length} chars');
        } else {
          print('❌ No token found in SharedPreferences either');
        }
      }

      final response = await _apiClient.put(
        '/api/v1/accounts/me/onboarding',
        data: {
          'user_name': _userName,
          'gender': _gender,
          'age': _age,
          'weight': _weight,
          'height': _height,
          'ethnicity': _ethnicity,
          'address': _address,
          'household_income_range': _householdIncomeRange,
          'health_concerns': _healthConcerns,
          'health_history': _healthHistory,
          'medications_or_supplements_indicator': _medicationsOrSupplementsIndicator,
          'medications_or_supplements': _medicationsOrSupplements,
          'current_stage_in_life': _currentStageInLife,
          'mood_energy_cognative_support': _moodEnergyCognitiveSupport,
          'gut_and_immune_support': _gutAndImmuneSupport,
          'over_the_counter_medications': _overTheCounterMedications,
          'vitamins_and_supplements': _vitaminsAndSupplements,
          'herbal_and_adaptogens': _herbalAndAdaptogens,
          'privacy_policy_accepted': _privacyPolicyAccepted,
          'sixteen_and_over': _sixteenAndOver,
          'is_active': _isActive,
          'den_privacy': _denPrivacy,
          'profile_icon_url': _profileIconUrl,
        },
      );

      print('📡 Onboarding API response status: ${response.statusCode}');
      print('📡 Onboarding API response data: ${response.data}');
      
      if (response.statusCode == 200) {
        print('✅ Onboarding API call successful!');
        emit(OnboardingSuccess());
        return true;
      } else {
        print('❌ Onboarding API call failed with status: ${response.statusCode}');
        emit(OnboardingError('Failed to submit onboarding data: ${response.statusCode}'));
        return false;
      }
    } catch (e) {
      print('❌ Onboarding API call error: $e');
      
      // Handle specific error types
      String errorMessage = 'Error submitting onboarding data: $e';
      
      if (e is DioException && e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic> && responseData.containsKey('detail')) {
          final detail = responseData['detail'];
          if (detail is List && detail.isNotEmpty) {
            // Handle validation errors
            final firstError = detail[0];
            if (firstError is Map<String, dynamic>) {
              final field = firstError['loc']?.last ?? 'field';
              final message = firstError['msg'] ?? 'Invalid value';
              errorMessage = 'Validation error in $field: $message';
            }
          } else if (detail is String) {
            errorMessage = detail;
          }
        }
      }
      
      emit(OnboardingError(errorMessage));
      return false;
    }
  }

  // Get current onboarding data
  Map<String, dynamic> getOnboardingData() {
    return {
      'user_name': _userName,
      'gender': _gender,
      'age': _age,
      'weight': _weight,
      'height': _height,
      'ethnicity': _ethnicity,
      'address': _address,
      'household_income_range': _householdIncomeRange,
      'health_concerns': _healthConcerns,
      'health_history': _healthHistory,
      'medications_or_supplements_indicator': _medicationsOrSupplementsIndicator,
      'medications_or_supplements': _medicationsOrSupplements,
      'current_stage_in_life': _currentStageInLife,
      'mood_energy_cognative_support': _moodEnergyCognitiveSupport,
      'gut_and_immune_support': _gutAndImmuneSupport,
      'over_the_counter_medications': _overTheCounterMedications,
      'vitamins_and_supplements': _vitaminsAndSupplements,
      'herbal_and_adaptogens': _herbalAndAdaptogens,
      'privacy_policy_accepted': _privacyPolicyAccepted,
      'sixteen_and_over': _sixteenAndOver,
      'is_active': _isActive,
      'den_privacy': _denPrivacy,
      'profile_icon_url': _profileIconUrl,
    };
  }

  // Reset onboarding data
  void resetOnboardingData() {
    _userName = null;
    _gender = null;
    _age = null;
    _weight = null;
    _height = null;
    _ethnicity = null;
    _address = null;
    _householdIncomeRange = null;
    _healthConcerns = [];
    _healthHistory = [];
    _medicationsOrSupplementsIndicator = null;
    _medicationsOrSupplements = [];
    _currentStageInLife = [];
    _moodEnergyCognitiveSupport = [];
    _gutAndImmuneSupport = [];
    _overTheCounterMedications = [];
    _vitaminsAndSupplements = [];
    _herbalAndAdaptogens = [];
    _privacyPolicyAccepted = false;
    _sixteenAndOver = true;
    _isActive = true;
    _denPrivacy = [];
    _profileIconUrl = null;
    
    emit(OnboardingInitial());
  }

  // Service functions moved from OnboardingService
  Future<List<OnboardingQuestion>> getOnboardingQuestions() async {
    try {
      final response = await _apiClient.get('/api/v1/questions/onboarding');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => OnboardingQuestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load onboarding questions: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching onboarding questions: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching onboarding questions: $e');
    }
  }

  OnboardingQuestion? getQuestionByType(List<OnboardingQuestion> questions, String type) {
    try {
      return questions.firstWhere((question) => question.type == type);
    } catch (e) {
      return null;
    }
  }
}
