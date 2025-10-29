// import 'package:equatable/equatable.dart';

// abstract class CommunityDenState extends Equatable {
//   const CommunityDenState();

//   @override
//   List<Object?> get props => [];
// }

// class CommunityDenInitial extends CommunityDenState {}

// class CommunityDenLoading extends CommunityDenState {}

// class CommunityDenSuccess extends CommunityDenState {
//   final String message;

//   const CommunityDenSuccess({required this.message});

//   @override
//   List<Object?> get props => [message];
// }

// class CommunityDenError extends CommunityDenState {
//   final String message;

//   const CommunityDenError({required this.message});

//   @override
//   List<Object?> get props => [message];
// }

import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';

abstract class CommunityDenState extends Equatable {
  const CommunityDenState();

  @override
  List<Object?> get props => [];
}

class CommunityDenInitial extends CommunityDenState {}

class CommunityDenLoading extends CommunityDenState {}

class CommunityDenLoaded extends CommunityDenState {
  final List<CommunityDenModel> dens;

  const CommunityDenLoaded(this.dens);

  @override
  List<Object?> get props => [dens];
}

class CommunityDenError extends CommunityDenState {
  final String message;

  const CommunityDenError(this.message);

  @override
  List<Object?> get props => [message];
}


/// Community Den Detail Loaded State
class CommunityDenDetailLoaded extends CommunityDenState {
  final CommunityDenModel den;

  const CommunityDenDetailLoaded(this.den);

  @override
  List<Object?> get props => [den];
} 

class CommunityDenSearched extends CommunityDenState {
  final List<CommunityDenModel> dens;

  const CommunityDenSearched(this.dens);

  @override
  List<Object?> get props => [dens];
}