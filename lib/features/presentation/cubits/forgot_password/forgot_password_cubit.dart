import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/core/network/api_client.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ApiClient _apiClient = ApiClient();
  String? _email;

  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> sendResetEmail(String email) async {
    try {
      emit(ForgotPasswordLoading());
      _email = email; // Store email for reset password step
      final response = await _apiClient.post(
        '/api/v1/auth/forgot-password',
        data: {
          'email': email,
        },
      );
      emit(EmailSent());
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> resetPassword({
    required String otp,
    required String newPassword,
  }) async {
    try {
      emit(ForgotPasswordLoading());
      if (_email == null) {
        throw Exception('Email not found. Please try again.');
      }
      
      final response = await _apiClient.post(
        '/api/v1/auth/reset-password',
        data: {
          'email': _email,
          'otp': otp,
          'new_password': newPassword,
        },
      );
      emit(PasswordReset());
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }
} 