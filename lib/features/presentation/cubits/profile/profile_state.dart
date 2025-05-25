part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userName;
  final String pronoun;
  final String emailAddress;
  final String ageGroupCode;
  final String heardFromCode;
  final bool isActive;
  final int accountId;
  final String userUniqueId;
  final String createdAt;
  final String updatedAt;

  ProfileLoaded({
    required this.userName,
    required this.pronoun,
    required this.emailAddress,
    required this.ageGroupCode,
    required this.heardFromCode,
    required this.isActive,
    required this.accountId,
    required this.userUniqueId,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}