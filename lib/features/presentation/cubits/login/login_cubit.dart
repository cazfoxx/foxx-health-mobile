import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/view/onboarding_flow.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/otp_verification_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/otp_verification_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _apiClient = ApiClient();
  final _analytics = AnalyticsService();

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

  // Getter for password
  String? get password => _password;

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
    if (fullName != null) this.fullName = fullName;
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

  Future<void> _saveEmailToPrefs(
      String email, String token, String firebaseToken) async {
    print('🔧 _saveEmailToPrefs called with:');
    print('   Email: $email');
    print(
        '   Token: ${token.isNotEmpty ? "${token.substring(0, 20)}..." : "EMPTY"}');
    print(
        '   Firebase Token: ${firebaseToken.isNotEmpty ? "${firebaseToken.substring(0, 20)}..." : "EMPTY"}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setString('access_token', token);
    await prefs.setString('firebase_token', firebaseToken);

    // Verify the save worked
    final savedToken = prefs.getString('access_token');
    print(
        '🔍 Token verification - saved: ${savedToken != null ? "${savedToken.substring(0, 20)}..." : "NULL"}');

    log('📝 Email saved to prefs: $email');
    log('📝 Token saved to prefs: $token');
    log('📝 Firebase token saved to prefs: $firebaseToken');

    print('🔧 Setting credentials in AppStorage...');
    await AppStorage.setCredentials(token: token, email: email);
    print(
        '🔧 AppStorage credentials set. Token: ${AppStorage.accessToken != null ? "Present (${AppStorage.accessToken!.length} chars)" : "NULL"}');

    // Verify AppStorage was set correctly
    final appStorageToken = AppStorage.accessToken;
    print(
        '🔍 AppStorage verification - token: ${appStorageToken != null ? "${appStorageToken.substring(0, 20)}..." : "NULL"}');
  }

  Future<Map<String, dynamic>?> registerUser(BuildContext context) async {
    try {
      emit(LoginLoading());

      // Register with your API using the new endpoint
      final response = await _apiClient.post(
        '/api/v1/auth/register',
        data: {
          'email_address': _email,
          'password': _password,
          // 'role': 'user',
        },
      );

      if (response.statusCode == 200) {
        print('🔍 Register API Response Data: ${response.data}');

        // Log signup event
        await _analytics.logSignUp();

        SnackbarUtils.showSuccess(
            context: context,
            title: 'Registration Successful',
            message: 'OTP sent to your email address');

                                        Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OnboardingFlow(
                                    email: _email!,
                                    password: _password!,
                                  ),),
                                );
        // emit(LoginSuccess());

      // emit state to notify UI to show OTP screen
      emit(LoginOtpSent(_email!));
        // // 🔹 Navigate to OTPVerificationScreen
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => OTPVerificationScreen(
        //       email: _email!,
        //       onSuccess: () {
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(
        //             builder: (_) => OnboardingFlow(
        //               email: _email!,
        //               password: _password!,
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // );
        // // // 🔹 Show OTP bottom sheet
        // // showModalBottomSheet(
        // //   context: context,
        // //   isScrollControlled: true,
        // //   backgroundColor: Colors.transparent,
        // //   builder: (_) => BlocProvider.value(
        // //     value: this,
        // //     child: OTPVerificationSheet(
        // //       email: _email!,
        // //       onSuccess: () {
        // //         Navigator.pushReplacement(
        // //           context,
        // //           MaterialPageRoute(
        // //             builder: (_) => OnboardingFlow(
        // //               email: _email!,
        // //               password: _password!,
        // //             ),
        // //           ),
        // //         );
        // //       },
        // //     ),
        // //   ),
        // // );
        return response.data; // Return the response data containing OTP info
      } else if (response.statusCode == 400 &&
          response.data['detail'] == 'Email already registered') {
        // Handle existing user - try to login directly
        print('🔍 Email already registered, attempting direct login...');

        final loginSuccess = await signInWithEmail(_email!, _password!);

        if (loginSuccess) {
          print('✅ Direct login successful for existing user');
          SnackbarUtils.showSuccess(
              context: context,
              title: 'Welcome Back!',
              message: 'You are already registered. Logging you in...');

          // Return a special indicator that user was logged in directly
          return {'direct_login': true};
        } else {
          print('❌ Direct login failed for existing user');
          SnackbarUtils.showError(
              context: context,
              title: 'Login Failed',
              message:
                  'Email is registered but login failed. Please check your password.');
          return null;
        }
      } else {
        // Log error
        await _analytics.logError(
          errorName: 'Registration Failed',
          errorDescription: 'Status code: ${response.statusCode}',
        );
        emit(LoginError('Registration failed: ${response.data}'));
        SnackbarUtils.showError(
            context: context,
            title: 'Registration Failed',
            message: response.data['detail'] ?? 'Registration failed');
        return null;
      }
    } catch (e) {
      // Log error
      await _analytics.logError(
        errorName: 'Registration Error',
        errorDescription: e.toString(),
      );
      emit(LoginError('Registration failed: $e'));
      SnackbarUtils.showError(
          context: context, title: 'Error', message: e.toString());
      return null;
    }
  }

  Future<bool> verifyRegistrationOTP(String email, String otp) async {
    try {
      emit(LoginLoading());

      final response = await _apiClient.post(
        '/api/v1/auth/verify-registration-otp',
        data: {
          'email_address': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
      // If API returns access_token here, save it; otherwise do login step
      final data = response.data;
      if (data != null && data['access_token'] != null) {
        await _saveEmailToPrefs(email, data['access_token'], '');
      } else {
        // Fallback: call login to obtain token
        final loginOk = await signInWithEmail(email, _password ?? '');
        if (!loginOk) {
          emit(LoginError('Login after OTP verification failed'));
          return false;
        }
      }

      emit(LoginOtpVerified());
      return true;

      // if (response.statusCode == 200) {
      //   print('🔍 OTP Verification Response: ${response.data}');
      //   emit(LoginSuccess());
      //   return true;
      } else {
        await _analytics.logError(
          errorName: 'OTP Verification Failed',
          errorDescription: 'Status code: ${response.statusCode}',
        );
        emit(LoginError('OTP verification failed: ${response.data}'));
        return false;
      }
    } catch (e) {
      await _analytics.logError(
        errorName: 'OTP Verification Error',
        errorDescription: e.toString(),
      );
      emit(LoginError('OTP verification failed: $e'));
      return false;
    }
  }

  Future<bool> resendRegistrationOTP(String email) async {
    try {
      emit(LoginLoading());

      final response = await _apiClient.post(
        '/api/v1/auth/resend-registration-otp',
        data: {
          'email_address': email,
        },
      );

      if (response.statusCode == 200) {
        print('🔍 Resend OTP Response: ${response.data}');
        emit(LoginSuccess());
        return true;
      } else {
        await _analytics.logError(
          errorName: 'Resend OTP Failed',
          errorDescription: 'Status code: ${response.statusCode}',
        );
        emit(LoginError('Resend OTP failed: ${response.data}'));
        return false;
      }
    } catch (e) {
      await _analytics.logError(
        errorName: 'Resend OTP Error',
        errorDescription: e.toString(),
      );
      emit(LoginError('Resend OTP failed: $e'));
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      emit(LoginLoading());

      // Login with the new API endpoint
      final response = await _apiClient.post(
        '/api/v1/auth/login',
        data: {
          'email_address': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final tokenData = response.data;
        print('🔍 Login API Response Data: $tokenData');
        print('🔍 Access Token from response: ${tokenData['access_token']}');
        print('🔍 Token type: ${tokenData['access_token'].runtimeType}');

        if (tokenData['access_token'] != null) {
          await _saveEmailToPrefs(email, tokenData['access_token'], '');
        } else {
          print('❌ No access_token found in response data');
          emit(LoginError('No access token received from server'));
          return false;
        }

        // Log login event
        await _analytics.logLogin();

        emit(LoginSuccess());
        return true;
      } else {
        // Log error
        await _analytics.logError(
          errorName: 'Login Failed',
          errorDescription: 'Status code: ${response.statusCode}',
        );
        emit(LoginError('Login failed: ${response.data}'));
        return false;
      }
    } catch (e) {
      // Log the error to Sentry with additional context
      await _analytics.logError(
        errorName: 'Login Error',
        errorDescription: e.toString(),
      );
      emit(LoginError(e.toString()));
      return false;
    }
  }

  bool validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasLetterAndNumber =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
    final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);

    return hasMinLength && hasLetterAndNumber && hasCapitalLetter;
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      emit(LoginLoading());
      // Call backend API to delete account
      final response = await _apiClient.delete(
        '/api/v1/accounts/me',
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Delete from Firebase
        final user = _auth.currentUser;
        if (user != null) {
          await user.delete();
        }
        SnackbarUtils.showSuccess(
          context: context,
          title: 'Account Deleted',
          message: 'Your account has been deleted successfully.',
        );
        emit(LoginAccountDeleted());
      } else {
        emit(LoginError('Failed to delete account: ${response.data}'));
        SnackbarUtils.showSuccess(
          context: context,
          title: 'Error',
          message: 'Failed to delete account: ${response.data}',
        );
      }
    } catch (e) {
      emit(LoginError('Account deletion failed: $e'));
      SnackbarUtils.showSuccess(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }
}
