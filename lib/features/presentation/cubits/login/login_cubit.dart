import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _apiClient = ApiClient();

  // User registration data
  String? fullName;
  String? _email;
  String? _password;
  String? _username;
  String? _phoneNumber;
  String? _age;
  String? _referralSource;
  String? _pronoun;
  List<String> _healthGoals = [];
  List<String> _healthConcerns = [];

  LoginCubit() : super(LoginInitial());

  // Setters for onboarding data
  void setUserDetails({
    String? fullName,
    String? email,
    String? password,
    String? username,
    String? phoneNumber,
    String? age,
    String? referralSource,
    String? pronoun,
  }) {
    // Only update fields that are not null
    if (fullName != null) fullName = fullName;
    if (email != null) _email = email;
    if (password != null) _password = password;
    if (username != null) _username = username;
    if (phoneNumber != null) _phoneNumber = phoneNumber;
    if (age != null) _age = age;
    if (referralSource != null) _referralSource = referralSource;
    if (pronoun != null) _pronoun = pronoun;
  }

  void setHealthGoals(List<String> goals) {
    _healthGoals = goals;
  }

  setUsername(String username) {
    _username = username;
  }

  void setHealthConcerns(List<String> concerns) {
    _healthConcerns = concerns;
  }

  Future<void> _saveEmailToPrefs(String email, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setString('access_token', token);
    log('Email saved to prefs: $email');
    log('Token saved to prefs: $token');
    AppStorage.setCredentials(token: token, email: email);
  }

  Future<bool> registerUser(BuildContext context) async {
    try {
      emit(LoginLoading());
      // Register with your API using Dio
      final response = await _apiClient.post(
        '/api/v1/auth/register',
        data: {
          'emailAddress': _email,
          'userName': _username ?? '',
          'pronounCode': _pronoun ?? '',
          'preferPronoun': _pronoun ?? '',
          'ageGroupCode': _age ?? '',
          'heardFromCode': _referralSource ?? '',
          'otherHeardFrom': '',
          'isActive': true,
          'password': _password,
        },
      );

      if (response.statusCode == 200) {
        if (_email != null) {
          await signInWithEmail(_email!, _password!);
          SnackbarUtils.showSuccess(
              context: context,
              title: 'Welcome $_username',
              message: 'Foxx health');
        }
        emit(LoginSuccess());
        return true;
      } else {
        emit(LoginError('Registration failed: ${response.data}'));
        SnackbarUtils.showSuccess(
            context: context,
            title: 'Error status code ${response.statusCode}',
            message: response.data);
        return false;
      }
    } catch (e) {
      emit(LoginError('Registration failed: $e'));
      SnackbarUtils.showSuccess(
          context: context, title: 'Error', message: e.toString());
      return true;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      emit(LoginLoading());

      final response = await _apiClient.post(
        '/api/v1/auth/login',
        queryParameters: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final tokenData = response.data;
        await _saveEmailToPrefs(_email!, tokenData['access_token']);
        emit(LoginSuccess());
      } else {
        await _auth.signOut();
        emit(LoginError('Login failed: ${response.data}'));
      }
    } catch (e) {
      emit(LoginError('Login failed: $e'));
    }
  }

  bool validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasLetterAndNumber =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
    final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);

    return hasMinLength && hasLetterAndNumber && hasCapitalLetter;
  }
}
