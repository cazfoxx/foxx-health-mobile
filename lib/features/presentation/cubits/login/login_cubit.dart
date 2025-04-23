import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginCubit() : super(LoginInitial());

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      emit(LoginLoading());
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? 'An error occurred'));
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      emit(LoginLoading());
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? 'An error occurred'));
    }
  }

  bool validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasLetterAndNumber = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
    final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);
    
    return hasMinLength && hasLetterAndNumber && hasCapitalLetter;
  }
}