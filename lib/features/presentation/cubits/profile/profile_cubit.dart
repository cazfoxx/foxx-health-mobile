import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/constants/shared_pref_keys.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ApiClient _apiClient = ApiClient();

  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile() async {
    try {
      emit(ProfileLoading());

      final response = await _apiClient.dio.get('/api/v1/accounts/accounts/me');

      final data = response.data;

      // Store accountId in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(SharedPrefKeys.accountId, data['accountId']);

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
