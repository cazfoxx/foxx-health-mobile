import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/constants/shared_pref_keys.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiClient _apiClient = ApiClient();

  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile() async {
    try {
      emit(ProfileLoading());

      final response = await _apiClient.dio.get('/api/v1/accounts/me');

      final data = response.data;

      // Store accountId in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(SharedPrefKeys.accountId, data['account_id']);

      // Store user profile data in constants
      UserProfileConstants.updateProfileData(
        userName: data['user_name'],
        gender: data['gender'],
        age: data['age'],
        weight: data['weight']?.toDouble(),
        height: data['height']?.toDouble(),
        ethnicity: data['ethnicity'],
        address: data['address'],
        householdIncomeRange: data['household_income_range'],
        healthConcerns: data['health_concerns'] != null 
            ? List<String>.from(data['health_concerns']) 
            : null,
        healthHistory: data['health_history'] != null 
            ? List<String>.from(data['health_history']) 
            : null,
        medicationsOrSupplementsIndicator: data['medications_or_supplements_indicator'],
        medicationsOrSupplements: data['medications_or_supplements'] != null 
            ? List<String>.from(data['medications_or_supplements']) 
            : null,
        currentStageInLife: data['current_stage_in_life'] != null 
            ? List<String>.from(data['current_stage_in_life']) 
            : null,
        moodEnergyCognitiveSupport: data['mood_energy_cognative_support'] != null 
            ? List<String>.from(data['mood_energy_cognative_support']) 
            : null,
        gutAndImmuneSupport: data['gut_and_immune_support'] != null 
            ? List<String>.from(data['gut_and_immune_support']) 
            : null,
        overTheCounterMedications: data['over_the_counter_medications'] != null 
            ? List<String>.from(data['over_the_counter_medications']) 
            : null,
        vitaminsAndSupplements: data['vitamins_and_supplements'] != null 
            ? List<String>.from(data['vitamins_and_supplements']) 
            : null,
        herbalAndAdaptogens: data['herbal_and_adaptogens'] != null 
            ? List<String>.from(data['herbal_and_adaptogens']) 
            : null,
        privacyPolicyAccepted: data['privacy_policy_accepted'],
        sixteenAndOver: data['sixteen_and_over'],
        isActive: data['is_active'],
        accountId: data['account_id'],
        userUniqueId: data['user_unique_id'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at'],
      );

      emit(ProfileLoaded(
        userName: data['user_name'] ?? data['userName'],
        pronoun: data['preferPronoun'],
        emailAddress: data['emailAddress'],
        ageGroupCode: data['ageGroupCode'],
        heardFromCode: data['heardFromCode'],
        isActive: data['is_active'] ?? data['isActive'],
        accountId: data['account_id'] ?? data['accountId'],
        userUniqueId: data['user_unique_id'] ?? data['userUniqueId'],
        createdAt: data['created_at'] ?? data['createdAt'],
        updatedAt: data['updated_at'] ?? data['updatedAt'],
      ));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateProfile({
    required String emailAddress,
    // required String password,
    required String userName,
    required String preferPronoun,
  }) async {
    try {
      emit(ProfileLoading());

      final response = await _apiClient.dio.put(
        '/api/v1/accounts/me',
        data: {
          'emailAddress': emailAddress,
          // 'password': password,
          'userName': userName,
          // 'pronounCode': pronounCode,
          'preferPronoun': preferPronoun,
          // 'ageGroupCode': ageGroupCode,
          // 'heardFromCode': heardFromCode,
          // 'otherHeardFrom': otherHeardFrom,
          // 'isActive': isActive,
        },
      );

      final data = response.data;

      emit(ProfileLoaded(
        userName: data['userName'],
        pronoun: data['preferPronoun'],
        emailAddress: data['emailAddress'],
        ageGroupCode: data['ageGroupCode'],
        heardFromCode: data['heardFromCode'],
        isActive: data['isActive'],
        accountId: data['accountId'],
        userUniqueId: data['userUniqueId'],
        createdAt: data['createdAt'],
        updatedAt: data['updatedAt'],
      ));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
