import 'package:equatable/equatable.dart';

abstract class CommunityDenState extends Equatable {
  const CommunityDenState();

  @override
  List<Object?> get props => [];
}

class CommunityDenInitial extends CommunityDenState {}

class CommunityDenLoading extends CommunityDenState {}

class CommunityDenSuccess extends CommunityDenState {
  final String message;

  const CommunityDenSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CommunityDenError extends CommunityDenState {
  final String message;

  const CommunityDenError({required this.message});

  @override
  List<Object?> get props => [message];
}

