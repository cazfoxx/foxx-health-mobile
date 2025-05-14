import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // User registration data
  String? _fullName;
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
    _fullName = fullName;
    _email = email;
    _password = password;
    _username = username;
    _phoneNumber = phoneNumber;
    _age = age;
    _referralSource = referralSource;
    _pronoun = pronoun;

    //log all of them
    log('Full Name: $_fullName');
    log('Email: $_email');
    log('Password: $_password');
    log('Username: $_username');
    log('Phone Number: $_phoneNumber');
    log('Age: $_age');
    log('Referral Source: $_referralSource');
    log('Pronoun: $_pronoun');
  }

  void setHealthGoals(List<String> goals) {
    _healthGoals = goals;
  }

  void setHealthConcerns(List<String> concerns) {
    _healthConcerns = concerns;
  }

  Future<void> registerUser(String email, String password) async {
    try {
      emit(LoginLoading());
      
      // First create Firebase auth user
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Then register with your API
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/v1/auth/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'full_name': _fullName,
          'phone_number': _phoneNumber,
          'age': _age,
          'referal_source': _referralSource,
          'pronoun': _pronoun,
          'health_goals': _healthGoals,
          'health_concerns': _healthConcerns,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        emit(LoginSuccess());
      } else {
        // If API registration fails, delete the Firebase user
        await _auth.currentUser?.delete();
        emit(LoginError('Registration failed: ${response.body}'));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? 'Firebase authentication failed'));
    } catch (e) {
      emit(LoginError('Registration failed: $e'));
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      emit(LoginLoading());
      
      // First sign in with Firebase
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Then get token from your API
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/v1/auth/users/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final tokenData = jsonDecode(response.body);
        // You might want to store the token somewhere
        emit(LoginSuccess());
      } else {
        // If API login fails, sign out from Firebase
        await _auth.signOut();
        emit(LoginError('Login failed: ${response.body}'));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? 'Firebase authentication failed'));
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
